class ChatController < ActionController::Base
	layout false 

	def index
	end

	def publish
		Secpubsub.publish_to("/messages/new", "alert('message test');")
  end
end
