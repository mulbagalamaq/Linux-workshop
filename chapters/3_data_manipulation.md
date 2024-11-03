# Data Manipulation with Bash: Automating Tasks and Processing Datasets

## Introduction

In this section, we will explore how to automate tasks and process datasets using Bash. We will focus on the pipe operator and for loops, which are powerful tools for data manipulation in Linux.

## The Pipe Operator

The pipe operator (|) allows you to send the output of one command as input to another command. This is useful for chaining commands together to process data efficiently.

Suppose you want to count the number of files in a directory:

```bash 
ls -l | wc -l
```

- ls -l: Lists files in long format.
- wc -l: Counts the number of lines (in this case, the number of files).

Some Basic commands with the pipe operator:

Using grep to Filter Output:

```bash 
ps aux | grep python
```
- ps aux lists all running processes.
- grep python filters for lines containing "python", showing only processes related to Python.

Sorting and Removing Duplicates:

```bash 
cat file.txt | sort | uniq
```
- cat file.txt outputs the file contents.
- sort organizes the lines alphabetically.
- uniq removes consecutive duplicate lines, giving unique sorted entries.

## for Loop in Bash

The for loop in Bash lets you repeat commands over multiple items, such as files in a directory. This is particularly useful for batch-processing datasets.

Basic For Loop Syntax:

```bash 
for item in list
do
    command $item
done
```

Example:

```bash 
for file in *.txt
do
    echo "Processing $file"
done
```

- file iterates over each .txt file in the current directory (using the *.txt wildcard).
- The command echo "Processing $file" prints out the name of each file being processed.

Processing Multiple Files in a Directory

```bash 
for file in *.txt
do
    grep "keyword" "$file" | sort | uniq > "processed_$file"
done
```

- for file in *.txt iterates over each .txt file.
- grep "keyword" "$file" filters lines containing "keyword".
- sort | uniq removes duplicate lines.
- ' > "processed_$file" '  writes the result to a new file with the prefix "processed_".


[Back to Main Page](./README.md)