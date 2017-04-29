class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_admin!
  before_action :setup_firebase

  def setup_firebase
  	base_uri = 'https://hb141-2fc0d.firebaseio.com/'
	@firebase = Firebase::Client.new(base_uri)
  end
end
