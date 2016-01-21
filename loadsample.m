function [audioData,fs] = loadsample(filename)
% LOADSAMPLE load an audio sample file, trim to middle L seconds and resample to 16KHZ 
%  
% filename - the full path to the file to load
%

L = 1; % The length of the sample in seconds

audio = audioinfo(filename);
[audioData,fs] = audioread(filename, 'native');
audioData = audioData(:,1); % Read only one channel

%Resample all audio data to a specific sample rate
SAMPLE_RATE = 8000;
downSample = ceil(audio.SampleRate / SAMPLE_RATE);
audioData = audioData(1:downSample:audio.TotalSamples);

%audioData = resample(audioData, SAMPLE_RATE, fs);
fs = SAMPLE_RATE;

%If audio data is more than L second , trim to the middle L seconds
if length(audioData) > fs*L
    numTrimSamples = length(audioData) - fs*L;
    startIndex = floor(numTrimSamples/2);
    endIndex = startIndex + fs*L;
    audioData = audioData(startIndex:endIndex-1);
end

fs = single(fs);
