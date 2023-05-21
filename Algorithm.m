close all; clear; clc;
% load the file
[x, fs] = audioread('Random_Signal.wav');

% Step 1: Signal Pre-Processing
% Apply a digital filter to remove noise
b = fir1(50, 0.5);
y = filter(b, 1, x);

% Apply a moving average filter to smooth the signal
z = smoothdata(y, 'movmean', 100);

% Normalize the signal to the range [-1, 1]
z_norm = normalize(z, 'range', [-1 1]);

% Step 2: Frame segmentaion
% Set the frame length and frame shift in samples
frame_length = round(fs * 0.025); % 25 milliseconds
frame_shift = round(fs * 0.01); % 10 milliseconds

% Divide the signal into frames
frames = buffer(z_norm, frame_length, frame_length - frame_shift, 'nodelay');

% Step 3: Windowing
% Apply a Hamming window to each frame
win = hamming(frame_length);
frames_win = frames .* repmat(win, 1, size(frames, 2));

% Step 4: fft 
% Compute the FFT of each frame and take the squared magnitude
nfft = 2^nextpow2(frame_length);
frames_fft = abs(fft(frames_win, nfft)).^2;
half_nfft = nfft/2+1;
% Plot the power spectrum of the first frame
f = linspace(0, fs/2, half_nfft);

% Step 5: Logarithmic Scalling
frames_log_fft = log10(frames_fft);

% Step 6: IFFT & Cpestral plot

% Compute the cepstrum by applying the inverse FFT to the log magnitude spectrum
cepstrum = real(ifft(frames_log_fft));

% Choose a frame index to plot (e.g., frame 10)
frame_idx = 100;

% Extract the desired frame from the matrix of log magnitude spectra
Extracted_frame_log_fft = frames_fft(:, frame_idx);

% Extract the desired frame from the matrix of cepstra
Extracted_frame_cepstrum = cepstrum(:, frame_idx);

t = linspace(0, frame_length/fs, frame_length);

% Plot the cepstrum of each frame
figure
imagesc(1:size(cepstrum, 2), t, cepstrum(1:frame_length, :))
axis xy
xlabel('Frame index')
ylabel('Time (seconds)')
colorbar

figure
plot(f, Extracted_frame_log_fft(1:half_nfft))
xlabel('Frequency (Hz)')
ylabel('Log magnitude spectrum')
title(sprintf('Log magnitude spectrum of frame %d', frame_idx))

figure
plot(t, Extracted_frame_cepstrum(1:frame_length))
xlabel('Time (seconds)')
ylabel('Cepstrum')
title(sprintf('Cepstrum of frame %d', frame_idx))