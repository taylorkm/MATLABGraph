classdef DataMaker

    
    methods
        % Create a circle in 2-dimensions.
        function data = Circle2D(dm, a, n)
            if nargin < 1 || isempty (a)
                a = 1;
            end
            if nargin < 2 || isempty (n)
                n = 100;
            end            
            t = linspace(0,2*pi,n);
            t = t(1:end-1);
            x = a*cos(t);
            y = a*sin(t);
            data = [x;y]';
        end
        
        % Create a torus
        
        % Create a swiss-roll
        
        
    end
end