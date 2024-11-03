# Bioinformatics Pipelines: Setting Up Workflows

In bioinformatics, a pipeline is a sequence of steps to process data, often involving tools for tasks like quality control, alignment, filtering, and data analysis. Bash scripts are commonly used to set up these workflows for reproducibility and efficiency.

# Skeleton Structure of a Bash Script for a Bioinformatics Pipeline

A typical bash script for a bioinformatics pipeline will contain sections for defining paths, setting parameters, running tools, and handling errors.

1. Shebang and Script Settings

```bash 
#!/bin/bash
set -e
```
#!/bin/bash: Specifies the script should run in the bash shell.
set -e: Stops the script if any command exits with a non-zero status (error), helping avoid partial or faulty results.

2. Define Variables 

```bash 
INPUT_DIR="/path/to/input/files"
OUTPUT_DIR="/path/to/output"
REFERENCE="/path/to/reference/genome.fasta"
THREADS=4
```

Define key paths (e.g., for input files, output, and reference genome) and parameters such as the number of threads

3. Quality Control

```bash 
for file in "$INPUT_DIR"/*.fastq
do
    fastqc "$file" -o "$OUTPUT_DIR/quality_control/"
done
```
Runs FastQC on each .fastq file in the input directory, outputting quality reports to a dedicated folder.

4. Alignment

```bash 
for file in "$INPUT_DIR"/*.fastq
do
    BASENAME=$(basename "$file" .fastq)
    bwa mem -t "$THREADS" "$REFERENCE" "$file" > "$OUTPUT_DIR/${BASENAME}_aligned.sam"
done
```
Aligns each .fastq file to the reference genome using BWA and generates .sam files for each sample.

5. Conversion and Sorting

```bash 
for sam_file in "$OUTPUT_DIR"/*_aligned.sam
do
    BASENAME=$(basename "$sam_file" _aligned.sam)
    samtools view -S -b "$sam_file" | samtools sort -o "$OUTPUT_DIR/${BASENAME}_sorted.bam"
done
```
Converts each .sam file to .bam, sorts it, and saves the output as a sorted .bam file using SAMtools.

6. Variant Calling

```bash 
for bam_file in "$OUTPUT_DIR"/*_sorted.bam
do
    BASENAME=$(basename "$bam_file" _sorted.bam)
    bcftools mpileup -f "$REFERENCE" "$bam_file" | bcftools call -mv -Ov -o "$OUTPUT_DIR/${BASENAME}_variants.vcf"
done
```
Runs BCFtools to call variants on each sorted .bam file and outputs the results as .vcf files.

7. Cleanup 

```bash 
rm "$OUTPUT_DIR"/*_aligned.sam
```
Removes intermediate files (like .sam) to save space, keeping only necessary final outputs.

## Steps to Use the Script

1. Save the Script
2. Make the Script Executable:

```bash 
chmod +x bio_pipeline.sh
```

3. Run the Script:

```bash 
./bio_pipeline.sh
```

[Back to Main Page](./README.md)