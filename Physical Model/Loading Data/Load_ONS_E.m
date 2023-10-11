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

    ONS_E_rawSpace = params.A_PV .* E_Nights .* params.eta_PV .* params.eta_wire .* params.eta_MPPT .* params.eta_mismatch .* eta_CF(params);
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
     




   % [~,closestIndex] = min(abs(params.t_vec-params.ONS_times));



%     ONS_Energy_vec = zeros(params.N_t,1)';
% 
%     for i = 1:5
%         ONS_Energy.t(i) = (31261+(i-1)*24*60);
% 
%         ONS_E = 0;
%         for j = ONS_Energy.t(i):ONS_Energy.t(i)+15*60
%             ONS_E = ONS_E + params.A_PV .* params.Weather.Weather_Raw.Gtotal(j) .* params.eta_PV .* params.eta_wire .* params.eta_MPPT .* params.eta_mismatch .* eta_CF(params);
%         end
%         ONS_Energy.t(i) = (ONS_Energy.t(i)-30721)*60;
%         [~,closest_t_index] = min(abs(params.t_vec-ONS_Energy.t(i)));
%         ONS_Energy.E(i) = ONS_E/60;
%         ONS_Energy_vec(closest_t_index) = ONS_Energy.E(i);
%     end
% 
%     ONS_Energy.E_M = repmat(ONS_Energy_vec,params.N_E_bat,1,params.N_V,params.N_P_mot_el);
%     ONS_Energy.E_M = permute(ONS_Energy.E_M, [1 3 2 4]);
end


