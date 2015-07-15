function [audioData,fs] = loadsample(filename)

[audioData,fs] = audioread(filename);
