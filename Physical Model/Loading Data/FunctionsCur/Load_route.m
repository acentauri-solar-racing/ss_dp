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
    route.incl = interp1(route_raw.cumDistance,route_raw.inclinationSmoothed,route.cumDist);

    % Interpolating maxV vector
    route.maxV = interp1(route_raw.cumDistance,route_raw.maxSpeed,route.cumDist);

    % Import Control Stops
    CS_raw = readtable('control_stops.csv');
    route.CS_cumDist = CS_raw.cumDistance(2:end-1);
%end