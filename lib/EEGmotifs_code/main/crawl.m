function crawl(information,parameters)
%CALCULATE_MOTIFS Summary of this function goes here
%   Detailed explanation goes here
    

    %% Setting up variables
    loading_path = information.loading_path;
    saving_path = information.saving_path;
    FOLDER_NAME = strcat("EEGMotifs_",num2str(floor(now*100000)));
    number_participant = get_number_participant(loading_path);
    
    %% Create the base folder at right place
    mkdir(saving_path,FOLDER_NAME);    
    information.saving_path = strcat(saving_path,filesep,FOLDER_NAME);
    
    %% Start the workers here
    cluster_pool = gcp();
    %% Crawling through the data
    
    % TODO: Need to crawl through each participant (FOR)
        % TODO: Create the saving folder for participant
        participant_id = "";
        participant_saving_path = "";
        % TODO: Need to load the data from one folder
        % TODO: COMPUTE HERE AND SAVE IN THE WORKER (PARFOR)
    
end

