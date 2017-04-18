class ReportsController < ApplicationController
	before_action :authenticate_admin!

	def index
		base_uri = 'https://hb141-2fc0d.firebaseio.com/'
		firebase = Firebase::Client.new(base_uri)

		@reports = firebase.get('/report/').body
	end

	def show
		base_uri = 'https://hb141-2fc0d.firebaseio.com/'
		firebase = Firebase::Client.new(base_uri)

		@report = firebase.get('/report/' + params[:id]).body

		@establishment = firebase.get('/establishment/' + @report["EID"].to_s).body

		#@volunteer = firebase.get('/volunteer/' + @report["VID"].to_s).body
	end

	def new
	end

	def create
	end

	def edit
		base_uri = 'https://hb141-2fc0d.firebaseio.com/'
		firebase = Firebase::Client.new(base_uri)

		@report = firebase.get('/report/' + params[:id]).body
	end

	def update
		base_uri = 'https://hb141-2fc0d.firebaseio.com/'
		firebase = Firebase::Client.new(base_uri)

		report = firebase.get('/report/' + params[:id]).body

		update_report = firebase.update('/report/' + params[:id], {
				"Datetime" => params["Datetime"],
				"Comment" => params["Comment"]
			})

		redirect_to report_path(params[:id])
	end

	private

	def pass(report)

		report["Public View"] and report["Restroom View"] and not report["No View"]
	end

	helper_method :pass
end