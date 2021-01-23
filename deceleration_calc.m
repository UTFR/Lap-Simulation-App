function car = deceleration_calc(car)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    static_mass_fr = car.mass*(car.frstwd/100);
    static_mass_r = car.mass*((100-car.frstwd)/100);
    accel = 2*9.81;
    velocity = car.maxspeed;
    i = 1;
    while velocity > 0
        F_downforce = car.col*velocity^2;
        F_drag = car.cod*velocity^2;
        weight_transfer = accel*car.mass*car.cogheight/car.wb;
        wheelrpm = cangvel(velocity/car.wr,"rad/s");
        if velocity < car.sspeeds(1)
            gear = 1;
            gear_output(i) = 1;
        elseif i == 1
            gear = 5;
            gear_output(i) = 5;
        else
            gear_index = find(car.sspeeds>velocity,1,'first');
            gear = car.gearing(gear_index);
            gear_output(i) = find(car.gearing==gear);
        end
        carrpm = wheelrpm*gear;
        carrpm_output(i) = carrpm; 
        Fnorm_front_max = 9.81*static_mass_fr + weight_transfer + F_downforce/2;
        Fnorm_rear_max = 9.81*static_mass_r - weight_transfer + F_downforce/2;
                
        Ff_front = Fnorm_front_max*car.longtcf;
        Ff_rear = Fnorm_rear_max*car.longtcf;
                
        F_app_brakes = car.mass*accel-F_drag;
        F_app_front = F_app_brakes*(car.frbb/100);
        F_app_rear = F_app_brakes*((100-car.frbb)/100);
                
        while F_app_front > Ff_front || F_app_rear > Ff_rear
            accel = accel - 0.1;
            weight_transfer = accel*car.mass*car.cogheight/car.wb;
                    
            Fnorm_front_max = 9.81*static_mass_fr + weight_transfer + F_downforce/2;
            Fnorm_rear_max = 9.81*static_mass_r - weight_transfer + F_downforce/2;
                
            Ff_front = Fnorm_front_max*car.longtcf;
            Ff_rear = Fnorm_rear_max*car.longtcf;
                
            F_app_brakes = car.mass*accel - F_drag;
            F_app_front = F_app_brakes*(car.frbb/100);
            F_app_rear = F_app_brakes*((100-car.frbb)/100);
            if accel < 0
                return
            end
        end
                
        accel_true = ((F_app_brakes + F_drag)/car.mass);
        vel_new = sqrt(velocity^2 - 2*accel_true*0.01);
        time = abs(vel_new - velocity)/accel_true;
        distance(i) = 0.01*i;
        if i == 1
            velocity_output(i) = car.maxspeed;
            time_output(i)  = 0;
        else
            time_output(i) = time_output(i-1) + time;
            velocity_output(i) = abs(vel_new);
        end
        accel_output(i) = accel_true/9.81;
        force_rear_output(i) = F_app_rear;
        force_front_output(i) = F_app_front;
        velocity = vel_new;
        i = i+1;
    end
    car.dtime = time_output;
    car.ddist = distance;
    car.dvel = velocity_output;
    car.daccel = accel_output;
    car.dforcef = force_front_output;
    car.dforcer = force_rear_output;
    car.drpm = carrpm_output;
    car.dgear = gear_output;

end

