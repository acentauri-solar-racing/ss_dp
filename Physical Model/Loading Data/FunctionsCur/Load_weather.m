% This code was written with MATLAB R2022b. Errors may occur with other
% versions
% Written for the Semester Thesis of Severin Meyer (18-926-857) in FS23

%% Initialization:
clc
clear
clearvars
close all

%% Include Path of idscDPfunction
addpath(genpath('.\..\'));

%% Loading Parameters
params = table2struct(Load_Parameters());

%% Main Function
%function weather = Load_weather(params)
    % Import raw weather data
    G_raw_table = readtable('globalIrradiance.csv','Delimiter',',');
    frontWind_raw_table = readtable('frontWind.csv','Delimiter',',');
    airDensity_raw_table = readtable('airDensity.csv','Delimiter',',');
    temperature_raw_table = readtable('temperature.csv','Delimiter',',');
    
    % Getting weather space and time stamps
    weather_time_raw = G_raw_table(2:end,1);
    weather_cumDist_raw = G_raw_table(1,2:end);




    % Processing time stamps
    % Sample date/time string

    % Original date/time string
    datetimeString = '2023-10-08 06:30:00+09:30';
    b = table2cell(weather_time_raw);
    % Remove the '+09:30' offset
    datetimeStringWithoutOffset = strrep(b, '+09:30', '');

    datetimeTable = datetime(datetimeStringWithoutOffset,'InputFormat', 'yyyy-MM-dd HH:mm:ss');

    index = find(timeofday(datetimeTable) == '11:00:00');
    
    % Convert the date/time string to a datetime object
    dt = datetime(datetimeStringWithoutOffset,'InputFormat', 'yyyy-MM-dd HH:mm:ss');
    
    % Extract date, time, and seconds
    dateComponent = datestr(dt, 'yyyy-mm-dd');  % Extract date in 'yyyy-mm-dd' format
    timeComponent = datestr(dt, 'HH:MM:SS');    % Extract time in 'HH:MM:SS' format
    secondsComponent = second(dt);              % Extract seconds
    
    index = find(timeComponent == '11:00:00');






    % Getting weather data tables
    G_raw = G_raw_table(2:end,2:end);
    frontWind_raw = frontWind_raw_table(2:end,2:end);
    airDensity_raw = airDensity_raw_table(2:end,2:end);
    temperature_raw = temperature_raw_table(2:end,2:end);

%end