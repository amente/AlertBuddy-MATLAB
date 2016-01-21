function [] = code_generator(sampleSize)
% CODE_GENERATOR 
% Generates Cortex-M C/C++ code and MEX code 

if nargin < 1
  sampleSize = 8000;
end

% Library code config for ARM Cortex-M'
cfgLib = coder.config('lib');
cfgLib.CodeReplacementLibrary = 'ARM Cortex-M';
cfgLib.HardwareImplementation.ProdHWDeviceType = 'ARM Compatible->ARM Cortex';
cfgLib.GenCodeOnly = true;
%cfgLib.dialog;

x1_type = coder.typeof(single(0), [8000, 1]) ;
x2_type = coder.typeof(single(0));

% Generate C code 
codegen('extract_mfcc', '-args', {x1_type, x2_type}, '-config', 'cfgLib', '-report');

% Mex code config for ARM Cortex-M'
cfgMex = coder.config('mex');
%Generate MEX
codegen('extract_mfcc', '-args', {x1_type, x2_type}, '-config', 'cfgMex', '-report');


x3_type = coder.typeof(single(0),[1, 13]);
% Generate C code 
codegen('neural_net', '-args', {x3_type}, '-config', 'cfgLib', '-report');

% Mex code config for ARM Cortex-M'
cfgMex = coder.config('mex');
%Generate MEX
codegen('neural_net', '-args', {x3_type}, '-config', 'cfgMex', '-report');

zip('extract_mfcc.zip',{'*.h','*.c'}, 'codegen/lib/extract_mfcc');
zip('neural_net.zip',{'*.h','*.c'}, 'codegen/lib/neural_net');
end