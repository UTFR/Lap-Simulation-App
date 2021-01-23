function [time,velocity,accel] = corner_calc(car,radius,corner_length)
    %CORNER_CALC Calculation of maximum corner velocity
    %       determine maximum lateral force tires can produce.
    %       radius, corner length in m.
    %       velocity in m/s
    %       time in s.
            
    % Initialize Acceleration, Error
    acceleration_new = 1;
    error = 1;
     
    while error > 0.001
        acceleration = acceleration_new;
        velocity = (acceleration*radius)^0.5; 
        if velocity > car.maxspeed
            velocity = car.maxspeed;
            break
        else
            downforce = car.col*velocity^2;
            lateral_force = (car.mass*9.81 + downforce)*car.lattcf;
            acceleration_new = lateral_force/car.mass;
            error = abs(acceleration_new - acceleration);
        end
    end
    if velocity == car.maxspeed
        time = corner_length/velocity;              % Final time
        accel = acceleration_new;                   % Final Accel
    else
        velocity = (acceleration_new*radius)^0.5;   % Final velocity
        time = corner_length/velocity;              % Final time
        accel = acceleration_new;                   % Final Accel
    end
end

