function mfcc_vec = mfcc(xx, fs)
% MFCC calculate mel frequency cepstrum coefficients
%  mfcc_vec = MFCC(time_waveform)

% 
nsamples = length(xx);
freq2mel = @(f) 2595*log10(1+f/700);
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

%% offset compensation (remove DC offset)
xx_nooffset = xx - mean(xx);

%% STFT
% todo - zero pad input signal?
% iterate through each frame
frame_ind = 1:frame_length;
while frame_ind(end) <= length(xx)
    xx_frame = xx(frame_ind).*hamming(frame_length);
    XX_frame = fft(xx_frame, N_fft);
    % mel transform
    
    % extract coefficients
    
    % 
    
    % update frame indices for next iteration
    frame_ind = frame_ind + frame_shift;
end

end