function [audioData,fs] = loadsample(filename)

[audioData,fs] = audioread(filename);

audioData = audioData(:,1);

%If audio data is more than 5 second , trim to the middle 5 seconds

%Resample all audio data to a specific sample rate
SAMPLE_RATE = 16000;
audioData = resample(audioData, SAMPLE_RATE, fs);
fs = SAMPLE_RATE;

if length(audioData) > fs*4
    numTrimSamples = length(audioData) - fs*4;
    startIndex = floor(numTrimSamples/2);
    endIndex = length(audioData) - startIndex;
    audioData = audioData(startIndex:endIndex);
end