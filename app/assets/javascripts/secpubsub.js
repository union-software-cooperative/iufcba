function buildSecpubsub(doc) {
	var secpubsub_callbacks = {}
	var clients = []
	var self = {
		subscribe: function(subscription, callback) {
			var ws = new WebSocket(subscription.server);

			if (!(callback === undefined))
				self.set_callback(subscription.channel, callback)

			ws.onmessage = self.callbackDispatch;
			ws.onopen = function () {
				ws.send(JSON.stringify(subscription));
				clients.push(ws)
			}
			ws.onclose = self.default_connection_lost;
		},
		get_callbacks: function(channel) {
			result = secpubsub_callbacks[channel];
			return result;
		},
		set_callback: function(channel, callback) {
			if (secpubsub_callbacks[channel] === undefined)
				secpubsub_callbacks[channel] = [];

			secpubsub_callbacks[channel].push(callback);
		}, 
		callbackDispatch: function(messageEvent) {
			message = JSON.parse(messageEvent.data);
			
			self.lastMessageEvent = messageEvent;
			self.lastMessage = message

			callbacks = self.get_callbacks(message['channel'])
			if (callbacks === undefined)
				self.defaultCallback(message);
			else
				callbacks.forEach(function(cb){
					cb(message);
				});				
		},
		defaultCallback: function(message) {
			if (typeof message['eval'] === 'undefined')
				console.log("When subscribing, please provide a callback to handle this message: " + message);
			else
				eval(message['eval']);
		},
		default_connection_lost: function() {
			self.connection_lost();
		}, 
		connection_lost: function() {
			console.log("Connection lost.  Please refresh the page.");
		},
		page_reset: function() {
			secpubsub_callbacks = {};
			clients.forEach(function(client){
				client.close();
			})
			clients = [];

		}
	}
	$(document).on('page:before-change', self.page_reset); // handle turbo links

	return self;
}

var Secpubsub = buildSecpubsub(document);
