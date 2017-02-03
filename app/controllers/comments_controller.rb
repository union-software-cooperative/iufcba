class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)
    respond_to do |format|
      if @comment.save
        notify

        format.html { redirect_to @comment.post.parent, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    parent = @comment.post.parent
    # TODO Can the CanCan gem clean this up.  Because there is no current_person acess in model so can't use before_destroy
    if @comment.person == current_person || owner? || (parent.class.to_s == 'Union' && can_edit_union?(parent))
      @comment.destroy
      notice = 'Comment was successfully destroyed.'
    else
      notice = 'You are not authorized to do that.'
    end
    respond_to do |format|
      format.html { redirect_to parent, notice: notice }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      result = params.require(:comment).permit(:body, :person_id, :post_id)
      result[:person] = current_person
      result
    end
    
    def notify
      # The poster and anyone who commented.
      recipients = [@comment.post.person]
      @comment.post.comments.each do |c|
        recipients << c.person
      end
      recipients.uniq.each do |p|
        if p.id != current_person.id
          PersonMailer.comment_notice(p, @comment, @division).deliver_now      
        end
      end
    end
end
