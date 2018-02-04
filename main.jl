include("./logic.jl")
include("./gemc.jl")
include("./game.jl")
using bslogic
using gemc
using bsgame

# testing
### GLOBALS ###
I = 3
J = 3
mapsize = (I, J)

shiplist = [0,0,1]

max_turns = 50
statehistory = []
actionhistory = []
valuehistory = []
epsilon = 0.1
n_games = 2000
sum_turns = 0
##

statistics = []
for game = 1:n_games
	println("Game number ", game)
	# Play a game of battleship
	statehistory, actionhistory, valuehistory, n_turns = bsgame.play_bsgame(mapsize, shiplist,  max_turns, epsilon, statehistory, actionhistory, valuehistory)

	println("value plays ", sum(valuehistory), " max value ", maximum(valuehistory))
	sum_turns += n_turns
	if mod(game, 100) == 0
		append!(statistics, sum_turns / 100)
		sum_turns = 0
	end
end

println("statistics")
println(statistics)

