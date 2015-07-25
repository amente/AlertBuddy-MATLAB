function [audioData,fs] = loadsample(filename)

[audioData,fs] = audioread(filename);

audioData = audioData(:,1);

%If audio data is more than 5 second , trim to the middle 5 seconds

if length(audioData) > fs*5
    numTrimSamples = length(audioData) - fs*5;
    startIndex = floor(numTrimSamples/2);
    endIndex = length(audioData) - startIndex;
    audioData = audioData(startIndex:endIndex);
end