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
      
%% Normalizing the real part

close all

L = length(waveform);
Xds = abs(Y./L);

h = figure();
plot(f,Xds)
title('Normalized Double-sided Spectrum')
xlabel('Frequency (Hz)')
ylabel('Amplitude')
grid on

h.Position = [2,2,4,3];

ax = gca;
ax.Position = [0.12, 0.15, 0.80, 0.75];

savePlots('SavePath',path,...
          'FileTypes',"png")
      
%% Making the single-sided version

close all

Xss = Xds(1:L/2) .* 2;
f = f(1:L/2);

h = figure();
plot(f,Xss);
title('Normalized Single-sided Spectrum')
xlabel('Frequency (Hz)')
ylabel('Amplitude')
grid on

h.Position = [2,2,4,3];

ax = gca;
ax.Position = [0.12, 0.15, 0.80, 0.75];

savePlots('SavePath',path,...
          'FileTypes',"png")
      
%% Using a higher sampling frequency

fs = 1000;
dt = 1/fs;
t = 0:dt:2;

waveform = 3.0.*sin(2*pi*f1*t) + 5.0.*sin(2*pi*f2*t) + randn(1,length(t));

Y = fft(waveform);
f = fs .* linspace(0,1,length(waveform));

L = length(waveform);
Xds = abs(Y./L);

Xss = Xds(1:L/2) .* 2;
f = f(1:L/2);

h = figure();
plot(f,Xss);
title('Using a Higher Sampling Frequency')
xlabel('Frequency (Hz)')
ylabel('Amplitude')
grid on

h.Position = [2,2,4,3];

ax = gca;
ax.Position = [0.12, 0.15, 0.80, 0.75];
ax.XLim = [0,50];

savePlots('SavePath',path,...
          'FileTypes',"png")
      
%% Using different recording lengths

fs = 100;
dt = 1/fs;

lengths = [0.5,2.0,100];

h = figure();
h.Position = [2,2,6,3];
tiles = tiledlayout(1,3);

for i = 1:3
    
    nexttile
    
    t = 0:dt:lengths(i);

    waveform = 3.0.*sin(2*pi*f1*t) + 5.0.*sin(2*pi*f2*t) + randn(1,length(t));

    Y = fft(waveform);
    f = fs .* linspace(0,1,length(waveform));

    L = length(waveform);
    Xds = abs(Y./L);

    Xss = Xds(1:L/2) .* 2;
    f = f(1:L/2);

    plot(f,Xss);
    title(strcat(num2str(lengths(i))," s"))
    xlabel('Frequency (Hz)')
    ylim([0,5.5])
    
    if i == 1
        ylabel('Amplitude')
    end
    grid on

%     ax = gca;
%     ax.Position = [0.12, 0.15, 0.80, 0.75];
%     ax.XLim = [0,50];
    
end

tiles.Title.String = "Adjusting the Recording Length";
tiles.Title.FontWeight = 'bold';
tiles.Title.FontName = 'arial';

savePlots('SavePath',path,...
          'FileTypes',"png",...
          'Titles',"Adjusting the Recording Length")