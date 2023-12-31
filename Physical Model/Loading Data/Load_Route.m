% This code was written with MATLAB R2022b. Errors may occur with other
% versions
% Written for the Semester Thesis of Severin Meyer (18-926-857) in FS23

%% Main Function
function route = Load_Route(params)
    % Import raw route data
    route_raw = readtable('route_preprocessed.csv');

    % Creating cumDist vector
    route.cumDist = params.S_RW_vec;

    % Interpolating inclination vector
    incl = interp1(route_raw.cumDistance,route_raw.inclinationSmoothed,params.S_RW_vec);

    % Interpolating maxV vector
    max_V = interp1(route_raw.cumDistance,route_raw.maxSpeed,params.S_RW_vec);

    % Determining group average constant n
    n = params.S_step/params.S_RW_Step;

    % Initialize empty 
    route.incl = [];
    route.max_V = [];

    % Iterate through the original vector
    for i = 1:n:length(route.cumDist)-n+1
        % Extract the current group of 'n' values
        group_incl = incl(i:i+n-1);
        group_max_V = max_V(i:i+n-1);
        
        % Calculate the average of the group
        averageValue_incl = mean(group_incl);
        averageValue_max_V = mean(group_max_V);
        
        % Append the average value to the new vector
        route.incl = [route.incl, averageValue_incl];
        route.max_V = [route.max_V, averageValue_max_V];
    end

    % Lowering maxV to the maximal possible speed of the solar car
    route.max_V(route.max_V>params.V_max) = params.V_max;

    % Adding minV
    route.min_V = route.max_V;
    route.min_V(route.max_V>60) = 60/3.6;
    route.min_V(route.max_V<=60) = 50/3.6;

    % Converting km/h to m/s
    route.max_V = route.max_V/3.6;

    % Adding cumDist due to data type issues
    route.cumDist = params.S_vec;

    % Import Control Stops
    CS_raw = readtable('control_stops.csv');
    route.CS_cumDist = round(CS_raw.cumDistance(2:end-1),-4);
end