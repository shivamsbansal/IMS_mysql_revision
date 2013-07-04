class ItemsController < ApplicationController
  
  before_filter :signed_in_user 
	before_filter :admin_user, except: [:index, :list]

  def index
  	@itemCategory = categoryList
  end

  def new
    @item = Item.new
  	@itemCategory = Category.all.map { |category| [category.nameCategory, category.nameCategory]}
  end

  def edit
    @item = Item.find(params[:id])
    @category = @item.category.nameCategory
  end

  def update
    @lifeCycle = params[:lifeCycle].to_i.send(params[:lifeCycleType]).to_i
    @leadTime = params[:leadTime].to_i.send(params[:leadTimeType]).to_i

    item_hash = {nameItem: params[:item][:nameItem], codeItem: params[:item][:codeItem], cost: params[:item][:cost], lifeCycle: @lifeCycle, leadTime: @leadTime,minimumStock: params[:item][:minimumStock], assetType: params[:item][:assetType], vendor_id: params[:item][:vendor_id] , brand: params[:item][:brand], distinction: params[:item][:distinction], model: params[:item][:model]}

    @itemCategory = Category.all.map { |category| [category.nameCategory, category.nameCategory]}
    @item = Item.find(params[:id])
    @category = @item.category.nameCategory

    @item.assign_attributes(item_hash)
    if @item.valid?
      @item.save
      flash[:success] = "Item updated"
      redirect_to items_path
    else
      render 'edit'
    end
  end

  def destroy
    @item = Item.find(params[:id])
    if @item.stocks != nil
      flash[:notice] = "Since stock of this item exist it cannot be deleted"
    else
      @item.destroy
      flash[:success] = "Item deleted."
    end
    redirect_to items_url
  end

  def redirect
    @item = Item.new
  	@category = params[:category]
    respond_to do |format|
      format.js
    end
  end

  def create
    @lifeCycle = params[:lifeCycle].to_i.send(params[:lifeCycleType]).to_i
    @leadTime = params[:leadTime].to_i.send(params[:leadTimeType]).to_i

    item_hash = {nameItem: params[:item][:nameItem], codeItem: params[:item][:codeItem], cost: params[:item][:cost], lifeCycle: @lifeCycle, leadTime: @leadTime,minimumStock: params[:item][:minimumStock], assetType: params[:item][:assetType], vendor_id: params[:item][:vendor_id] , brand: params[:item][:brand], distinction: params[:item][:distinction], model: params[:item][:model]}
    @itemCategory = Category.all.map { |category| [category.nameCategory, category.nameCategory]}

    @item = Category.find_by_nameCategory(params[:category]).items.new(item_hash)
    if @item.valid?
        flash[:sucess] = "Item added"
        @item.save
        redirect_to items_path
    else
      render 'new'
    end
  end

  def list
    @category = params[:category]
    if @category != 'All'
      @list = Category.find_by_nameCategory(@category).items
    else
      @list = Item.all
    end
    respond_to do |format|
      format.js
    end
  end

  def new_category
    @category = Category.new
  end

  def create_category
    if Category.create(nameCategory: params[:category][:nameCategory])
      flash[:success] = "Category created"
      redirect_to '/items/list_category'
    else
      flash[:error] = "Category name should be less than 30 characters"
      render 'new_category'
    end
    
  end

  def list_category
    @list = Category.all
  end

  def edit_category
    @category = Category.find(params[:id])
  end

  def category_update
    @category = Category.find(params[:id])
    @category.nameCategory = params[:nameCategory]
    if @category.save
      flash[:success] = "Category updated"
      redirect_to '/items/list_category'
    else
      flash[:error] = "Category name should be less than 30 characters"
      render 'edit_category'
    end
    
  end
end
