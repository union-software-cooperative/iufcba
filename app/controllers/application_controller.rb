class ApplicationController < ActionController::Base
  include ApplicationHelper

  before_action :set_division

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_person!

  def default_url_options(options={})
    result = {} #{ locale: I18n.locale }
    result.merge!({ division_id: params[:division_id] }) if params[:division_id] #request.path =~ /\/divisions\//
    result.merge! options
  end

  def set_division
    if params[:division_id]
      @division = Division.where("short_name ilike ?", params[:division_id]).first
      @division ||= Division.find_by_id(params[:division_id]) 
      not_found unless @division
    end
  end

  def not_found
    render(:file => File.join(Rails.root, 'public/404.html'), :status => 404, :layout => false)
  end

  def forbidden
    render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false)
  end
end
