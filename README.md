# Helianthus_diversity
This repository contains scripts and filtered data for Baute et al., 2016.

## ABBA-BABA
*ABBA_BABA.v1.pl*: Calculates the components of Patterson's D statistic and Fd for each site.
*ABBA_BABA_pipe.sh*: Runs all parts of the ABBA-BABA test for a single set of populations/species
*ABBA_out_blocker.pl*: Summarizes Patterson's D statistic and Fd for genomic blocks
*ABBA_pvalue.R*: Calculates a p-value for ABBA-BABA tests
*Jacknife_ABBA_pipe.R*: Jackknife bootstraps genomic blocks for ABBA-BABA tests
*plot_abba_baba.R*: Plots figure for ABBA-BABA

## SNP calling
*alignment_pipe.bash*: Alignment and bam file processing 
*run_freebayes_singlecore.sh*: SNP calling using freebayes
*fbvcf2filtergenotypecount.pl*: Filter freebayes vcf for read count
*fbvcf2tab_full.pl*: Convert vcf to flat tab format
*snp_label_rows.pl*: Estimates missing data, heterozygosity and MAF for all sites

## Phylogenetics
*plot_phylogeny.R*: Plot phylogeny for supplementary figure 1

## Diversity
*SNPtable2NeiD.pl*: Calculates Nei's D for species
*jackknife_neiD.pl*: Jackknife estimates of Nei's D

##PCA
*PCA.R*: Principal component analysis and plotting
*PCA_introgression.R*: Analysis of PCA connection to introgression
*SNPtable2checkPCintrogression.pl*: Examines allele frequency for sites identified in PCA
