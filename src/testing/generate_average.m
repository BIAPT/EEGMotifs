% Scripts used to generate the average participant given the pre-calculated
% motifs. Make use of aggregate and average script.

%% Variables Declaration
number_participant = 9;
number_epoch = 10;
number_channels = 129;
epochs = {'EC1','IF5','EMF5','EML5','EC3','EC4','EC5','EC6','EC7','EC8'};

%% Step 1: Iterate throught the data and load it into a structure
% First we should let the user select a folder where the data is located.
[data_path] = uigetdir('Select Motifs Results Folder');
% Then we should get every folder inside that folder
all_dir = get_all_directory(data_path);
% After that we should iterate through every folder and load the data into
% a data structure that will contain every data points separated by epoch
data_motifs = [];
% each row of this struct is an epoch that has a name and a frequency_data
% 3d array
for i=1:number_epoch
    % Create the structure
    data_struct = struct();
    data_struct.name = epochs{i};
    data_struct.frequency_data = zeros(number_participant,number_channels,number_channels);
    
    % Populate it
    
    % Save it into data_motifs
    data_motifs = [data_motifs,data_struct];
end

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
       else % we add the index
           all_dir(i).index = fetch_index(name);
       end
       
       %
       i = i + 1;
    end
    
end

% Return an index corresponding to the type of datasets
function [index] = fetch_index(name)
    index = -1;
    if(strcmp(name,"MDFA03"))
        index = 1;
    elseif(strcmp(name,"MDFA05"))
        index = 2;
    elseif(strcmp(name,"MDFA06"))
        index = 3;
    elseif(strcmp(name,"MDFA07"))
        index = 4;
    elseif(strcmp(name,"MDFA10"))
        index = 5;
    elseif(strcmp(name,"MDFA11"))
        index = 6;
    elseif(strcmp(name,"MDFA12"))
        index = 7;
    elseif(strcmp(name,"MDFA15"))
        index = 8;
    elseif(strcmp(name,"MDFA17"))
        index = 9;
    end
end
