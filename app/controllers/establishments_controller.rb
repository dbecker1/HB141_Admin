class EstablishmentsController < ApplicationController
	def index
		base_uri = 'https://hb141-2fc0d.firebaseio.com/'
		firebase = Firebase::Client.new(base_uri)

		establishments = firebase.get('/establishment/').body
		@establishments = establishments.except("Incrementor")
	end

	def show
		base_uri = 'https://hb141-2fc0d.firebaseio.com/'
		firebase = Firebase::Client.new(base_uri)

		establishment = firebase.get('/establishment/' + params[:id]).body
		@establishment = {params[:id] => establishment}

		manager = firebase.get('/manager/' + establishment["MID"].to_s).body
		@manager = {establishment["MID"] => manager}

		# TODO: REPLACE THIS BLOCK AFTER LEARNING ABOUT FIREBASE-RUBY QUERY OPTIONS
		reports = firebase.get('/report/').body
		reports.keep_if do |id, report|
			id != "Incrementor" and report["EID"].to_s == params[:id]
		end

		@reports = reports
	end
end
