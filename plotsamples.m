clc
clear


data = dir(fullfile('training_sample','*.wav'));

playsound = @(source,cbdata) (sound(source.UserData.data, source.UserData.fs));

fprintf('%d\n', numel(data))

for i=1:numel(data)
% for i=1:1
    [audioData, fs] = loadsample(strcat('training_sample/',data(i).name));
     
    fig = figure(i);
    set(fig, 'Position', [300*mod(i,6) 400*ceil(i/6)-350 300 350]);
    subplot(2,1,1)
    plot(audioData)
    title(data(i).name);
    xlabel('sample_index');
    ylabel('mag signal');
    
    subplot(2,1,2)
    plot(abs(fft(audioData)))
    title(data(i).name);
    xlabel('frequency');
    ylabel('mag spectrum');
    
    [~, filename, etx] = fileparts(data(i).name);
    filename = strcat('plots/', filename);
%     print(fig, filename, '-dpng') % full size
    saveas(fig, filename, 'bmp') % size as shown by plot
    
    pbData = struct;
    pbData.data = audioData;
    pbData.fs = fs;
    
    play_btn = uicontrol('Style', 'pushbutton', 'String', 'Play',...
        'Position', [20 20 50 20],...
        'Callback', playsound, 'UserData',pbData);
    
    close(fig) % close current plot so computer is not bombarded with them
end

