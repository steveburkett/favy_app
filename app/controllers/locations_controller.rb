class LocationsController < ApplicationController

	def index
	  @locations = Location.order(:name).where("name like ?", "%#{params[:term]}%")
	  render json: @locations.map(&:name)
	end

end
