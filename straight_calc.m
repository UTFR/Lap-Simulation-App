function data = straight_calc(car,length,vel1,vel2)
%STRAIGHT_CALC Summary of this function goes here
%   Detailed explanation goes here       
    a = 1;
    b = 1;
    while car.avel(a) < vel1
        a = a+1;
    end
    while car.dvel(b) > vel2
        b = b+1;
    end

    c = a;
    d = b;
    while (car.adist(c) - car.adist(a)) + (car.ddist(b)-car.ddist(d)) < length
        if car.avel(c) < car.dvel(d)
            c = c+1;
        else
            if d == 1
                break
            else
            	d = d-1;
            end
        end
    end
    if d == 1
        while car.ddist(b)+ car.adist(c)< length
            c = c+1;
        end
    end
    if abs(car.avel(c)-car.dvel(d))>1
        data = straight_calc(car,length,vel1-0.1,vel2);
        indexes = data(4:end);
        a = indexes(1);
        c = indexes(2);
        d = indexes(3);
        b = indexes(4);
    end
    indexes = [a,c,d,b];
    time = (car.atime(c)-car.atime(a)) + (car.dtime(b)-car.dtime(d));
    data = [time,vel1,vel2,indexes];
    disp(d)
end

