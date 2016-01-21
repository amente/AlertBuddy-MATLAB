% This script outputs 3D plots of MFCC features for audio samples in 'tmp'
% directory
data = dir(fullfile('training_data/siren','*.wav'));
C = 12;
for i=1:numel(data)
    [audioData, fs] = loadsample(strcat('training_data/siren/',data(i).name));
    % Feature extraction (feature vectors as columns)
    MFCCs = extract_mfcc(audioData, fs);
     
    % Plot cepstrum over time
    fig = figure(i);
    set(fig,'PaperPositionMode', 'auto', ...
        'color', 'w', 'PaperOrientation', 'landscape', 'Visible', 'on' );
    set(fig, 'Position', [400*mod(i,4) 250*ceil(i/4)-150 400 250]);
    
   % surf(30 + MFCCs);
   figure('Position', [30 100 400 200], 'PaperPositionMode', 'auto', ...
        'color', 'w', 'PaperOrientation', 'landscape', 'Visible', 'on' );
    
    imagesc( [1:size(MFCCs,2)], [0:C-1], MFCCs );
    colorbar
    axis( 'xy' );
    xlabel( 'Frame index' );
    ylabel( 'Cepstrum index' );
    title( strcat('MFCC: ', data(i).name));
%     print(fig, filename, '-dpng') % full size
  %  saveas(fig, filename, 'bmp') % size as shown by plot
    %close(fig);
end