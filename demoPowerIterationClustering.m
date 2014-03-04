% create a dataset and visualize it
n = 1000;
data = DataMaker.ClustersIn2D(n, 3);
ss = get(0,'Screensize');
figure('Position',[1, ss(4)*2/3, ss(3),ss(4)*1/3])
subplot(1,3,1)
scatter(data(:,1),data(:,2),25,'filled')



% Construct graph from sampled data
pause()
g = Graph(data);
P = g.degreeMatrix^(-1)*g.weightMatrix;
x = rand(n,1);
subplot(1,3,2)
for k = 1:50
    x = P*x;
    plot(x,'k.')
    axis([1,n,min(x),max(x)])
    pause(.001)
end

pause()
subplot(1,3,3)
scatter(data(:,1),data(:,2),25,x,'filled')

disp('Spectrum:')
disp(g.spectrum)