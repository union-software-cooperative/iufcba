class PeopleController < ApplicationController
  prepend_before_action :forbid, only: [:show, :edit, :update, :destroy]
  prepend_before_action :set_person, only: [:show, :edit, :update, :destroy, :compose_email, :send_email]

  # GET /people
  # GET /people.json
  def index
    @people = Person.filter(params.slice(:name_like))
    @people = @people.in_division(@division.id) if @division.present?
    @people = @people.where(["union_id = ?", current_person.union_id]) if request.format.json? && !owner?
    @people = @people.order([:last_name, :first_name, :id])

    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /people/1/edit
  def edit
  end

  # PATCH/PUT /people/1
  # PATCH/PUT /people/1.json
  def update
    @person.authorizer = current_person
    respond_to do |format|
      if @person.update(person_params)
        @person.invite!(current_person) if params['resend_invite']=='true'

        # destination = @division ? people_path : divisions_path

        format.html { redirect_to (@division ? division_people_path : people_path), notice: 'Profile successfully updated.' }
        format.json { render :show, status: :ok, location: @person }
      else
        format.html { render :edit }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    @person.destroy rescue nil
    respond_to do |format|
      if @person.destroyed?
        format.html { redirect_to people_url, notice: 'Person was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to edit_person_path(@person), notice: "Could not delete person, probably because they've posted content.  TODO Create a way to deactivate and hide people."
        }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  def compose_email
  end

  def send_email
    PersonMailer.private_email(@person, current_person, params[:subject], params[:body], request).deliver_now
    redirect_to (@division ? division_people_path : people_url), notice: "Email sent..."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def person_params
      result = params.require(:person).permit(:first_name, :last_name, :title, :address, :mobile, :fax, :email, :attachment, :union_id, :gender, :remove_attachment, :country, :languages => [])
      result['languages'].delete("") if result['languages']
      result
    end

    def forbid
      return forbidden if params[:action] == "destroy" && !owner?
      return forbidden unless can_edit_union?(@person.union)
    end

    def breadcrumbs
      (@division ? super : []) + [
        [I18n.t("layouts.navbar.people").titlecase, (@division ? division_people_path : people_path), action?("index")],
        @person ? [@person.name, edit_person_path(@person), !action?("index")] : nil
      ].compact
    end
end
