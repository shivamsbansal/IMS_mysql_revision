class AssociatesController < ApplicationController
	before_filter :signed_in_user
  before_filter :atleast_one_station

  def new
  	@associate=Associate.new
  end

  def edit
    @associate = Associate.find(params[:id])
    if can_access_station(@associate.station) == false
      return
    end
  end

  def update
		@associate = Associate.find(params[:id])
    if can_access_station(@associate.station) == false
      return
    end
		begin
  		@date= Date.new(params[:associate][:'dateOfJoining(1i)'].to_i, params[:associate][:'dateOfJoining(2i)'].to_i, params[:associate][:'dateOfJoining(3i)'].to_i)
  	rescue ArgumentError
  		@date=nil
  	end
		if @associate.update_attributes(name: params[:name], email: params[:email], dateOfJoining: @date, station_id: params[:station_id])
      flash[:success] = "Associate updated"
      redirect_to associates_path
    else
      render 'edit'
    end
	end

  def create
    if can_access_station(Station.find(params[:station_id])) == false
      return
    end
  	begin
  		@date= Date.new(params[:associate][:'dateOfJoining(1i)'].to_i, params[:associate][:'dateOfJoining(2i)'].to_i, params[:associate][:'dateOfJoining(3i)'].to_i)
  	rescue ArgumentError
  		@date=nil
  	end
  	@associate = Associate.new(name: params[:name], email: params[:email], station_id: params[:station_id], dateOfJoining: @date)
    	
  	if @associate.save
      flash[:success] = "Successfully added #{@associate.name}"
      redirect_to associates_path
    else
    	render 'new'
  	end
	end

	def index
		@stations = user_access_stations(current_user)
		@stationList = @stations[:stations].map { |station| [station.nameStation, station.id]}
	end

	def list
    @station = Station.find(params[:station])
    if can_access_station(@station) == false
      return
    end
    @associates = @station.associates
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @associate = Associate.find(params[:id])
    if can_access_station(@associate.station) == false
      return
    end
    @assets = @associate.assets
    @assets.each do |asset|
      asset.issued = false
      @stock = asset.stock
      @stock.presentStock = @stock.presentStock + 1
      @stock.save
      @asset.save
    end
    @associate.destroy
    flash[:success] = "Associate destroyed , issued items retained and stock updated"
    redirect_to associates_url
  end

end
