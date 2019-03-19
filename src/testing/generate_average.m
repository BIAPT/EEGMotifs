% Scripts used to generate the average participant given the pre-calculated
% motifs. Make use of aggregate and average script.

%% Variables Declaration
number_participant = 9;
number_epoch = 10;
number_channels = 91;
number_motifs = 13;
number_frequencies = 2;
motif_name_alpha = 'motifs_dpli_alpha.mat';
motif_name_theta = 'motifs_dpli_theta.mat';
epochs = {'EC1','IF5','EF5','EL5','EC3','EC4','EC5','EC6','EC7','EC8'};

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
    data_struct.frequency_data = zeros(number_frequencies,number_participant,number_motifs,number_channels);
    data_struct.alpha_frequency_avg = struct();
    data_struct.theta_frequency_avg = struct();
    
    % Populate it
    for participant_id=1:number_participant
        participant_root = all_dir(participant_id);
        participant_index = participant_root.index;
        participant_path = participant_root.full_path;
        
        data_path_alpha = strcat(participant_path,filesep,data_struct.name,filesep,motif_name_alpha);
        data_path_theta = strcat(participant_path,filesep,data_struct.name,filesep,motif_name_theta);
        
        motifs_data_alpha = get_motifs_data(data_path_alpha,participant_index);
        motifs_data_theta = get_motifs_data(data_path_theta,participant_index);
        
        % Put them in frequency data
        data_struct.frequency_data(1,participant_index,:,:) = motifs_data_alpha;
        data_struct.frequency_data(2,participant_index,:,:) = motifs_data_theta;
    end
    
    % Calculate the average
    data_struct.alpha_frequency_avg = get_average(data_struct.frequency_data(1,:,:,:));
    data_struct.theta_frequency_avg = get_average(data_struct.frequency_data(2,:,:,:));
    
    % Save it into data_motifs
    data_motifs = [data_motifs,data_struct];
end

% Here we run through data_motifs and calculate the averages


% Helper functions
function [frequency_data] = get_motifs_data(full_path,index)
    data = load(full_path);
    motifs_data = data.motifs;
    
    % Need to pad with 0s and remove missing channels
    motifs_data = clean_data(motifs_data,index);
    frequency_data = motifs_data.node_frequency;
end

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
       if(strcmp(name,'.') || strcmp(name,'..') || fetch_index(name) == -1)
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

% Will pad with 0s the missing channels and remove unecessary channels
function [dataset] = clean_data(dataset,index)
    %% Here we should pad the dataset with a column of 0s
    % 1 = MDAF03 no missing channels
    % 2 = MDAF05 no missing channels
    % 3 = MDAF06 8,13,23,45,56,57,63,107,115
    % 4 = MDAF07 17,18,22,40,44,56,100,107,123
    % 5 = MDAF10 3,10,11,45,57,70,71,102,110,111,126
    % 6 = MDAF11 46,47,55
    % 7 = MDAF12 no missing channels
    % 8 = MDAF15 100
    % 9 = MDAF17 8,21,25,81,88
    
    % we should not pad these channels;
    %{
    E1 E8 E14 E17 E21 E25 E32 E38 E43 E44 E48 E49 E56 E57 E63 E64 E68 E69 E73 E74 
    E81 E82 E88 E89 E94 E95 E99 E100 E107 E113 E114 E119 E120 E121 E125
    E126 E127 E128
    
    %}
    skip_array = [1, 8, 14, 17, 21, 25, 32, 38, 43, 44, 48, 49, 56, 57, 63, 64, 68, 69, 73, 74,81, 82, 88, 89, 94, 95, 99, 100, 107, 113, 114, 119, 120, 121, 125, 126, 127, 128];
    zero_array = [];
    if(index == 3)
        zero_array = [13,23,45,56,115];
    elseif(index == 4)
        zero_array = [18,22,40,123];
    elseif(index == 5)
        zero_array = [3,10,11,45,70,71,102,110,111];
    elseif(index == 6)
        zero_array = [46,47,55];      
    elseif(index == 8)
        zero_array = [];        
    elseif(index == 9)
        zero_array = [];
    else
        zero_array = [];
    end
    
    frequency = zeros(13,91);
    intensity = zeros(13,91);
    
    %% Here we pad when we need to
    index = 1;
    index_global = 1;
    for i = 1:129
        if(ismember(i,skip_array))
            continue
        end
        if(ismember(i,zero_array))
            frequency(:,index_global) = zeros(13,1);
            intensity(:,index_global) = zeros(13,1);
        else
            frequency(:,index_global) = dataset.node_frequency(:,index);
            intensity(:,index_global) = dataset.node_intensity(:,index);
            index = index + 1;
        end
        index_global = index_global + 1;
    end
    dataset.node_frequency = frequency;
    dataset.node_intensity = intensity;
end

function [motifs] = get_average(frequency)
    %% Average the raw number
    frequency = squeeze(frequency);
    avg_raw_freq = zeros(13,91);

    for i = 1:91
        count = 0;
        for j = 1:9
            % Check which channel is missing
            if(sum(frequency(j,:,i)) == 0)
               % should skip this one 
            else
                count = count + 1;
            end
        end

        for j = 1:13
            avg_raw_freq(j,i) = sum(frequency(:,j,i))/count;     
        end
    end

    %% Normalized the data from the average participant
    avg_norm_freq = zeros(13,91);
    for i = 1:13
        if(std(avg_raw_freq(i,:)) ~= 0)
            avg_norm_freq(i,:) = (avg_raw_freq(i,:) - mean(avg_raw_freq(i,:)))/std(avg_raw_freq(i,:));
        end
    end

    motifs = struct();
    motifs.analysis_type = "dpli";
    motifs.graph_type = "weighted";
    motifs.node_intensity = avg_norm_freq;
    motifs.node_frequency = avg_norm_freq;
    motifs.node_coherence = avg_norm_freq;
end