function [ type ] = classify( fileName )
%CLASSIFY :- Given an audio file it classifyies it to a given type
%   fileName - The name of the audio file
%   type - The classification type, it assumes there is one feature file
%   per each type

FEATURES_FOLDER = 'features';
W = 100; %This is the tolerance for frequency peaks in HZ.
H = 0.3; % Percentage tolerance for peak magnitude
O = 10; %Order of the ButterWorth filter
N = 1024; %The number of FFT points
T = 0.5; %Threshold for peak cutoff to normalized magnitude response

%Load the audio sample
[audioData, fs] = loadsample(fileName);

%Load the features
features = dir(fullfile(FEATURES_FOLDER,'*.mat'));
for i=1:numel(features)
     
     %Load the features
     featureName = features(i).name
     load(strcat(FEATURES_FOLDER,'/',featureName), 'peaks', 'locs');
    
     numPeaks = 0;
     %Count the number of detected peaks
     for j=1:numel(locs)
         F = locs(j);
         FL = F-W;
         FH = F+W;
         
       
         %Calculate the FFT magnitude response and adjust for frequency in HZ
         x = abs(fftshift(fft(audioData,N)))/N;
         df = fs/N;
         x = x(N/2:end-1);
         
         %Filter the data arroud the peak
         for r=1: numel(x)
            if(r < FL/df && r > FH/df)
                x(r) = 0;
            end
         end
        
         %Normalize the magnitude response
         minX = min(x);
         maxX = max(x);
         x = (x - minX) / ( maxX - minX);

         %Detect if there are peaks and their location
         [p, l] = findpeaks(x,'MinPeakHeight', T);
         
         %Denormalize the peak values and adjust the locations to frequency in HZ 
         p = (maxX - minX)*p + minX
         l = df*l
         
         peaks
         locs
         
         if(numel(l) > 0)
            for k=1: numel(l)
                if(l(k)>= FL && l(k) <= FH)
                   numPeaks = numPeaks+1
                end
            end
         end
     end
     
     %Check if all peaks have been detected
     if(numPeaks >= numel(locs))
         type = featureName;
         return;
     end   
end

type = 'Uknown';

end

