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

  # DELETE /comments/1.json
  def destroy
    @message = Message.find(params[:id])

    respond_to do |format|
      if @message.person == current_person || owner? 
        if @message.destroy
          format.js { render :destroy }
        else 
          format.js { render js: "alert('Whoops!  Something went wrong...');" } # unprocessible 
        end
      else
        format.js { render js: "alert('You are forbidden');" } # forbidden 
      end
    end
  end

  private
  def message_params
    params.require(:message).permit(:body, :person_id, :display_name)
  end

  def notify
    #  offline_people.each do |p|
    #    PersonMailer.message_notice(p, @message, "#{request.protocol}#{request.host}#{messages_path}", "noreply@#{request.host}").deliver_later      end
  end
end
