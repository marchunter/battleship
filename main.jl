include("./logic.jl")
include("./gemc.jl")
using bslogic
using gemc


# testing

mapsize = (5, 5)
shiplist = [2,0,1]

actual_map, ship_tensor = bslogic.create_ships(mapsize, shiplist)

info_map = -ones(mapsize)

println("actual map state")
println(actual_map)

#println("ship tensor")
#println(ship_tensor)

max_turns = 50
n_turns = 0
game_state = 0
for i = 1:max_turns
	info_map, game_state = bslogic.update_game!([rand(1:mapsize[1]) rand(1:mapsize[2])], info_map, actual_map, ship_tensor)
	println("game state ", game_state)

	if game_state == 3
		println("All ships are sunk after ", i, " turns.")
		n_turns = i
		break
	end
	if i == max_turns
		println("Game over after ", i, " turns.")
		n_turns = i
	end
end


# Game stats
println("--- ____ _____ ---")
println("--- Game Stats ---")
println("--- ____ _____ ---")
println("actual map state")
println(actual_map)
println("info map state")
println(info_map)
println("Turns: ", n_turns)
if game_state == 3
	println("Game was won")
else
	println("Game was lost")
end

##
println("testing")

find
