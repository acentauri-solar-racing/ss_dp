% This code was written with MATLAB R2022b. Errors may occur with other
% versions
% Written for the Semester Thesis of Severin Meyer (18-926-857) in FS23

%% Main function
function P = Load_Parameters()
    % Creating Table
    P = table();
    
    % Adding Parameters
        %% Set for new DP
        % Space
        P.S_start = 0; % Initial distance (m)
        P.S_step = 10000; % Distance step size (m)
        P.S_EF_Step = 200; % Distance step size euler forward (m)
        P.S_RW_Step = 10; % Subsampled Route/Weather step (m)
        P.S_final = 800000; % Final distance (m) % 3020km max

        % Battery
        P.ue_E_bat = 1; % Upper end target SoC (%)
        P.le_E_bat = 0.1; % Lower end target SoC (%)
        P.N_E_bat = 20+1; % Number of discretization points for E_bat state

        % Velocity
        P.V_start = 65; % Initial Velocity (km/h)
        P.V_max = 100; % Largest possible velocity (km/h)
        P.V_min = 50; % Smallest possible velocity (km/h)
        P.N_V = 10+1; % Number of discretization points for V state

        % Time
        P.t_start = 0; % Initial time (s)
        P.t_divider = 1000; % Time divider (s)
        P.t_S_divider = 20; % S divider

        % Input
        P.P_mot_el_max = 3000; % Largest possible input (W)
        P.P_mot_el_min = 200; % Smallest possible input (W)
        P.N_P_mot_el = 20+1; % Number of discretization points for input

        %% General
        % DP Setup Space
        P.S_vec = P.S_start:P.S_step:P.S_final; % Space vector
        P.S_RW_vec = P.S_start:P.S_RW_Step:(P.S_final+P.S_step); % Route Space Vector for interpolation

        % Loading route
        P.Route = Load_Route(P);
        % Adding the final position as CS in case there are no others
        % Bug fix, code cant handle no CSs present
        if P.Route.CS_cumDist(end) <= P.S_start
            P.Route.CS_cumDist(end+1) = P.S_final;
        end

        % DP Setup Time (with CS time augmentation)
        P.t_final = (P.S_final-P.S_start)/P.t_S_divider ; % Time horizon (s) 
        P.CS_location = P.Route.CS_cumDist.'; % Transposing locations to be in the correct format
        logicalIndex = P.CS_location > P.S_start; % Filtering out the applicable stops
        P.CS_location = P.CS_location(logicalIndex);% Filtering out the applicable stops
        P.CS_vec = (P.CS_location - P.S_start) / P.S_step; % getting the space indices
        P.t_final = P.t_final + 1800*(sum(P.CS_location<=P.S_final,'all')); % CS adapted time horizon (s) 
        P.N_t = round(P.t_final/P.t_divider+1); % Number of discretization points for t state
        P.t_vec = linspace(P.t_start,P.t_final,P.N_t); % Time vector
        P.t_step = P.t_vec(2) - P.t_vec(1); % Time step size (s)

        % PV Parameters
        P.A_PV = 4; % PV area (m2)
        P.eta_PV = 0.244; % PV efficiency
        P.eta_wire = 0.98; % PV wire efficiency
        P.eta_MPPT = 0.99; % PV MPPT efficiency
        P.eta_mismatch = 0.98; % PV mismatch
        P.lambda_PV = -0.0029; % Power loss coef (/K);
        P.temp_STC = 25; % Standard-condition temperature (C)

        % P_V_const Parameters
        P.temp_PV_Stops = 35; % PV temperature during stops (C)
%         P.rho = 1.17; % Air density (kg/m3)
        P.A_aero = 0.85; % Frontal aerodynamic area (m2)
        P.C_d = 0.2171; % Drag coef
        P.g = 9.81; % Acceleration of gravity (m/s2)
        P.C_r = 0.00157; % Roll friction coef
        P.N_front = 4; % Number for frontal bear rings
        P.N_rear = 1; % Number for rear bear rings
        P.T_front = 0.0; % 0.055; % Front wheels bearing friction moment (Nm)
        P.T_rear = 0.0; % 0.2; % Rear wheels bearing friction moment (Nm)
        P.r_w = 0.2785; % Wheel radius (m)
        P.mass = 264; % Car mass with driver (kg)

        % P_mot_mech Parameters
        P.e_mot = 0.98; % E-motor efficiency
        P.P_0 = 110; % Idle power (W)

        % Battery Parameters
        P.E_bat_max = 5200; % Energy in Battery when fully charged (Wh)

        %% Loading weather data
        P.weather = Load_Weather(P);

        %% Over-Night Stop Energy
        P.ONS_times = (1:7)*9*3600;
        P.ONS_E = Load_ONS_E(P); % Energy supplied by ONS (Wh)

        %% Control Stop Energy
        P.CS_E = Load_CS_E(P); % Energy supplied by CS (Wh)
end