# battleship
Battleship Game in Julia
(V0.6)

## Rules
Two-player game where every player owns ships in a separate map
Ships on a map need to be separated by at least one field (including diagonally).
The game ends when all ships of a player are sunk.


## Work in Progress

logic.jl includes two functions create_ships and update_game!. Appended in logic.jl is a testing part which can be transferred to the main file later. In order to facilitate look_up of ships, there is a simple map as well as a tensor which are essentially a list of single-ship maps

