% This script outputs 3D plots of MFCC features for audio samples in 'tmp'
% directory
data = dir(fullfile('tmp','*.wav'));

for i=1:numel(data)
    [audioData, fs] = loadsample(strcat('tmp/',data(i).name));
    % Feature extraction (feature vectors as columns)
    MFCCs = extract_mfcc(audioData, fs);
     
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