function [] = custom_filter( k, input )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

i = size(input,1);
last = input(i);
while(i > 1)
    input(i) = last + k*input(i-1);
    last = input(i-1);
end


end

