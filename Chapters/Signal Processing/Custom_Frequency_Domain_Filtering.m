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

[f,Xss,RealFFT,ImagFFT] = getSingleSidedFFT(waveform,fs);

h = figure();
h.Position(3:4) = [4,3];
loglog(f,Xss)
title('Simulated N-Wave Single-sided Spectrum')
xlabel('Frequency (Hz)')
ylabel('Pressure (Pa)')
grid on

ax = gca;
ax.Position = [0.15, 0.16, 0.75, 0.75];
ax.XTick = logspace(0,5,6);

savePlots('SavePath',path,...
          'FileTypes',"png")
      
%% Using the zero-ed out second side of the spectrum

[f,Xss,RealFFT,ImagFFT] = getSingleSidedFFT(waveform,fs);

% Substitute the second half of the spectrum for zeros
L = length(waveform);

Y = RealFFT + 1j .* ImagFFT;

Y = [Y; flip(RealFFT) - 1j * flip(ImagFFT)];

reconstructedWaveform = ifft(Y,'symmetric');

plot(t,reconstructedWaveform)

%% Taking the FFT and plotting the amplitude and phase

close all

Y = fft(waveform);
L = length(waveform);

f = fs.*linspace(0,1,L/2);

Xss = Y(1:L/2);

amplitude = abs(Xss/L);
phase = atan2(imag(Xss/L),real(Xss/L));

h = figure();
h.Position(3:4) = [6.0,3.0];
subplot(1,2,1)
loglog(f,amplitude)
title('Amplitude')
xlabel('Frequency (Hz)')
ylabel('Amplitude')
grid on
xlim([f(1),f(end)])

subplot(1,2,2)
semilogx(f,phase)
title('Phase')
xlabel('Frequency (Hz)')
grid on
xlim([f(1),f(end)])

savePlots('SavePath',path,...
          'FileTypes',"png",...
          'Titles',"Simulated N-Wave Amplitude and Phase")
      
%% Attempting to change a few of the frequencies

newAmplitude = amplitude;
newPhase = phase;

newAmplitude(1:5) = 0;
%newPhase(1:5) = 0;

a = newAmplitude ./ sec(newPhase);
b = newAmplitude .* tan(newPhase) ./ sec(newPhase);

Y2 = a + 1j .* b;
Y2 = Y2(:);
Y2 = [Y2; flip(a) - 1j .* flip(b)];

newWaveform = ifft(Y2.*L,'symmetric');

plot(newWaveform)

%% Deleting the first five frequencies

newAmplitude = amplitude;
newPhase = phase;

newAmplitude(1:5) = newAmplitude(1:5)/1000;
%newPhase(1:5) = 0;

a = newAmplitude ./ sec(newPhase);
b = newAmplitude .* tan(newPhase) ./ sec(newPhase);

Y2 = a + 1j .* b;
Y2 = Y2(:);
Y2 = [Y2; flip(a) - 1j .* flip(b)];

newWaveform = ifft(Y2.*L,'symmetric');

subplot(2,2,[1,2])
plot(t,newWaveform)
xlim([0,max(t)])
ylim([-1.2*overPressure,1.2*overPressure])
grid on
title('First Five Frequency Bins Removed')
xlabel('Time (s)')
ylabel('Pressure (Pa)')

subplot(2,2,3)
loglog(f,newAmplitude)
title('Amplitude')
xlabel('Frequency (Hz)')
ylabel('Amplitude')
grid on
xlim([f(1),f(end)])

subplot(2,2,4)
semilogx(f,newPhase)
title('Phase')
xlabel('Frequency (Hz)')
grid on
xlim([f(1),f(end)])

h = gcf;
h.Position(3:4) = [5.0,5.0];

savePlots('SavePath',path,...
          'FileTypes',"png",...
          'Titles',string(h.Children(3).Title.String))

%% Changing the phases

newAmplitude = amplitude;
newPhase = phase;

%newAmplitude(1:5) = newAmplitude(1:5)/1000;
newPhase(20:30) = 0;

a = newAmplitude ./ sec(newPhase);
b = newAmplitude .* tan(newPhase) ./ sec(newPhase);

Y2 = a + 1j .* b;
Y2 = Y2(:);
Y2 = [Y2; flip(a) - 1j .* flip(b)];

newWaveform = ifft(Y2.*L,'symmetric');

subplot(2,2,[1,2])
plot(t,newWaveform)
xlim([0,max(t)])
ylim([-1.2*overPressure,1.2*overPressure])
grid on
title('Phases Altered')
xlabel('Time (s)')
ylabel('Pressure (Pa)')

subplot(2,2,3)
loglog(f,newAmplitude)
title('Amplitude')
xlabel('Frequency (Hz)')
ylabel('Amplitude')
grid on
xlim([f(1),f(end)])

subplot(2,2,4)
semilogx(f,newPhase)
title('Phase')
xlabel('Frequency (Hz)')
grid on
xlim([f(1),f(end)])

h = gcf;
h.Position(3:4) = [5.0,5.0];

savePlots('SavePath',path,...
          'FileTypes',"png",...
          'Titles',string(h.Children(3).Title.String))