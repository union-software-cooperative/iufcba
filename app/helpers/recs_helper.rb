module RecsHelper
	
	def nature_of_operation_options
		options_for_select(
				(%w[beer PepsiCo Coca-Cola other-beverages] + @rec.nature_of_operation).uniq, 
				@rec.nature_of_operation
			)
	end

end
