%% TODO: filter the dPLI given an EEG_info struct and a matrix

% Step 1: Create the structure of label to remove. (X)

% Step 2: Use the structure to filter out a loaded EEG_info structure and a
% dpli matrix

% Load the array
data = load('plot/non_scalp_channel_label.mat');
non_scalp_channel_label = data.non_scalp_channel_label;

