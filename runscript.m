% create a dataset of unique points on S^1
t = linspace(0,2*pi);
t = t(1:end-1);
x = cos(t);
y = sin(t);
data = [x;y]';

% Construct graph from sampled data
g = Graph(data);
