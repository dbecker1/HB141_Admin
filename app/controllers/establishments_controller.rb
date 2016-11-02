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

		@establishment = firebase.get('/establishment/' + params[:id]).body

		@manager = firebase.get('/manager/' + @establishment["MID"].to_s).body

		# TODO: REPLACE THIS BLOCK AFTER LEARNING ABOUT FIREBASE-RUBY QUERY OPTIONS
		reports = firebase.get('/report/').body
		reports.keep_if do |id, report|
			id != "Incrementor" and report["EID"].to_s == params[:id]
		end

		@reports = reports
	end

	def new
	end

	def create
		base_uri = 'https://hb141-2fc0d.firebaseio.com/'
		firebase = Firebase::Client.new(base_uri)

		new_id = firebase.get('/establishment/Incrementor').body
		new_m_id = firebase.get('/manager/Incrementor').body

		add_manager = firebase.set('/manager/' + new_m_id.to_s, {
				"Name" => params["Manager Name"],
				"Phone" => params["Manager Phone"],
				"Email" => params["Manager Email"]
			})
		firebase.update('', {'/manager/Incrementor' => new_m_id + 1})

		add_establishment = firebase.set('/establishment/' + new_id.to_s, {
				"Name" => params["Name"],
				"Location" => {
						"Address" => params["Address"],
						"City" => params["City"],
						"State" => params["State"],
						"Zip" => params["Zip"]
					},
				"MID" => new_m_id,
				"Status" => params["Status"]
			})
		firebase.update('', {'/establishment/Incrementor' => new_id + 1})

		redirect_to establishments_path
	end

	def edit
		base_uri = 'https://hb141-2fc0d.firebaseio.com/'
		firebase = Firebase::Client.new(base_uri)

		@establishment = firebase.get('/establishment/' + params[:id]).body

		@manager = firebase.get('/manager/' + @establishment["MID"].to_s).body
	end

	def update
		base_uri = 'https://hb141-2fc0d.firebaseio.com/'
		firebase = Firebase::Client.new(base_uri)

		establishment = firebase.get('/establishment/' + params[:id]).body

		update_manager = firebase.update('/manager/' + establishment["MID"].to_s, {
				"Name" => params["Manager Name"],
				"Phone" => params["Manager Phone"],
				"Email" => params["Manager Email"]
			})

		update_establishment = firebase.update('/establishment/' + params[:id], {
				"Name" => params["Name"],
				"Location" => {
					"Address" => params["Address"],
					"City" => params["City"],
					"State" => params["State"],
					"Zip" => params["Zip"]
				},
				"Status" => params["Status"]
			})

		redirect_to establishment_path(params[:id])
	end
end
