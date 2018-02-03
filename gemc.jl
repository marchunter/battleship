module gemc
function eval_actions(info_map, actual_map, shiptensor, epsilon)
    # evaluate all possible actions on a current game state
    # after greedy epsilon monte carlo

    # iterate over sensible guesses (it assumes the computer
    # knows which moves are useless based on rules)
    for idx in eachindex(info_map)
        if info_map[idx] == -1
            println("guess what")
        else
            println("don't guess")
        end

    end

    # greedy epsilon monte carlo

end

end # end module
