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
    cluster_pool = gcp();
    
    %% Crawling through the data
    for i = 1:number_participant
        participant_id = participants(i).name
        participant_saving_path = strcat(base_saving_path,filesep,participant_id);
        participant_loading_path = strcat(loading_path,filesep,participant_id);
        
        information.saving_path = participant_saving_path;
        information.loading_path = participant_loading_path;
        
        mkdir(participant_saving_path);
        [number_files,files] = get_files(participant_loading_path);
        parfor j=1:number_files
            disp(files(i).name)
           %%process_participant(information,parameters,files(j)); 
        end 
    end
end

