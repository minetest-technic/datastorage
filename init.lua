datastorage={}
datastorage["registered_players"]={}

datastorage.save_data = function(table_pointer)
	local data = minetest.serialize( datastorage[table_pointer] )
	local path = minetest.get_worldpath().."/datastorage_"..table_pointer..".data"
	local file = io.open( path, "w" )
	if( file ) then
		file:write( data )
		file:close()
		return true
	else return nil
	end
end

datastorage.load_data = function(table_pointer)
	local path = minetest.get_worldpath().."/datastorage_"..table_pointer..".data"
	local file = io.open( path, "r" )
	if( file ) then
		local data = file:read("*all")
		datastorage[table_pointer] = minetest.deserialize( data )
		file:close()
	return true
	else return nil
	end
end

datastorage.get_container = function (mod_name, player)
	local player_name = player:get_player_name()
	local container = datastorage[player_name]
	if container[mod_name] == nil then
		container[mod_name] = {}
	end
	datastorage.save_data(player_name)
	return container[mod_name]
end

-- forced save of all player's data
datastorage.save_container = function (player)
	local player_name = player:get_player_name()
	datastorage.save_data(player_name)
end


-- Init
if datastorage.load_data("registered_players") == nil then
	datastorage["registered_players"]={}
	datastorage.save_data("registered_players")
end

minetest.register_on_joinplayer(function(player)
	local player_name = player:get_player_name()
	local registered = nil
	for __,tab in ipairs(datastorage["registered_players"]) do
		if tab["player_name"] == player_name then registered = true break end
	end
	if registered == nil then
		print("creating new one")
		local new={}
		new["player_name"]=player_name
		table.insert(datastorage["registered_players"],new)
		datastorage[player_name]={}
		datastorage.save_data("registered_players")
		datastorage.save_data(player_name)
	else 
		print("loading containers")
		datastorage.load_data(player_name)
	end


-- TEST AREA:	
local test_container = datastorage.get_container("dupa",player)
test_container["var1"] = 1.23
test_container["table1"] = {}
test_container["table1"]["var2"] = "nowa"
test_container["table1"]["var3"] = "a string"

print("Testing:")
print(dump(test_container))
--datastorage.save_container(player)
-- END OF TEST AREA

end
)

minetest.register_on_leaveplayer(function(player)
	local player_name = player:get_player_name()
	datastorage.save_data(player_name)
	datastorage[player_name] = nil
end
)

minetest.register_on_shutdown(function()
	for __,tab in ipairs(datastorage["registered_players"]) do
		if datastorage[tab["player_name"]] == nil then break end
		datastorage.save_data(tab["player_name"]) 
	end
end
)
