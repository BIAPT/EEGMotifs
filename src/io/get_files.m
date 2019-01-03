function [number_files,files] = get_files(loading_path)
%GET) Summary of this function goes here
%   Detailed explanation goes here
    all_files = dir(loading_path);
    files = [];
    number_files = 0;
    for i=1:length(all_files)
       current_file = all_files(i);
       if(current_file.isdir == 0)
           files = [files,current_file];
           number_files = number_files + 1;
       end
    end
end

