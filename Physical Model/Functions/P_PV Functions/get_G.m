% This code was written with MATLAB R2022b. Errors may occur with other
% versions
% Written for the Semester Thesis of Severin Meyer (18-926-857) in FS23

%% Main Function
% get_G
function G = get_G(dpState,params,k)
    % Calculations
    if (params.N_E_bat == 1)
%         Old SP code
%         [~,closestIndex] = min(abs(params.t_vec-t));
%         G(1,1,1,:) = params.Weather.G(closestIndex);
        [~,closestIndex] = min(abs(params.t_vec-dpState.t(1,1,1,:)));
        G(1,1,1,:) = params.weather.G(k,closestIndex);
    else
%         Old SP code
%         G = repmat(params.Weather.G,params.N_E_bat,1,params.N_V,params.N_P_mot_el);
%         G = permute(G, [1 3 2 4]);
        G = repmat(params.weather.G(k,:),params.N_E_bat,1,params.N_V,params.N_P_mot_el);
        G = permute(G, [1 3 2 4]);
    end
end
