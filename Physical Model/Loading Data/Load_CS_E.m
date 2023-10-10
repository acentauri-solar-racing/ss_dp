% This code was written with MATLAB R2022b. Errors may occur with other
% versions
% Written for the Semester Thesis of Severin Meyer (18-926-857) in FS23

%% Main Function
function CS_Energy = Load_CS_E(params)
    CS_Numbers = find(params.CS_location > params.S_start & params.CS_location < params.S_final);
    for i = CS_Numbers(1):CS_Numbers(end)
        G_raw_t = table2array(params.weather.G_raw).';
        G_Matrix = G_raw_t(:,(params.weather.Day_Start_indices(1)):params.weather.Day_End_indices(1));
        for j = 2:length(params.weather.Day_Start_indices)
            G_Matrix = [G_Matrix, G_raw_t(:,(params.weather.Day_Start_indices(j)):params.weather.Day_End_indices(j))];
        end
        CS_cur_cumDist = params.CS_location(i);
        % Find the index where the value is higher than the target
        higherIndex = find(params.weather.cumDist_raw > CS_cur_cumDist, 1);
        % Find the index where the value is lower than the target
        lowerIndex = find(params.weather.cumDist_raw < CS_cur_cumDist, 1, 'last');
        target = interp1(params.weather.cumDist_raw(lowerIndex:higherIndex),params.weather.G_raw(lowerIndex:higherIndex,:),CS_cur_cumDist);
        

    end

%     for i = 1:length(params.t_vec)
%         CS_Energy.t(i) = params.t_vec(i);
%         [~,closestIndex] = min(abs(params.t_vec(i)-params.Weather.t_min));
% 
%         CS_E = 0;
%         for j = closestIndex:closestIndex+29
%             CS_E = CS_E + params.A_PV .* params.Weather.G_min(j) .* params.eta_PV .* params.eta_wire .* params.eta_MPPT .* params.eta_mismatch .* eta_CF(params);
%         end
% 
%         CS_Energy.E(i) = CS_E/60;
%     end
end


