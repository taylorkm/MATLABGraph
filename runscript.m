% create a dataset 
n = 100;
data = DataMaker.ClustersIn2D(n, 3);

% Construct graph from sampled data
g = Graph(data);

P = g.degreeMatrix^(-1)*g.weightMatrix;

x = rand(n,1);

figure
for k = 1:200
    x = P*x;
    plot(x,'k.')
    axis([1,n,0,1])
    pause(.001)
end

figure,plot(data(:,1),data(:,2),'o')