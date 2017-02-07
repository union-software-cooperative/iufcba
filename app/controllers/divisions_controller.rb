class DivisionsController < ApplicationController
  before_action :set_division, only: [:show, :edit, :update, :destroy]
  before_action :forbid, only: [:new, :create, :edit, :update]

  # GET /divisions
  # GET /divisions.json
  def index
    @divisions = Division.all
    respond_to do |format|
      format.html
      format.json { render json: @divisions }
    end
  end

  # GET /divisions/new
  def new
    @division = Division.new
  end

  # GET /divisions/1/edit
  def edit
  end

  # POST /divisions
  # POST /divisions.json
  def create
    @division = Division.new(division_params)

    respond_to do |format|
      if @division.save
        format.html { redirect_to :divisions, notice: 'Division was successfully created.' }
        format.json { render :divisions, status: :created }
      else
        format.html { render :new }
        format.json { render json: @division.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /divisions/1
  # PATCH/PUT /divisions/1.json
  def update
    respond_to do |format|
      if @division.update(division_params)
        format.html { redirect_to :divisions, notice: 'Division was successfully updated.' }
        format.json { render :divisions, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @division.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /divisions/1
  # DELETE /divisions/1.json
  def destroy
    @division.destroy
    respond_to do |format|
      format.html { redirect_to divisions_url, notice: 'Division was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_division
      @division = Division.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def division_params
      params.require(:division).permit(:name, :short_name, :logo, :colour1, :colour2)
    end

    def forbid
      return forbidden unless owner?
    end
end
