function [] = code_generator(sampleSize)
% CODE_GENERATOR 
% Generates Cortex-M C/C++ code and MEX code 

if nargin < 1
  sampleSize = 16000;
end

% Library code config for ARM Cortex-M'
cfgLib = coder.config('lib');
cfgLib.CodeReplacementLibrary = 'ARM Cortex-M';
cfgLib.HardwareImplementation.ProdHWDeviceType = 'ARM Compatible->ARM Cortex';
cfgLib.GenCodeOnly = true;
%cfgLib.dialog;

x1_type = coder.typeof(double(0), [sampleSize, 1]) ;
x2_type = coder.typeof(double(0));

% Generate C code 
codegen('neural_net_classify', '-args', {x1_type, x2_type}, '-config', 'cfgLib', '-report');

% Mex code config for ARM Cortex-M'
cfgMex = coder.config('mex');
%Generate MEX
codegen('neural_net_classify', '-args', {x1_type, x2_type}, '-config', 'cfgMex', '-report');

end