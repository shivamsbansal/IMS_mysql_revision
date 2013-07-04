class ConsumablesController < ApplicationController
	before_filter :signed_in_user
	before_filter :atleast_one_station

  def consumable_issue
  	@stock = Stock.find(params[:id])
  	@station = @stock.station
    if can_access_station(@station) == false
      return
    end
    @associates = @station.associates
    @item = @stock.item
    @stocks = [@stock]
  end

  def issueConsumable
  	begin
      @date= Date.new(params[:issued_consumable][:'dateOfIssue(1i)'].to_i, params[:issued_consumable][:'dateOfIssue(2i)'].to_i, params[:issued_consumable][:'dateOfIssue(3i)'].to_i)
    rescue ArgumentError
      @date=nil
    end
    @issued = IssuedConsumable.new(stock_id: params[:stock_id], associate_id: params[:associate_id], dateOfIssue: @date, quantity: params[:quantity])

    @stock = Stock.find(params[:stock_id])
    if can_access_station(@stock.station) == false
      return
    end
    if params[:quantity].to_i > @stock.presentStock
      flash[:notice] = "issued quantity should be less than present quantity"
      @item = @stock.item
      @stocks = [@stock]
      redirect_to "/consumable_issue/#{@stock.id}"
      return
    end

    @stock.presentStock = @stock.presentStock - params[:quantity].to_i
    @stock.issuedStock = @stock.issuedStock + params[:quantity].to_i

    if ([@stock,@issued].map(&:valid?)).all?
      @stock.save
      @issued.save
      flash[:success] = "Successfully issued"
    else
      flash[:error] = "Unsuccessfull issue check date"
    end
    @stock = Stock.find(params[:stock_id])
    @item = @stock.item
    @stocks = [@stock]
    redirect_to "/consumable_issue/#{@stock.id}"
  end

  def withdraw
    @consumable = IssuedConsumable.find(params[:id])
    @stock = @consumable.stock
    if can_access_station(@stock.station) == false
      return
    end
    @associate = @consumable.associate
    if can_access_station(@associate.station) == false
      return
    end
    @stock.presentStock = @stock.presentStock + @consumable.quantity
    @stock.issuedStock = @stock.issuedStock - @consumable.quantity
    @stock.save
    @consumable.destroy
    flash[:success] = "Consumable withdrawn."
    redirect_to "/assets/issued_list/#{@associate.id}"
  end

end
