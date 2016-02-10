function [ CCs ] = extract_mfcc_frame(audioFrame)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    fs = single(8000);
    %% PARAMETERS
    Tw = 16;           % analysis frame duration (ms)   
    alpha = 0.97;      % preemphasis coefficient   
    M = 20;            % number of filterbank channels
    C = 13;            % number of cepstral coefficients
 
    %% PRELIMINARIES 
      
    Nw = round( 1E-3*Tw*fs );    % frame duration (samples)
    nfft = 2^nextpow2( Nw );     % length of FFT analysis 
    K = nfft/2+1;                % length of the unique part of the FFT 
     
    %% FEATURE EXTRACTION      
    S =coder.load('H', 'H');    
    % DCT matrix computation
    DCT =  single(sqrt(2.0/M) * cos( repmat([0:C-1].',1,M).* repmat(pi*([1:M]-0.5)/M,C,1) )); 
    
    currentFrame = single(audioFrame); 
    CCs = single(zeros(C, 1));        
    custom_filter(-1*alpha, currentFrame);
    for i = 0:Nw-1
        currentFrame(i+1) = (0.54-0.46*cos(2*pi*i)/(Nw-1)) * currentFrame(i+1);
    end 
    currentFrame = abs(fft(currentFrame,nfft, 1)); 

    for i=1:C
       for l=1 : M
            r = single(0);
            for k=1: K
                r = r + S.H(l,k)*currentFrame(k);
            end
            if(r > 1.0)
                CCs(i,1) = CCs(i,1) + DCT(i,l) * log(r);
            end    
       end    
   end
end

