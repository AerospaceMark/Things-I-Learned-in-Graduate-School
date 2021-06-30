clear; close all;

usePackage GeneralSignalProcessing
plotStyle('StandardStyle','SonicBoom')

path = strcat(pwd,'/Figures');

%% Creating a waveform with noise in it

close all

f1 = 9; % Hz
f2 = 33; % Hz

fs = 100;
dt = 1/fs;
t = 0:dt:2;

rng(1.2); % Setting the random number generator seed
waveform = 3.0.*sin(2*pi*f1*t) + 5.0.*sin(2*pi*f2*t) + randn(1,length(t));

h = figure();
plot(t,waveform)
title('Sample Waveform')
xlabel('Time (s)')
ylabel('Amplitude')
grid on

h.Position(3:4) = [6.0,3.0];

ax = gca;
ax.Position = [0.12, 0.15, 0.80, 0.75];

savePlots('SavePath',path,...
          'FileTypes',"png")

%% Calculating the FFT

close all

Y = fft(waveform);
f = fs .* linspace(0,1,length(waveform));

h = figure();
subplot(1,2,1)
plot(f,real(Y))
title('Raw Real Part')
xlabel('Frequency (Hz)')
ylabel('Amplitude')
grid on

ax = gca;
ax.XTick = 0:20:100;

subplot(1,2,2)
plot(f,imag(Y))
title('Raw Imaginary Part')
xlabel('Frequency (Hz)')
ylabel('Amplitude')
grid on

ax = gca;
ax.XTick = 0:20:100;

h.Position(3:4) = [6.0,3.0];

savePlots('SavePath',path,...
          'FileTypes',"png",...
          'Titles',"Raw FFT Output")