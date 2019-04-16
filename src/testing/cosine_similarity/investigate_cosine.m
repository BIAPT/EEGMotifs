%% Load data_motifs

% Parameters
motif = 1;
num_epoch = 12;
epoch_labels = {'EC1','IF5','EF5','EL30','EL10','EL5','EC3','EC4','EC5','EC6','EC7','EC8'};

data = load('average_data.mat');
data_motifs = data.data_motifs;

alpha_cosim_matrix = zeros(num_epoch,num_epoch);
theta_cosim_matrix = zeros(num_epoch,num_epoch);

alpha_vector = zeros(num_epoch,99);
theta_vector = zeros(num_epoch,99);
for i=1:num_epoch
   epoch_data = data_motifs(i);
   alpha_vector(i,:) = epoch_data.alpha_frequency_avg.node_frequency(motif,:);
   theta_vector(i,:) = epoch_data.theta_frequency_avg.node_frequency(motif,:);
end


for epoch_i = 1:num_epoch
   for epoch_j = 1:num_epoch
       A = alpha_vector(epoch_i,:);
       B = alpha_vector(epoch_j,:);
       alpha_cosim_matrix(epoch_i,epoch_j) = cosine_similarity(A,B);
       
       A = theta_vector(epoch_i,:);
       B = theta_vector(epoch_j,:);
       theta_cosim_matrix(epoch_i,epoch_j) = cosine_similarity(A,B);
   end
end

plot_cosine_similarity(alpha_cosim_matrix,sprintf('Cosine similarity | Alpha | Average Participant | Motif %d',motif),epoch_labels);
plot_cosine_similarity(theta_cosim_matrix,sprintf('Cosine similarity | Theta | Average Participant | Motif %d',motif),epoch_labels);

function plot_cosine_similarity(cosim_matrix,title_string,ticks_string)
    figure;
    colormap('jet')
    imagesc(cosim_matrix);
    title(title_string);
    xlabel('Epoch') 
    ylabel('Epoch')
    xticks(1:length(cosim_matrix))
    yticks(1:length(cosim_matrix))
    xticklabels(ticks_string)
    yticklabels(ticks_string)
    colorbar;
end

function [similarity] = cosine_similarity(A,B)
     similarity = dot(A,B) / (norm(A) * norm(B));
end