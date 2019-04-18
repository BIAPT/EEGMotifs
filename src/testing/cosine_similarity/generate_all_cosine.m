% Parameters
motif = 2;
num_epoch = 12;
num_participant = 9;
frequency_band = 1; % 1 = alpha, 2 = theta
if(frequency_band == 1)
   frequency = 'alpha'; 
else
    frequency = 'theta';
end
epoch_labels = {'EC1','IF5','EF5','EL30','EL10','EL5','EC3','EC4','EC5','EC6','EC7','EC8'};

data = load('average_data.mat');
data_motifs = data.data_motifs;

data = load('EEG_info_AVG.mat');
chanlocs = data.EEG_info.chanlocs;

all_cosine_similarity = zeros(num_epoch,num_participant);

all_data = zeros(12,2,9,13,99);
for e=1:num_epoch
   epoch_data = data_motifs(e);
   all_data(e,:,:,:,:) = epoch_data.frequency_data(:,:,:,:);
end

all_data = squeeze(all_data(:,frequency_band,:,motif,:));
for n = 1:num_participant
   participant_frequency_data = squeeze(all_data(:,n,:));
   participant_frequency_data = normalize(participant_frequency_data);
   for e = 1:num_epoch
       A = participant_frequency_data(1,:)';
       B = participant_frequency_data(e,:)';
       all_cosine_similarity(e,n) = cosine_similarity(A,B);
   end
end

function [similarity] = cosine_similarity(A,B)
     similarity = dot(A,B) / (norm(A) * norm(B));
end

function [avg_norm_freq] = normalize(avg_raw_freq)
    % Normalized the data from the average participant
    avg_norm_freq = zeros(12,99);
    for i = 1:12
        if(std(avg_raw_freq(i,:)) ~= 0)
            avg_norm_freq(i,:) = (avg_raw_freq(i,:) - mean(avg_raw_freq(i,:)))/std(avg_raw_freq(i,:));
        end
    end
end