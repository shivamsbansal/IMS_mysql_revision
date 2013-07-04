module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Inventory Management System"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def timePeriod(name, default, disable = false)
  	select_tag(name.to_sym, options_for_select((1..30).each {|n| ["#{n}",n]}, default ), disabled: disable)
  end

  def timePeriodType(name, default, disable = false)
   	select_tag("#{name}Type".to_sym, options_for_select(['day','month','year'].each {|n| [n,n]}, default ), disabled: disable) 
  end

  def toSensibleTime(seconds)
    if seconds != nil
      if (seconds % 31557600) == 0 
        {years: (seconds/31557600), months: 0, days: 0}
      elsif (seconds % 2592000) == 0
        {years: 0, months: (seconds/2592000), days: 0}
      else
        {years: 0, months: 0, days: (seconds/86400)}
    	end
    else
      {years: 0, months: 0, days: 0}
    end
  	 
  end

  def toSensibleWords(hash)
    string = ''
    if hash[:years] != 0
      string =  "#{string} #{hash[:years]} years"
    end
    if hash[:months] != 0
      string = "#{string} #{hash[:months]} months"
    end
    if hash[:days] != 0
      string = "#{string} #{hash[:days]} days"
    end
    string
  end

  def toInsensibleTime(seconds)
    if seconds != nil
      if (seconds % 31557600) == 0
        result = {value: (seconds/31557600), period: "year"}
      elsif (seconds % 2592000) == 0
        result = {value: (seconds/2592000), period: "month"}
      else
        result = {value: (seconds/86400), period: "day"}
      end
    else
      result = {value: 1, period: "day"}
    end
  end

  def atleast_one_station
    if user_access_stations(current_user) == nil
      redirect_to current_user, notice: "Currently no station assigned"
    end
  end

  def generate_pdf(transfers, chalanNo)
      Prawn::Document.new do |pdf|
        pdf.move_down(20)

        pdf.text "<b><u>INTER BRANCH TRANSFER CHALLAN</u></b>", align: :center, inline_format: true

        pdf.move_down(15)

        pdf.text "<b>Amazon Transportation Services Private Limited\n Regd Office Address: \n Eros Corporate Tower, Eros Plaza \n Ground Floor, Opposite Nehru Place Metro Station,\n Nehru Place ,Delhi - 110019 \n India</b> ", inline_format: true
        pdf.move_down(15)

        transfer_to = Station.find(transfers.first.to)
        transfer_from = Station.find(transfers.first.from)

        address = [["ship to:", "ship from:"],[transfer_to.addr1,transfer_from.addr1],[transfer_to.addr2,transfer_from.addr2],[transfer_to.pincode, transfer_from.pincode],["Contact Deatils:", "Contact Details:"],[transfer_to.contactDetails,transfer_from.contactDetails]]

        pdf.table address, cell_style: { borders: [] }

        pdf.stroke_horizontal_rule

        pdf.move_down(20)

        pdf.text "Branch Transfer Number: #{chalanNo}" 
        pdf.text "Branch Transfer Date: #{Date.today.strftime('%d %b %Y') }"

        rows = transfers.size

        items = [["<b>Goods Description</b>","<b>Qty</b>","<b>Value</b>"]]

        total_cost = 0
        items += transfers.map do |transfer|
        stock = transfer.stock
        cost = stock.initialStock * stock.item.cost
        total_cost += cost
        [
          stock.item.nameItem,
          stock.initialStock,
          cost,
        ]
        end

        items += [["<b>Total</b>","","<b>#{total_cost}</b>"]]

        my_tabel = pdf.make_table items , cell_style: { inline_format: true }

        pdf.table [[my_tabel,{content: "<b><u>Remarks</u></b>", inline_format: true },{content: "<b><u>Purpose of Transfer</u></b>", inline_format: true}]]

        pdf.move_down(20)

        pdf.text "<b>Approx Value in Rupees: </b>", inline_format: true

        pdf.move_down(20)

        pdf.stroke_horizontal_rule
        pdf.move_down(10)

        pdf.text "<b><u>Declaration</u></b>" ,align: :center, inline_format: true

        pdf.stroke_horizontal_rule
        pdf.move_down(10)

        pdf.text "We Declare that:\n"
        pdf.text "The above mentioned goods are being moved from our premises for inter branch transfer. The movement of goods between our branches is meant for internal use and not for resale and does not attract any VAT/CST liability."
        pdf.text "\nThe above mentioned details are true and correct to the best of our knowledge."

        
        pdf.stroke_horizontal_rule

        pdf.move_down(30)

        pdf.table [["<b>For Amazon Transportaion Services Private Limited</b>","<b>For Amazon Transportaion Services Private Limited</b>"],["",""],["",""],["",""],["(Receiver's Name & Signature)","(Sender's Name & Signature)"]] , cell_style: { borders: [] ,inline_format: true}

        pdf.move_down(30)

        pdf.stroke_horizontal_rule
      end.render 
    end


end