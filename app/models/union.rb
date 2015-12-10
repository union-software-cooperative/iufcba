class Union < Supergroup

	has_many :people
	
	def post_title
		"Post your union pictures and status updates here"
	end
end
