function [motifs] = random_network_validation(og_network,rewiring,number_rand_network)
%RANDOM_NETWORK_VALIDATION calculate motifs and z score for frequency
%   Detailed explanation goes here

    % Function will be using randmio_dir.m from the BCT toolbox
    
    %% Here is what the motifs structure should looks like at the end 
    % motif
    %   - raw_frequency
    %   - raw_intensity
    %   - raw_coherence
    
    %   - rand_frequency
    %   - rand_intensity
    %   - rand_coherence
    
    %   This is the threshold data
    %   - node_frequency
    %   - node_intensity
    %   - node_coherence
    
    %% Variable Initialization
    motifs = struct();
    motifs = struct();
    
    %% 0) Thresholding to make the Brain Connectivity Toolbox works
    [og_network] = threshold(og_network,"dpli",0,0);
    
    %% 1) Calculate the motif for our network of interest.
    disp('Calculate Motif for NOI')
    [og_intensity,og_coherence,og_frequency] = motif3funct_wei(og_network);
    % Saving the motifs for the return
    motifs.raw_intensity = og_intensity;
    motifs.raw_coherence = og_coherence;
    motifs.raw_frequency = og_frequency;
    
    rand_intensity = zeros(number_rand_network,13,length(og_network));
    rand_coherence = zeros(number_rand_network,13,length(og_network));
    rand_frequency = zeros(number_rand_network,13,length(og_network)); 
    
    disp('Create Random Network')
    %% 2) Create X random network using our network of interest 
    for i = 1:number_rand_network
        disp(strcat("network: ",string(i)))
        [rand_network,~]=randmio_dir(og_network, rewiring);
        %% 3) Calculate the motif for the X random network. (BOTTLE NECK)
        [rand_intensity(i,:,:),rand_coherence(i,:,:),rand_frequency(i,:,:)] = motif3funct_wei(rand_network);
    end
    
    % Saving the random motifs for the return
    motifs.rand_intensity = rand_intensity;
    motifs.rand_coherence = rand_coherence;
    motifs.rand_frequency = rand_frequency;
    
    
    %% 4) Calculate the Z score for each motifs
    disp('Calculate Z score')
    rand_frequency_mean = mean(sum(rand_frequency,3))';
    rand_frequency_std = std(sum(rand_frequency,3))';
    og_frequency_sum = sum(og_frequency,2);
    z_score_frequency = (og_frequency_sum - rand_frequency_mean) ./ rand_frequency_std;
    
    %% 5) Flag as statistically significant the motifs that have a Z = 1.96 (p < 0.05)
    disp('Threshold value that are not statistically significant')
    for i=1:13
       % Need to set the count for these motifs to 0 
       if(z_score_frequency(i) < 1.96) 
           for j=1:length(og_frequency)
              og_frequency(i,j) = 0;
           end
       end
    end
    
    % Here we set the thresholded values
    motifs.node_frequency = og_frequency;
    motifs.node_intensity = og_intensity;
    motifs.node_coherence = og_coherence;
    
end

