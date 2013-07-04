class StationsController < ApplicationController
	before_filter :signed_in_user, only: [:new, :edit,    :index, :create, :update]
	before_filter :admin_user, only: [:new, :update, :edit, :create]

	def update
		@station = Station.find(params[:id])
		if @station.update_attributes(nameStation: params[:nameStation], territory_id: params[:territory_id], addr1: params[:addr1], addr2: params[:addr2], pincode: params[:pincode], contactDetails: params[:contactDetails])
	      flash[:success] = "Territory updated"
	      redirect_to stations_path
	  else
	      render 'edit'
	  end
	end

	def edit
		@station = Station.find(params[:id])
	end

	def new
		@station = Station.new
	end

	def index
		result = user_access_stations(current_user)
		if result == nil
			flash.now[:notice] = "No station assigned to you"
		else
			@stations = result[:stations]
			@name =	result[:name]
		end
	end

	def create
	  @station = Station.new(nameStation: params[:nameStation], territory_id: params[:territory_id], addr1: params[:addr1], addr2: params[:addr2], pincode: params[:pincode], contactDetails: params[:contactDetails])
	  if @station.save
	    flash[:success] = "Successfully added #{@station.nameStation}"
	    redirect_to stations_path
	  else
	    render 'new'
	  end
  end

end
