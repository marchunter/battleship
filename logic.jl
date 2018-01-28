# sinkships for julia

function create_ships(mapsize, shiplist)
	# shiplist gives the number of ships for each size
	# e.g. [2,0,0,1] means 2 1-field and one 4-field ship
	initmap = -ones(mapsize)
	m,n = mapsize[1], mapsize[2]
	#println(initmap)
	println("Following number of ships with increasing number are being created ", shiplist)
	maxshiplength = length(shiplist)

	# ship tensor is an overlay of single-ship maps
	ship_tensor = zeros(m, n, sum(shiplist))
	ship_count = 0

	isminusone(x) = x .==-1
	for (i, n_ships) in enumerate(reverse(shiplist))
		for j = 1:n_ships
			shipsize = maxshiplength - i + 1
			println("Inserting ship of size ", shipsize)
			for count = 1:100
				# randomized ship position
				rand_hor_vert = rand(0:1)
				if rand_hor_vert == 0
					randrow = rand(1:m-shipsize + 1)
					randcol = rand(1:n)
				else
					randrow = rand(1:m)
					randcol = rand(1:n-shipsize + 1)
				end
				#println(randrow, randcol, rand_hor_vert)

				if rand_hor_vert == 0
					row, col = randrow:randrow+shipsize-1, randcol
					extended_row, extended_col = max(randrow -1, 1):min(randrow+shipsize, m), max(randcol-1, 1):min(randcol + 1, n)
				else
					row, col = randrow, randcol:randcol+shipsize-1
					extended_row, extended_col = max(randrow-1, 1):min(randrow + 1, m), max(randcol -1, 1):min(randcol+shipsize, n)
				end


				# tentative ship placement (limited trials given by count)
				shipslot = initmap[row, col]
				if sum(shipslot) == -shipsize
					# fill vicinity of shipslot with water
					initmap[extended_row, extended_col] = 0
					# place ship inside water
					initmap[row,col] = 1
					#println(initmap)

					# add ship to ship tensor
					ship_count += 1
					ship_tensor[row, col, ship_count] = 1
				break
				end 
				if count == 1000
					println("WARNING, no space found on map. A ship of size ", shipsize, 
						" has not been placed. Make sure the map is big enough to contain all the ships. ",
						"Bare in mind that ships need to be separated by at least one field of water ",
						"(also diagonally)")
				end
			end
		end
	end

	# fill the rest of the map with water
	emptyfields = find(initmap .== -1)
	initmap[emptyfields] = 0
	return initmap, ship_tensor
end


function update_game!(guess, info_map, actual_map, ship_tensor)
	println("Guess was ", guess)
	row_guess = guess[1]
	col_guess = guess[2]
	info_map[row_guess, col_guess] = actual_map[row_guess, col_guess] 
	#println(actual_map[row_guess, col_guess])
	# check when there is a hit
	if actual_map[row_guess, col_guess] == 1
		game_state = 1
		# check whether a ship was sunk

		temprw, tempcl, ship_id = findn(ship_tensor[row_guess,col_guess, :])
		#println("ship number ", ship_id, " was hit")

		diffmap = ship_tensor[:,:, ship_id] - info_map
		if maximum(diffmap) < 2
			game_state = 2
			println("ship number ", ship_id, " was sunk")
		end

		# check whether all ships are sunk
		diffmap = actual_map - info_map
		if maximum(diffmap) < 2
			game_state = 3
		end
	else 
		game_state = 0
	end


	return info_map, game_state
end


# testing

mapsize = (7, 7)
shiplist = [2,0,1]

actual_map, ship_tensor = create_ships(mapsize, shiplist)

info_map = -ones(mapsize)

println("actual map state")
println(actual_map)

#println("ship tensor")
#println(ship_tensor)

max_turns = 120
n_turns = 0
game_state = 0
for i = 1:max_turns
	info_map, game_state = update_game!([rand(1:mapsize[1]) rand(1:mapsize[2])], info_map, actual_map, ship_tensor)
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

