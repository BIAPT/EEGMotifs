function crawl(information,parameters)
%CALCULATE_MOTIFS Summary of this function goes here
%   Detailed explanation goes here
    

    %% Setting up variables
    loading_path = information.loading_path;
    saving_path = information.saving_path;
    FOLDER_NAME = strcat("EEGMotifs_",num2str(floor(now*100000)));
    [number_participant,participants] = get_directories(loading_path);
    
    %% Create the base folder at right place
    base_saving_path = strcat(saving_path,filesep,FOLDER_NAME);
    mkdir(base_saving_path);    

    %% Start the workers here
    gcp();
    %% Crawling through the data
    % First through each participant
    make_motif34lib; %Used to make motif34lib.m used by the functions
    for i = 1:number_participant
        participant_id = participants(i).name;
        participant_saving_path = strcat(base_saving_path,filesep,participant_id);
        participant_loading_path = strcat(loading_path,filesep,participant_id);
        
        information.saving_path = participant_saving_path;
        information.loading_path = participant_loading_path;
        
        mkdir(participant_saving_path);
        [number_conditions,conditions] = get_directories(participant_loading_path);
        
        
        % HERE WE LOAD THE EEG_INFO
        eeg_info_name = strcat('EEG_info_',participant_id,'.mat');
        % Then through each of the individual condition
        for index = 1:number_conditions
            
            % We process each condition folder appropriatly
            process_folder(information,parameters,index,conditions,eeg_info_name); 
        end
    end
    delete 'motif34lib.mat'
end

