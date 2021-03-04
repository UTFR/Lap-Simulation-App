function car = acceleration_calc(car)
%ACCELERATION_CALC Summary of this function goes here
%   Detailed explanation goes here

    % Initialize variables

    velocity = 0;
    accel = 0;
    min_velocity = cangvel(1000,"rpm")*car.wr/car.gearing(1);
    max_velocity = car.maxspeed;

    % Begin iterations
    i = 1;
    while (accel>=0) && (velocity < max_velocity)
        if velocity < min_velocity
            torque = car.torquecurve(1,2);
            gear = car.gearing(1);
            gear_output(i) = find(car.gearing==gear);
            carrpm_output(i) = car.torquecurve(1,1);
        else
            wheelrpm = cangvel(velocity/car.wr,"rad/s");
            gear_index = find(car.sspeeds>velocity,1,'first');
            gear = car.gearing(gear_index);
            gear_output(i) = find(car.gearing==gear);
            carrpm = wheelrpm*gear;
            carrpm_output(i) = carrpm;
            if mod(carrpm,1000) == 0
                torque_index = find(car.torquecurve(:,1),rpm);
                torque = car.torque(torque_index,2);
            else
                j = 1;
                while carrpm < car.torquecurve(j,1)
                    j = j+1;
                end
                if j == 1
                    torque = car.torquecurve(1,2);
                else
                    torque_low = car.torquecurve(j-1,2);
                    torque_high = car.torquecurve(j,2);
                    torque = ((torque_high-torque_low)/500)*(car_rpm-car.torque_curve(j-1,1))+torque_low;
                end
            end
        end
        force_e = torque*gear/car.wr;
        if velocity == 0
            weight_transfer = 0;
        else
            weight_transfer = (accel*car.mass*car.cogheight)/car.wb;
        end
        downforce = car.col*velocity^2;
        drag = car.cod*velocity^2;
        force_n = car.mass*((100-car.frstwd)/100)*9.81 + weight_transfer + downforce/2;
        force_tire_max = force_n*car.longtcf;
        if force_e > force_tire_max
            force_applied = force_tire_max;
        else
            force_applied = force_e;
        end
        accel_new = (force_applied - drag)/car.mass;
        distance(i) = 0.01*i;
        if i == 1
            velocity_output(i) = 0;
            time_output(i) = 0;
        else
            vel_final = sqrt(velocity^2 + 2*accel_new*.01);
            time_output(i) = (vel_final - velocity)/accel_new + time_output(i-1);
            velocity_output(i) = vel_final;
            velocity = vel_final;
        end
        force_e_output(i) = force_e;
        accel_output(i) = accel_new/9.81;
        i = i+1;
        accel = accel_new;
        if accel < 1e-4
            break
        end
        car.atime = time_output;
        car.adist = distance;
        car.avel = velocity_output;
        car.aaccel = accel_output;
        car.aforcee = force_e_output;
        car.arpm = carrpm_output;
        car.agear = gear_output;
    end
    if velocity >= max_velocity
        timedelta = 100/max_velocity;
        time_add = linspace(0,timedelta,10000) + car.atime(end);
        dist_add = linspace(0,100,10000) + car.adist(end);
        vel_add = zeros(1,10000)+ max_velocity;
        accel_add = zeros(1,10000);
        force_e_add = zeros(1,10000) + car.aforcee(end);
        rpm_add = zeros(1,10000) + car.arpm(end);
        gear_add = zeros(1,10000) + car.agear(end);
        
        car.atime = [car.atime,time_add];
        car.adist = [car.adist,dist_add];
        car.avel = [car.avel,vel_add];
        car.aaccel = [car.aaccel,accel_add];
        car.aforcee = [car.aforcee,force_e_add];
        car.arpm = [car.arpm,rpm_add];
        car.agear = [car.agear,gear_add];
    end
end


