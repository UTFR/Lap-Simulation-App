classdef CAR
    %CAR object with relevant car data
    %   Object meant to store and act as a quick lookup for car parameters
    %   while holding functions that only require itself to calculate.
    
    properties
        % Suspension Parameters
        
        cogheight       % Center of Gravity Height [m]
        frbb            % Brake Bias (Front) [%]
        frstwd          % Static Weight Distribution (Front) [%]
        mass            % Static Mass [kg]
        track           % Track [m]
        wb              % Wheelbase [m]
        lattcf          % Lateral Tire Coefficient of Fricition [-]
        longtcf         % Longitudinal Tire Coefficient of Friction [-]
        wr              % Wheel Radius [m]
        
        % Aerodynamic Parameters
        
        cod             % Normalized Coefficient of Drag [-]
        col             % Normalized Coefficient of Lift [-]
        fa              % Frontal Area [m^2]
        airden          % Air Density [kg/m^3]
        
        % Powertrain Parameters
        
        dreff           % Drivetrain Efficiency [%]
        gears           % Gears (individual) [1xN array]
        gearing         % Gearing (total per gear [gear*final]) [1xN array]
        sspeeds         % Car shifting speeds per gear (1xN array) [m/s]
        maxrpm          % Maximum Engine RPM [RPM]
        torquecurve     % Engine Torque Curve wrt RPM (2xN array wrt RPM) [RPM,Nm]
        
        % Vehicle Parameters
        
        maxspeed        % Maximum Engine Speed [m/s] 
        ptconfig        % Powertrain Configuration [2WD/4WD]
        pttype          % Powertrain Type [EV/IC]
        name            % Vehicle name/number
        
        % Vehicle Data        
        %Acceleration
        
        atime           % Time (1xn) [s]
        adist           % Distance (1xn) [m]
        avel            % Velocity (1xn) [m/s]
        aaccel          % Acceleration (1xn) [m/s^2]
        aforcee         % Engine Output Force (1xn) [N]
        arpm            % Current RPM [1xn] [RPM]
        agear           % Current Gear [1xn] [-]
        
        %Deceleration
        dtime           % Time (1xn) [s]
        ddist           % Distance (1xn) [m]
        dvel            % Velocity (1xn) [m/s]
        daccel          % Acceleration (1xn) [m/s^2]
        dforcef         % Front Braking Force (1xn) [N]
        dforcer         % Rear Braking Force (1xn) [N]
        drpm            % Current RPM [1xn] [RPM]
        dgear           % Current Gear [1xn] [-]

    end
    
    methods
        function obj = CAR(cogheight,frbb,frstwd,mass,track,wb,lattcf,...
                           longtcf,wr,cod_base,col_base,fa,dreff,gears,...
                           maxrpm,ptconfig,pttype,airden,torquecurve,name)
            %CAR Creation Construct an instance of this class
            obj.airden = airden;
            obj.cogheight = cogheight;
            obj.frbb = frbb;
            obj.frstwd = frstwd;
            obj.mass = mass;
            obj.track = track;
            obj.wb = wb;
            obj.lattcf = lattcf;
            obj.longtcf = longtcf;
            obj.wr = wr;
            obj.cod = 0.5*fa*airden*cod_base;
            obj.col = 0.5*fa*airden*col_base;
            obj.fa = fa;
            obj.dreff = dreff;
            obj.gears = gears;
            obj.maxrpm = maxrpm;
            obj.ptconfig = ptconfig;
            obj.pttype = pttype;
            obj.gearing = obj.gears(1:end-1)*obj.gears(end);
            obj.maxspeed = cangvel(obj.maxrpm,"rpm")*obj.wr/obj.gearing(end);
            obj.sspeeds = cangvel(obj.maxrpm,"rpm")*obj.wr./obj.gearing;
            obj.torquecurve = torquecurve;
            obj.name = name;
        end

        function obj = c_param(obj,value,inputp)
            % Identify and change a parameter for a parameter sweep
            switch value
                case 1
                    obj.mass = inputp;
                case 2
                    obj.track = inputp;
                case 3
                    obj.wb = inputp;
                case 4
                    obj.cogheight = inputp;
                case 5
                    obj.wd = inputp;
                case 6
                    obj.frbb = inputp;
                case 7
                    obj.lattcf = inputp;
                case 8
                    obj.longtcf = inputp;
                case 9 
                    obj.col = 0.5*obj.fa*obj.airden*inputp;
                case 10
                    obj.cod = 0.5*obj.fa*obj.airden*inputp;
                case 11
                    obj.gears(end) = inputp;
            end
        end
    end
end

