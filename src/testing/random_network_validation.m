function [z_score_frequency] = random_network_validation(og_network,...
                                p_value,rewiring,number_rand_network)
%RANDOM_NETWORK_VALIDATION Summary of this function goes here
%   Detailed explanation goes here

    % Function will be using randmio_dir.m from the BCT toolbox
    
    %% Note: Here we only will use the weighted networks
    %% 0) Thresholding to make the Brain Connectivity Toolbox works
    [og_network] = threshold(og_network,"dpli",0,0);
    %% 1) Calculate the motif for our network of interest.
    disp('Calculate Motif for NOI')
    [og_intensity,og_coherence,og_frequency] = motif3funct_wei(og_network);
    
    rand_intensity = zeros(number_rand_network,13,length(og_network));
    rand_coherence = zeros(number_rand_network,13,length(og_network));
    rand_frequency = zeros(number_rand_network,13,length(og_network));  
    disp('Create Random Network')
    %% 2) Create X random network using our network of interest 
    parfor i = 1:number_rand_network
        disp(strcat("network: ",string(i)))
        disp('Randomize the network')
        [rand_network,~]=randmio_dir(og_network, rewiring);
        %% 3) Calculate the motif for the X random network. (BOTTLE NECK)
        disp('Calculate the motif for RNOI')
        [rand_intensity(i,:,:),rand_coherence(i,:,:),rand_frequency(i,:,:)] = motif3funct_wei(rand_network);
    end
    
    %% 4) Calculate the Z score for each motifs
    disp('Calculate Z score')
    [z_score_frequency] = calculate_z_score(og_frequency,rand_frequency);
    %% 5) Flag as statistically significant the motifs that have a Z = 1.96 (p < 0.05)
    disp('Threshold value that are not statistically significant')
end

function [z_score_frequency] = calculate_z_score(og_frequency,rand_frequency)
    rand_frequency_mean = squeeze(mean(rand_frequency));
    rand_frequency_std = squeeze(std(rand_frequency));
    %% Here will use the formula
    z_score_frequency = (og_frequency - rand_frequency_mean) ./ rand_frequency_std
end

