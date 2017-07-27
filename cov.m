function [ output_args ] = cov( input_args )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

 output_args=std(input_args)/mean(input_args);
end

