function process_folder(information,parameters,index,conditions)
%PROCESS_FILE Summary of this function goes here
%   Detailed explanation goes here
    condition_id = conditions(index).name;
    condition_saving_path = strcat(information.saving_path,filesep,condition_id);
    condition_loading_path = strcat(information.loading_path,filesep,condition_id);
            
    information.saving_path = condition_saving_path;
    information.loading_path = condition_loading_path;
            
    mkdir(condition_saving_path);

    if(parameters.general.is_dpli)
       type = "dpli"; 
    elseif(parameters.general.is_nste)
       type = "nste";
    end
    
    threshold = parameters.general.threshold;
    number_motifs = parameters.general.number_motifs;
    
    disp(strcat("Processing folder: ",information.loading_path));
    calculate_all_motifs(information.loading_path,information.saving_path,...
                        type,threshold,number_motifs);
end

