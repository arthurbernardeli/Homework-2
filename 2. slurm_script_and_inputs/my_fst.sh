# Codes used for the analyses

# unzipping the sequencing and SNP files

gzip -dk glyma.Wm82.gnm2.div.Song_Hyten_2015.vcf.gz

# filtering by chromosome (in this case, chromosome 11)

awk '$1 == "glyma.Wm82.gnm2.Gm11" || /^#/' glyma.Wm82.gnm2.div.Song_Hyten_2015.vcf > chr11.vcf

# checking only chr11 dataset

ls -lh chr11.vcf  # Check file size

head -n 20 chr11.vcf  # View first 20 lines

grep -v "^#" chr11.vcf | wc -l  # Count the number of SNPs

#grep -v "^#" chr11.vcf # View all markers as covariates

grep "^#CHROM" chr11.vcf #View all genotypes/strains

grep "^#CHROM" chr11.vcf | awk '{print NF-9}' #Count the number of genotypes/strains

#Visualizing PIs in the dataset

# check if 5 chinese and 5 russian included in the paper are lines are in the chr11 dataset. 

grep "^#CHROM" chr11.vcf | tr '\t' '\n' | grep -E "PI152361|PI361059B|PI378668|PI639633A|PI639634|PI70242-4|PI79739|PI89001|PI567167|PI567175C" 

# check how many chinese and russian lines included in the paper are lines are in the chr11 dataset. 

grep "^#CHROM" chr11.vcf | tr '\t' '\n' | grep -E "PI152361|PI361059B|PI378668|PI639633A|PI639634|PI70242-4|PI79739|PI89001|PI567167|PI567175C" | wc -l 

# using bcftools to filter the PIs in the dataset

module load bcftools

module list

bgzip -c chr11.vcf > chr11.vcf.gz #compressing for bcftools

tabix -p vcf chr11.vcf.gz #indexing for bcftools

bcftools view -s PI152361,PI361059B,PI378668,PI639633A,PI639634 -o chr11_russian.vcf chr11.vcf.gz #filtering for russian group

bcftools view -s PI70242-4,PI79739,PI89001,PI567167,PI567175C -o chr11_chinese.vcf chr11.vcf.gz #filtering for chinese group

grep "^#CHROM" chr11_russian.vcf #genotype names for russian lines

grep "^#CHROM" chr11_chinese.vcf #genotype names for chinese lines

grep "^#CHROM" chr11_russian.vcf | awk '{print NF-9}' #count the number of russian lines

grep "^#CHROM" chr11_chinese.vcf | awk '{print NF-9}' #count the number of chinese lines

#grep -v "^#" chr11_russian.vcf | head -n 20 #showing snp covariates fir russian lines
 
#grep -v "^#" chr11_chinese.vcf | head -n 20 #showing snp covariates for chinese lines

# compressing and index the filtered files

module load vcftools

bgzip -c chr11_russian.vcf > chr11_russian.vcf.gz #compressing files
bgzip -c chr11_chinese.vcf > chr11_chinese.vcf.gz #compressing files

tabix -p vcf chr11_russian.vcf.gz #indexing files
tabix -p vcf chr11_chinese.vcf.gz #indexing files

# using bcftools to merge indexed files

bcftools merge chr11_russian.vcf.gz chr11_chinese.vcf.gz -o chr11_merged.vcf #merging files

# visualizing the merged file

#grep "^#CHROM" chr11_merged.vcf #checking the merged file content

#grep "^#CHROM" chr11_merged.vcf | cut -f10- #checking the merged file content

grep "^#CHROM" chr11_merged.vcf | awk '{print NF-9}' #checking the merged file content

#grep -v "^#" chr11_merged.vcf | cut -f10- | head -n 20 #checking the merged file content

grep "^#CHROM" chr11_russian.vcf | cut -f10- > russian_list.txt #extracting russian line names

grep "^#CHROM" chr11_chinese.vcf | cut -f10- > chinese_list.txt #extracting chinese line names

cat russian_list.txt #verifying population files

cat chinese_list.txt #verifying population files

echo -e "PI152361\nPI361059B\nPI378668\nPI639633A\nPI639634" > russian_list.txt #correcting tabs to columns

echo -e "PI70242-4\nPI79739\nPI89001\nPI567167\nPI567175C" > chinese_list.txt #correcting tabs to columns

cat russian_list.txt #verifying fix

cat chinese_list.txt #verifying fix

#using vcftools to perform the Fst analyses by chromosome

vcftools --vcf chr11_merged.vcf --keep russian_list.txt --out check_russian_fixed --missing-indv #testing if vcftools recognizes the samples

vcftools --vcf chr11_merged.vcf --keep chinese_list.txt --out check_chinese_fixed --missing-indv #testing if vcftools recognizes the samples

vcftools --vcf chr11_merged.vcf --weir-fst-pop russian_list.txt --weir-fst-pop chinese_list.txt --out fst_russian_vs_chinese_chr11 #run FST analyses

head fst_russian_vs_chinese_chr11.weir.fst #checking snp-specific fst values ##check 10 individual snp-specific FST

awk 'NR>1 && $3 != "-nan" {print $2, $3; sum+=$3; count+=1} 
     END {if (count > 0) print "Mean_Fst =", sum/count > "fst_mean11.txt"; else print "No valid Fst values" > "fst_mean11.txt"}' \
     fst_russian_vs_chinese_chr11.weir.fst > fst_per_snp11.txt #remove NaN, save mean fst, and save per snp fst

# Plotting the histogram Fst x SNP position by chromosome

module load R
R

plot_fst_barplot <- function(file_path, mean_fst_path, output_path) {
  # Load FST data
  data <- read.table(file_path, header = FALSE)
  colnames(data) <- c("SNP_Position", "FST_Value")
  
  # Load mean FST value
  mean_fst <- readLines(mean_fst_path)
  mean_fst_value <- as.numeric(sub("Mean_Fst = ", "", mean_fst))  # Extract numerical value
  
  # Sort data by SNP position
  data <- data[order(data$SNP_Position), ]
  
  # Determine label positions: Select SNPs at roughly 500,000 intervals
  interval <- 500000
  tick_positions <- seq(min(data$SNP_Position), max(data$SNP_Position), by = interval)
  
  # Find the closest SNPs in the dataset to these tick positions
  label_indices <- sapply(tick_positions, function(x) which.min(abs(data$SNP_Position - x)))
  
  # Save plot as PNG
  png(output_path, width = 1200, height = 700)  # Increased height for better spacing
  
  # Create bar plot
  bar_positions <- barplot(data$FST_Value, 
                           col = "lightblue", 
                           border = "black",
                           xlab = "",  # Remove default X-axis title to reposition it manually
                           ylab = "FST Value",
                           main = "FST Values Across SNP Positions - Chr11",
                           cex.main = 2,
                           cex.names = 0.8)  # No X labels here, added manually later
  
  # Add manually selected X-axis labels
  axis(1, at = bar_positions[label_indices], 
       labels = data$SNP_Position[label_indices], 
       las = 2, cex.axis = 0.7)
  
  # Add X-axis title lower in the image
  mtext("SNP Position", side = 1, line = 4, cex = 1.2)  # Adjust line to move lower
  
  # Add a horizontal line for the mean FST value
  abline(h = mean_fst_value, col = "red", lwd = 2, lty = 2)
  
  # Add subtitle with dynamic mean Fst value in bigger font
  mtext(paste("Mean Fst =", mean_fst_value), side = 3, line = 0.5, cex = 1.5, col = "red", font = 2, adj = 1)
  
  dev.off()
}

# Call the function with the full paths to your files
plot_fst_barplot("/work/unlsbp/arthurbern/Homework 2/slurm_script_and_inputs/fst_per_snp11.txt",  
                 "/work/unlsbp/arthurbern/Homework 2/slurm_script_and_inputs/fst_mean11.txt",
                 "/work/unlsbp/arthurbern/Homework 2/slurm_script_and_inputs/fst_barplot11.png" )