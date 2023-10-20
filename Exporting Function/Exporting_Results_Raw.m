% This code was written with MATLAB R2022b. Errors may occur with other
% versions
% Written for the Semester Thesis of Severin Meyer (18-926-857) in FS23

%% Main Function
function Exporting_Results_Raw(OptRes,params,currentDateTime)
    % G Drive
    directory = 'G:\Shared drives\AlphaCentauri\SolarCar_22 23\6. Strategy & Simulation\ss_online_data\DP_optimal\Raw Data\';
    timestamp = datestr(currentDateTime, 'yyyymmdd_HHMMSS');
    filename = [directory, timestamp, '_DP.mat'];
    save(filename,'OptRes','params');

% %     Local Backup
%     directory = 'C:\BWSC 2023 Local Backup\DP_optimal\Raw Data\';
%     filename = [directory, timestamp, '_DP.mat'];
%     save(filename,'OptRes','params');
end