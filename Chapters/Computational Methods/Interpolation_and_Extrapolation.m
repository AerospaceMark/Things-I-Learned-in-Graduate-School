clear; close all;

usePackage GeneralSignalProcessing
plotStyle('StandardStyle','SonicBoom')
plotStyle('StandardStyle','custom','ColorScheme','MATLABDefault')

path = strcat(pwd,'/Figures');

%% Making the coarsely-sampled waveform

endTime = 1; % seconds

rng(0)
fs = 10;
dt = 1/fs;
t = 0:dt:endTime;
x = randn(length(t),1);

h = figure();
h.Position(3:4) = [5,3];
stem(t,x,'--')
title('Coarsely-sampled Function')
xlabel('Time (s)')
ylabel('Pressure (Pa)')
grid on

ax = gca;
ax.Position = [0.1, 0.15, 0.85, 0.76];

savePlots('SavePath',path,...
          'FileTypes',"png")
      
%% Performing a linear interpolation

close all

fs_2 = 100;
dt_2 = 1/fs_2;
t_2 = 0:dt_2:endTime;

methods = ["Linear","Pchip","Cubic","Makima","Spline"];

h = figure();
h.Position(3:4) = [6.5,3];
stem(t,x,'--','DisplayName','Original'); hold on

for i = 1:length(methods)
    
    x_2 = interp1(t,x,t_2,methods(i));
    plot(t_2,x_2,'LineWidth',2,'DisplayName',methods(i))
    
end

title('Interpolated Function')
xlabel('Time (s)')
ylabel('Pressure (Pa)')
grid on
hleg = legend();

hleg.Title.String = "Method";
ax = gca;
ax.Position = [0.1, 0.15, 0.69, 0.76];

savePlots('SavePath',path,...
          'FileTypes',"png")
      
%% Doing the autospectral analysis

close all

fs = 12.6e3;
time = 100; % seconds
dt = 1/fs;
t = 0:dt:time - dt;

rng(1.5)
x = randn(length(t),1);

h = figure();
h.Position(3:4) = [5,3];
plot(t,x)
grid on
title('Randomly-Distributed Gaussian Noise')
xlabel('Time (s)')
ylabel('Pressure (Pa)')
ylim([-6,6])

ax = gca;
ax.Position = [0.1, 0.15, 0.85, 0.76];

% Getting the original autospectrum
[Gxx,f,OASPL] = autospec(x,fs,'BlockSize',fs/2);
[spec,fc] = FractionalOctave(f,Gxx,[10,20e3],3);
spec = convertToDB(spec,'squared',true);
h = figure();
h.Position(3:4) = [6.0,4];
semilogx(fc,spec,'DisplayName',"Original")
hold on

fs_2 = 51.2e3;
dt_2 = 1/fs_2;
t_2 = 0:dt_2:time;

for i = 1:length(methods)
    
    x_2 = interp1(t,x,t_2,methods(i));
    
    [Gxx,f,OASPL(i+1)] = autospec(x_2,fs_2,'BlockSize',fs/2);
    [spec,fc] = FractionalOctave(f,Gxx,[10,fs_2/2],3);
    spec = convertToDB(spec,'squared',true);
    semilogx(fc,spec,'DisplayName',methods(i))
    
end

title("Interpolation Methods FFT Comparison")
xlabel("Frequency (Hz)")
ylabel("SPL (re 20\muPa)")
xlim([min(fc),max(fc)])
grid on
hleg = legend();
hleg.Title.String = "Methods";

ax = gca;
ax.Position = [0.1,0.15,0.6174,0.77];

savePlots('SavePath',path,...
          'FileTypes',"png")