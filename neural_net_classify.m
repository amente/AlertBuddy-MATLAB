function [ type ] = neural_net_classify( audioData, fs)
%NEURAL_NET_CLASSIFY Classifies an audio data using the neural net
%       audioData: The audio data  
%       fs: The sample rate
   
    MFCCs = extract_mfcc(audioData, fs);
    %Ignore the first MFCC value
    inputMatrix = MFCCs(2:end,:);
    result = neural_net(inputMatrix);
    
    k = sum(result');
    if(max(k) == k(1))
        type = 1;
    else
        type = 2;
end

