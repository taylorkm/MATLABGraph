% The graph class is the backbone of the experiments. Note that the class
% subclasses the handle class for pass-by-ref behavior.
%
% SYNTAX:
%

classdef Graph < handle 
    
    properties(Constant, GetAccess = private)
        maxNVec = 10;
        K = 3;
        sigma = 2;
    end

    properties
        data; % N-by-d data matrix of N points in R^d
        N; % Number of data points
        % Graph info in matrix form
        weightMatrix; % N-by-N sparse matrix of weights
        markovMatrix; % N-by-N sparse matrix of transition probabilities
        degreeMatrix; % N-by-N sparse diag matrix of degrees
        laplacian;
        harmonics; % N-by-K array of K harmonics, evaluated at each vertex
        spectrum;
    end
    
    methods
        % Class Constructor. Example Syntax:
        %
        %   >> g = Graph('slow', 23, 3);
        %   >> g = Graph('fast', 23, 3);
        %   >> g = Graph('fused', 23, 3);
        %   >> g = graph(data);
        function g = Graph(varargin)        
            if (~nargin) % default constructor
                g.N = 50;
                g.makeSlowGraph(1);      
            elseif ischar(varargin{1})
                if strcmpi(varargin{1},'slow')
                    g.N = varargin{2};
                    L = varargin{3};
                    g.makeSlowGraph(L);
                elseif strcmpi(varargin{1},'fast')
                    g.makeFastGraph();
                else
                    error('Unrecognized graph');
                end
            elseif ismatrix(varargin{1})
                g.makeGraphFromData(varargin{1})
            else
                error('Unrecognized initialization')
            end
            
            % At this point, the graph object has a weight matrix
            g.initArrays();
            
        end
        
        
        % Compute the graph-related matrices.
        function initArrays(g)
            g.degreeMatrix  = spdiags(sum(g.weightMatrix,2),0,g.N,g.N);
            g.markovMatrix  = g.degreeMatrix^(-1)*g.weightMatrix;
            dinvsqrt        = g.degreeMatrix.^(1/2)^(-1);
            g.laplacian     = dinvsqrt*g.weightMatrix*dinvsqrt;
            
            [g.harmonics, g.spectrum] = eigs(g.laplacian, ...
                min(g.maxNVec,g.N-1));
            g.spectrum = diag(g.spectrum);
        end
        
        
        % Make a graph from a set of data points in R^d. The input data is
        % assumed to be a n-by-d matrix.  Is there a smarter, but still
        % easy, way to symmetrize?
        function makeGraphFromData(g,data)
            g.N = size(data, 1);
            g.data = data;
            [j, dist] = knnsearch(data, data, 'K', g.K);
            i = repmat(1:g.N, g.K ,1)';
            dist = exp(- dist.^2 / g.sigma);
            g.weightMatrix = sparse(i(:), j(:), dist(:), g.N, g.N); 
            g.weightMatrix = g.weightMatrix + sparse(j(:), i(:), dist(:), g.N, g.N);
            g.weightMatrix = g.weightMatrix / 2;         
        end
                
        
        % Create a slow graph. Function is written to compute weight
        % matrices using sparse matrices... faster than actually
        % computing distances.
        function makeSlowGraph(g,L)        
            nZeros = g.N*(2*L+1)-L*(L+1); % total number of nonzeros
            idx = zeros(nZeros,2);
            cMin2 = ones(1,g.N);
            cMin2(L+1:g.N) = 1:(g.N-L);
            cMax2 = g.N*ones(1,g.N);
            cMax2(1:g.N-L) = (L+1):g.N;
            cnt = 1;
            r = 1;
            while ( r <= g.N )
                for offset = cMin2(r):cMax2(r)
                    idx(cnt,1) = r;
                    idx(cnt,2) = offset;
                    cnt = cnt+1;
                end
                r = r+1;
            end
            g.data = [];
            g.weightMatrix = sparse(idx(:,1),idx(:,2),1);
        end
        
        
        % Create a fast graph. Function is written to compute weight
        % matrices using sparse matrices... faster than actually
        % computing distances.
        function makeFastGraph(graphObj, N, p)
            disp('Making fast graph');
        end
        
        
        % For visualizing the harmonics as a function of the vertex index.
        function showHarmonics(g,a,d)
            if nargin < 2 || isempty(a)
                a = 1;
            end
            if nargin < 3 || isempty(d)
                d = 1;
            end
            figure
            nVecs = g.maxNVec;
            steps = a:d:nVecs;
            cnt = 1;
            for j = steps
                subplot(length(steps), 1, cnt)
                plot(g.harmonics(:,j))
                title(['Harmonic ',num2str(j)])
                xlim([0,g.N])
                cnt = cnt + 1;
            end
        end
        
        % Plot the graphs data points in ambient space, if applicable.
        function plotData(g)            
            if size(g.data,2)>=3
                figure
                plot(g.data(:,1), g.data(:,2), g.data(:,3), 'ko-')
            elseif size(g.data,2) == 2
                figure
                plot(g.data(:,1), g.data(:,2), 'ko-')
            else
                plot(g.data)
            end
        end
        
        % Plot the embedding of the vertices
        function showEmbedding(g)
            if size(g.data,2)>=3
                figure
                plot3(g.harmonics(:,2), g.harmonics(:,3), g.harmonics(:,4), 'o')
            elseif size(g.data,2) == 2
                figure
                plot(g.harmonics(:,2), g.harmonics(:,3), 'o')
            else
                plot(g.data)
            end           
        end
        
        
        
        function imagesc(g)
            figure
            imagesc(g.weightMatrix);
        end
    end
    
end

