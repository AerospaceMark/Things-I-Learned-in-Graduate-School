clear; close all;

usePackage GeneralSignalProcessing
usePackage SonicBoomAnalysis

plotStyle('StandardStyle','SonicBoom')

path = strcat(pwd,'/Figures');

%% Making the waveform

close all

% Let's create a simulated N-wave
overPressure = 50;
time = 0.2;
recordLength = 0.650;
fs = 51.2e3;

[waveform,t] = simulateBoom(overPressure,time,recordLength,fs);

h = figure();
plot(t,waveform)
xlim([0,max(t)])
ylim([-1.2*overPressure,1.2*overPressure])
grid on
title('Simulated N-Wave')
xlabel('Time (s)')
ylabel('Pressure (Pa)')

h.Position(3:4) = [5.0,2];

ax = gca;
ax.Position = [0.12, 0.21, 0.80, 0.65];
ax.YTick = -50:25:50;

savePlots('SavePath',path,...
          'FileTypes',"png")
      
%% Doing the FFT

close all

X = fft(waveform);
f = fs*(0:length(X))/length(X);