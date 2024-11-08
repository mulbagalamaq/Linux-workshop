#!/usr/bin/bash
#SBATCH --partition=express              # Use express partition
#SBATCH --job-name=Basic_RNAseq          # Name the job
#SBATCH --time=00:15:00                  # Time limit set to 15 mins for the pipeline
#SBATCH -N 2                             # Request 2 nodes
#SBATCH -n 16                            # Number of tasks per node
#SBATCH --mem=32Gb                       # Memory allocation
#SBATCH --exclusive                      # Exclusive node usage
#SBATCH --output="basic-batch-%x-%j.output"    # Output file
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mulbagal.a@northeastern.edu

# Start benchmarking
start_total=$(date +%s)
echo "Starting basic RNA-seq analysis at $(date)"

# Step 1: Set up the virtual environment and install required packages
echo "Setting up virtual environment GBBA-LINUX-ENV"
python3 -m venv GBBA-LINUX-ENV
source GBBA-LINUX-ENV/bin/activate

echo "Installing necessary packages"
pip install numpy || { echo "Installation failed"; exit 1; }

# Step 2: Create required directories
echo "Creating necessary directories for raw reads and results"
mkdir -p data/rawreads results/fastqc

# Step 3: Download Raw Reads
start_step=$(date +%s)
echo "Downloading raw reads at $(date)"
wget -q -O data/rawreads/sample_1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR000/SRR000001/SRR000001.fastq.gz || { echo "Download of sample_1 failed"; exit 1; }
wget -q -O data/rawreads/sample_2.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR000/SRR000002/SRR000002.fastq.gz || { echo "Download of sample_2 failed"; exit 1; }
end_step=$(date +%s)
echo "Download step took $(($end_step - $start_step)) seconds."

# Step 4: Quality Check using FastQC
start_step=$(date +%s)
echo "Running FastQC on raw reads at $(date)"
wget -q "https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip" -O FastQC.zip && unzip -o FastQC.zip
chmod +x FastQC/fastqc
./FastQC/fastqc data/rawreads/*.fastq.gz -o results/fastqc/ || { echo "FastQC failed"; exit 1; }
end_step=$(date +%s)
echo "FastQC step took $(($end_step - $start_step)) seconds."

# Step 5: Aggregate FastQC Summary Results
start_step=$(date +%s)
echo "Aggregating FastQC summary results at $(date)"
{
    echo "FastQC Summary Report"
    echo "---------------------"
    for file in results/fastqc/*_fastqc/summary.txt; do
        echo ""
        echo "Summary for $(basename $file):"
        cat "$file"
    done
} > results/fastqc_summary_report.txt
end_step=$(date +%s)
echo "Aggregation step took $(($end_step - $start_step)) seconds."

# Step 6: Basic Sequence Count Analysis with AWK
start_step=$(date +%s)
echo "Counting sequences in the raw data using AWK at $(date)"
sequence_count_1=$(zcat data/rawreads/sample_1.fastq.gz | awk 'NR%4==1' | wc -l)  # Count sequences in sample_1
sequence_count_2=$(zcat data/rawreads/sample_2.fastq.gz | awk 'NR%4==1' | wc -l)  # Count sequences in sample_2
echo "Total sequences in raw sample_1: $sequence_count_1"
echo "Total sequences in raw sample_2: $sequence_count_2"
end_step=$(date +%s)
echo "Sequence counting step took $(($end_step - $start_step)) seconds."

# Step 7: Compile Results
echo "Compiling results into results/summary_report.txt"
{
    echo "Basic RNA-Seq Analysis Summary Report"
    echo "---------------------------------"
    echo "Date: $(date)"
    echo ""
    echo "1. Raw Reads Downloaded:"
    echo "  - Sample 1: data/rawreads/sample_1.fastq.gz"
    echo "  - Sample 2: data/rawreads/sample_2.fastq.gz"
    echo ""
    echo "2. FastQC Analysis:"
    echo "  - FastQC results are stored in results/fastqc/"
    echo "  - FastQC summary report: results/fastqc_summary_report.txt"
    echo ""
    echo "3. Sequence Count in Raw Data:"
    echo "  - Total sequences in sample_1: $sequence_count_1"
    echo "  - Total sequences in sample_2: $sequence_count_2"
} > results/summary_report.txt

# Total time
end_total=$(date +%s)
echo "Total time: $(($end_total - $start_total)) seconds."
echo "Analysis completed at $(date)"

# Deactivate and clean up environment
deactivate
echo "Virtual environment deactivated."
