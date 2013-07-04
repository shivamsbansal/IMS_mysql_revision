module StationsHelper

	def user_access_stations(user)
		@user_access_stations ||= aux_user_access_stations(user)
	end

	def aux_user_access_stations(user)
		if user[:level_type]!= nil 
			if user.admin?
				@stations = Station.all
				@name = "Central Team" 
			elsif Region.find(user.level_id).nameRegion=="India"
				@stations=Station.all - Region.find_by_nameRegion('Central Team Region').stations
				@name = "India"
			else
				@stations=[]
				if user.level_type == "Region" 
					@stations = Region.find(user.level_id).stations
					@name = Region.find(user.level_id).nameRegion
				elsif user[:level_type] == "Territory"
					@stations = Territory.find(user.level_id).stations
					@name=Territory.find(user.level_id).nameTerritory
				else
					@stations =[Station.find(user.level_id)]
					@name = Station.find(user).nameStation
				end
			end
			{stations: @stations, name: @name}
		else
			nil
		end
	end


	def can_access_station(station)
		if user_access_stations(current_user)[:stations].include? station
			return true
		else
			flash.now[:notice] = "access denied"
			@user = current_user
      render 'users/show'
      return false
    end
  end
end
