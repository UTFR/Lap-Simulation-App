classdef RUNDATA
    %RUNDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name            % rundata name
        date            % creation date [dd-mm-yy]
        trackpoints     % xy location of each run point for plotting (2xN) [m]
        distance        % Distance (1xN) [m]
        time            % Time (1xN) [s]
        velocity        % Velocity (1xN) [m/s]
        along           % Longitudinal Acceleration (1xN) [m/s^2]
        alat            % Lateral Acceleration (1xN) [m/s^2]
        rpm             % Engine RPM (1xN)
        gear            % Current Gear (1xN)
        
    end
    
    methods
        function obj = RUNDATA(dist,time,vel,along,alat,rpm,gear)
            %RUNDATA Construct an instance of this class
            %   Detailed explanation goes here
            cd = date;
            obj.date = cd;
            obj.distance = dist;
            obj.time = time;
            obj.velocity = vel;
            obj.along = along;
            obj.alat = alat;
            obj.rpm = rpm;
            obj.gear = gear;
        end
        
        function obj = Name(obj,name)
            obj.name = name;
        end
        
        function obj = tpts(obj,pts)
            obj.trackpoints = pts;
        end
    end
end

