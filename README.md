datastorage
===========

Helper mod to manage players data.
All the mods can acces a single file (container) and easily have the data saved/loaded for them.


Use:

local container = datastorage.get_container (mod_name, player)
  returns the table for given mod and a player.
  If container wasnt used before it will be created, otherwise it will contain all previously stored data.
  The table can store any data.
  
  Player's containers will be saved to disk on player leave.
  All the containers will be saved on server shutdown.
  To force save all player's data, use: 

datastorage.save_container (player)

