module ControllerExampleHelpers
  [:get, :post, :put, :delete].each do |verb|
    define_method("scoped_#{verb}") do |action, params = {}, session = nil|
      scoped_request(method(verb), action, params, session)
    end
  end

  private
  def scoped_request(verb, action, params, session)
    params = if @division
      { division_id: @division.id, locale: I18n.default_locale }.merge(params)
    else
      { locale: I18n.default_locale }.merge(params)
    end
    
    verb.call action, params, session
  end
end
