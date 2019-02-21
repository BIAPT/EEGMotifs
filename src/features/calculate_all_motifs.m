function [isError] = calculate_all_motifs(loading_folder,saving_folder,type,thresh,num_motifs,is_binary,eeg_info_name)
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
    full_path = strcat(loading_folder,filesep,file_name);
    if(contains(file_name, type))
        saving_path = strcat(saving_folder,filesep,'motifs_',file_name);
        
        data = load(full_path);
        if(strcmp(type,'dpli'))
            matrix = data.z_score;
        elseif(strcmp(type,'nste'))
            matrix = data.NSTE;        
        end

       disp(['Analyzing file: ',file_name]); 
       motifs = calculate_validated_motifs(matrix,10,100);
       
       % Save the motifs
       save(saving_path, 'motifs');
       
       % Creating the plots and saving them
       [filepath,name,ext] = fileparts(file_name);
       figure_path_f = strcat(saving_folder,filesep,'figure_',name,'_frequency');
       figure_path_i = strcat(saving_folder,filesep,'figure_',name,'_intensity');
       figure_path_c = strcat(saving_folder,filesep,'figure_',name,'_coherence');  
       
       [figure_f,figure_i,figure_c] = plot_motifs(motifs,1,eeg_info_name);
       saveas(figure_f,figure_path_f,'fig')
       saveas(figure_i,figure_path_i,'fig')
       saveas(figure_c,figure_path_c,'fig')
    end
end
end

