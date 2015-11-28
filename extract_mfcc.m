function [ MFCCs ] = extract_mfcc( audioData, fs )
%EXTRACT_MFCC Extract MFCC features
%   audioData - The sample audio data
%   fs - The sample rate

    %% PARAMETERS
    Tw = 11.6;           % analysis frame duration (ms)
    Ts = 5.8;           % analysis frame shift (ms)
    alpha = 0.97;      % preemphasis coefficient
    R = [20 12000 ];  % frequency range to consider
    M = 20;            % number of filterbank channels
    C = 13;            % number of cepstral coefficients
    L = 22;            % cepstral sine lifter parameter

    %% PRELIMINARIES 
    % Explode samples to the range of 16 bit shorts
    if( max(abs(audioData))<=1 ), audioData = audioData * 2^15; end;

    Nw = round( 1E-3*Tw*fs );    % frame duration (samples)
    Ns = round( 1E-3*Ts*fs );    % frame shift (samples)

    nfft = 2^nextpow2( Nw );     % length of FFT analysis 
    K = nfft/2+1;                % length of the unique part of the FFT 
     
    %% FEATURE EXTRACTION 
    % Preemphasis filtering (see Eq. (5.1) on p.73 of [1])
    audioData = filter( [1 -alpha], 1, audioData ); % fvtool( [1 -alpha], 1 );

    Len = length( audioData );                  % length of the input vector
    Mat = floor((Len-Nw)/Ns+1);             % number of frames 
    
    indf = Ns*[ 0:(Mat-1) ];                                  % indexes for frames      
    inds = [ 1:Nw ].';                                      % indexes for samples
    indexes = indf(ones(Nw,1),:) + inds(:,ones(1,Mat));       % combined framing indexes
    
    % divide the input signal into frames using indexing
    frames = audioData( indexes );
    frames = diag( (0.54-0.46*cos(2*pi*[0:Nw-1].'/(Nw-1))) ) * frames;
    
    % Magnitude spectrum computation (as column vectors)
    MAG = abs( fft(frames,nfft,1) ); 
  
    f_min = 0;          % filter coefficients start at this frequency (Hz)
    f_low = R(1);       % lower cutoff frequency (Hz) for the filterbank 
    f_high = R(2);      % upper cutoff frequency (Hz) for the filterbank 
    f_max = 0.5*fs;     % filter coefficients end at this frequency (Hz)
    f = linspace( f_min, f_max, K ); % frequency range (Hz), size 1xK
    fw = 1127*log(1+f/700);

    % filter cutoff frequencies (Hz) for all filters, size 1x(M+2)
    f_low_f = 1127*log(1+f_low/700);
    f_high_f = 1127*log(1+f_high/700);
    
    c_f =  f_low_f + [0:M+1]*((f_high_f - f_low_f)/(M+1));
    
    c = 700*exp(c_f/1127)-700;
    cw = 1127*log(1+c/700);

    H = zeros( M, K );                  % zero otherwise
    for m = 1:M      
        k = f>=c(m)&f<=c(m+1); % up-slope
        H(m,k) = (f(k)-c(m))/(c(m+1)-c(m));
        k = f>=c(m+1)&f<=c(m+2); % down-slope
        H(m,k) = (c(m+2)-f(k))/(c(m+2)-c(m+1));    
   end
    
    % Filterbank application to unique part of the magnitude spectrum
    FBE = H * MAG(1:K,:);  FBE( FBE<1.0 ) = 1.0; % apply mel floor

    % DCT matrix computation
    DCT =  sqrt(2.0/M) * cos( repmat([0:C-1].',1,M).* repmat(pi*([1:M]-0.5)/M,C,1) ); 

    % Conversion of logFBEs to cepstral coefficients through DCT
    CC =  DCT * log( FBE );

    % Cepstral lifter computation
    lifter = 1+0.5*L*sin(pi*[0:C-1]/L);

    % Cepstral liftering gives liftered cepstral coefficients
    MFCCs = diag( lifter ) * CC; % ~ HTK's MFCCs 
end

