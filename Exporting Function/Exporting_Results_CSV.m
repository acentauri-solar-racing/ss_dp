% This code was written with MATLAB R2022b. Errors may occur with other
% versions
% Written for the Semester Thesis of Severin Meyer (18-926-857) in FS23

%% Main Function
function Exporting_Results_CSV(OptRes,referenceTime,params,currentDateTime)
    seconds_DP = round(OptRes.states.t.',0);
    k_night = 0;

    for i = 1:length(seconds_DP)
        if seconds_DP(i) >= 9*60*60*(k_night+1)
            k_night = k_night+1;
            seconds_DP(i) = seconds_DP(i) + 15*60*60*k_night;
        else
            seconds_DP(i) = seconds_DP(i) + 15*60*60*k_night;
        end
    end
%     Var_Names = {'cumDist' 'time' 'optV' 'optSoC'};
    time = referenceTime + seconds(round(seconds_DP,0));
    cumDistance = OptRes.time.';
    velocity = OptRes.states.V.'*3.6;
    soc = OptRes.states.E_bat.'/params.E_bat_max;
    Results_DP = table(time, cumDistance, velocity, soc);

    % G Drive
    directory = 'G:\Shared drives\AlphaCentauri\SolarCar_22 23\6. Strategy & Simulation\ss_online_data\DP_optimal\CSV\';
    timestamp = datestr(currentDateTime, 'yyyymmdd_HHMMSS');
    filename = [directory, timestamp, '_DP.csv'];
    writetable(Results_DP,filename,'Delimiter',',');

    % Local Backup
    directory = 'C:\BWSC 2023 Local Backup\DP_optimal\CSV\';
    filename = [directory, timestamp, '_DP.csv'];
    writetable(Results_DP,filename,'Delimiter',',');
end