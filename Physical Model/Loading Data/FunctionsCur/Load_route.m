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
%function route = Load_route(params)
    % Import raw route data
    route_raw = readtable('route_preprocessed.csv');

    % Creating cumDist vector
    route.cumDist = params.S_RW_vec;

    % Interpolating inclination vector
    incl = interp1(route_raw.cumDistance,route_raw.inclinationSmoothed,route.cumDist);

    % Interpolating maxV vector
    maxV = interp1(route_raw.cumDistance,route_raw.maxSpeed,route.cumDist);

    % Determining group average constant n
    n = params.S_step/params.S_RW_Step;

    % Initialize empty 
    route.incl = [];
    route.maxV = [];

    % Iterate through the original vector
    for i = 1:n:length(route.cumDist)-n+1
        % Extract the current group of 'n' values
        group_incl = incl(i:i+n-1);
        group_maxV = maxV(i:i+n-1);
        
        % Calculate the average of the group
        averageValue_incl = mean(group_incl);
        averageValue_maxV = mean(group_maxV);
        
        % Append the average value to the new vector
        route.incl = [route.incl, averageValue_incl];
        route.maxV = [route.maxV, averageValue_maxV];
    end

    % Import Control Stops
    CS_raw = readtable('control_stops.csv');
    route.CS_cumDist = CS_raw.cumDistance(2:end-1);