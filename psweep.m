function data = psweep(app,car,input1,input2,pd)
%PSWEEP sweep through parameters and collect data from it.
%   Create matrix and run sweep of all cells in matrix
    p1_list = linspace(input1(2),input1(3),input1(4));
    p2_list = linspace(input2(2),input2(3),input2(4));
    total_iter = input1(4)*input2(4);
    data = cell(input1(4),input2(4));
    count = 0;
    for i = 1:input1(4)
        car = car.c_param(input1(1),p1_list(i));
        for j = 1:input2(4)
            pd.Message = ["Calculating Iterations... ",num2str(count)+"/"+num2str(total_iter)];
            car = car.c_param(input2(1),p2_list(j));
            car = acceleration_calc(car);
            car = deceleration_calc(car);
            data(i,j) = {laptime_calc(app,car)};
            count = count+1;
        end
    end
end

