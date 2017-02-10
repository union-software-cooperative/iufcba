class ApplicationController < ActionController::Base
  include ApplicationHelper

  before_action :authenticate_person!, except: [:pass_to_locale_scope]
  before_action :expand_navbar?
  before_action :set_division
  before_action :set_locale
  before_action :set_breadcrumbs, if: :format_html?, except: [:update, :create, :destroy]

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def pass_to_locale_scope
    redirect_to root_with_locale_path
  end
  
  def after_sign_in_path_for(person)
    divisions_path
  end

  def default_url_options(options={})
    result = {} #{ locale: I18n.locale }
    [:locale, :division_id].each { |p| result.merge!(p => params[p]) if params[p] }
    result.merge! options
  end

  def set_division
    if params[:division_id]
      @division = Division::Translation.where(locale: I18n.locale).
        find_by_short_name(params[:division_id]).try(:globalized_model)
      # @division = Division.where("short_name ilike ?", params[:division_id]).first
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
  def set_locale
    supported_locales = I18n.available_locales.map(&:to_s)
    
    # Returns the first, and only the first, provided_locale that is supported.
    # Order of provided_locales array determines precedence!
    I18n.locale = provided_locales.find(&supported_locales.method(:include?))
    
    # redirect_to url_for(params.merge(locale: I18n.locale, only_path: true)) unless params[:locale]
    params[:locale] = I18n.locale
  end
  
  # 
  def provided_locales
    ([*params[:locale]] | [I18n.default_locale]).compact
  end
  
  def breadcrumbs
    [
      [
        I18n.t("layouts.navbar.divisions").titlecase, 
        divisions_path(division_id: nil),
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
  
  def expand_navbar?
    @expand_navbar = true
  end
end
