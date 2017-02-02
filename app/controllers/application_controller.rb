class ApplicationController < ActionController::Base
  include ApplicationHelper

  before_action :set_division

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_person!

  def set_division
    @division = Division.find(params[:division_id]) if params[:division_id]
  end

  def not_found
    render(:file => File.join(Rails.root, 'public/404.html'), :status => 404, :layout => false)
  end

  def forbidden
    render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false)
  end
end
