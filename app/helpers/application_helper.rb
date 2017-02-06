module ApplicationHelper
  # Intercept URL and path helpers, and add a division_id if there's a 
  # @division in scope. Otherwise, send the missed method on up the chain.
  # def method_missing(m, **args)
  #   super unless m.to_s.end_with?("_url") || m.to_s.end_with?("_path")
    
  #   if Rails.application.routes.url_helpers.respond_to?(m) && @division.present?
  #     Rails.application.routes.url_helpers.send(m, { division_id: @division.id }.merge(args))
  #   else super end
  # end

  def navbar_logo
    if @division && @division.logo.url
      @division.logo.url
    else
      image_path('iuf_logo.png')
    end
  end

  def page_title
    # Can only be called from application layout
    if @division
      "#{t('.title')} - #{@division.name}"
    else
      "#{t('.title')}"
    end
  end

  def profile_thumb(person)		
    unless person.attachment.blank?
      image_tag person.attachment.thumb.url, class: "profile_thumb"
    else
      "<span class=\"glyphicon glyphicon-user\"></span>".html_safe
    end
  end
  
  def l10n_switch_data(size: 'small', on_color: 'success')
    { :size => size, 'on-color' => on_color, 'on-text' => t('switch_yes'), 'off-text' => t('switch_no') }
  end

  def profile_logo(person)		
    unless person.attachment.blank?
      image_tag person.attachment.quote.url, class: "profile_logo"
    end
  end

  def pencil_button
    "<span class=\"small glyphicon glyphicon-pencil\"/>".html_safe 
  end

  def gender_options(person)
    options_for_select(
      ([
        t('gender.male'), 
        t('gender.female'),
        t('gender.other')
        ]).uniq, 
      person.gender
    )
  end

  def owner_union
    #Rails.application.config.owner_union ||= Union.find_by_short_name(ENV['OWNER_UNION']) rescue nil # Added for tests, since I couldn't get seeds to work
    #Rails.application.config.owner_union
    Union.find_by_short_name(ENV['OWNER_UNION']) rescue nil
  end

  def owner?
    return false unless current_person.present?
    return false unless owner_union.present?
    current_person.union.id == owner_union.id 
  end

  def iso_languages
    Rails.application.config.iso_languages
  end

  def language_options(selected_options)
    # put selected languages first to preserve selection order
    selected_options = selected_options.collect(&:to_sym)

    options_hash = iso_languages.slice(selected_options)
    options_hash.merge!(iso_languages.except(selected_options))

    options = options_hash.collect do |k,v|
      display_value = v[:nativeName] || v[:name]
      display_value += " (#{v[:name]})" unless v[:nativeName] == v[:name]
      [display_value,k]
    end

    options_for_select options, selected_options
  end

  def can_edit_union?(union)
    if current_person.present?
      if union.blank? || owner? || current_person.union.id == union.id
        true
      else
        false
      end 
    else
      false
    end
  end

  def selected_option(entity)
    entity ? 
      options_for_select([[entity.name, entity.id]], entity.id) :
      []
  end

  def offline_people()
    Person.where(["not (invitation_accepted_at is null or id in (?))", Secpubsub.presence.keys])
  end

  def local_time_tag(t)
  	content_tag(:span, I18n.l(t, format: :long), data: { time: t.iso8601 })
  end

  # def method_missing(m, *args, &block)
  #   m = m.to_s
  #   if m =~ /optional_division.+_[path|url]/
  #     if request.path =~ /\/divisions\//
  #       m = m.gsub(/optional_division/, 'division')
  #     else
  #       m = m.gsub(/optional_division_/, '')
  #     end
  #   end
  #   send(m, *args, &block)
  # end
  
  def page_colours
    bg = ENV["background_color"]
    bg = @division.colour1 if @division && @division.colour1

    fg = ENV["foreground_color"]
    fg = @division.colour2 if @division && @division.colour2
    
    <<~CSS.html_safe
      <style>
        body {
          background: #{bg};
          color: #{fg};
        }
        h1,h2,h3 {
          color: #{fg};
        }
        a,a:hover,a:focus,a:visited,a:active {
          color: #{fg}
        }
      </style>
    CSS
  end
end
