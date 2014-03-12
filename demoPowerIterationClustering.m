% create a dataset and visualize it
n = 1000;
data = DataMaker.ClustersIn2D(n, 3);
ss = get(0,'Screensize');
figure('Position',[1, ss(4)*2/3, ss(3),ss(4)*1/3])
subplot(1,3,1)
scatter(data(:,1),data(:,2),25,'filled')
xlabel('x')
ylabel('y')

% TODO: Add constructor to Graph, so that we can invoke it as
% g = Graph(data, 0.1, n); % passing shape parameter and number of neighbors

% Construct graph from sampled data
% pause()

f = warndlg('The original data is shown', 'Information');
drawnow     % Necessary to print the message
waitfor(f);

g = Graph(data); 
P = g.degreeMatrix^(-1)*g.weightMatrix;
x = rand(n,1);
subplot(1,3,2)
for k = 1:50
    x = P*x;
    plot(x,'k.')
    axis([1,n,min(x),max(x)])
    title(['Iterate ',num2str(k)])
    xlabel('Node idx')
    ylabel('Appx eigenvector value')
    pause(.001)
end

f = warndlg('Click OK to threshold vector values', 'Information');
get(f)
drawnow     % Necessary to print the message
waitfor(f);

subplot(1,3,3)
scatter(data(:,1),data(:,2),25,x,'filled')
title('Color represents vector value')
xlabel('x')
ylabel('y')

