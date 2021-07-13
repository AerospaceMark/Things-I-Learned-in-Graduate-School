path = '/Users/markanderson/Desktop/Things I Learned in Graduate School/Chapters/Computational Methods/Figures';

%% Linear Least Squares

x = -2:0.5:5;
y = x.^2 + 2.*randn(1,length(x));

scatter(x,y)
grid on
title('Sampled Data')
xlabel('X')
ylabel('Y')
box on

ax = gca;
ax.Children.MarkerFaceColor = [0 0.1797 0.3633];
ax.Children.SizeData = 50;

savePlots('SavePath',path,...
          'Titles',"Sample Linear Least Squares Data",...
          'FileTypes',"png")