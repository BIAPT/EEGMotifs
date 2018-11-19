function [t_matrix] = threshold(matrix,analysis_type,is_binary,thresh)
%THRESHOLD Summary of this function goes here
%   Detailed explanation goes here
    if(is_binary)
        t_matrix = threshold_binary(matrix,analysis_type,thresh)
    else
       t_matrix = threshold_weighted(matrix,analysis_type); 
    end
end

function [t_matrix] = threshold_binary(matrix,type,threshold)
    t_matrix = NaN;
    if(strcmp(type,'dpli'))
        size_m = length(matrix);
        t_matrix = zeros(size_m,size_m);
        
        A = sort(matrix); % sort pli
        B = sort(matrix(:)); % sort all value in A
        index = floor(length(B)*(1-threshold)); 
        threshold_value = B(index);
        t_matrix = matrix;
        t_matrix(t_matrix < threshold_value) = 0;
        t_matrix(t_matrix >= threshold_value) = 1;
       
    elseif(strcmp(type,'nste')) %% TODO here I didn't change the code just yet
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
        
        t_matrix = (t_matrix-minimum)/(maximum-minimum);        
    end
   
end

function [t_matrix] = threshold_weighted(matrix,type)
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
       
        threshold_value = 0;
        abs_matrix = t_matrix;
        abs_matrix(t_matrix <= threshold_value) = 0;
        abs_matrix(t_matrix > threshold_value) = 1;

        t_matrix = t_matrix.*abs_matrix; %Put everything that fail the threshold to 0
        t_matrix = t_matrix./2; %to be simlar to dpli
        %Have everything between 0 and 1
        minimum = min(t_matrix(:));
        maximum = max(t_matrix(:));

        t_matrix = (t_matrix-minimum)/(maximum-minimum);        

    end
   
end
