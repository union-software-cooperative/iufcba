class HelpController < ApplicationController
  before_action :authenticate_person!, except: [:show]

  def show
  end
end
