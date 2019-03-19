%% Select Multiple Files
paths = select_files('*.mat','Select multiple files to merge');
% load them up
datasets = load_files(paths);

%% Padding
for i = 1:length(datasets)
   
   datasets(i).motifs = pad(datasets(i).motifs,i+1);
end

%% Combine these files into one

frequency_datasets = zeros(length(datasets),13,91);
intensity_datasets = zeros(length(datasets),13,91);
for i = 1:length(datasets)
    current_frequency = datasets(i).motifs.node_frequency;
    current_intensity = datasets(i).motifs.node_intensity;
    for j = 1:length(current_frequency)
       frequency_datasets(i,:,j) = current_frequency(:,j);
       intensity_datasets(i,:,j) = current_intensity(:,j);
    end
end


function [paths] = select_files(regex,title)
    [file,path] = uigetfile(regex,title,'MultiSelect','on');
    for i = 1:length(file)
       paths(i) = strcat(path,file(i));
    end
end

function [datasets] = load_files(paths)
    for i = 1:length(paths)
       datasets(i) = load(paths{i}); 
    end
end

function [dataset] = pad(dataset,index)
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
    
    disp(index)
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


