classdef DataMaker

    
    methods(Static)
        % Create a circle in 2-dimensions.
        function data = Circle2D(a, n)
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
        
        
        % Create cluster data in the plane
        function x = ClustersIn2D(n, k)
            % n is the number of points
            % k is the number of clusters k<=n     
            rng(10);
            nPerCluster = floor(n/k)*ones(1,k);
            nPerCluster(1:mod(n,k)) = nPerCluster(1:mod(n,k))+1;            
            x = zeros(n,2);            
            idx0 = 1;
            for j = 1:k
                o = randn(1,2); % random location for center
                x(idx0:idx0+nPerCluster(j)-1,:) = ...
                    bsxfun(@plus,o,0.6* randn(nPerCluster(j), 2));
                idx0 = idx0 + nPerCluster(j);
            end
            
            
        end
        
        
    end
end