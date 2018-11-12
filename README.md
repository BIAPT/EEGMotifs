# EEGMotifs
<p> Uses the <a href=https://sites.google.com/site/bctnet/>BCT toolbox</a></p>
<p> Parallele computing can be used (multi core = faster) </p>

Step to make motif_analysis.mlapp work:
1) add the whole folder to your MATLAB path
2) double click on motif_analysis.mlapp
3) run the analysis


How to plot the motifs (ONLY for num_motif = 3):
1) Load your motifs data structure by double clicking on one of the output of motif_analysis.mlapp
2) call this function on the cmd line: plot_motifs(I,Q,F,norm),
where I = motifs.I , Q = motifs.Q, F = motifs.F and norm = 1 if you want to normalize the outputs*.
3) This will output 3 plots 

*normalization: (I,Q or F - mean(I,Q or F)) / std(I,Q or F)
