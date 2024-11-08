# FastQC Slurm Job README 

## Overview

This repository contains an `sbatch` script designed to submit jobs to a high-performance computing (HPC) cluster managed by the Slurm workload manager. The script configures resource allocation and scheduling parameters for running a job on the cluster.

## Table of Contents

1. [Script File](#script-file)
1. [Purpose](#purpose)
1. [Script Parameter](#script-parameters)
1. [Usage](#usage)
1. [Script Breakdown](#script-breakdown)
1. [Benchmarking and Cleanup](#benchmarking-and-cleanup)
1. [Expected Output](#expected-output)


## Script File

- **File**: `sbatch_tutorial.sh`

## Purpose

The `sbatch` script in this repository is intended to:
1. Allocate resources (e.g., CPU, memory, time).
2. Load necessary modules and set up the environment.
3. Download raw reads, do quality check using FastQC and Summarize the results.

## Script Parameters

The script includes key Slurm directives for job customization:

- **`--job-name`**: Sets the job name for identification in the job queue.
- **`--partition`**: Specifies the partition or queue to submit the job to.
- **`--ntasks` or `-n`**: Defines the number of tasks per node.
- **`--mem`**: Memory allocated per node or per core.
- **`--time`**: Maximum runtime for the job in `DD-HH:MM:SS` format.
- **`--output`**: Path for saving the standard output of the job.
- **`--error`**: Path for saving the standard error of the job.
- **`--mail-type`**: Specifies the type of email
- **`--mail-user`**: Specifies who to email

### Example
```bash
#SBATCH --partition=express              # Use express partition
#SBATCH --job-name=Basic_RNAseq          # Name the job
#SBATCH --time=00:15:00                  # Time limit set to 15 mins for the pipeline
#SBATCH -N 2                             # Request 2 nodes
#SBATCH -n 16                            # Number of tasks per node
#SBATCH --mem=32Gb                       # Memory allocation
#SBATCH --exclusive                      # Exclusive node usage
#SBATCH --output="basic-batch-%x-%j.output"    # Output file
#SBATCH --output="basic-batch-%x-%j.err"       # Error file
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=<user-name>@northeastern.edu
```

## Usage

### Submitting the Job

To submit the job to the Slurm scheduler, use:
```bash
sbatch sbatch_tutorial.sh
```

### Checking Job Status

After submission, check the status of your job with:
```bash
squeue -u $USER
```

### Canceling the Job

To cancel a job, use:
```bash
scancel <job_id>
```

### Customizing the Script

1. Adjust resource requirements as needed.
2. Update paths for `output`, `error`, or any specific modules you need to load.

## Example Workflow

1. **Edit** `job_submit.sbatch` to set job-specific parameters.
2. **Submit** the job with `sbatch job_submit.sbatch`.
3. **Monitor** job status using `squeue` or `sacct`.
4. **Review** output and error files generated after completion.

## Script Breakdown
### Step 1: Set up the Virtual Environment and Install Required Packages

This section of the `sbatch` script sets up a virtual environment and installs necessary Python packages.

```bash
echo "Setting up virtual environment GBBA-LINUX-ENV"
python3 -m venv GBBA-LINUX-ENV
source GBBA-LINUX-ENV/bin/activate

echo "Installing necessary packages"
pip install numpy || { echo "Installation failed"; exit 1; }
```

- Setting up an virtual enviroment `GBBA-LINUX-ENV` with `python3 -m venv` and activating it using `source`. 
- Installs the numpy package using `pip install numpy`.
- The `||` operator checks if pip install fails, printing "Installation failed" and exiting the script with an error code.

### Step 2: Create required directories

This section of the `sbatch` script creates directories using `mkdir`

```bash
echo "Creating necessary directories for raw reads and results"
mkdir -p data/rawreads results/fastqc
```

### Step 3: Download Raw Reads

This section of the `sbatch` script downloads the FASTQ file using the `wget` command. 

`wget` is a used to download files from the internet. It supports various protocols like HTTP, HTTPS, and FTP, making it ideal for retrieving data files, scripts, and software directly to a local or remote server

```bash
start_step=$(date +%s)
echo "Downloading raw reads at $(date)"
wget -q -O data/rawreads/sample_1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR000/SRR000001/SRR000001.fastq.gz || { echo "Download of sample_1 failed"; exit 1; }
wget -q -O data/rawreads/sample_2.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR000/SRR000002/SRR000002.fastq.gz || { echo "Download of sample_2 failed"; exit 1; }
end_step=$(date +%s)
echo "Download step took $(($end_step - $start_step)) seconds."
```

### Step 4: Quality Check using FastQC

This section of the `sbatch` script is to quality check using [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/). 

```bash
start_step=$(date +%s)
echo "Running FastQC on raw reads at $(date)"
wget -q "https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip" -O FastQC.zip && unzip -o FastQC.zip
chmod +x FastQC/fastqc
./FastQC/fastqc data/rawreads/*.fastq.gz -o results/fastqc/ || { echo "FastQC failed"; exit 1; }
end_step=$(date +%s)
echo "FastQC step took $(($end_step - $start_step)) seconds."
```

- We download the software using `wget` and `unzip` it. 
- `&&` is used between these `wget` and `unzip` to chain these commands, i.e. it ensures that the next command only runs if the previous command completes successfully. 
-  `chmod` is a command-line utility used to change the permissions of files and directories in Unix/Linux systems. It allows you to specify who can read, write, or execute a file or directory by modifying its permission settings. 

[Refer here]() for more details.   

### Step 5: Aggregate FastQC Summary Results

This section of the `sbatch` script consolidates the summary reports from multiple FastQC analyses and displays in the output file. 

```bash
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
```
### Step 6: Basic Sequence Count Analysis with AWK

This section of the `sbatch` script ......

```bash
start_step=$(date +%s)
echo "Counting sequences in the raw data using AWK at $(date)"
sequence_count_1=$(zcat data/rawreads/sample_1.fastq.gz | awk 'NR%4==1' | wc -l)  # Count sequences in sample_1
sequence_count_2=$(zcat data/rawreads/sample_2.fastq.gz | awk 'NR%4==1' | wc -l)  # Count sequences in sample_2
echo "Total sequences in raw sample_1: $sequence_count_1"
echo "Total sequences in raw sample_2: $sequence_count_2"
end_step=$(date +%s)
echo "Sequence counting step took $(($end_step - $start_step)) seconds."
```
### Step 7: Compile Results

The final section compliles all the rresults and displays a consolidated summary. Refer [Exptected Outcome](#expected-output) on how this section would display the output. 


```bash
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
```

## Benchmarking and Cleanup

This step is crucial for tracking and optimizing the runtime of the RNA-seq analysis, enabling better resource management and performance assessment. It also ensures a clean environment reset, which is essential for consistent and error-free future runs.

```bash
# Start benchmarking
start_total=$(date +%s)
echo "Starting basic RNA-seq analysis at $(date)"

...

# Total time
end_total=$(date +%s)
echo "Total time: $(($end_total - $start_total)) seconds."
echo "Analysis completed at $(date)"

# Deactivate and clean up environment
deactivate
echo "Virtual environment deactivated."
```

- **Start Time**: Captures the start time with `start_total=$(date +%s)` and logs the start of the RNA-seq analysis.

- **Total Time Calculation**: After the analysis completes, calculates the total elapsed time with `end_total=$(date +%s)` and displays the result in seconds.

- **Cleanup**: Deactivates the virtual environment and logs its deactivation, ensuring the environment is reset after the job completes.

## Expected Output

### Step 1
```
Starting basic RNA-seq analysis at Thu Nov  7 19:30:14 EST 2024
Setting up virtual environment GBBA-LINUX-ENV
Installing necessary packages
Collecting numpy
  Using cached numpy-2.1.3-cp312-cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl.metadata (62 kB)
Using cached numpy-2.1.3-cp312-cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (16.0 MB)
Installing collected packages: numpy
Successfully installed numpy-2.1.3
```
### Step 2 
```
Creating necessary directories for raw reads and results
```
### Step 3
```
Downloading raw reads at Thu Nov  7 19:30:41 EST 2024
Download step took 8 seconds.
```
### Step 4

```
Running FastQC on raw reads at Thu Nov  7 19:30:49 EST 2024
Archive:  FastQC.zip
... 
Analysis complete for sample_1.fastq.gz
Analysis complete for sample_2.fastq.gz
FastQC step took 12 seconds.
```
### Step 5
```
Aggregating FastQC summary results at Thu Nov  7 19:31:01 EST 2024
Aggregation step took 0 seconds.
```

### Step 6
```
Counting sequences in the raw data using AWK at Thu Nov  7 19:31:01 EST 2024
Total sequences in raw sample_1: 236003
Total sequences in raw sample_2: 196876
Sequence counting step took 2 seconds.
```

### Step 7
```
Compiling results into results/summary_report.txt
Total time: 49 seconds.
```

### Clean up
```
Analysis completed at Thu Nov  7 19:31:03 EST 2024
Virtual environment deactivated.
```


---

This README provides a basic guide to work with an `sbatch` file on Discovery. For further customization, refer to the [Slurm documentation](https://slurm.schedmd.com/documentation.html) and for help with discovery, refer to the [RC Documentatio](https://rc-docs.northeastern.edu/en/latest/). 
