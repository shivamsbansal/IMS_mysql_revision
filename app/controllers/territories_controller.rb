class TerritoriesController < ApplicationController

	before_filter :signed_in_user 
	before_filter :admin_user

	def index
		@territories=Territory.paginate(page: params[:page],per_page: 5)
	end

	def new
		@territory = Territory.new
	end

	def edit
		@territory = Territory.find(params[:id])
	end

	def update
		@territory = Territory.find(params[:id])
		if @territory.update_attributes(nameTerritory: params[:nameTerritory], idTerritory: params[:idTerritory], region_id: params[:region_id])
      flash[:success] = "Territory updated"
      redirect_to territories_path
    else
      render 'edit'
    end
	end

	def create
		@territory = Territory.new(nameTerritory: params[:nameTerritory], idTerritory: params[:idTerritory], region_id: params[:region_id])
  	if @territory.save
      flash[:success] = "Successfully added #{@territory.nameTerritory}"
      redirect_to territories_path
    else
    	render 'new'
  	end
	end

end
