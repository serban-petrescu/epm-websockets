/* global showError, logoff */
sap.ui.core.mvc.Controller.extend("epmwebsockets.view.Detail", {

	onInit : function() {
		this.oInitialLoadFinishedDeferred = jQuery.Deferred();

		if(sap.ui.Device.system.phone) {
			//Do not wait for the master when in mobile phone resolution
			this.oInitialLoadFinishedDeferred.resolve();
		} else {
			this.getView().setBusy(true);
			var oEventBus = this.getEventBus();
			oEventBus.subscribe("Component", "MetadataFailed", this.onMetadataFailed, this);
			oEventBus.subscribe("Master", "InitialLoadFinished", this.onMasterLoaded, this);
		}
		this.getRouter().attachRouteMatched(this.onRouteMatched, this);
	},

	onMasterLoaded :  function (sChannel, sEvent) {
		this.getView().setBusy(false);
		this.oInitialLoadFinishedDeferred.resolve();
	},

	onMetadataFailed : function(){
		this.getView().setBusy(false);
		this.oInitialLoadFinishedDeferred.resolve();
        this.showEmptyView();
	},

	onRouteMatched : function(oEvent) {
		var oParameters = oEvent.getParameters();

		jQuery.when(this.oInitialLoadFinishedDeferred).then(jQuery.proxy(function () {
			var oView = this.getView();

			// When navigating in the Detail page, update the binding context
			if (oParameters.name !== "detail") {
				return;
			}

			var sEntityPath = "/" + oParameters.arguments.entity;
			this.bindView(sEntityPath);

			var oIconTabBar = oView.byId("idIconTabBar");
			oIconTabBar.getItems().forEach(function(oItem) {
			    if(oItem.getKey() !== "selfInfo"){
    				oItem.bindElement(oItem.getKey());
			    }
			});

			// Specify the tab being focused
			var sTabKey = oParameters.arguments.tab;
			this.getEventBus().publish("Detail", "TabChanged", { sTabKey : sTabKey });

			if (oIconTabBar.getSelectedKey() !== sTabKey) {
				oIconTabBar.setSelectedKey(sTabKey);
			}
		}, this));

	},

	bindView : function (sEntityPath) {
		var oView = this.getView();
		oView.bindElement(sEntityPath);
		oView.getElementBinding().attachChange(jQuery.proxy(this.checkViewData, this));

		//Check if the data is already on the client
		if(!oView.getModel().getData(sEntityPath)) {

			// Check that the entity specified was found.
			oView.getElementBinding().attachEventOnce("dataReceived", jQuery.proxy(function() {
				var oData = oView.getModel().getData(sEntityPath);
				if (oData) {
					this.fireDetailChanged(sEntityPath);
				}
			}, this));

		} else {
			this.fireDetailChanged(sEntityPath);
		}

	},

	checkViewData: function(oEvent) {
		var binding = this.getView().getElementBinding();
		if (binding && binding.getPath()) {
			var oData = this.getView().getModel().getData(binding.getPath());
			if (!oData) {
				this.showEmptyView();
				this.fireDetailNotFound();
			}
		}
	},

	showEmptyView : function () {
		this.getRouter().myNavToWithoutHash({
			currentView : this.getView(),
			targetViewName : "epmwebsockets.view.NotFound",
			targetViewType : "XML"
		});
	},

	fireDetailChanged : function (sEntityPath) {
		this.getEventBus().publish("Detail", "Changed", { sEntityPath : sEntityPath });
	},

	fireDetailNotFound : function () {
		this.getEventBus().publish("Detail", "NotFound");
	},

	onNavBack : function() {
		// This is only relevant when running on phone devices
		this.getRouter().myNavBack("main");
	},

	onDetailSelect : function(oEvent) {
		sap.ui.core.UIComponent.getRouterFor(this).navTo("detail",{
			entity : oEvent.getSource().getBindingContext().getPath().slice(1),
			tab: oEvent.getParameter("selectedKey")
		}, true);
	},

	openActionSheet: function() {

		if (!this._oActionSheet) {
			this._oActionSheet = new sap.m.ActionSheet({
				buttons: new sap.ushell.ui.footerbar.AddBookmarkButton()
			});
			this._oActionSheet.setShowCancelButton(true);
			this._oActionSheet.setPlacement(sap.m.PlacementType.Top);
		}

		this._oActionSheet.openBy(this.getView().byId("actionButton"));
	},

	getEventBus : function () {
		return sap.ui.getCore().getEventBus();
	},

	getRouter : function () {
		return sap.ui.core.UIComponent.getRouterFor(this);
	},

	onExit : function(oEvent){
	    var oEventBus = this.getEventBus();
    	oEventBus.unsubscribe("Master", "InitialLoadFinished", this.onMasterLoaded, this);
		oEventBus.unsubscribe("Component", "MetadataFailed", this.onMetadataFailed, this);
		if (this._oActionSheet) {
			this._oActionSheet.destroy();
			this._oActionSheet = null;
		}
	},

    editEntity: function() {
        if (!this.dialog) {
            this.dialog = sap.ui.xmlfragment(this.getView().getId(), "epmwebsockets.view.CreateDialog", this);
            this.getView().addDependent(this.dialog);
	        var i18n = this.getOwnerComponent().getModel("i18n").getResourceBundle();
            this.dialog.setTitle(i18n.getText("editDialogTitle"));
            this.byId("dialogInput1").setEnabled(false);
        }

        this.dialog.bindElement(this.getView().getBindingContext().getPath());
        jQuery.sap.syncStyleClass("sapUiSizeCompact", this.getView(), this.dialog);
        this.dialog.open();
    },

    deleteEntity: function() {
        jQuery.sap.require("sap.ca.ui.dialog.factory");
	    var i18n = this.getOwnerComponent().getModel("i18n").getResourceBundle();
	    var context = this.getView().getBindingContext();
        sap.ca.ui.dialog.confirmation.open({
            question : i18n.getText("confirmDeleteQuestion", context.getProperty("Name")),
            showNote : false,
            title : i18n.getText("confirmDeleteTitle"),
            confirmButtonLabel: i18n.getText("confirmDeleteLabel")
        }, jQuery.proxy(function(oResult) {
            if (oResult.isConfirmed) {
                this.getOwnerComponent().getModel().remove(context.getPath(), {
	            	success: jQuery.proxy(function() {
	            		this.getView().unbindElement();
	                	this.showEmptyView();
	            	}, this),
	            	error: showError
	            });
            }
        }, this));
    },

    onDialogAcceptButton: function() {
	    var context = this.getView().getBindingContext();
        this.getOwnerComponent().getModel().update(context.getPath(), {
            Description: this.byId("dialogInput2").getValue(),
            Price: this.byId("dialogInput3").getValue()
         }, {error: showError, success: jQuery.proxy(function(){this.dialog.close();}, this)});
    },

    onDialogCloseButton: function() {
        this.dialog.close();
    }
});
