class MessagesController < ApplicationController
	#layout false 

	def index
		@messages = Message.all
	end

	def create
		@message = Message.create!(message_params)
	end

 private
 	def message_params
 		  params.require(:message).permit(:body, :person_id, :display_name)
 	end
end
