class ReportsController < ApplicationController
	def index
		base_uri = 'https://hb141-2fc0d.firebaseio.com/'
		firebase = Firebase::Client.new(base_uri)

		reports = firebase.get('/report/').body
		@reports = reports.except("Incrementor")
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
				"Comment" => params["Comment"],
				"Pass" => params["Pass"] == 'true'
			})

		redirect_to report_path(params[:id])
	end
end