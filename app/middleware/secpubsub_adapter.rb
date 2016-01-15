require 'faye/websocket'

module Secpubsub
  class Adapter
    KEEPALIVE_TIME = 15 # in seconds
    CHANNEL        = "chat-demo"

    def initialize(app, options)
      @app     = app
      @channels = {}
    end

    def call(env)
      if Faye::WebSocket.websocket?(env)
        ws = Faye::WebSocket.new(env, nil, {ping: KEEPALIVE_TIME })
        ws.on :open do |event|
          p [:open, ws.object_id]
        end

        ws.on :message do |event|
          data = unpack(event.data)
          
          subscribed = authenticate_subscribe(data, ws)
          published = authenticate_publish(data)
          
          unless subscribed || published
            p [:message, data]
            ws.close(1000, 'authentication failed')
          end
        
          ws.close(1000, 'publish request fulfilled') if published
        end

        ws.on :close do |event|
          p [:close, ws.object_id, event.code, event.reason]
          @channels.each do |k,v|
            v.delete(ws)
          end
          ws = nil
        end

        # Return async Rack response
        ws.rack_response

      else
        @app.call(env)
      end
    end

    def unpack(data)
      JSON.parse(data).symbolize_keys
    end
  
    def authenticate_subscribe(data, ws)
      if Secpubsub.subscription(data)[:auth_token] == data[:auth_token]
        @channels[data[:channel]] ||= []
        @channels[data[:channel]] << ws
        p [:subscribe, data[:channel], "subscribers: #{(@channels[data[:channel]]||[]).count}"]
        
        true
      end
    end

    def authenticate_publish(data)
      if Secpubsub.config[:secret_token] == data[:auth_token]
        sanitised_data = data.reject {|k,v| k == :auth_token}.to_json
        p [:publish, sanitised_data]
        channel_clients = @channels[data[:channel]] || []
        channel_clients.each do |client| 
          client.send(sanitised_data) 
          p [:sent, data[:channel], client.object_id, sanitised_data]
        end

        true
      end 
    end   
  end
end