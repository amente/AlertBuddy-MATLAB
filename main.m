[audioData, fs] = loadsample('data_sample/ambulance_1.wav');

mfcc = computemfcc(audioData, fs);