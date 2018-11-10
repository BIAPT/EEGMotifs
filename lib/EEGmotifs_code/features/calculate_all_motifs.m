function [isError] = calculate_all_motifs(loading_folder,type,thresh,num_motifs,saving_folder)
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
disp(size(listing))
make_motif34lib; %Used to make motif34lib.m used by the functions
for i = 1:size(listing)
    file_name = listing(i).name;
    full_path = strcat(loading_folder,'\',file_name);
    if(contains(file_name, 'data.mat'))
        saving_path = strcat(saving_folder,'\','motifs_',file_name);
        data = load(full_path);
        if(strcmp(type,'dpli'))
            matrix = data.z_score;
        elseif(strcmp(type,'nste'))
            matrix = data.NSTE;        
        end
        motifs = struct();
        disp(['Analyzing file: ',file_name]); 
       [motifs.I,motifs.Q, motifs.F] = calculate_motifs(matrix,type,thresh,num_motifs,0,0);
       save(saving_path, 'motifs');
    end
end 
delete 'motif34lib.mat'
end

