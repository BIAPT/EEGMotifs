function [assymmetry] = FF_vs_FB_assymmetry(matrix)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%Frontal channels: 24, 19, 11, 4, 124, 12, 5
%Parietal channels: 52,60,67,72,77,85,92,86,78,62,61,53
frontal_channels = [24,19,11,4,124,12,5];
parietal_channels = [52,60,67,72,77,85,92,86,78,62,61,53];
index = 1;
for ch_f_ind = 1:size(frontal_channels)
    ch_f = frontal_channels(ch_f_ind);
   for ch_p_ind = 1: size(parietal_channels)
       ch_p = parietal_channels(ch_p_ind);
       nste_ff(index) = matrix(ch_p,ch_f);
       nste_fb(index) = matrix(ch_f,ch_p);
       index = index + 1;
   end
end

%Feedback = frontal to parietal NSTE
%Feedforward = parietal to frontal NSTE
%Asymmetry = (FB - FF)/(FB + FF)
FB = mean(nste_fb);
FF = mean(nste_ff);
assymmetry = (FB-FF)/(FB+FF);
end

