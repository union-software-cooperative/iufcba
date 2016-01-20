require 'faye/websocket'

module Secpubsub
  class Adapter
    KEEPALIVE_TIME = 15 # in seconds
    CHANNEL        = "chat-demo"

    def initialize(app, options)
      @app     = app
      @channels = {}
      @presence = {}
    end

    def call(env)
      if Faye::WebSocket.websocket?(env)
        ws = Faye::WebSocket.new(env, nil, {ping: KEEPALIVE_TIME })
        ws.on :open do |event|
          p [:open, ws.object_id]
        end

        ws.on :message do |event|
          data = unpack(event.data)
          #p [:message, data]
          
          if authenticated(data)
            
            create_presence(data, ws)
            
            case data[:command]
            when 'subscribe'
              subscribe(data, ws)
            when 'publish'
              publish(data)
              ws.close(1000, 'publish request fulfilled')
            else
              ws.close(1000, 'unknown command')
            end
          else 
            p [:authentication_failed]
            ws.close(1000, 'authentication failed') #neither 1008 code works, or reason???
          end
        end

        ws.on :close do |event|
          p [:close, ws.object_id, event.code, event.reason]
          destroy_presence(ws)

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

    def authenticated(data)
      Secpubsub.subscription(data)[:auth_token] == data[:auth_token]
    end
  
    def subscribe(data, ws)
      ch = data[:channel]
      @channels[ch] ||= []
      
      #if @channels[ch].include?(ws) 
      #  p[:resubscribe, ch, "subscribers: #{(@channels[ch]||[]).count}"]  
      #else
      unless @channels[ch].include?(ws)
        @channels[ch] << ws 
        p [:subscribe, ch, "subscribers: #{(@channels[ch]||[]).count}"]  
      else
        p [:resubscribe, ch, data[:person_handle]]
      end
      
      if ch == "/presence"
        ws.send(presence.to_json)
      end
    end

    def publish(data)
      ch = data[:channel]
      sanitised_data = data.reject {|k,v| k == :auth_token}.to_json
      #p [:publish, sanitised_data]
      channel_clients = @channels[ch] || []
      channel_clients.each do |client| 
        client.send(sanitised_data) 
        #p [:sent, ch, client.object_id, sanitised_data]
      end
    end

    def create_presence(data, ws)
      if data[:person_id].present?
        c = presence[:data].length
        @presence[ws.object_id] = {
          id: data[:person_id], 
          handle: data[:person_handle],
          created_at: Time.now,
          channel: data[:channel]
        }
        if c != presence[:data].length
          p [:presence_change, presence]
          send_presence
        end
      end
    end

    def destroy_presence(ws)
      c = presence[:data].length
      @presence.reject! { |k,v| k==ws.object_id }
      if c != presence[:data].length
        p [:presence_change, presence]
        send_presence
      end
    end

    def send_presence
      p = presence
      (@channels['/presence'] || []).each do |client|
        p [:send_presence]
        client.send(p.to_json)
      end
    end

    def presence
      result = {} 
      @presence.each do |k,v|
        result[v[:id]] = v # assumes items at end of enumeration will have later timestamps
      end
      {channel: '/presence', data: result }
    end   
  end
end