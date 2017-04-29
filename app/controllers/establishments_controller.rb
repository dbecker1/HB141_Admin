require 'date'

class EstablishmentsController < ApplicationController

	def index
		establishments = @firebase.get('/establishment/').body

		establishments_with_status = {}

		establishments.each do |id, establishment|
			reports = @firebase.get('/report/').body
			reports.keep_if do |r_id, report|
				report["EID"].to_s == id
			end
			establishment["Status"] = status(reports)
			establishments_with_status[id] = establishment
		end

		@establishments = establishments_with_status
	end

	def show
		@establishment = @firebase.get('/establishment/' + params[:id]).body

		reports = @firebase.get('/report/').body
		reports.keep_if do |id, report|
			report["EID"].to_s == params[:id]
		end

		@reports = reports
	end

	def edit
		@establishment = @firebase.get('/establishment/' + params[:id]).body

		@manager = firebase.get('/manager/' + @establishment["MID"].to_s).body
	end

	def update
		establishment = @firebase.get('/establishment/' + params[:id]).body

		update_establishment = firebase.update('/establishment/' + params[:id], {
				"Name" => params["Name"],
				"Address" => params["Address"],
				"Phone Number" => params["Phone Number"],
				"Website" => params["Website"]
			})

		redirect_to establishment_path(params[:id])
	end

	def destroy
		reports = @firebase.get('/report/').body
		reports.each do |id, report|
			if report["EID"].to_s == params[:id]
				@firebase.delete('/report/' + id)
			end
		end

		@firebase.delete('/establishment/' + params[:id])

		redirect_to establishments_path
	end

	private

	def status(reports)
		neg_reports = 0
		latest_report = DateTime.new(0)

		reports.each do |id, report|
			if pass(report)
				return "COMPLIES"
			end
			if neg_reports < 4 and not pass(report)
				neg_reports += 1
			end
			begin
				datetime = DateTime.strptime(report["Datetime"], '%m/%d/%y %H:%M %p')
			rescue
				datetime = DateTime.new(0)
			end
			if datetime > latest_report
				latest_report = datetime
			end
		end

		if latest_report < DateTime.now - 30
			return "NEEDS VISIT"
		end

		return neg_reports.ordinalize.upcase + " NEGATIVE SURVEY"
	end

	def pass(report)
		report["Public View"] and report["Restroom View"] and not report["No View"]
	end

	helper_method :status, :pass
end
