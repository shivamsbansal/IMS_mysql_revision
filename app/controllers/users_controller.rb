class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:assignLevel, :edit, :update, :index, :show, :destroy]
  before_filter :correct_user,   only: [:edit, :update, :show]
  before_filter :admin_user,     only: [:destroy, :assignLevel,  :index, :retainLevel, :chooseLevel, :assignUserform]

  def index
    @users = User.where('level_id is not null').paginate(page: params[:page],per_page: 20, order: 'level_type')
  end


  def show
  	@user = User.find(params[:id])
  end
  
  def new
  	@user = User.new
  end

  def create
  	@user = User.new(params[:user])
  	if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Jolie!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  def assignUserform
    @users = User.where('level_id is null').paginate(page: params[:page], per_page: 10)
    @level_type = "Region"
    @array = Region.all.map { |region| ["#{region.nameRegion}", region.id]}
  end

  def assignLevel
    @user=User.find(params[:id])
    @user.is_admin_applying_update = true
    @user.level_type = params[:level_type]
    @user.level_id = params[:level_id]
    if params[:level_type] == 'admin'
      @user.admin = true
    end
    if @user.save(as: :admin) 
      flash[:success] = "User authorised"
      redirect_to users_url
    else
      @users = User.where(:level_id => nil).paginate(page: params[:page], per_page: 10)
      @level_type = "Region"
      @array = Region.all.map { |region| ["#{region.nameRegion}", region.id]}
      render 'assignUserform'
    end  
  end

  def chooseLevel
    @id = params[:id]
    @user = User.find(params[:id])
    @level_type = params[:level_type]
    if params[:level_type] == "admin"
      @array = [["Not Applicable","1"]]
    elsif params[:level_type] == "Region"
      @array = Region.all.map { |region| ["#{region.nameRegion}", region.id]}
    elsif params[:level_type] == "Territory"
      @array = Territory.all.map { |territory| ["#{territory.nameTerritory}, #{territory.region.nameRegion}", territory.id]}
    else
      @array = Station.all.map { |station| ["#{station.nameStation}, #{station.territory.nameTerritory}", station.id]}
    end
    respond_to do |format|
      format.js
    end
  end

  def retainLevel
    @user = User.find(params[:id])
    if @user.level_type == 'admin'
      @user.admin = false
    end
    @user.level_type = nil
    @user.level_id = nil
    if @user.save validate: false
      flash[:success] = "Change succesfull"
    end
    redirect_to users_url
  end

  private

    # Before filters

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user) || current_user.admin?
    end
end
