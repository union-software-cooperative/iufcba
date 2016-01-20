function buildSecpubsub(doc) {
	var subscriptions = [];
	var self = {
		subscribe: function(registration, callback) {

			var subscription = self.get_subscription(registration.channel);

			if (subscription === undefined) {
				// if no existing subscription and websocket
				var ws = new WebSocket(registration.server);
			
				ws.onmessage = self.callbackDispatch;
			
				ws.onopen = function () {
					ws.send(JSON.stringify(registration));
					subscription.client = ws;
				}

				subscription = {
					channel: registration.channel,
					registration: registration,
					callbacks: [], 
					client: undefined, 
					add_callback: function(callback) {
						var exists = false;
						subscription.callbacks.forEach(function(cb) {
							if (cb.toString() == callback.toString()) exists = true;
						});
						if (!exists) subscription.callbacks.push(callback);
					}	
				}

				ws.onclose = function (closeEvent) {
					self.default_connection_lost(subscription, closeEvent);
				}

				subscriptions.push(subscription);
			} else {
				// Else convert the subscription into a resubscription 
				// for the sake of updating presence
				if (!(subscription.client === undefined)) {
					subscription.client.send(JSON.stringify(registration));
				}
			}
			
			if (callback === undefined)
				callback = self.defaultCallback;

			subscription.add_callback(callback);
			return subscription;
		},
		unsubscribe: function(channel, callback) {
			subscription = self.get_subscription(channel);
			if (subscription === undefined) return;

			var index = -1;
			for (var i = 0; i < subscription.callbacks.length; i++)
				if (subscription.callbacks[i].toString() == callback.toString())
					index = i;

			if (index != -1) 
				subscription.callbacks.splice(index, 1);

			/*
			// Because the connection may not be open by the time we unsubscribe
			// I remarked this, in order to let it hang around.  It will get reused
			// when the next turbolinks pages subscribes again.

			if (subscription.callbacks.length == 0) {
				subscription.client.close();
				subscriptions = $.grep(subscriptions, function(sub) {
					return sub.channel != channel;
				});
			}
			*/
		},
		get_subscription: function(channel) {
			var result;
			subscriptions.forEach(function(sub){
				if (sub.channel == channel) result = sub;
			});
			return result;
		},
		get_callbacks: function(channel) {
			var result = [];
			subscription = self.get_subscription(channel);
			if (!(subscription === undefined))
				result = subscription.callbacks;

			return result;
		}, 
		callbackDispatch: function(messageEvent) {
			message = JSON.parse(messageEvent.data);
			
			self.lastMessageEvent = messageEvent;
			self.lastMessage = message

			subscription = self.get_subscription(message['channel'])
			if (!(subscription === undefined)) {
				subscription.callbacks.forEach(function(cb){
					cb(message);
				});	
			}			
		},
		defaultCallback: function(message) {
			if (typeof message['eval'] === 'undefined')
				console.log("When subscribing, please provide a callback to handle this message: " + message);
			else
				eval(message['eval']);
		},
		// TODO clean up subscriptions
		default_connection_lost: function(subscription, closeEvent) {
			var index = -1;
			for(var i = 0; i < subscriptions.length; i++)
				if (subscription == subscriptions[1]) index = i;

			subscriptions.splice(index, 1);

			self.connection_lost(subscription, closeEvent); // user customizable event
		}, 
		// Generic function for user override
		connection_lost: function(subscription, closeEvent) {
			console.log("Connection to " + subscription.channel + " server lost.  Please refresh the page.");
		},
		// Was thinking this would be useful, particularly when using turbo-links, but
		// closing websockets is slow.  
		page_reset: function() {
			subscriptions.forEach(function(s){
				s.client.close();
			});
			subscriptions = [];
		}
	}
	//$(document).on('page:before-change', self.page_reset); // handle turbo links

	return self;
}

var Secpubsub = buildSecpubsub(document);
