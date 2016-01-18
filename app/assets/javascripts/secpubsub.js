function buildSecpubsub(doc) {
	var self = {
		subscribe: function(subscription, callback) {
			var ws = new WebSocket(subscription.server);
			if (typeof callback === 'undefined') 
				callback = self.defaultHandler;
			
			ws.onmessage = callback;
			ws.onopen = function () {
				ws.send(JSON.stringify(subscription));
			}
			ws.onclose = self.default_connection_lost;
		},
		defaultHandler: function(messageEvent) {
			message = JSON.parse(messageEvent.data);
			
			self.lastMessageEvent = messageEvent;
			self.lastMessage = message

			if (typeof message['eval'] === 'undefined')
				console.log("When subscribing, please provide a callback to handle this message: " + messageEvent.data);
			else
				eval(message['eval']);
		},
		default_connection_lost: function() {
			self.connection_lost();
		}, 
		connection_lost: function() {
			alert("Connection lost.  Please refresh the page.");
		}
	}
	return self;
}

var Secpubsub = buildSecpubsub(document);