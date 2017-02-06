class RecsController < ApplicationController
  before_action :set_rec, only: [:show, :edit, :update, :destroy, :follow]
  before_action :forbid, only: [:edit, :update]

  # GET /recs
  # GET /recs.json
  def index
    @recs = Rec.all
  end

  # GET /recs/new
  def new
    @rec = Rec.new
  end

  # GET /recs/1
  # GET /recs/1.json
  def show
    @post = Post.new(parent: @rec)
  end

  def show
    @post = Post.new(parent: @rec)
  end

  # GET /recs/1/edit
  def edit
  end

  # POST /recs
  # POST /recs.json
  def create
    @rec = Rec.new(rec_params)
    @rec.authorizer = current_person
    
    respond_to do |format|
      if @rec.save
        subscribe
        notify
        thank

        format.html { redirect_to @rec, notice: 'Rec was successfully created.' }
        format.json { render :show, status: :created, location: @rec }
      else
        format.html { render :new }
        format.json { render json: @rec.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recs/1
  # PATCH/PUT /recs/1.json
  def update
    @rec.authorizer = current_person
    
    respond_to do |format|
      if @rec.update(rec_params)
        format.html { redirect_to @rec, notice: 'Rec was successfully updated.' }
        format.json { render :show, status: :ok, location: @rec }
      else
        format.html { render :edit }
        format.json { render json: @rec.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recs/1
  # DELETE /recs/1.json
  def destroy
    @rec.destroy
    respond_to do |format|
      format.html { redirect_to recs_url, notice: 'Rec was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def follow
    current_person.toggle_follow!(@rec) unless @rec.person.id == current_person.id # can't toggle follow status if you are assigned
    redirect_to @rec
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rec
      @rec = Rec.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rec_params
      result = params.require(:rec).permit(:taking_action, :name, :tags, 
        :start_date, :end_date, :attachment, :coverage, :union_id, :company_id, 
        :person_id, :multi_site, :health_and_safety, :health_and_safety_page, 
        :health_and_safety_clause, :anti_precariat, :anti_precariat_page, 
        :anti_precariat_clause, :grievance_handling, :grievance_handling_page, 
        :grievance_handling_clause, :other_provisions, :specific_rights, 
        :specific_rights_page, :specific_rights_clause, 
        :nature_of_operation => [], :divisions => [])
      result['nature_of_operation'].delete("") if result['nature_of_operation']
      result[:divisions] = Division.find(result[:divisions].reject(&:blank?)) if result[:divisions]
      result
    end
    
    # def assign_divisions
    #   rec_params[:divisions].each { |id| @rec.divisions << Division.find(id) }
    # end

    def forbid
      return forbidden unless can_edit_union?(@rec.union)
    end

    def notification_recipients(rec)
      (@rec.union.followers(Person) + @rec.company.followers(Person)).uniq.reject { |p| p.id == current_person.id }
    end

    def subscribe
      ##(@rec.union.followers(Person) + @rec.company.followers(Person)).uniq.each do |p|
      #@rec.union.people.each do |p|
      #  p.follow! @rec
      #end

      @rec.person.follow! @rec
    end

    def notify
      notification_recipients(@rec).each do |p|
        PersonMailer.rec_notice(p, @rec, @division).deliver_now
      end
    end

    def thank
      PersonMailer.thanks(current_person, @rec, @division, notification_recipients(@rec)).deliver_now
    end
end
