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
    matching_states = sum(sum(abs, info_map .- statehistory, 1), 2)
    matching_states = matching_states[1,1,:]
    end

    # iterate over sensible guesses (it assumes the computer
    # knows which moves are useless based on rules)
    for guess in eachindex(info_map)
        #println("iterating over guess: ", guess)
        #println("iterating over actionhistory: ", actionhistory)
        #println("matching_states: ", matching_states, " l ", length(matching_states))

        if info_map[guess] == -1
            state_idx = findin(actionhistory[matching_states .== 0], guess)
            #println("state exists? ", state_idx)
            if length(state_idx) > 0
                value = valuehistory[state_idx]
            else
                value = 0
                statehistory = cat(3, statehistory, info_map)
                state_idx = size(statehistory)[3]
                actionhistory = cat(1, actionhistory, guess)
                valuehistory = cat(1, valuehistory, value)
                matching_states = sum(sum(abs, info_map .- statehistory, 1), 2)
                matching_states = matching_states[1,1,:]
            end
        end
    end

    #println("matching_states: ", " l ", length(matching_states))

    # greedy epsilon monte carlo
    if rand(0:100) > epsilon*100
        #println("valuehistory: ", valuehistory, " l ", length(valuehistory))
        #println("actionhistory: ", actionhistory, " l ", length(actionhistory))
        #println("statehistory: ", " l ", size(statehistory))
        ids = find(matching_states .== 0)
        value, idx_ids = findmax(valuehistory[ids])
        idx = ids[idx_ids]
        #println("value ", value, "idx ", idx)
        #println("idx_ids ", idx_ids)
        action = actionhistory[idx]
    else
        #validactions = actionhistory[matching_states .== 0]
        #println("valid actions: ", validactions)
        #action = validactions[rand(1:length(validactions))]

        ids = find(matching_states .== 0)
        idx_ids = rand(1:length(ids))
        idx = ids[idx_ids]
        action = actionhistory[idx]
        #println("ids ", ids)
        #println("idx_ids ", idx_ids)
        #println("idx ", idx)


    #println("action chosen:")
    #println(action)
    end

    return action, idx, statehistory, actionhistory, valuehistory
end

function rank_action(action_idx, valuehistory, game_state)
    # miss, hit, sunk or game done
    if game_state == 0  
        added_value = -1
    elseif game_state == 1   
        added_value = 1
    elseif game_state == 2    
        added_value = 3
    elseif game_state == 3    
        added_value = 5
    else
        println("WARNING: game state unknown")
    end

    valuehistory[action_idx] += added_value
    return valuehistory
end

end # end module
