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
    G_raw = readtable('globalIrradiance.csv','Delimiter',',');
    frontWind_raw = readtable('frontWind.csv','Delimiter',',');
    airDensity_raw = readtable('airDensity.csv','Delimiter',',');
    temperature_raw = readtable('temperature.csv','Delimiter',',');
    
    % Getting weather space and time stamps
    weather_time_raw = airDensity_raw(2:end,1);
    weather_cumDist_raw = airDensity_raw(1,2:end);

    p = airDensity_raw(2:end,2:end);

%end