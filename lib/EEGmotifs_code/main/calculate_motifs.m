function calculate_motifs(information,parameters)
%CALCULATE_MOTIFS Summary of this function goes here
%   Detailed explanation goes here
    

    %% Setting up variables
    loading_path = information.loading_path;
    saving_path = information.saving_path;
    FOLDER_NAME = strcat("EEGMotifs_",num2str(floor(now*100000)));
    
    %% Create the base folder at right place
    
    information.saving_path = strcat(saving_path,filsep,FOLDER_NAME);
    
    %% TODO: Start the workers here
    
    %% Crawling through the data
    
    % TODO: Need to crawl through each participant (FOR)
        % TODO: Create the saving folder for participant
        participant_id = "";
        participant_saving_path = "";
        % TODO: Need to load the data from one folder
        % TODO: COMPUTE HERE AND SAVE IN THE WORKER (PARFOR)
    
end
