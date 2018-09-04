jQuery.sap.declare("epmwebsockets.MessageHandler");
jQuery.sap.require("sap.ui.core.ws.WebSocket");

sap.ui.base.EventProvider.extend("epmwebsockets.MessageHandler", {
	constructor: function(url, cooldown) {
		sap.ui.base.EventProvider.apply(this);
		try {
			this.ws = new sap.ui.core.ws.WebSocket(url);
			this.ws.attachError(jQuery.proxy(this.fireError, this));
			this.ws.attachMessage(jQuery.proxy(this.handleMessage, this));
			this.cooldown = cooldown;
			this.last = (new Date()).getTime();
			this.programmed = false;
			this.ignore = false;
		}
		catch(e) {
			this.fireError(e);
		}
	},

	metadata: {
		publicMethods : [ "attachError", "detachError", "attachRefresh", "detachRefresh", "notify", "ignoreNext" ]
	}

});
epmwebsockets.MessageHandler.M_EVENTS = {
	error : "error",
	refresh : "refresh"
};

epmwebsockets.MessageHandler.prototype.ignoreNext = function(oEvent) {
	this.ignore = true;
	return this;
};

epmwebsockets.MessageHandler.prototype.fireError = function(oEvent) {
	this.fireEvent("error", oEvent);
	return this;
};

epmwebsockets.MessageHandler.prototype.handleMessage = function(oEvent) {
	if (!this.ignore) {
		try {
			var msg = JSON.parse(oEvent.getParameter("data"));
			if (msg.action == "refresh") {
				var time = (new Date()).getTime();
				if (this.cooldown > 0 && time - this.last < this.cooldown) {
					if (!this.programmed) {
						this.programmed = true;
						setTimeout(time - this.last, jQuery.proxy(function(){
							this.programmed = false;
							this.last = (new Date()).getTime();
							this.fireEvent("refresh");
						}, this));
					}
				}
				else {
					this.last = (new Date()).getTime();
					this.fireEvent("refresh");
				}
			}
		} catch (e) {
			this.fireError(e);
		}
	}
	else {
		this.ignore = false;
	}
	return this;
};

epmwebsockets.MessageHandler.prototype.notify = function() {
	var time = (new Date()).getTime();
	this.ignore = true;
	if (this.cooldown > 0 && time - this.last < this.cooldown) {
		if (!this.programmed) {
			this.programmed = true;
			setTimeout(time - this.lastNotify, jQuery.proxy(function(){
				this.programmed = false;
				this.last = (new Date()).getTime();
				this.ws.send(JSON.stringify({action: "refresh"}));
			}, this));
		}
	}
	else {
		this.last = (new Date()).getTime();
		this.ws.send(JSON.stringify({action: "refresh"}));
	}
	return this;
};

epmwebsockets.MessageHandler.prototype.detachRefresh = function(handler) {
	this.detachEvent("refresh", handler);
	return this;
};

epmwebsockets.MessageHandler.prototype.attachRefresh = function(handler) {
	this.attachEvent("refresh", handler);
	return this;
};
epmwebsockets.MessageHandler.prototype.detachError = function(handler) {
	this.detachEvent("error", handler);
	return this;
};

epmwebsockets.MessageHandler.prototype.attachError = function(handler) {
	this.attachEvent("error", handler);
	return this;
};