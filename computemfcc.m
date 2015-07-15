function [mfcc] = computemfcc(audioData, fs)

% implemented based on dsp.stackexchange.com/questions/6499 

% divide signal into frames
windowSize = 0.03;
windowLength = fs * windowSize;
numSamples = length(audioData);

% calculate the number of samples per frame 
numFrames = floor((numSamples-1)/windowLength)+1;

% allocate memory to the frame matrix
frameData = zeros(numFrames,windowLength);

%extract the frames 
for k=1:numFrames
     startAtIdx = (k-1)*windowLength+1;
     if k~=numFrames
         frameData(k,:) = audioData(startAtIdx:startAtIdx+windowLength-1);
     else
         % handle this case separately in case the number of input samples
         % does not divide evenly by the window size
         frameData(k,1:(numSamples-startAtIdx)+1) = audioData(startAtIdx:numSamples);
     end
end

% Not implemented yet, for now this is just frame data
mfcc = frameData;