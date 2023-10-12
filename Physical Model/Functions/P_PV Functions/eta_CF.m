% This code was written with MATLAB R2022b. Errors may occur with other
% versions
% Written for the Semester Thesis of Severin Meyer (18-926-857) in FS23

%% Main Function
% eta_CF
function ECF = eta_CF(dpState,params,k)
    % Calculations
    ECF = 1 - params.lambda_PV .* (temp_PV(dpState,params,k) - params.temp_STC);
end
