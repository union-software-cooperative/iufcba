function buildSecpubsub(doc) {
	var secpubsub_callbacks = {}
	var self = {
		subscribe: function(subscription, callback) {
			var ws = new WebSocket(subscription.server);
			
			ws.onmessage = self.callbackDispatch;
			ws.onopen = function () {
				ws.send(JSON.stringify(subscription));
			}
			ws.onclose = self.default_connection_lost;
		},
		get_callback: function(channel) {
			result = secpubsub_callbacks[channel];
			alert('getting ' + channel + ' callback: ' + result);
			return result;
		},
		set_callback: function(channel, callback) {
			secpubsub_callbacks[channel] = callback;
			alert('setting ' + channel);
		}, 
		callbackDispatch: function(messageEvent) {
			message = JSON.parse(messageEvent.data);
			
			self.lastMessageEvent = messageEvent;
			self.lastMessage = message

			callback = self.get_callback(message['channel'])
			if (callback === undefined)
				self.defaultCallback(message);
			else
				eval(callback);			
		},
		defaultCallback: function(message) {
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