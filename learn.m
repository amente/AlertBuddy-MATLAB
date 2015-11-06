% learn.m 
% This script loads training audio samples and learns features 

% The features are the locations of peak frequencies from the audio sample
% First the magnitude of the FFT output is normalized and
% then peaks of values above adjustable threshold (T) are detected

% The output is saved to the workspace with the same name as the audio file

clc
clear
plotData = false;

SAMPLES_FOLDER = 'training';
N = 1024; %Number of FFT points
T = 0.5; %Threshold for peak cutoff to normalized magnitude response


data = dir(fullfile(SAMPLES_FOLDER,'*.wav'));
for i=1:numel(data)
    
    %Load the data
    dataName = data(i).name;
    [audioData, fs] = loadsample(strcat(SAMPLES_FOLDER,'/',dataName));
    
    %Calculate the FFT magnitude response and adjust for frequency in HZ
    x = abs(fftshift(fft(audioData,N)))/N;
    df = fs/N;
    x = x(N/2:end-1);
    f = 0:df:fs/2-df;
     
    %Normalize the magnitude response
    minX = min(x);
    maxX = max(x);
    x = (x - minX) / ( maxX - minX);
    
    %Detect the peaks and their respective locations
    [peaks, locs] = findpeaks(x,'MinPeakHeight', T);
    
    %Denormalize the peak values and adjust the locations to frequency in HZ 
    peaks = (maxX - minX)*peaks + minX;
    locs = df*locs;
    
    %Save the features in the workspace
    save(fullfile(pwd, 'features', strcat(dataName,'.mat')),'peaks','locs');
    
    if plotData
        %Plot the FFT
        fig = figure(i);
        plot(f,x);
        grid on
        grid minor
        title(dataName);
        xlabel('Frequency (in Hz)');
        ylabel('Magnitude Response (Normalized)');
    end
    
end

