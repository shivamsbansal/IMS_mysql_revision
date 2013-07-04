module StocksHelper
	def myclone(id)
    os = Stock.find(id)
    new_stock = Stock.new
    new_stock.assign_attributes(item_id: os.item_id, poId: os.poId, poDate: os.poDate, invoiceNo: os.invoiceNo, invoiceDate: os.invoiceDate, warrantyPeriod: os.warrantyPeriod)
    new_stock
  end
end
