% This code was written with MATLAB R2022b. Errors may occur with other
% versions
% Written for the Semester Thesis of Severin Meyer (18-926-857) in FS23

%% Main Function
% temp_PV
function TPV = temp_PV(dpState,params,k)
    % Calculations
    if (params.N_E_bat == 1)
        [~,closestIndex] = min(abs(params.t_vec-dpState.t(1,1,1,:)));
        ambTemp(1,1,1,:) = params.weather.temp(k,closestIndex);
    else
        ambTemp = repmat(params.weather.temp(k,:),params.N_E_bat,1,params.N_V,params.N_P_mot_el);
        ambTemp = permute(ambTemp, [1 3 2 4]);
    end
    TPV = 15 + ambTemp; % PV temp (C)
end
