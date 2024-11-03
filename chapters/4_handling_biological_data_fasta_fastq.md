
# Handling Biological Data: Managing FASTA/FASTQ Files on Linux (Awk & Grep)

## Table of Contents
- [FASTA/FASTQ Basics](#fasta-fastq-basics)
- [AWK for FASTA/FASTQ Files](#awk-for-fasta-fastq-files)
- [Grep with Regular Expressions](#grep-with-regular-expressions)

---

## FASTA/FASTQ Basics

### FASTA Format
- **Header**: Starts with `>` followed by the sequence name.
- **Sequence**: Biological sequence data (DNA, RNA, or protein).

Example:
```
>sequence_1
ATCGATCGATCG
```

### FASTQ Format
- **4 Lines**:
  1. `@sequence_id`
  2. Sequence data
  3. `+` (optional sequence description)
  4. Quality score data

Example:
```
@sequence_1
ATCGATCGATCG
+
IIIIIIIIIIII
```

---

## AWK for FASTA/FASTQ Files

### 1. **Print Sequence Headers in FASTA**
```bash
awk '/^>/ {print $0}' file.fasta
```

### 2. **Extract Sequences (No Headers)**
```bash
awk '/^>/ {next} {print}' file.fasta
```

### 3. **Count Number of Sequences in FASTA**
```bash
awk '/^>/ {count++} END {print count}' file.fasta
```

### 4. **Print Sequence IDs in FASTQ**
```bash
awk 'NR % 4 == 1' file.fastq
```

### 5. **Extract Quality Scores from FASTQ**
```bash
awk 'NR % 4 == 0' file.fastq
```

---

## Grep with Regular Expressions

### 1. **Search for Specific Sequence Pattern in FASTA/FASTQ**
```bash
grep -B 1 "ATCG" file.fasta   # Finds sequence "ATCG" and prints the sequence header
grep -A 2 "ATCG" file.fastq   # Finds sequence "ATCG" and shows next 2 lines (quality score)
```

### 2. **Search for Specific Header in FASTA**
```bash
grep "^>sequence_1" file.fasta
```

### 3. **Count Specific Sequences Containing a Pattern**
```bash
grep -c "ATCG" file.fasta
```

### 4. **Find Sequences Matching a Regular Expression**
```bash
grep -E "A{4,}" file.fasta     # Sequences with 4 or more consecutive "A"s
```

### 5. **Inverse Match (Exclude Lines with a Pattern)**
```bash
grep -v "ATCG" file.fasta
```

---

## Combined AWK & Grep Commands

### 1. **Extract Sequences with a Specific Length in FASTA**
```bash
awk 'BEGIN {RS=">"; ORS=""} length($2) > 100 {print ">" $0}' file.fasta
```

### 2. **Search for Sequences Matching a Pattern and Print Full Entry**
```bash
grep -A 1 "ATCG" file.fasta | awk 'BEGIN {RS=">"} NR > 1 {print ">" $0}'
```

---

## summarize 
- **Awk** is ideal for line-based operations and column extraction.
- **Grep** is fast for pattern matching using regular expressions.


[Back to Main Page](./README.md)
