function  [matrix,EEG_info] = filter_non_scalp(matrix,EEG_info)
%FILTER_NON_SCALP Summary of this function goes here
%   Detailed explanation goes here
    non_scalp_channel_label = {'E127', 'E126', 'E17', 'E128', 'E125', 'E21', 'E25', 'E32', 'E38', 'E44', 'E14', 'E8', 'E1', 'E121', 'E114', 'E43', 'E49', 'E56', 'E63', 'E68', 'E73', 'E81', 'E120', 'E113', 'E107', 'E99', 'E94', 'E88', 'LM', 'E64', 'E69', 'E74', 'E82', 'E89', 'E95', 'RM', 'E48', 'E119'};

    for i=1:length(non_scalp_channel_label)
        current_label = non_scalp_channel_label{i};
        for j=1:length(EEG_info.chanlocs)
           if(strcmp(EEG_info.chanlocs(j).labels,current_label))
               disp(strcat('Found : ',current_label))
               EEG_info.chanlocs(j) = [];
               matrix(j,:) = [];
               matrix(:,j) = [];
               break;
           end
        end
    end
end
