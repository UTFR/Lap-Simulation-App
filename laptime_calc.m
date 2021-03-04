function rundata = laptime_calc(app,car)
%LAPTIME_CALC Summary of this function goes here
%   Detailed explanation goes here
 % Index corners and straights by radius data
    corners = find(app.TrackTable.Data(:,2))';
    straights = find(~app.TrackTable.Data(:,2))';
  
    % Prep data variables
    cornerdata = zeros(length(app.TrackTable.Data(:,2)),3,"double");
    straightdata = zeros(length(app.TrackTable.Data(:,2)),7,"double");
            
    % Calculate each corner max velocity
    for i = corners
         [a,b,c] = corner_calc(car,app.TrackTable.Data(i,2),app.TrackTable.Data(i,1));
         cornerdata(i,:) = [a,b,c];
    end
    corner_speeds = cornerdata(:,2);
            
    % Calculate each straight min. time
    for j = straights
        if j == 1
            data = straight_calc(car,app.TrackTable.Data(j,1),corner_speeds(end),corner_speeds(j+1));
            if data(2) ~= corner_speeds(end)
                adj_time = data(2)/app.TrackTrable.Data(end,1);
                cornerdata(end) = [adj_time,data(2)];
            end
        else
            data = straight_calc(car,app.TrackTable.Data(j,1),corner_speeds(j-1),corner_speeds(j+1));
            if data(2) ~= corner_speeds(j-1)
                adj_time = data(2)/app.TrackTrable.Data(j-1,1);
                cornerdata(j-1) = [adj_time,data(2)];
            end
        end
        straightdata(j,:) = data;
    end
    % Add data to laptime datastruct
    for z = 1:length(app.TrackTable.Data(:,1))
        if app.TrackTable.Data(z,2) == 0
            if z == 1
                lindex = straightdata(z,5)-straightdata(z,4)+straightdata(z,7)-straightdata(z,6);
            else
                lindex = lindex + straightdata(z,5)-straightdata(z,4)+straightdata(z,7)-straightdata(z,6);
            end
        else
            lindex = lindex + round(app.TrackTable.Data(z,1)/0.01);
        end
    end
    distdata = zeros(1,lindex);
    timedata = zeros(1,lindex);
    veldata = zeros(1,lindex);
    alongdata = zeros(1,lindex);
    alatdata = zeros(1,lindex);
    rpmdata = zeros(1,lindex);
    geardata = zeros(1,lindex);
     
    tindex = 1;
    for k = 1:length(app.TrackTable.Data(:,1))
        % Use indices taken from straight calcs
        aindex = [straightdata(k,4):straightdata(k,5)];
        aindexdelta = aindex(end)-aindex(1)+1;
        dindex = [straightdata(k,6):straightdata(k,7)];
        dindexdelta = dindex(end)-dindex(1)+1;
        totindexdelta = aindexdelta+dindexdelta;
        if k == 1
            % add accel and decel data
            distdata(1:aindexdelta) = car.adist(aindex)-car.adist(aindex(1));
            distdata(aindexdelta+1:totindexdelta) = (car.ddist(dindex)-car.ddist(dindex(1)))+distdata(aindexdelta);
            timedata(1:aindexdelta) = car.atime(aindex)-car.atime(aindex(1));
            timedata(aindexdelta+1:totindexdelta) = (car.dtime(dindex)-car.dtime(dindex(1)))+timedata(aindexdelta);
            veldata(1:totindexdelta) = [car.avel(aindex),car.dvel(dindex)];
            alongdata(1:totindexdelta) = [car.aaccel(aindex),car.daccel(dindex)];
            alatdata(1:totindexdelta) = zeros(totindexdelta,1);
            rpmdata(1:totindexdelta) = [car.arpm(aindex),car.drpm(dindex)];
            geardata(1:totindexdelta) = [car.agear(aindex),car.dgear(dindex)];
            tindex = totindexdelta;
        else
            if app.TrackTable.Data(k,2) == 0
                tindex = tindex+1;
                tindexnew = tindex + totindexdelta-1;
                distdata(tindex:tindex+aindexdelta-1) = (car.adist(aindex)-car.adist(aindex(1))) + distdata(tindex-1);
                distdata(tindex+aindexdelta:tindexnew) = (car.ddist(dindex)-car.ddist(dindex(1))) + distdata(tindex+aindexdelta-1);
                timedata(tindex:tindex+aindexdelta-1) = (car.atime(aindex)-car.atime(aindex(1))) + timedata(tindex-1);
                timedata(tindex+aindexdelta:tindexnew) = (car.dtime(dindex)-car.dtime(dindex(1))) + timedata(tindex+aindexdelta-1);
                veldata(tindex:tindexnew) = [car.avel(aindex),car.dvel(dindex)];
                alongdata(tindex:tindexnew) = [car.aaccel(aindex),car.daccel(dindex)];
                alatdata(tindex:tindexnew) = zeros(totindexdelta,1);
                rpmdata(tindex:tindexnew) = [car.arpm(aindex),car.drpm(dindex)];
                geardata(tindex:tindexnew) = [car.agear(aindex),car.dgear(dindex)];
                tindex = tindexnew;
            else
                % Add datapoints for corners
                tindex = tindex+1;
                cindex_a = round(app.TrackTable.Data(k,1)/0.01);
                ddist = zeros(cindex_a,1);
                Dtime = zeros(cindex_a,1);
                dtime = 0.01/cornerdata(k,2);
                dvel = zeros(cindex_a,1) + cornerdata(k,2);
                dacc = zeros(cindex_a,1) + cornerdata(k,3);
                for l = 1:length(ddist)
                    ddist(l) = l*0.01;
                    Dtime(l) = l*dtime;
                end
                tindexnew = tindex + cindex_a-1;
                distdata(tindex:tindexnew) = ddist + distdata(tindex-1);
                timedata(tindex:tindexnew) = Dtime + timedata(tindex-1);
                veldata(tindex:tindexnew) = dvel;
                alongdata(tindex:tindexnew) = zeros(cindex_a,1);
                alatdata(tindex:tindexnew) = dacc;
                geardata(tindex:tindexnew) = geardata(tindex-1);
                rpmdata(tindex:tindexnew) = rpmdata(tindex-1);
                tindex = tindexnew;
            end
        end
    end
    rundata = RUNDATA(distdata',timedata',veldata',alongdata',alatdata',rpmdata',geardata');
    
end

