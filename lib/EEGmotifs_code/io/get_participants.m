function [number_participants,participants] = get_participants(loading_path)
%GET_NUMBER_PARTICIPANT Summary of this function goes here
%   Detailed explanation goes here
    
    %% Calculate number of subfolders
    all_files = dir(loading_path);
    all_dir = all_files([all_files(:).isdir]);
    number_folder = numel(all_dir);
    
    %% Selecting only the real folder (not . and ..)
    participants = [];
    for i =1:number_folder
       current_participant = all_dir(i);
       if(~strcmp(current_participant.name,".") && ~strcmp(current_participant.name,".."))
           participants = [participants,current_participant]; 
       end
    end
    
    number_participants = numel(participants);
end

