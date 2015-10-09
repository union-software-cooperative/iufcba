class SupergroupsController < ApplicationController
  
  before_action :set_klass
  before_action :set_supergroup, only: [:show, :edit, :update, :destroy]

  include SupergroupsHelper

  # GET /supergroups
  # GET /supergroups.json
  def index
    @supergroups = @klass.all
  end

  # GET /supergroups/1
  # GET /supergroups/1.json
  def show
  end

  # GET /supergroups/new
  def new
    @supergroup = @klass.new
  end

  # GET /supergroups/1/edit
  def edit
  end

  # POST /supergroups
  # POST /supergroups.json
  def create
    @supergroup = @klass.new(supergroup_params)

    respond_to do |format|
      if @supergroup.save
        format.html { redirect_to @supergroup, notice: "#{supergroup.titlecase} was successfully created." }
        format.json { render :show, status: :created, location: @supergroup }
      else
        format.html { render :new }
        format.json { render json: @supergroup.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /supergroups/1
  # PATCH/PUT /supergroups/1.json
  def update
    respond_to do |format|
      if @supergroup.update(supergroup_params)
        format.html { redirect_to @supergroup, notice: "#{supergroup.titlecase} was successfully updated." }
        format.json { render :show, status: :ok, location: @supergroup }
      else
        format.html { render :edit }
        format.json { render json: @supergroup.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /supergroups/1
  # DELETE /supergroups/1.json
  def destroy
    @supergroup.destroy
    respond_to do |format|
      format.html { redirect_to polymorphic_url(supergroups), notice: "#{supergroup.titlecase} was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_klass
      @klass = params[:type].blank? ? Supergroup : params[:type].constantize
    end

    def set_supergroup
      @supergroup = @klass.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def supergroup_params
      params[supergroup]['type'] = @klass.name
      params.require(supergroup).permit(:name, :type, :www)
    end
end