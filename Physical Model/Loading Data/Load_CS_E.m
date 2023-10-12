% This code was written with MATLAB R2022b. Errors may occur with other
% versions
% Written for the Semester Thesis of Severin Meyer (18-926-857) in FS23

%% Main Function
function CS_Energy = Load_CS_E(params)
    % Getting indices of CS locations
    CS_Numbers = find(params.CS_location > params.S_start & params.CS_location < params.S_final);
    % Getting G table in Race Space/Time
    G_RST = params.weather.G;

    % Iterating through CS locations
    for i = 1:length(params.CS_location)
        if any(CS_Numbers == i)
            G_CS_RT = G_RST((params.CS_location(i)-params.S_start)/params.S_step+1,:);
            CS_G_Mat(i,:) = G_CS_RT;
        else
            CS_G_Mat(i,:) = zeros(1,length(G_RST(1,:)));
        end
    end

    minInSec_net = 0:60:params.t_final;
    mat = interp1(params.t_vec,CS_G_Mat.',minInSec_net).';
    if length(mat(1,:)) == 1
        mat = mat.';
    end

    for i = 1:(length(mat(1,:))-30)
        sum = zeros(1,length(mat(:,1))).';
        for j = i:i+29
            sum = sum + mat(:,j);
        end
        CS_Gsum_Mat(:,i) = sum/30;
    end

    for i = length(CS_Gsum_Mat(1,:)):length(mat(1,:))
        CS_Gsum_Mat(:,i) = CS_Gsum_Mat(:,i-1);
    end

    minInSec_net(end) = minInSec_net(end) + 61;
    mat2 = interp1(minInSec_net,CS_Gsum_Mat.',params.t_vec).';
    CS_Energy.E = 0.5* params.A_PV .* mat2 .* params.eta_PV .* params.eta_wire .* params.eta_MPPT .* params.eta_mismatch .* (1 - params.lambda_PV .* (params.temp_PV_Stops - params.temp_STC));
%     Old SP code
%     CS_Numbers = find(params.CS_location > params.S_start & params.CS_location < params.S_final);
%     for i = CS_Numbers(1):CS_Numbers(end)
%         G_raw_t = table2array(params.weather.G_raw).';
%         G_Matrix = G_raw_t(:,(params.weather.Day_Start_indices(1)):params.weather.Day_End_indices(1));
%         for j = 2:length(params.weather.Day_Start_indices)
%             G_Matrix = [G_Matrix, G_raw_t(:,(params.weather.Day_Start_indices(j)):params.weather.Day_End_indices(j))];
%         end
%         CS_cur_cumDist = params.CS_location(i);
%         % Find the index where the value is higher than the target
%         higherIndex = find(params.weather.cumDist_raw > CS_cur_cumDist, 1);
%         % Find the index where the value is lower than the target
%         lowerIndex = find(params.weather.cumDist_raw < CS_cur_cumDist, 1, 'last');
%         CS_G = interp1(params.weather.cumDist_raw(lowerIndex:higherIndex),G_Matrix(lowerIndex:higherIndex,:),CS_cur_cumDist);
%         for j = 1:length(params.t_vec)
%             CS_Energy.t(i) = params.t_vec(i);
% %             [~,closestIndex] = min(abs(params.t_vec(i)-params.weather.));
%         end
%         
%     end
end


