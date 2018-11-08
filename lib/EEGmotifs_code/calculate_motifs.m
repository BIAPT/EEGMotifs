function [Intensity,Coherence,Frequency] = calculate_motifs(matrix,type,thresh,num_motifs,isPlot,normalize)
%CALCULATE_MOTIFS : 
%Calculate the frequency, intensity and coherence of a dpli or NSTE matrix 
%[Intensity,Coherence,Frequency] = calculate_motifs(matrix,type,num_motifs)
%   Input: Mahdid Y. Automatic Pipeline for EEG Network Processing, McGill Neuroscience Undergraduate Students Research Event, Montreal, Quebec, March 2017. I presented the EEGapp software to neuroscience undergraduates at McGill University. 
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
Intensity = NaN;
Coherence = NaN;
if(strcmp(type,'dpli') || strcmp(type,'nste'))
    %% Thresholding
    matrix = threshold(matrix,type,thresh);
    if(isnan(matrix))
        error('ERROR in THRESHOLD');
        return;
    end
    
    %% Motif Caculations
    [Intensity,Coherence,Frequency] = compute(matrix,num_motifs);
    if(isnan(Intensity))
        error('NUMBER OF MOTIFS NOT EQUAL TO 3 OR 4');
        return;
    end
    
    %% plotting
    if(num_motifs == 4 && isPlot == 1)
        error("CAN'T PLOT F,I,C for MOTIF =4, THE PLOT WOULD BE TOO TINY!")
    elseif(isPlot == 1)
       plot_motifs(Intensity,Coherence,Frequency,normalize) 
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

function [t_matrix] = threshold(matrix,type,thresh)
%THRESHOLD : threshold a matrix between 0 and 1
%   Input: 
%   matrix = dPLI or NSTE matrix obtained from EEGapp
%   type = 'nste' or 'dpli'
%   num_motifs = 3 or 4, depending if we want 3 or 4 motifs
%   Output:
%   thresholded matrix between 0 and 1
%   if an error occured the t_matrix will return NaN


    disp('Thresholding...');
    t_matrix = NaN;
    if(strcmp(type,'dpli'))
        size_m = length(matrix);
        t_matrix = zeros(size_m,size_m);
        
        %Here we make a matrix of phase lead bounded from 0 to 1
        for i = 1:size_m
            for j = 1:size_m
                if(i == j)
                    t_matrix(i,j) = 0;
                elseif(matrix(i,j) <= 0.5)
                   t_matrix(i,j) = 0; 
                else
                    t_matrix(i,j) = (matrix(i,j) - 0.5)*2;
                end
            end
        end
    elseif(strcmp(type,'nste'))
       size_m = length(matrix);
       t_matrix = zeros(size_m,size_m);
       for i = 1:size_m
          for j = 1:size_m
            %Feedback = frontal to parietal NSTE
            %Feedforward = parietal to frontal NSTE
            %Asymmetry = (FB - FF)/(FB + FF)
            FB = matrix(i,j);
            FF = matrix(j,i);
            t_matrix(i,j) = (FB-FF)/(FB+FF);
          end
       end
       assignin('base','ass_matrix',t_matrix);
       
        size_to_keep = size(t_matrix,1);
        size_to_keep = floor(size_to_keep*size_to_keep*thresh);
        sorted_vector = sort(t_matrix(:));

        threshold_value = sorted_vector(size_to_keep); %Get the right threshold value
        if(threshold_value < 0)
           threshold_value = 0; 
        else
            threshold_value = 0;
        end
        abs_matrix = t_matrix;
        abs_matrix(t_matrix <= threshold_value) = 0;
        abs_matrix(t_matrix > threshold_value) = 1;

        t_matrix = t_matrix.*abs_matrix; %Put everything that fail the threshold to 0
        t_matrix = t_matrix./2; %to be simlar to dpli
        %Have everything between 0 and 1
        minimum = min(t_matrix(:));
        maximum = max(t_matrix(:));
        assignin('base','pretest',t_matrix);
        t_matrix = (t_matrix-minimum)/(maximum-minimum);        
        assignin('base','test',t_matrix);
    end
    
   
end

function [I,Q,F] = compute(t_matrix,num_motifs)
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

function plot_motifs(I,Q,F,norm)
%PLOT_MOTIFS : Make plots for the I Q C
%   Input: 
%   Intensity,Coherence and Frequency 
%   norm = 1 or 0 means normalization or not

EEG_info= load('EEG_info.mat');
EEG_info = EEG_info.EEG_info;
figure
size_m = size(Q,1);
for i = 1:size_m
    if(size_m == 13)
    subplot(4,4,i)
    else
        
    end
    
if(norm == 1)
    I(i,:) = (I(i,:) - mean(I(i,:)))/std(I(:,i));    
end
title(['I: ',num2str(i)]);
topoplot(I(i,:),EEG_info.chanlocs,'maplimits','absmax', 'electrodes', 'off');
colorbar;
end

figure
for i = 1:size_m
    if(size_m == 13)
    subplot(4,4,i)
    else
        
    end
if(norm == 1)
    Q(i,:) = (Q(i,:) - mean(Q(i,:)))/std(Q(:,i));    
end    
title(['Q: ',num2str(i)]);
topoplot(Q(i,:),EEG_info.chanlocs,'maplimits','absmax', 'electrodes', 'off');
colorbar;
end

figure
for i = 1:size_m
    if(size_m == 13)
    subplot(4,4,i)
    else
        
    end
if(norm == 1)
    F(i,:) = (F(i,:) - mean(F(i,:)))/std(F(:,i));    
end    
title(['F: ',num2str(i)]);
topoplot(F(i,:),EEG_info.chanlocs,'maplimits','absmax', 'electrodes', 'off');
colorbar;
end
end
