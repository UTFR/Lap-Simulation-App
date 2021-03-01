classdef TRACK
    %TRACK Summary of this class goes here
    %   Detailed explanation goes here
    
    % Track parameters
    % Tracklength and trackradius: parallel lists.
    properties
        name % Name of the track
        trackradius % array of radiuses
        tracklength % array of lengths
    end
    
    methods
        function obj = TRACK(Tname, Tradius,Tlength)
            %TRACK Construct an instance of this class
            %   Detailed explanation goes here
            obj.name = Tname;
            obj.trackradius = Tradius;
            obj.tracklength = Tlength;
        end
    end
end

