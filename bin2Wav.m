function [] = bin2Wav( folder )
%UNTITLED3 Convert a batch of 16bit audio samples to wav files
%   
   files = dir(fullfile(folder,'*.bin'));
    
   for i=1:numel(files)
     fileName = strcat(folder,'/', files(i).name);
     f = fopen(fileName,'r');
     x = fread(f,[1 16000],'int16');
     y = resample(x, 1, 2);
     audiowrite(strcat(folder,'/', files(i).name, '.wav'),y,8000);
     fclose(f);
   end

end

