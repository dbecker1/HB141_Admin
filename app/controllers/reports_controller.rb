class ReportsController < ApplicationController

	def index
		@reports = @firebase.get('/report/').body
	end

	def show
		@report = @firebase.get('/report/' + params[:id]).body

		@establishment = @firebase.get('/establishment/' + @report["EID"].to_s).body

		#@volunteer = firebase.get('/volunteer/' + @report["VID"].to_s).body
	end

	def edit
		@report = @firebase.get('/report/' + params[:id]).body
	end

	def update
		report = @firebase.get('/report/' + params[:id]).body

		update_report = @firebase.update('/report/' + params[:id], {
				"Datetime" => params["Datetime"],
				"Comment" => params["Comment"],
				"Public View" => params["Public View"] ? true : false,
				"Restroom View" => params["Restroom View"] ? true : false,
				"No View" => params["No View"] ? true : false
			})

		redirect_to report_path(params[:id])
	end

	def destroy
		@firebase.delete('/report/' + params[:id])

		redirect_to reports_path		
	end

	private

	def pass(report)
		report["Public View"] and report["Restroom View"] and not report["No View"]
	end

	helper_method :pass
end