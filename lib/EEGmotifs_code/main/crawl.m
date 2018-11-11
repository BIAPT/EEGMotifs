function crawl(information,parameters)
%CALCULATE_MOTIFS Summary of this function goes here
%   Detailed explanation goes here
    

    %% Setting up variables
    loading_path = information.loading_path;
    saving_path = information.saving_path;
    FOLDER_NAME = strcat("EEGMotifs_",num2str(floor(now*100000)));
    [number_participant,participants] = get_participants(loading_path);
    
    %% Create the base folder at right place
    mkdir(saving_path,FOLDER_NAME);    
    information.saving_path = strcat(saving_path,filesep,FOLDER_NAME);
    
    disp(number_participant)
    disp(participants)
    %% Start the workers here
    cluster_pool = gcp();
    %% Crawling through the data
    % TODO: Need to crawl through each participant (FOR)
    for i = 1:number_participant
        % TODO: Create the saving folder for participant
        participant_id = participants(i).name
        participant_saving_path = strcat(information.saving_path,filesep,participant_id);
        mkdir(participant_saving_path);
        % TODO: Need to load the data from one folder
        % TODO: COMPUTE HERE AND SAVE IN THE WORKER (PARFOR)
    end
end

