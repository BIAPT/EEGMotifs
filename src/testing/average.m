%% Select Multiple Files
path = select_file('*.mat','Select one file to load');
% load them up
dataset = load(path);

%% take variable out
frequency = dataset.frequency_datasets;
intensity = dataset.intensity_datasets;

%% Average the raw number
avg_raw_freq = zeros(13,129);
avg_raw_int = zeros(13,129);

for i = 1:129
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
        avg_raw_int(j,i) = sum(intensity(:,j,i))/count;         
    end
end

%% Normalized the data from the average participant
avg_norm_freq = zeros(13,129);
avg_norm_int = zeros(13,129);
for i = 1:13
    avg_norm_freq(i,:) = (avg_raw_freq(i,:) - mean(avg_raw_freq(i,:)))/std(avg_raw_freq(i,:));
    avg_norm_int(i,:) = (avg_raw_int(i,:) - mean(avg_raw_int(i,:)))/std(avg_raw_int(i,:));
end

motifs = struct();
motifs.analysis_type = "dpli";
motifs.graph_type = "weighted";
motifs.node_intensity = avg_norm_int;
motifs.node_frequency = avg_norm_freq;
motifs.node_coherence = avg_norm_freq;

%% May not need the stuff below as we already are normalizing above
%{
%% Normalized the raw numbers across motifs
% TODO same idea as above,but we normalize all of them first then we add and then we average
norm_avg_freq = zeros(13,129);
norm_avg_int = zeros(13,129);

norm_ppl_freq = zeros(9,13,129);
norm_ppl_int = zeros(9,13,129);

for person = 1:9
    for channel = 1 :129
        for motif=1:13
           if(sum(frequency(person,:,channel)) ~= 0)
               data_freq(motif,channel) = [data_freq, frequency(person,motif,channel)];
               data_int(motif,channel) = intensity(person,motif,channel); 
           end 
        end
    end
    
    for motif = 1:13
        norm_ppl_freq(person,motif,:) = (data_freq(motif,:) - mean(data_freq(motif,:))) / std(data_freq(motif,:));
        norm_ppl_int(person,motif,:) = (data_int(motif,:) - mean(data_int(motif,:))) / std(data_int(motif,:));        
    end
end

%% Average the normalized numbers
%}

function [path] = select_file(regex,title)
    [file,path] = uigetfile(regex,title,'MultiSelect','on');
    path = strcat(path,file);
end

function [datasets] = load_files(paths)
    for i = 1:length(paths)
       datasets(i) = load(paths{i}); 
    end
end