function [action, reward, next_state] = step(current_state, Q, n_states, n_cols, n_eps, start, goal, experiment_n, step_n, reward_array, policy, probs)
% Grid world step

if strcmp(policy, 'eps')
    if(rand > (1 / sqrt(n_eps(current_state))))
        mean_Q = mean(Q, 3);
        [~, max_action] = max(mean_Q(current_state, :));
        action = max_action;
    else
        action = floor(rand * 4) + 1;
    end
elseif strcmp(policy, 'neps')
    cums = cumsum(probs);
    probs = cums / max(cums);
    action = find(rand <= probs, 1, 'first');
end

if(current_state ~= goal)
    if(action == 1)
        next_state = current_state - n_cols;
        if(next_state < 1)
            next_state = current_state;
        end
    elseif(action == 2)
        next_state = current_state + n_cols;
        if(next_state > n_states)
            next_state = current_state;
        end
    elseif(action == 3)
        next_state = current_state - 1;
        if(mod(next_state, n_cols) == 0)
            next_state = current_state;
        end
    else
        next_state = current_state + 1;
        if(mod(current_state, n_cols) == 0)
            next_state = current_state;
        end
    end
    
    reward = reward_array(experiment_n, step_n);
else
    reward = 5;
    next_state = start;

end

