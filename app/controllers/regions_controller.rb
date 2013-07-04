class RegionsController < ApplicationController

	before_filter :signed_in_user 
	before_filter :admin_user

	def index
		@regions=Region.paginate(page: params[:page],per_page: 5)
	end

	def new
		@region = Region.new
	end

	def edit
		@region = Region.find(params[:id])
	end

	def update
		@region = Region.find(params[:id])
		if @region.nameRegion == 'India' || @region.nameRegion == 'Central Team Region'
			flash[:notice] = "#{@region.nameRegion} cannot be edit"
			redirect_to regions_path
			return
		end
		if @region.update_attributes(nameRegion: params[:nameRegion], idRegion: params[:idRegion])
      flash[:success] = "Region updated"
      redirect_to regions_path
    else
      render 'edit'
    end
	end

	def create
		@region = Region.new(nameRegion: params[:nameRegion], idRegion: params[:idRegion])
  	if @region.save
      flash[:success] = "Successfully added #{@region.nameRegion}"
      redirect_to regions_path
    else
    	render 'new'
  	end
	end

end

