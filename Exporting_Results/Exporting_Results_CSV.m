% This code was written with MATLAB R2022b. Errors may occur with other
% versions
% Written for the Semester Thesis of Severin Meyer (18-926-857) in FS23

%% Main Function
function Exporting_Results_CSV(OptRes,referenceTime)
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
    DateTime_DP = referenceTime + seconds(round(seconds_DP,0));
    cumDist_DP = OptRes.time.';
    optV_DP = OptRes.states.V.'*3.6;
    optSoC_DP = OptRes.states.E_bat.'/params.E_bat_max;

    Results_DP = table(DateTime_DP, cumDist_DP, optV_DP, optSoC_DP);
    writetable(Results_DP,'Results_DP_Test.csv','Delimiter',',')
end