% This code was written with MATLAB R2022b. Errors may occur with other
% versions
% Written for the Semester Thesis of Severin Meyer (18-926-857) in FS23

%% Main Function
% SolarCarModel_DP
function [dpState, dpCost, dpIsFeasible, dpOutput] = SolarCarModel_DP(dpState, dpInput, dpDisturbance, dpTs, parameters)
    
    % Getting matrix dimensions
    [parameters.N_E_bat, parameters.N_V, parameters.N_t, parameters.N_P_mot_el] = size(dpState.t);

    % Storing t(k) before overwriting it to t(k+1) for ONS condition
    t_min1 = dpState.t;
    
    %% Calculating states(k+1)
    % EF_Substeps
    % Calculating E_bat derivative 
    E_bat_dot = (P_PV(dpState,parameters,dpDisturbance.k) - dpInput.P_mot_el) ./ dpState.V;

    % Calculating E_bat state(k+1)
    dpState.E_bat = dpState.E_bat + E_bat_dot*dpTs/3600;

    for i = 0:parameters.S_EF_Step:(dpTs-parameters.S_EF_Step)
        % Calculating V derivative 
        V_dot = (P_mot_mech(dpInput.P_mot_el,parameters) - P_V_const(dpState,parameters,dpDisturbance.k))./ ... 
                (parameters.mass.*dpState.V.^2);
        
        % Calculating V state(k+1)
        dpState.V = dpState.V + V_dot*parameters.S_EF_Step;

        % Calculating t derivative 
        t_dot = 1 ./ dpState.V;

        % Calculating t state(k+1)
        dpState.t = dpState.t + t_dot*parameters.S_EF_Step;
    end      

    %% Implementing CSs
    % Checking if we are at a CS location
    if(any(dpDisturbance.k-1 == parameters.CS_vec))
        % finding the exact CS we are at in the CS_vec array
        k_CS = find(dpDisturbance.k-1 == parameters.CS_vec);

        % Cecking if we are in the backwards or frowards DP step
        if (parameters.N_E_bat == 1)
            % Finding the correct time
            [~,closestIndex] = min(abs(parameters.t_vec-dpState.t(1,1,1,:)));
            
            if length(parameters.CS_E.E(1,:)) == 1
                % Bug fix when only one CS is present in horizon
                CS_Energy(1,1,1,:) = parameters.CS_E.E(closestIndex,k_CS);
            else
                % Getting the correct CS Energy for the location
                CS_Energy(1,1,1,:) = parameters.CS_E.E(k_CS,closestIndex);
            end
        else
            % Creating the CS_Energy matrix in the required DP format
            CS_Energy = repmat(parameters.CS_E.E(k_CS,:),parameters.N_E_bat,1,parameters.N_V,parameters.N_P_mot_el);
            CS_Energy = permute(CS_Energy, [1 3 2 4]);
        end
        % Adding Energy to the battery
        dpState.E_bat = dpState.E_bat + CS_Energy; % CHECK THAT VECTOR IN FORWARD CASE
        % Moving time forward 30 min due to CS
        dpState.t = dpState.t + 1800;
    end

    %% Implementing ONSs
    % Cecking if we are in the backwards or frowards DP step
    if(parameters.N_E_bat == 1)
        % Iterating through all possible nights (7 at max)
        for i = 1:7
            % Checking if we pass a Night Stop
            bool = (t_min1 <= parameters.ONS_times(i) & dpState.t > parameters.ONS_times(i));
            % Finding the exact night
            [~,closestIndex] = min(abs(mode(t_min1(1,1,1,:))-parameters.ONS_times));
            % Adding the energy to the battery
            % Bool filters the correct Night out
            dpState.E_bat = dpState.E_bat + bool * parameters.ONS_E.E(dpDisturbance.k,closestIndex);
        end
    else
        % Getting the ONS_E_Mat
        ONS_E_Mat = parameters.ONS_E.E_Mat;
        % Getting the row for the current location
        ONS_E_Nights = ONS_E_Mat(dpDisturbance.k,:);
        % Creating the ONS_E_M matrix in the required DP format
        ONS_E_M = repmat(ONS_E_Nights,parameters.N_E_bat,1,parameters.N_V,parameters.N_P_mot_el);
        ONS_E_M = permute(ONS_E_M, [1 3 2 4]);
        % Adding Energy to the Battery
        dpState.E_bat = dpState.E_bat + ONS_E_M;
    end

    % Preventing battery overload
    dpState.E_bat(dpState.E_bat > parameters.E_bat_max) = parameters.E_bat_max;

    % Cost
    dpCost = 1./dpState.V;

    % Feasibility
    V_max = parameters.Route.max_V(dpDisturbance.k);
    dpIsFeasible = Constraints(dpState,V_max);

    % Output
    dpOutput = [];
end