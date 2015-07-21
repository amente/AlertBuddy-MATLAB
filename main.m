Tw = 25;           % analysis frame duration (ms)
Ts = 10;           % analysis frame shift (ms)
alpha = 0.97;      % preemphasis coefficient
R = [ 20 15000 ];  % frequency range to consider
M = 20;            % number of filterbank channels
C = 13;            % number of cepstral coefficients
L = 22;            % cepstral sine lifter parameter

% hamming window
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));

data = dir(fullfile('data_sample','*.wav'));

for i=1:numel(data)
    [audioData, fs] = loadsample(strcat('data_sample/',data(i).name));
    % Feature extraction (feature vectors as columns)
    [ MFCCs, FBEs, frames ] =  mfcc( audioData, fs, Tw, Ts, alpha, hamming, R, M, C, L );
    % Plot cepstrum over time
    figure('Position', [30 100 400 200], 'PaperPositionMode', 'auto', ...
        'color', 'w', 'PaperOrientation', 'landscape', 'Visible', 'on' );
    
    imagesc( [1:size(MFCCs,2)], [0:C-1], MFCCs );
    axis( 'xy' );
    xlabel( 'Frame index' );
    ylabel( 'Cepstrum index' );
    title( strcat('Mel frequency cepstrum: ', data(i).name));
end