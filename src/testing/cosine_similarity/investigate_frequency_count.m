% Parameters
motif = 2;
num_epoch = 12;
num_pariticipant = 9;
frequency_band = 1; % 1 = alpha, 2 = theta
if(frequency_band == 1)
   frequency = 'alpha'; 
else
    frequency = 'theta';
end
epoch_labels = {'EC1','IF5','EF5','EL30','EL10','EL5','EC3','EC4','EC5','EC6','EC7','EC8'};

data = load('average_data.mat');
data_motifs = data.data_motifs;

X = zeros(num_pariticipant,num_epoch);
means = zeros(1,num_epoch);
stds = zeros(1,num_epoch);
for i=1:num_epoch
   epoch_data = data_motifs(i);
   frequency_data = sum(squeeze(epoch_data.frequency_data(frequency_band,:,motif,:)),2);
   means(1,i) = mean(frequency_data);
   stds(1,i) = std(frequency_data);
   X(:,i) = frequency_data;
   
end


plot_average_frequency_count(X,sprintf("Boxplot Sum Channels Frequency | %s | Motif %d",frequency,motif),epoch_labels);

function plot_average_frequency_count(X,title_string,ticks_string)
    figure;
    boxplot(X);
    title(title_string);
    xlabel('Epoch') 
    ylabel('Frequency Count')
    xticks(1:length(X))
    xticklabels(ticks_string)
end
