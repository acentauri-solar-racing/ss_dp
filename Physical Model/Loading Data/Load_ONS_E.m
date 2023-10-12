% This code was written with MATLAB R2022b. Errors may occur with other
% versions
% Written for the Semester Thesis of Severin Meyer (18-926-857) in FS23

%% Main Function
function ONS_Energy = Load_ONS_E(params)
    weather = params.weather;
    G_raw = table2array(weather.G_raw).';
    t_seconds_raw = weather.weather_seconds_raw;
    Day_Start_indices = weather.Day_Start_indices;
    Day_End_indices = weather.Day_End_indices;
    
    G_Nights = [];
    for i = 1:length(Day_Start_indices)-1
        G_ith_night = G_raw(:,Day_End_indices(i):Day_Start_indices(i+1));
        sum = zeros(length(G_ith_night(:,1)),1);
        for j = 1:length(G_ith_night(1,:))
            sum = sum + G_ith_night(:,j);
        end
        G_Nights = [G_Nights sum];
    end
    E_Nights = G_Nights / (3600/params.weather.time_step_raw);

    ONS_E_rawSpace = params.A_PV .* E_Nights .* params.eta_PV .* params.eta_wire .* params.eta_MPPT .* params.eta_mismatch .* (1 - params.lambda_PV .* (params.temp_PV_Stops - params.temp_STC));
    ONS_Energy.E = interp1(params.weather.cumDist_raw,ONS_E_rawSpace,params.S_vec);

    ONS_Energy.E_Mat = zeros(length(params.S_vec),length(params.t_vec));

    ONS_index_DPT = [];
    for i = 1:length(params.ONS_times)
        ONS_time = params.ONS_times(i);
        [~,closestIndex] = min(abs(params.t_vec-ONS_time));
        if closestIndex ~= length(params.t_vec)
            ONS_index_DPT = [ONS_index_DPT closestIndex];
            ONS_Energy.E_Mat(:,closestIndex) = ONS_Energy.E(:,i);
        end
    end
end


