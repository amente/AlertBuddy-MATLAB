function [] = neural_net_learn()
% NEURAL_NET_LEARN
% This function has no input and output. It is a script and does the
% following:
%    - Reads the training_data folder for audio samples in the sub folders 'siren' and 'no_siren' 
%    - Extracts MFCC features for the samples
%    - Trains a neural network classifier with those samples
%    - Generates code 'neural_net.m' for the classifier
% 
clc
clear

dataset = [];

%% FEATURE EXTRACTION
%Extract features from the siren data
traning_data_siren = dir(fullfile('training_data/siren','*.wav'));
for i=1:numel(traning_data_siren)
   [audioData, fs] = loadsample(strcat('training_data/siren/',traning_data_siren(i).name));
    % Feature extraction (feature vectors as columns)
   MFCCs =  extract_mfcc( audioData, fs);
   
  %Ignore the first MFCC value
  MFCCs(1,:)=[];
  
  inputMatrix = MFCCs';
  targetMatrix = zeros(size(inputMatrix,1),2);
  targetMatrix(:,end-1) = ones(size(inputMatrix,1),1)';
  dataset = [dataset; [inputMatrix,targetMatrix]]; 
end

%Extract features from the non_siren data
traning_data_no_siren = dir(fullfile('training_data/no_siren','*.wav'));
for i=1:numel(traning_data_no_siren)
   [audioData, fs] = loadsample(strcat('training_data/no_siren/',traning_data_no_siren(i).name));
   
    % Feature extraction (feature vectors as columns)
   MFCCs =  extract_mfcc( audioData, fs);
   MFCCs(1,:)=[];
   
   inputMatrix = MFCCs';
  targetMatrix = zeros(size(inputMatrix,1),2);
  targetMatrix(:,end) = ones(size(inputMatrix,1),1)';
  
  dataset = [dataset; [inputMatrix,targetMatrix]];
end

C = size(inputMatrix,2)+1;
x = dataset(:,1:C-1)'; % The input matrix is MFCC's except the first value
t = dataset(:,C:C+1)'; % The target matrix is two columns: COLUMN_1 = 'siren' , COLUMN_2 = 'no_siren'

% Save the features for debugging purposes
save(fullfile(pwd, 'neural_net_features','dataset_input.mat'),'x');
save(fullfile(pwd, 'neural_net_features','dataset_target.mat'),'t');

%% NEURAL NET TRAINING
% Set seed to avoid randomness
 setdemorandstream(391418381);
% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
trainFcn = 'trainscg';  % Scaled conjugate gradient backpropagation.

% Create a Pattern Recognition Network
hiddenLayerSize = 10;
net = patternnet(hiddenLayerSize);

% Choose Input and Output Pre/Post-Processing Functions
% For a list of all processing functions type: help nnprocess
net.input.processFcns = {'removeconstantrows','mapminmax'};
net.output.processFcns = {'removeconstantrows','mapminmax'};

% Setup Division of Data for Training, Validation, Testing
% For a list of all data division functions type: help nndivide
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% Choose a Performance Function
% For a list of all performance functions type: help nnperformance
net.performFcn = 'crossentropy';  % Cross-Entropy

% Choose Plot Functions
% For a list of all plot functions type: help nnplot
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
    'plotconfusion', 'plotroc'};

% Train the Network
[net,tr] = train(net,x,t);

% Test the Network
y = net(x);
e = gsubtract(t,y);
performance = perform(net,t,y);
tind = vec2ind(t);
yind = vec2ind(y);
percentErrors = sum(tind ~= yind)/numel(tind);

% Recalculate Training, Validation and Test Performance
trainTargets = t .* tr.trainMask{1};
valTargets = t .* tr.valMask{1};
testTargets = t .* tr.testMask{1};
trainPerformance = perform(net,trainTargets,y);
valPerformance = perform(net,valTargets,y);
testPerformance = perform(net,testTargets,y);

% View the Network
view(net);

% Plots
% Uncomment these lines to enable various plots.
%figure, plotperform(tr)
%figure, plottrainstate(tr)
%figure, ploterrhist(e)
%figure, plotconfusion(t,y);
%figure, plotroc(t,y)

% Deployment
fprintf('Deploying code ....\n');
% Generate MATLAB Code for NeuralNet
genFunction(net,'neural_net','MatrixOnly','yes');
% Generate C\C++ Code and MEX Code
%code_generator(size(audioData));
end