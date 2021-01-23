function output = cangvel(input,condition1)
%CANGVEL Summary of this function goes here
%   Detailed explanation goes here
    if condition1 == "rad/s"
        output = input*30/pi;
    elseif condition1 == "rpm"
        output = input*pi/30;
    end
end

