include("./logic.jl")
include("./gemc.jl")
include("./game.jl")
using bslogic
using gemc
using bsgame

# testing
### GLOBALS ###
I = 4
J = 4
mapsize = (I, J)

shiplist = [2,0,1]

max_turns = 50
statehistory = []
actionhistory = []
valuehistory = []
epsilon = 0.1
n_games = 200
##


for game = 1:n_games
	println("Game number ", game)
	# Play a game of battleship
	statehistory, actionhistory, valuehistory = bsgame.play_bsgame(mapsize, shiplist,  max_turns, epsilon, statehistory, actionhistory, valuehistory)

	println("value plays ", sum(valuehistory), " max value ", maximum(valuehistory))
end

