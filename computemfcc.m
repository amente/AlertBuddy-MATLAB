function [mfcc] = computemfcc(audioData, fs)

% implemented based on dsp.stackexchange.com/questions/6499 

% divide signal into frames
windowLength = 1024;
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
     % Use a hamming window
     rawFrame =  (frameData(k,:))';
     frameData(k,:)  = (rawFrame .* hamming(length(rawFrame)))';
end

%First convert the frame data to column vector then apply FFT to all frames
frameData = fft(frameData', windowLength);

% Plotting code
%f = fs/2*linspace(0,1,windowLength/2+1);
%plot(f,abs(frameData(1:windowLength/2+1,10)));

function m = freqTomel(f)
    m = 2595 * log10(1+f/700);
end

% Number of mel frequencies
N = 40;

melsData = zeros(N,size(frameData,2));

% Convert the frame data to mel frequencies and apply triangle bank filter
for k=1:size(frameData,2)
   frame = frameData(:,k);
   
   melFilter = zeros(N, numel(frame));
   
   maxF = max(frame);
   minF = min(frame);
   melBinWidth = (maxF - minF) / (N+1);
   
   melFreqFrame = freqTomel(frame);
   
   for i=1:N
       iMelFilter = find(melFreqFrame>=((i-1)*melBinWidth+minF) & ...
                    melFreqFrame<=((i+1)*melBinWidth+minF));
       melFilter(i,iMelFilter) = triang(numel(iMelFilter));
   end
   
   mels = log10(melFilter * frame);
   melsData(:,k) = mels;
end

% Not implemented yet, for now this is just mels data, no DCT
mfcc = melsData;

end