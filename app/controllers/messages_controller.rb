class MessagesController < ApplicationController
	#layout false 
	after_action :notify, only: [:create]

	def index
		since = Time.parse(params[:last_message_time] || Time.now.to_s)
		@messages = Message.eager_load(:person).where(['messages.created_at < ?', since]).order('messages.created_at desc').limit(25).reverse
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


    def notify
      offline_people.each do |p|
        PersonMailer.message_notice(p, @message, request).deliver_now
      end
    end
end
