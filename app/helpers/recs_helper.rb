module RecsHelper
	
	def nature_of_operation_options
		options_for_select(
				(%w[fresh-milk powdered-milk butter cheese yogurt ice-cream cream industrial-dairy food-service soy-milk other-specific] + @rec.nature_of_operation).uniq, 
				@rec.nature_of_operation
			)
	end

end
