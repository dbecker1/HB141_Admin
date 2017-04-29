class HomeController < ApplicationController
	skip_before_action :authenticate_admin!
	skip_before_action :setup_firebase
	
	def index
	end
end