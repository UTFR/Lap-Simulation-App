final = zeros(41,2);
c = 1;
s = 1;
for i = 1:41
    if rem(i,2) ~= 0
        final(i,:) = [Data_Corner(c,2),Data_Corner(c,1)];
        c = c + 1;
    else
        final(i,:) = [Data_Straight(s,1),0];
        s = s+1;
    end
        
end