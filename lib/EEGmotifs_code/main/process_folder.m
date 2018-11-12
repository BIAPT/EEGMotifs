function process_folder(information,parameters)
%PROCESS_FILE Summary of this function goes here
%   Detailed explanation goes here
    
    if(parameters.general.is_dpli)
       type = "dpli"; 
    elseif(parameters.general.is_nste)
        type = "nste";
    end
    
    threshold = parameters.general.threshold;
    number_motifs = parameters.general.number_motifs;
    
    calculate_all_motifs(information.loading_path,information.saving_path,...
                         type,threshold,number_motifs);
end

