class ApplicationController < ActionController::Base
  include ApplicationHelper

  before_action :authenticate_person!
  before_action :set_division
  before_action :set_breadcrumbs, if: :format_html?, except: [:update, :create, :destroy]

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

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
  
  private
  def breadcrumbs
    [
      [
        I18n.t("layouts.navbar.divisions").titlecase, 
        divisions_path, 
        match_action?("divisions", "index")
      ],
      @division ? [
        @division.short_name.titlecase, 
        division_path(@division),
        true # there's no Division#show action
      ] : nil
    ].compact
  end
  
  def set_breadcrumbs
    @breadcrumbs = breadcrumbs
  end
  
  def match_action?(controller, action)
    params[:controller] == controller && params[:action] == action
  end
  
  def not_action?(controller, action)
    params[:controller] == controller && params[:action] != action
  end
  
  def format_html?
    request.format.html?
  end
end
