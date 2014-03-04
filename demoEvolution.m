% Create domain
xrng = linspace(0,1,50);
yrng = linspace(0,1,50);
[x1,y1] = meshgrid(xrng, yrng);
isRegion = (x1<0.05 | (x1>=0.05 & y1>0.75)); 
data = [x1(isRegion), y1(isRegion)];
N = size(data,1);

% Compute pairwise distances
d = pdist2(data,data);
W = exp(-1*d.^2);
W(W<0.95) = 0;
D = diag(sum(W,2));
P = D^(-1)*W;
Q = P';

% Initial distribution zeros, all but one place
x0 = zeros(size(data,1), 1);
x0(10) = 1;

% Visualize data 
figure
nIt = 100;
for i = 1:nIt
    scatter(data(:,1),data(:,2),30,x0,'filled')
    x0 = Q*x0;
    colorbar
    axis equal
    box on
    title(['Probability at time-step ',num2str(i)])
    if (i == 1)
        pause()
    else
        pause(.001)
    end
end


