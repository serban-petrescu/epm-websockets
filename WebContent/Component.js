/* global showError */
jQuery.sap.declare("epmwebsockets.Component");
jQuery.sap.require("epmwebsockets.MessageHandler");
jQuery.sap.require("epmwebsockets.MyRouter");
sap.ui.core.UIComponent.extend("epmwebsockets.Component", {
	metadata : {
		name : "epmwebsockets",
		version : "1.0",
		includes : [],
		dependencies : {
			libs : ["sap.m", "sap.ui.layout"],
			components : []
		},

		rootView : "epmwebsockets.view.App",

		config : {
			resourceBundle : "i18n/messageBundle.properties",
			serviceConfig : {
				name: "",
				serviceUrl: "model.svc/"
			},
			ws: {
				url: "./ws",
				cooldown: 1000
			},
			abapServiceConfig : {
				name: "",
				serviceUrl: "/sap/opu/odata/SAP/Z<GW_SERVICE_NAME>/"
			},
			abapWs: {
				url: "/sap/bc/apc/sap/z<push_channel_name>",
				cooldown: 1000
			},
			backendServiceConfig : {
				name: "",
				serviceUrl: "backend.svc/"
			},
			backendWs: {
				url: "./bws",
				cooldown: 1000
			},
		},

		routing : {
			config : {
				routerClass : epmwebsockets.MyRouter,
				viewType : "XML",
				viewPath : "epmwebsockets.view",
				targetAggregation : "detailPages",
				clearTarget : false
			},
			routes : [
				{
					pattern : "",
					name : "main",
					view : "Master",
					targetAggregation : "masterPages",
					targetControl : "idAppControl",
					subroutes : [
						{
							pattern : "{entity}/:tab:",
							name : "detail",
							view : "Detail"
						}
					]
				},
				{
					name : "catchallMaster",
					view : "Master",
					targetAggregation : "masterPages",
					targetControl : "idAppControl",
					subroutes : [
						{
							pattern : ":all*:",
							name : "catchallDetail",
							view : "NotFound",
							transition : "show"
						}
					]
				}
			]
		}
	},

	init : function() {
		sap.ui.core.UIComponent.prototype.init.apply(this, arguments);

		var mConfig = this.getMetadata().getConfig();
		var p = getQueryParams(document.location.search);
		if (p.location == "abap") {
			mConfig.serviceConfig = mConfig.abapServiceConfig;
			mConfig.ws = mConfig.abapWs;
		}
		else if (p.location == "backend") {
			mConfig.serviceConfig = mConfig.backendServiceConfig;
			mConfig.ws = mConfig.backendWs;
		}
		// Always use absolute paths relative to our own component
		// (relative paths will fail if running in the Fiori Launchpad)
		var oRootPath = jQuery.sap.getModulePath("epmwebsockets");

		// Set i18n model
		var i18nModel = new sap.ui.model.resource.ResourceModel({
			bundleUrl : [oRootPath, mConfig.resourceBundle].join("/")
		});
		this.setModel(i18nModel, "i18n");

		var sServiceUrl = mConfig.serviceConfig.serviceUrl;

		var oModel = new sap.ui.model.odata.ODataModel(sServiceUrl, {json: true,loadMetadataAsync: true});
		oModel.attachMetadataFailed(function(){
            this.getEventBus().publish("Component", "MetadataFailed");
		},this);
		oModel.setDefaultCountMode(sap.ui.model.odata.CountMode.Inline);
		oModel.attachRequestFailed(showError);
		this.setModel(oModel);

		// Set device model
		var oDeviceModel = new sap.ui.model.json.JSONModel({
			isTouch : sap.ui.Device.support.touch,
			isNoTouch : !sap.ui.Device.support.touch,
			isPhone : sap.ui.Device.system.phone,
			isNoPhone : !sap.ui.Device.system.phone,
			listMode : sap.ui.Device.system.phone ? "None" : "SingleSelectMaster",
			listItemType : sap.ui.Device.system.phone ? "Active" : "Inactive"
		});
		oDeviceModel.setDefaultBindingMode("OneWay");
		this.setModel(oDeviceModel, "device");

		this.getRouter().initialize();
		this.wsHandler = new epmwebsockets.MessageHandler(mConfig.ws.url, mConfig.ws.cooldown);
		this.wsHandler.attachRefresh(jQuery.proxy(function(){
			this.getModel().refresh(true, true);
		}, this));
		this.wsHandler.attachError(function(){
			sap.m.MessageToast.show(i18nModel.getResourceBundle().getText("wsError"));
		});
		oModel.attachEvent("requestSent", jQuery.proxy(function(oEvent){
			if (oEvent.getParameter("type") != "GET") {
				this.wsHandler.ignoreNext();
			}
		}, this));

	},


	getEventBus : function () {
		return sap.ui.getCore().getEventBus();
	}
});