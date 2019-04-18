% Parameters
motif = 7;
num_epoch = 12;
num_pariticipant = 9;
frequency_band = 2; % 1 = alpha, 2 = theta
sift = -1; % sift = 0 , means full head ; sift = 1 , means anterior ; sift = -1 means posterior
sift_label = 'Full';
if(sift == 1)
   sift_label = 'Anterior'; 
elseif(sift == -1)
    sift_label = 'Posterior';
end
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

X = zeros(num_pariticipant,num_epoch);

for i=1:num_epoch
   epoch_data = data_motifs(i);
   all_frequency_data = squeeze(epoch_data.frequency_data(frequency_band,:,motif,:));
   sifted_frequency_data = [];
   for j = 1:num_pariticipant
      participant_frequency_data = all_frequency_data(j,:);
      sifted_frequency_data = [ sifted_frequency_data ;  sift_anterior_posterior(participant_frequency_data,chanlocs,sift)];
   end
   
   frequency_data = sum(sifted_frequency_data,2);

   X(:,i) = frequency_data;
   
end


plot_average_frequency_count(X,sprintf("Boxplot Sum Channels Frequency | %s | %s | Motif %d",sift_label,frequency,motif),epoch_labels);
frequency_count = X;

function plot_average_frequency_count(X,title_string,ticks_string)
    figure;
    boxplot(X);
    title(title_string);
    xlabel('Epoch') 
    ylabel('Frequency Count')
    xticks(1:length(X))
    xticklabels(ticks_string)
end

function [sifted_vector] = sift_anterior_posterior(vector,chanlocs,sift)
    sifted_vector = [];
    if(sift == 0)
        sifted_vector = vector;
    else
        
        for i = 1:length(vector)
           if(sift == 1 && chanlocs(i).X > -0.001)
               disp(chanlocs(i).labels)
               sifted_vector = [sifted_vector, vector(i)];
           elseif(sift == -1 && chanlocs(i).X < 0.001)
               disp(chanlocs(i).labels)
               sifted_vector = [sifted_vector, vector(i)];
           end
        end
        
    end
end