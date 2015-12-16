class Company < Supergroup
	has_many :recs
	
	def post_title
		"Post your questions or research here"
	end
end
