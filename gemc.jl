module gemc
using bslogic
function eval_actions(info_map, actual_map, ship_tensor, epsilon, statehistory, actionhistory, valuehistory)
    # evaluate all possible actions on a current game state
    # after greedy epsilon monte carlo

    # very first guess
    if length(statehistory) == 0
        statehistory = info_map
        actionhistory = [1]
        valuehistory = [0]
        matching_states = [0.0]
    else
    # evaluate history, matching instances evaluate to zero
    matching_states = sum(sum(info_map .- statehistory, 1), 2)
    matching_states = matching_states[1,1,:]
    end

    # iterate over sensible guesses (it assumes the computer
    # knows which moves are useless based on rules)
    for guess in eachindex(info_map)
        #println("iterating over guess: ", guess)
        #println("iterating over actionhistory: ", actionhistory)
        #println("matching_states: ", matching_states)

        if info_map[guess] == -1
            state_idx = findin(actionhistory[matching_states .== 0], guess)
            if length(state_idx) > 0
                value = valuehistory[state_idx]
            else
                value = 0
                statehistory = cat(3, statehistory, info_map)
                state_idx = size(statehistory)[3]
                actionhistory = cat(1, actionhistory, guess)
                valuehistory = cat(1, valuehistory, value)
                matching_states = sum(sum(info_map .- statehistory, 1), 2)
                matching_states = matching_states[1,1,:]
            end
        end
    end

    # greedy epsilon monte carlo
    if rand(0:100) > (1-epsilon)/100
        println("valuehistory: ", valuehistory, " l ", length(valuehistory))
        println("matching_states: ", matching_states, " l ", length(matching_states))
        println("actionhistory: ", actionhistory, " l ", length(actionhistory))
        println("statehistory: ", " l ", size(statehistory))
        value, idx = findmax(valuehistory[matching_states .== 0])
        println("value ", value, "idx ", idx)
        action = actionhistory[idx]
    else
        action = actionhistory[rand(1:length(valuehistory[matching_states == 0]))]
    println("action chosen:")
    println(action)
    end

    return action, statehistory, actionhistory, valuehistory
end

end # end module
