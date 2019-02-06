%% Select Multiple Files
paths = select_files('*.mat','Select multiple files to merge');
% load them up
datasets = load_files(paths);

%% Padding
for i = 1:length(datasets)
   datasets(i).motifs = pad(datasets(i).motifs,i);
end

%% Combine these files into one

frequency_datasets = zeros(length(datasets),13,129);
intensity_datasets = zeros(length(datasets),13,129);
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
    
    zero_array = [];
    if(index == 3)
        zero_array = [8,13,23,45,56,57,63,107,115];
    elseif(index == 4)
        zero_array = [17,18,22,40,44,56,100,107,123];
    elseif(index == 5)
        zero_array = [3,10,11,45,57,70,71,102,110,111,126];
    elseif(index == 6)
        zero_array = [46,47,55];      
    elseif(index == 8)
        zero_array = [100];        
    elseif(index == 9)
        zero_array = [8,21,25,81,88];
    else
        return
    end
    
    frequency = zeros(13,129);
    intensity = zeros(13,129);
    
    %% Here we pad when we need to
    index = 1;
    for i = 1:129
        if(ismember(i,zero_array))
            frequency(:,i) = zeros(13,1);
            intensity(:,i) = zeros(13,1);
        else
            frequency(:,i) = dataset.node_frequency(:,index);
            intensity(:,i) = dataset.node_intensity(:,index);
            index = index + 1;
        end
    end
    dataset.node_frequency = frequency;
    dataset.node_intensity = intensity;
end