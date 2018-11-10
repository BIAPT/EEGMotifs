function [number_participant] = get_number_participant(loading_path)
%GET_NUMBER_PARTICIPANT Summary of this function goes here
%   Detailed explanation goes here
    
    %% Setup variables
    number_participant = 0;
    
    %% Calculate number of subfolders
    all_files = dir;
    all_dir = all_files([all_files(:).isdir]);
    num_participant = numel(all_dir);
end

