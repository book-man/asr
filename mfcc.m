function all_mfccs = mfcc(varargin)
% MFCC calculate mel frequency cepstrum coefficients
%  mfcc_vec = MFCC(xx, fs)
%  mfcc_vec = MFCC(xx, fs, params_struct)

% helper functions
freq2mel = @(f) 1125.*log(1+f./700);
mel2freq = @(m) 700.*(exp(m./1125)-1);

% get inputs
switch nargin
    case 2
        xx = varargin{1};
        fs = varargin{2};
        % default parameters
        params.n_filterbank_freqs = 26;
        params.min_filterbank_freq = 300; % Hz
        params.max_filterbank_freq = min(8000, fs/2); % Hz
    case 3
        xx = varargin{1};
        fs = varargin{2};
        params = varargin{3};
    otherwise
        error('Invalid number arguments');
end

%% set parameters based on 
% parameters from ETSI ES 201 108 v1.1.3
switch fs
    case 8e3
        frame_length = 200;
        frame_shift = 80;
        N_fft = 256;
    case 11e3
        frame_length = 256;
        frame_shift = 110;
        N_fft = 256;
    case 16e3
        frame_length = 400;
        frame_shift = 160;
        N_fft = 512;
    otherwise
        error('fs must be 8, 11, or 16 kHz');
end

% make the filterbank
filterbank_mels = linspace(freq2mel(params.min_filterbank_freq), ...
    freq2mel(params.max_filterbank_freq), params.n_filterbank_freqs); % Hz
filterbank_freqs = mel2freq(filterbank_mels);
filterbank_bounds = cell(params.n_filterbank_freqs, 1);
filterbank = zeros(params.n_filterbank_freqs, N_fft);
filterbank_freqs = [0 filterbank_freqs];
hz2fftbin = @(ff) round(ff ./ (fs/2) .* (N_fft/2));
fftbin2hz = @(bb) round(bb .* (fs/2) ./ (N_fft/2));
for i = 2:params.n_filterbank_freqs
    % get bounds for this triangular filter in Hz
    filterbank_bounds{i-1} = [filterbank_freqs(i-1) filterbank_freqs(i) filterbank_freqs(i+1)];
    left_side = interp1( ...
        [filterbank_freqs(i-1) filterbank_freqs(i)], [0 1], fftbin2hz(1:N_fft));
    right_side = interp1( ...
        [filterbank_freqs(i), filterbank_freqs(i+1)], [1 0], fftbin2hz(1:N_fft));
    left_side(isnan(left_side)) = 0; right_side(isnan(right_side)) = 0;
    filterbank(i-1, :) = max([left_side; right_side]);
end
% plot filterbank (for debug)
clf; hold all; grid on;
xlabel('FFT bin'); ylabel('Mag');
title('MFCC Extraction Filterbank');
plot(filterbank.');

%% offset compensation (remove DC offset)
xx_nooffset = xx - mean(xx);

%% STFT
% todo - zero pad input signal
% iterate through each frame
frame_ind = 1:frame_length;
all_mfccs = {};
while frame_ind(end) <= length(xx)
    % get current frame
    xx_frame = xx(frame_ind).*hamming(frame_length);
    XX_frame = fft(xx_frame, N_fft);
    psd_frame = 0.5*abs(XX_frame).^2; % power spectrum
    % apply filterbank
    mfccs = filterbank*psd_frame;
    all_mfccs{end+1} = mfccs;
    % update frame indices for next iteration
    frame_ind = frame_ind + frame_shift;
end

end