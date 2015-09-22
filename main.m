Tw = 11.6;           % analysis frame duration (ms)
Ts = 5.8;           % analysis frame shift (ms)
alpha = 2;      % preemphasis coefficient
R = [ 20 12000 ];  % frequency range to consider
M = 20;            % number of filterbank channels
C = 13;            % number of cepstral coefficients
L = 22;            % cepstral sine lifter parameter

% hamming window
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));

data = dir(fullfile('training_sample','*.wav'));

for i=1:numel(data)
    [audioData, fs] = loadsample(strcat('training_sample/',data(i).name));
    % Feature extraction (feature vectors as columns)
    [ MFCCs, FBEs, frames ] =  mfcc( audioData, fs, Tw, Ts, alpha, hamming, R, M, C, L );
     
    % Plot cepstrum over time
    fig = figure('Position', [30 100 400 200], 'PaperPositionMode', 'auto', ...
        'color', 'w', 'PaperOrientation', 'landscape', 'Visible', 'on' );
    set(fig, 'Position', [400*mod(i,4) 250*ceil(i/4)-150 400 250]);
    
    imagesc( [1:size(MFCCs,2)], [0:C-1], MFCCs );
    axis( 'xy' );
    xlabel( 'Frame index' );
    ylabel( 'Cepstrum index' );
    title( strcat('Mel frequency cepstrum: ', data(i).name));
end