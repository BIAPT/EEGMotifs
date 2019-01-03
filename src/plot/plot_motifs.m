function plot_motifs(motifs,normalization)
%PLOT_MOTIFS : Make plots for the I Q F
%   Input: 
%   Intensity,Coherence and Frequency 
%   norm = 1 or 0 means normalization or not

    EEG_info = load('EEG_info.mat');
    EEG_info = EEG_info.EEG_info;

    if(strcmp(motifs.graph_type,"binary"))
        plot_motifs_bin(EEG_info,motifs.node_frequency,motifs.motif_frequency,normalization);
    elseif(strcmp(motifs.graph_type,"weighted"))
        plot_motifs_wei(EEG_info,motifs.node_intensity,motifs.node_coherence,motifs.node_frequency,normalization);
    end
end


function plot_motifs_bin(EEG_info,F,f,norm)

    %% Plot the frequency per node
    figure
    size_m = size(F,1);
    for i = 1:size_m
        if(size_m == 13)
            subplot(4,4,i)
        end

    if(norm == 1)
        F(i,:) = (F(i,:) - mean(F(i,:)))/std(F(:,i));    
    end
    title(['Node Frequency: ',num2str(i)]);
    topoplot(F(i,:),EEG_info.chanlocs,'maplimits','absmax', 'electrodes', 'off');
    colorbar;
    end
    
    %% Plot the motif frequency
    figure
    bar(f)
    title("Motif frequency")
end

function plot_motifs_wei(EEG_info,I,Q,F,norm)
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