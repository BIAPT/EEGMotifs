function [number_directory,directory] = get_directory(loading_path)
%GET_NUMBER_PARTICIPANT Summary of this function goes here
%   Detailed explanation goes here
    
    %% Calculate number of subfolders
    all_files = dir(loading_path);
    all_dir = all_files([all_files(:).isdir]);
    number_folder = numel(all_dir);
    
    %% Selecting only the real folder (not . and ..)
    directory = [];
    for i =1:number_folder
       current_directory = all_dir(i);
       if(~strcmp(current_directory.name,".") && ~strcmp(current_directory.name,".."))
           directory = [directory,current_directory]; 
       end
    end
    
    number_directory = numel(directory);
end

