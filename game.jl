module bsgame
using bslogic
using gemc

function play_bsgame(mapsize, shiplist,  max_turns, epsilon, statehistory, actionhistory, valuehistory)
	n_turns = 0
	game_state = 0
	I = mapsize[1]
	J = mapsize[2]

	actual_map, ship_tensor = bslogic.create_ships(mapsize, shiplist)

	info_map = -ones(mapsize)

	#println("actual map state")
	#println(actual_map)


	for i = 1:max_turns
		action, action_idx, statehistory, actionhistory, valuehistory = gemc.eval_actions(info_map, actual_map, ship_tensor, epsilon, statehistory, actionhistory, valuehistory)

		#println("action index ", action )
		# get row and column indices
		row = mod(action -1, I) + 1
		col = floor(Int,((action - row) / J) + 1)

		info_map, game_state = bslogic.update_game!([row col], info_map, actual_map, ship_tensor)
		#println("game state ", game_state)

		valuehistory = gemc.rank_action(action_idx, valuehistory, game_state)

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

	#=
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
	=#
	
	return statehistory, actionhistory, valuehistory
end











end