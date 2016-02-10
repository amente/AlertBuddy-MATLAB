function [ MFCCs ] = extract_mfcc_8000( audioData)
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here
    %EXTRACT_MFCC Extract MFCC features
%   audioData - The sample audio data
%   fs - The sample rate

    fs = single(8000);
    %% PARAMETERS
    Tw = 16;           % analysis frame duration (ms)
    Ts = 8;           % analysis frame shift (ms)   
    C = 13;            % number of cepstral coefficients
    L = 22;            % cepstral sine lifter parameter

    %% PRELIMINARIES 
      
    Nw = round( 1E-3*Tw*fs );    % frame duration (samples)
    Ns = round( 1E-3*Ts*fs );    % frame shift (samples) 
       
    %% FEATURE EXTRACTION 
    Len = length( audioData );                  % length of the input vector
    Mat = floor((Len-Nw)/Ns+1);             % number of frames        
    
    CC3 = single(zeros(C, Mat));
    for j=1: Mat
        CC3(:,j) = extract_mfcc_frame(single(audioData(((j-1)*64)+1 : (j-1)*64+Nw)));
    end
    
   
    % Cepstral liftering gives liftered cepstral coefficients
    for cc_k = 1 : size(CC3,2)
         for i = 0:C-1
            CC3(i+1,cc_k) = (1+0.5*L*sin(pi*i/L)) * CC3(i+1,cc_k);
         end
    end
    
    MFCCs = CC3;    

end

