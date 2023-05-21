close all; clear; clc;
% Generate a harmonic signal composed of sine and cosine waves
Fs = 44100; % sampling frequency
t = 0:1/Fs:60; % time vector
y = sin(2*pi*440*t) + 0.5*cos(2*pi*880*t); % sum of sine and cosine waves

figure;
plot(t, y);
title('Harmonic Signal Composed of Sine and Cosine Waves');
xlabel('Time (s)');
ylabel('Amplitude');

% Save the harmonic signal as a WAV file
audiowrite('Harmonic_Signal.wav', y, Fs);

% Generate a random signal
Fs = 44100; % sampling frequency
n = Fs*60; % number of samples for a duration of 1 minute
x = randn(n, 1); % Gaussian white noise signal

figure;
plot(x);
title('Random Signal');
xlabel('Sample Number');
ylabel('Amplitude');

% Save the random signal as a WAV file
audiowrite('Random_Signal.wav', x, Fs);
