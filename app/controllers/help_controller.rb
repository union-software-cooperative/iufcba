class HelpController < ApplicationController
  skip_before_action :authenticate_person!

  def show
    # redirect_to divisions_path if person_signed_in?
  end
end
