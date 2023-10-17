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

%% Adding Simulation model
OptPrb = dpaProblem('SolarCarModel_DP',params);

%% Preparing DP
% Creating "Time" vector (working in space domain)
OptPrb.timeVector = params.S_vec;

% Adding states
OptPrb.addStateVariable('E_bat',params.N_E_bat,params.E_bat_max*0.1,params.E_bat_max);
OptPrb.addStateVariable('V',params.N_V,params.V_min/3.6,params.V_max/3.6);
OptPrb.addStateVariable('t',params.N_t,params.t_start,params.t_final);

% Adding input
OptPrb.addInputVariable('P_mot_el',params.N_P_mot_el,params.P_mot_el_min,params.P_mot_el_max); 

% Adding space vector as disturbance
OptPrb.addDisturbance('k',1:length(params.S_vec));

% Adding final state constraints
% OptPrb.setFinalStateConstraint('E_bat',params.E_bat_max*params.le_E_bat,params.E_bat_max*params.ue_E_bat);

% Choosing DP settings
OptPrb.useMyGrid = false;
OptPrb.myInf = 10^5;
OptPrb.storeOptInputs = false; % used for plots, consider to set to false for RAM improvements

%% Running backwards DP
OptPrb.solve;

%% Running forwards simulation
OptRes = evaluate(OptPrb,'E_bat',params.E_bat_max,'V',params.V_start/3.6,'t',params.t_start);

% save("BWSC2023_20231015.mat",'OptRes','params'); % BWSC 2023 ---
referenceTime = datetime('17-10-2023 08:00:00', 'Format', 'dd-MM-yyyy HH:mm:ss');
Exporting_Results_CSV(OptRes,referenceTime,params);
Exporting_Results_Raw(OptRes,params);
%% Plotting results
Plot_Data_DP(OptRes,params.S_vec,params);
