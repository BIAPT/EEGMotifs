% Scripts used to generate the average participant given the pre-calculated
% motifs. Make use of aggregate and average script.

%% Step 1: Iterate throught the data and load it into a structure
% First we should let the user select a folder where the data is located.
[data_path] = uigetdir('Select Motifs Results Folder');
% Then we should get every folder inside that folder
all_dir = get_all_directory(data_path);



% Helper functions
% Get all the dirs and process them to have the same structure as a call
% to the dir() function + full path and give an index for the padding
% portion of the code
function [all_dir] = get_all_directory(data_path)
    all_files = dir(data_path);
    all_dir = all_files([all_files(:).isdir]);
    
    number_directory = length(all_dir);
    i = 1;
    while(i <= number_directory)
       disp(i)
       name = all_dir(i).name
       folder = all_dir(i).folder
       full_path = strcat(folder,filesep,name);
       all_dir(i).full_path = full_path;
       
       % If its the . or .. directory we delete it
       if(strcmp(name,'.') || strcmp(name,'..'))
          all_dir(i) = [];
          i = i - 1;
          number_directory = number_directory - 1;
       end
       
       %
       i = i + 1;
    end
    
end

function [index] = fetch_index(name)
    % Here are the index and what they mean
    % 1 = MDAF03
    % 2 = MDAF05
    % 3 = MDAF06
    % 4 = MDAF07
    % 5 = MDAF10
    % 6 = MDAF11
    % 7 = MDAF12
    % 8 = MDAF15
    % 9 = MDAF17 
end
