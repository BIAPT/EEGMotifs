%% TODO: investigate how to calculate the std properly using a 129 000x13 matrices.
rand_network = motifs.rand_frequency;
number_rand_network = 100;
cat_rand_network = rand_network(1,:,:);
for i = 2:number_rand_network
    cat_rand_network = cat(3,cat_rand_network,rand_network(i,:,:));
end
cat_rand_network = squeeze(cat_rand_network);

std_rand_network = std(cat_rand_network');

mean_rand_network = mean(cat_rand_network');