% create a dataset 
data = DataMaker.Sphere(); %

% Construct graph from sampled data
g = Graph(data);

% Visualize harmonics as time-series
g.showHarmonicsVsVertex();

% Visualize harmonic value as color on nodes
for k = 1:4
    g.showHarmonics(k);
end

