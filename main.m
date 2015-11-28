% This script uses the samples in the test_data folder to measure the
% accuracy of the classifier

num_siren = 0;
num_no_siren = 0;
num_correct_siren = 0;
num_correct_no_siren = 0;

traning_data_siren = dir(fullfile('test_data/siren','*.wav'));
for i=1:numel(traning_data_siren)
   [audioData, fs] = loadsample(strcat('test_data/siren/',traning_data_siren(i).name));
   num_siren = num_siren + 1;
   if(neural_net_classify_mex(audioData,fs) == 1)
       num_correct_siren = num_correct_siren + 1;
   end
end

%Extract features from the non_siren data
traning_data_no_siren = dir(fullfile('test_data/no_siren','*.wav'));
for i=1:numel(traning_data_no_siren)
   [audioData, fs] = loadsample(strcat('test_data/no_siren/',traning_data_no_siren(i).name));
   num_no_siren = num_no_siren + 1;
   if(neural_net_classify_mex(audioData,fs) == 2)
       num_correct_no_siren = num_correct_no_siren + 1;
   end
end

fprintf('Total number of samples: %.2f  \n', num_siren + num_no_siren);
fprintf('Classification Accuracy: %.2f%%  \n', (num_correct_siren/num_siren)*100);
fprintf('False Positives: %.2f%%  \n', (1 - (num_correct_no_siren/num_no_siren))*100);



