module DivisionsHelper

	 def division_logo_image
    unless @division.logo.blank?
      image_tag @division.logo.url, class: "logo-image"
    end
  end
end
