function [isError] = calculate_all_motifs(loading_folder,saving_folder,type,thresh,num_motifs,is_binary)
%CALCULATE_ALL_MOTIFS : Will load all matrix from a folder calculate the
%motifs metrix and then save then in another folder
% Input:
% loading_folder = path of folder we want to load data from
% type = dPLI or NSTE
% num_motifs = 3 or 4
% saving_folder = path to where we want to save the data
% Output:
% isError = 1 if error and 0 if no error
listing = dir(loading_folder);
for i = 1:size(listing)
    file_name = listing(i).name;
    full_path = strcat(loading_folder,'\',file_name);
    if(contains(file_name, type))
        saving_path = strcat(saving_folder,'\','motifs_',file_name);
        data = load(full_path);
        if(strcmp(type,'dpli'))
            matrix = data.z_score;
        elseif(strcmp(type,'nste'))
            matrix = data.NSTE;        
        end
        motifs = struct();
        motifs.analysis_type = type;
        disp(['Analyzing file: ',file_name]); 
       [I,Q,F,f] = calculate_motifs(matrix,type,thresh,num_motifs,is_binary);
       if(is_binary)
          motifs.graph_type = "binary";
          motifs.node_frequency = F;
          motifs.motif_frequency = f;
       else
           motifs.graph_type = "weighted";
           motifs.node_intensity = I;
           motifs.node_frequency = F;
           motifs.node_coherence = Q;
       end
       save(saving_path, 'motifs');
    end
end 
end
