class MessagesController < ApplicationController
	#layout false 

	def index
		since = Time.parse(params[:last_message_time] || Time.now.to_s)
		@messages = Message.where(['created_at < ?', since]).order('created_at desc').limit(25).reverse
		respond_to do |format|
      format.html 
      format.json { return render @messages, formats: 'html' }
    end
	end

	def create
		@message = Message.create!(message_params)
	end

 private
 	def message_params
 		  params.require(:message).permit(:body, :person_id, :display_name)
 	end
end
