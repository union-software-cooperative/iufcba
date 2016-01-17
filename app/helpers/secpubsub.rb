require "digest/sha1"
require 'secpubsub_adapter'
require 'eventmachine'

module Secpubsub
	class << self
		attr_reader :config

    # Resets the configuration to the default (empty hash)
    def reset_config
      @config = {}
    end

    def adapter_options
    	{
    		secret_token: config[:secret_token]
    	}
    end

    def server 
    	url = URI.parse(config[:server])
    	(url.scheme == 'https' ? "wss" : "ws") + "://#{url.host}:#{url.port}"
    end


 		# Determine if the signature has expired given a timestamp.
    def signature_expired?(timestamp)
      timestamp < ((Time.now.to_f - config[:signature_expiration])*1000).round if config[:signature_expiration]
    end

    def subscription(options = {})
      sub = {
      	server: server, 
      	timestamp: (Time.now.to_f * 1000).round
      }.merge(options)
      sub[:auth_token] = Digest::SHA1.hexdigest([config[:secret_token], sub[:command], sub[:channel], sub[:timestamp]].join)
      sub[:auth_token] = nil if signature_expired?(sub[:timestamp])
      sub
    end


	  # Returns a message hash for sending to Faye
    def publish_to(channel, data)
      #message = {:channel => channel, :data => {:channel => channel}, :ext => {:auth_ => config[:secret_token]}}
      message = subscription(channel: channel, command: 'publish')
      
      if data.kind_of? String
        message[:eval] = data
      else
        message[:data] = data
      end
      
      publish_message(message)
    end

    # Sends the given message hash to the Faye server using Net::HTTP.
    def publish_message(message)
    	EM.run {
    		ws = Faye::WebSocket::Client.new(server)
		    ws.on :open do |event|
		    	ws.send message.to_json
		    end	
    	}
    end
	end

	module ViewHelpers
    def subscribe_to(channel)
    	subscription = Secpubsub.subscription(channel: channel, command: 'subscribe')
      content_tag "script", :type => "text/javascript" do
        raw("Secpubsub.subscribe(#{subscription.to_json});")
      end
    end

  end

	reset_config 
	ActionView::Base.send :include, ViewHelpers
end