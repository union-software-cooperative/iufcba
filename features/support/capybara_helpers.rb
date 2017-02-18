module CapybaraHelpers
	def select2(value, selector)
	  #s2c = first("#s2id_#{attrs[:from]}")
	  #(s2c.first(".select2-choice") || s2c.find(".select2-choices")).click

	  #find(:xpath, "//body").all("input.select2-input")[-1].set(value)
	  #binding.pry
	  #fill_in placeholder, with: value # was working??

	  #page.execute_script(%|$("input.select2-input:visible").keyup();|)
	  if selector[:div]
	  	first("##{selector[:div]} .select2-selection").click
	  	first("##{selector[:div]} .select2-search__field").set(value)
	  end

	  if selector[:argh]
	  	first("##{selector[:argh]} .select2-selection").click
	  	all('input').last.set(value)
		end

	  if selector[:label]
	  	field_labeled(selector[:label]).click 
	  	all('input').last.set(value)
		end

		if selector[:placeholder]
			fill_in selector[:placeholder],	with: value
		end

	  all('.select2-results li', text: value)[-1].click

	  #drop_container = ".select2-results"
	  #find(:xpath, "//body").all("#{drop_container} li", text: value)[-1].click
	end

	def select2_clear(selector)
		if selector[:label]
			f = field_labeled(selector[:label]).parent
		end
		f.find('.select2-selection__clear').click
	end
end
World(CapybaraHelpers)