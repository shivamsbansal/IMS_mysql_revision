class SellStocksController < ApplicationController
	def initialise_sell_stock
    @stock = Stock.find(params[:id])
    if can_access_station(@stock.station) == false
      return
    end
    @stocks = [@stock]
    @item = @stock.item
    if @stock.item.assetType == 'consumable'
      render 'consumable_sell'
    else
      @assets = @stock.assets
      render 'fixed_sell'
    end
  end

  def sell_stock
    @stock = Stock.find(params[:id])
    
    if can_access_station(@stock.station) == false
      return
    end

    if @stock.item.assetType == 'consumable'
      @quantity = params[:quantity].to_i
    elsif @stock.item.assetType == 'fixed' && params[:assets] != nil
      @quantity = params[:assets].size
    else
      flash[:notice] = "No assets to sell"
      redirect_to "/asset_list/#{params[:id]}"
      return
    end

    @stock.presentStock = @stock.presentStock - @quantity
    @stock.soldStock += @quantity
    @stock.soldValue += params[:soldValue].to_i
    if @stock.item.assetType == 'consumable'
      if @stock.save
        flash[:success] = "Stock Sold"
        redirect_to "/show_stock/#{params[:id]}"
      else
        @stock.presentStock += @quantity
        @stock.transferedStock -=@quantity
        @stock.soldValue -= params[:soldValue].to_i
        @stocks = [@stock]
        @item = @stock.item
        flash.now[:error] = "Unsuccessfull, please check the form"
        render 'consumable_sell'
      end
    elsif @stock.item.assetType == 'fixed'
      if @stock.save
        params[:assets].each do |asset_id|
          @asset = Asset.find(asset_id)
          @asset.update_attributes(state: 'sold')
        end
        flash[:success] = "Stock Sold"
        redirect_to "/show_stock/#{params[:id]}"
      else
        @stock.presentStock += @quantity
        @stock.transferedStock -=@quantity
        @stock.soldValue -= params[:soldValue].to_i
        @stocks = [@stock]
        @assets = @stock.assets
        @item = @stock.item
        flash.now[:error] = "Unsuccessfull, please check the form"
        render 'fixed_sell'
      end
    end
  end
end
