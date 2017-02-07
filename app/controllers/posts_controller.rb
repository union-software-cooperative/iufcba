class PostsController < ApplicationController
  before_action :set_post, only: [:edit, :update, :destroy]

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    respond_to do |format|
      if @post.save
        notify

        format.html { redirect_to @post.parent, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    parent = @post.parent

    # TODO Can the CanCan gem clean this up.  Because there is no current_person acess in model so can't use before_destroy
    if @post.person == current_person
      @post.destroy
      notice = 'Post was successfully destroyed.'
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
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      result = params.require(:post).permit(:body, :attachment, :person_id, :parent_id, :parent_type)
      result[:person] = current_person
      result
    end

    def notification_recipients(post)
      result = post.parent.followers(Person)
      result += [post.parent.person] if post.parent.respond_to? :person
      result
        .uniq
        .reject { |p| p.id == current_person.id}
    end

    def notify
      notification_recipients(@post).each do |p|
        PersonMailer.post_notice(p, @post, @division).deliver_now
      end
    end
end
