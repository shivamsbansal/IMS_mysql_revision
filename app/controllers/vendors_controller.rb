class VendorsController < ApplicationController
 	
 	before_filter :signed_in_user 
	before_filter :admin_user

  def index
		@vendors=Vendor.paginate(page: params[:page],per_page: 30)
	end

	def new
		@vendor = Vendor.new
	end

	def edit
		@vendor = Vendor.find(params[:id])
	end

	def update
		@vendor = Vendor.find(params[:id])
		if @vendor.update_attributes(nameVendor: params[:nameVendor], email: params[:email], phone: params[:phone], category_id: params[:category_id])
      flash[:success] = "Vendor updated"
      redirect_to vendors_path
    else
      render 'edit'
    end
	end

	def create
		@vendor = Vendor.new(nameVendor: params[:nameVendor], email: params[:email], phone: params[:phone], category_id: params[:category_id])
  	if @vendor.save
      flash[:success] = "Successfully added #{@vendor.nameVendor}"
      redirect_to vendors_path
    else
    	render 'new'
  	end
	end

	def destroy
    Vendor.find(params[:id]).destroy
    flash[:success] = "Vendor destroyed."
    redirect_to vendors_url
  end
end
