class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

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

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
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

    def notify
      @post.parent.followers(Person).each do |p|
      if p.id != current_person.id
        PersonMailer.post_notice(p, @post, request).deliver_now
      end
    end
  end
end
