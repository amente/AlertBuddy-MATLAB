Tw = 11.6;           % analysis frame duration (ms)
Ts = 5.8;           % analysis frame shift (ms)
alpha = 2;      % preemphasis coefficient
R = [ 20 12000 ];  % frequency range to consider
M = 20;            % number of filterbank channels
C = 13;            % number of cepstral coefficients
L = 22;            % cepstral sine lifter parameter

% hamming window
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));

data = dir(fullfile('tmp','*.wav'));

for i=1:numel(data)
    [audioData, fs] = loadsample(strcat('tmp/',data(i).name));
    % Feature extraction (feature vectors as columns)
    [ MFCCs, FBEs, frames ] =  mfcc( audioData, fs, Tw, Ts, alpha, hamming, R, M, C, L );
     
    % Plot cepstrum over time
    fig = figure(i);
    set(fig,'PaperPositionMode', 'auto', ...
        'color', 'w', 'PaperOrientation', 'landscape', 'Visible', 'on' );
    set(fig, 'Position', [400*mod(i,4) 250*ceil(i/4)-150 400 250]);
    
    surf(30 + MFCCs);
    xlim([0 C-1]);
    hold on
    imagesc( [1:size(MFCCs,2)], [0:C-1], MFCCs );
    colorbar
    axis( 'xy' );
    xlabel( 'Frame index' );
    ylabel( 'Cepstrum index' );
    title( strcat('Mel frequency cepstrum: ', data(i).name));
    
     [~, filename, etx] = fileparts(data(i).name);
    filename = strcat('cepstrum_plots/', filename);
%     print(fig, filename, '-dpng') % full size
    saveas(fig, filename, 'bmp') % size as shown by plot
    %close(fig);
end