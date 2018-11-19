function [Frequency,frequency] = calculate_motifs(matrix,type,thresh,num_motifs,is_binary)
%CALCULATE_MOTIFS : 
%Calculate the frequency, intensity and coherence of a dpli or NSTE matrix 
%[Intensity,Coherence,Frequency] = calculate_motifs(matrix,type,num_motifs)
%   Input: 
%   matrix = dPLI or NSTE matrix obtained from EEGapp
%   type = 'nste' or 'dpli'
%   num_motifs = 3 or 4, depending if we want 3 or 4 motifs
%   isPlot = 1 means plot 0 means no plot
%   normalize = 1 means normalize the plot by doing ((C or I or F) - mean)
%   / std, 0 means no normalization
%   Output:
%   Frequency,Intensity and Coherence as obtained by the BCT motif
%   functions
%   If error occured Frequency,Intensity and Coherence will return NaN

disp('Setup...');
type = lower(type); % put the type to lowercase
Frequency = NaN;
frequency = NaN;
Intensity = NaN;
Coherence = NaN;
if(strcmp(type,'dpli') || strcmp(type,'nste'))
    %% Thresholding
    matrix = threshold(matrix,type,is_binary,thresh)
    if(isnan(matrix))
        error('ERROR in THRESHOLD');
        return;
    end
    
    %% Motif Caculations
    [Frequency,frequency] = compute_bin(matrix,num_motifs);
    if(isnan(Frequency))
        error('NUMBER OF MOTIFS NOT EQUAL TO 3 OR 4');
        return;
    end
    
else
    error('ERROR: Unsuported matrix type');
end

end

%% Helper functions

function error(error)
%ERROR : display the error given
%   Input: 
%   error = string that display the error
    disp('ERROR in CALCULATE_MOTIFS.m'); 
    disp(['!!!!!',error,'!!!!!']);
end


function [I,Q,F] = compute_wei(t_matrix,num_motifs)
%COMPUTE : calculate motifs of the matrix
%   Input: 
%   t_matrix = thresholded matrix
%   num_motifs = number of motifs, either 3 or 4
%   I,Q,F = intensity, coherence and frequency
%   If equals to NaN means that there is an error
    disp('Motif Analysis...');
    I = NaN;
    Q = NaN;
    F = NaN;
    if(num_motifs == 3)
        [I,Q,F] = motif3funct_wei(t_matrix);
    elseif(num_motifs == 4)
        [I,Q,F] = motif4funct_wei(t_matrix);
    end
end

function [F,f] = compute_bin(t_matrix,num_motifs)
%COMPUTE : calculate motifs of the matrix
%   Input: 
%   t_matrix = thresholded matrix
%   num_motifs = number of motifs, either 3 or 4
%   I,Q,F = intensity, coherence and frequency
%   If equals to NaN means that there is an error
    disp('Motif Analysis...');
    F = NaN;
    f = NaN;
    if(num_motifs == 3)
        [F,f] = motif3funct_bin(t_matrix);
    elseif(num_motifs == 4)
        [F,f] = motif4funct_bin(t_matrix);
    end
end
