class HelpController < ApplicationController
	before_action :authenticate_person!, except: [:index]

	def index
	end

end
