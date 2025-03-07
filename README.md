# Homework-2
- Description of Homework 2 file, analyses, and results as part of the AGRO932 course.
- Professor: Dr. Jinliang Yang. 
- PhD Candidate: Arthur Bernardeli.

**The items and subitems described below follow the same structure when navigating the Homework 2 directory.**

## 1. misc_files
- **AGRO-932 Homework 2.docx**: Homework 2 assigned by Dr. Jinliang Yang.  
- **Homework 2 codes.txt**: TXT file containing R notebook codes.  
- **homework_2 notebook.Rmd**: R file containing R notebook codes.  

## 2. slurm_script_and_inputs
- **glyma.Wm82.gnm2.div.Song_Hyten_2015.vcf**: Soybean 50K SNP chip available at [SoyBase](https://www.soybase.org) (uncompressed).  
- **glyma.Wm82.gnm2.div.Song_Hyten_2015.vcf.gz**: Soybean 50K SNP chip available at [SoyBase](https://www.soybase.org) (compressed).  
- **glyma.Wm82.gnm2.DTC4.genome_main.fna.gz**: Soybean reference genome version 2 based on Williams 82 accession available at [SoyBase](https://www.soybase.org) (compressed).  
- **my_fst.sh**: Bash file containing codes used to run FST calculations.
- **my_fst.txt**: Text file containing codes used to run FST calculations (same as my_fst.sh).  
- **submit_script.slurm**: Slurm file used to execute the Bash code (`my_fst.sh`) through the UNL HCC cluster.  
- **usda_PIs.xls**: List of 321 PIs from Zhang et al. (2017) used in the scan study.
- **Zhang et al 2017.pdf**: Manuscript used in this homework. The authors scanned USDA soybean PI accessions from different regions of origin to examine differentiation in seed composition traits  

## 3. log
Folder containing the analysis log files showing success or failure of the `my_fst.sh` execution using `submit_script.slurm` command.

## 4. results - plots and fst_values (by_chr)
This folder contains plots (figures) of FST values by chromosome across SNP positions, as well as FST values by position by chromosome and mean FST value by chromosome. See examples below:

- **fst_barplot1.png**: FST values plotted against SNP positions for chromosome 9. `fst_barplot` plots are available for all chromosomes.  
- **fst_per_snp1.txt**: FST value per SNP for chromosome 9. `fst_per_snp` results are available for all chromosomes.  
- **fst_mean9.txt**: Mean FST value across all SNPs for chromosome 9. `fst_mean` results are available for all chromosomes.  

## 5. results - assignment answers (R_notebook_file)
Contains R notebook files with the answers to the assignment.