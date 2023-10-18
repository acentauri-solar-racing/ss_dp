% This code was written with MATLAB R2022b. Errors may occur with other
% versions
% Written for the Semester Thesis of Severin Meyer (18-926-857) in FS23

%% Main Function
function weather = Load_Weather(params)
    %% Loading Data
    % Import raw weather data
    G_raw_table = readtable('globalIrradiance.csv','Delimiter',',');
    frontWind_raw_table = readtable('frontWind.csv','Delimiter',',');
    airDensity_raw_table = readtable('airDensity.csv','Delimiter',',');
    temperature_raw_table = readtable('temperature.csv','Delimiter',',');

    % Getting weather data tables by cutting away time and space vectors
    G_raw = G_raw_table(2:end,2:end);
    frontWind_raw = frontWind_raw_table(2:end,2:end);
    airDensity_raw = airDensity_raw_table(2:end,2:end);
    temperature_raw = temperature_raw_table(2:end,2:end);
    
    % Getting weather space and time stamps
    weather_time_raw = G_raw_table(2:end,1);
    weather_cumDist_raw = table2cell(G_raw_table(1,2:end));

    %% Processing time array
    % Remove the '+09:30' offset
    datetimeStringWithoutOffset = strrep(table2cell(weather_time_raw), '+09:30', '');

    % Creating datetime data format
    datetimeTable = datetime(datetimeStringWithoutOffset,'InputFormat', 'yyyy-MM-dd HH:mm:ss');

    % Getting timeofday array
    timeofDay = timeofday(datetimeTable);

    % finding the first and last indices of all days in race time (08:00:00 and 17:00:00)
    Day_Start_indices = find(timeofDay == '08:00:00');
    Day_End_indices = find(timeofDay == '17:00:00');

    % Getting seconds and time steps
    weather_seconds_raw = seconds(timeofDay);
    weather.weather_seconds_raw = weather_seconds_raw;
    
    % weather_seconds_step_raw = weather_seconds_raw(4)-weather_seconds_raw(3);

    % Moving weather raw time to race time
    weather_seconds_RT_raw = weather_seconds_raw(Day_Start_indices(1):Day_End_indices(1))-weather_seconds_raw(Day_Start_indices(1));
    for i = 2:length(Day_Start_indices)
        weather_seconds_RT_raw = [weather_seconds_RT_raw; weather_seconds_raw(Day_Start_indices(i):Day_End_indices(i))-weather_seconds_raw(Day_Start_indices(i))+weather_seconds_RT_raw(end)+1];
    end

    %% Moving weather data to race time (RT) domain
    G_RT_raw = cut_to_RT(G_raw,Day_Start_indices,Day_End_indices);
    frontWind_RT_raw = cut_to_RT(frontWind_raw,Day_Start_indices,Day_End_indices);
    airDensity_RT_raw = cut_to_RT(airDensity_raw,Day_Start_indices,Day_End_indices);
    temperature_RT_raw = cut_to_RT(temperature_raw,Day_Start_indices,Day_End_indices);

    %% Getting data into the DP time and space frame
    weather_cumDist_raw = cell2mat(weather_cumDist_raw);
    G_RST = R_ST_interpolation(G_RT_raw, params, weather_seconds_RT_raw, weather_cumDist_raw);
    frontWind_RST = R_ST_interpolation(frontWind_RT_raw, params, weather_seconds_RT_raw, weather_cumDist_raw);
    airDensity_RST = R_ST_interpolation(airDensity_RT_raw, params, weather_seconds_RT_raw, weather_cumDist_raw);
    temperature_RST = R_ST_interpolation(temperature_RT_raw, params, weather_seconds_RT_raw, weather_cumDist_raw);

    %% Creating Weather struct
    weather.G = G_RST;
    weather.frontWind = frontWind_RST;
    weather.airDensity = airDensity_RST;
    weather.temp = temperature_RST;
    weather.G_raw = G_raw;
    weather.time_step_raw = weather_seconds_raw(4) - weather_seconds_raw(3);
    weather.cumDist_raw = weather_cumDist_raw;
    weather.Day_Start_indices = Day_Start_indices;
    weather.Day_End_indices = Day_End_indices;
end

% Converts raw weather data tables to race time (RT)
function table_RT = cut_to_RT(table_raw,Day_Start_indices,Day_End_indices)
    table_RT = [];
    for i = 1:length(Day_Start_indices)
        table_RT = [table_RT; table_raw(Day_Start_indices(i):Day_End_indices(i),:)];
    end
end

% Interpolates the weather data form the raw format to the race space/time
% format
function interpolatedData = R_ST_interpolation(data, params, weather_seconds_RT_raw, weather_cumDist_raw)
    [oldTimeGrid, oldSpaceGrid] = meshgrid(weather_seconds_RT_raw, weather_cumDist_raw);
    [newTimeGrid, newSpaceGrid] = meshgrid(params.t_vec, params.S_vec);
    data = table2array(data);
    interpolatedData = interp2(oldTimeGrid, oldSpaceGrid, data.', newTimeGrid, newSpaceGrid, 'linear');
end