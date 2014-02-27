% create a dataset 
data = DataMaker.Circle2D(1, 100); % radius 1, 100 samples

% Construct graph from sampled data
g = Graph(data);

% Visualize harmonics as time-series
g.showHarmonics();

% TODO: Visualize harmonic value as color on nodes