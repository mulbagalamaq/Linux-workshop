# Linux Navigation and File Management

In this chapter, we will delve upon basic commands in Linux.      

Why is Linux important? Most of the cloud systems use Linux shells and knowing basic commands can help you navigate within the servers and work with files and folders within it. 

**Note**: Before we begin, connect to a Linux Server. If you are a Northeastern Student - you will have access to [Discovery](https://rc-docs.northeastern.edu/en/latest/index.html). Connect to Discovery using SSH and continue. 

# Basics

Let's look at the **3 MOST BASIC COMMANDS** that every Linux user should know - `pwd`, `ls` and `cd`, followed by commands to **create, move, copy or remove a file/directory** and file editing commands - `nano` and `vim`.

## Find the Current dir using `pwd`

`pwd` - To know where what your current directory is, simply run the code `pwd`. 
```shell
pwd
```
```shell
/home/username
```

## List the contents of dir using `ls`

Now to find that are present within the current directory, you can simply use the command `ls`

```shell
ls
```
```shell
GBBA  math7340  ondemand  project110  R
```
Now there are multiple flags that can be used with `ls`. Some useful ones are `ls -a` for displaying all files (hidden files included) and `ls -l` to display the files in 'long'-view. 

```shell
ls -a
```
```shell
.              .conda              .java       .nextflow        .singularity
..             .condarc            .jupyter    .nextflow.log    .ssh
.bash_history  .config             .kshrc      .nextflow.log.1  .viminfo
.bash_logout   .emacs              .local      .nextflow.log.2
.bash_profile  GBBA                .local-off  ondemand
.bashrc        .ipynb_checkpoints  math7340    project110
.cache         .ipython            .ncbi       R
```
```shell
ls -l
```
```shell
drwxr-xr-x 2 sample.s users 4096 Jul 31 12:21 GBBA
drwxr-xr-x 2 sample.s users 4096 Sep 10 22:41 math7340
drwxr-xr-x 2 sample.s users 4096 Mar 21  2024 ondemand
drwxr-xr-x 2 sample.s users 4096 Sep 14 14:03 project110
drwxr-xr-x 2 sample.s users 4096 Apr 18  2024 R
```
PRO TIP: If you are unsure of the flags each commands have - you can always use the flag `--help`
```shell
ls --help
```
```shell
Usage: ls [OPTION]... [FILE]...
List information about the FILEs (the current directory by default).
Sort entries alphabetically if none of -cftuvSUX nor --sort is specified.

Mandatory arguments to long options are mandatory for short options too.
  -a, --all                  do not ignore entries starting with .
  -A, --almost-all           do not list implied . and ..
      --author               with -l, print the author of each file
  -b, --escape               print C-style escapes for nongraphic characters
      --block-size=SIZE      scale sizes by SIZE before printing them; e.g.,
                               '--block-size=M' prints sizes in units of
                               1,048,576 bytes; see SIZE format below

...
```

## Navigating the dir using `cd`

`cd` stands for change directory. We can navigate the directory using the `cd`.

Now to navigate into the, say 'GBBA' folder - 

```shell
cd GBBA
pwd
```
```shell
/home/sample.s/GBBA
```
Now to go one directory up. We can use `..` flag. 
```shell
cd ..
pwd
```
```shell
/home/sample.s
```

### Absolute and Relative Paths 

The above was the example of **relative path**, it refers to the current directory. Any file or directory within the current dir can be accessed directly without using `/path`

On the other hand, **absolute path** indicates the location of a directory in refers to this top-level directory. 

In our example, we can go to home using `cd /home/sample.s`. In Linux, every file and directory is under the top-most directory, which is called the “root” directory, but referred to by a single leading slash “/”.

```shell
cd /home/sample.s/GBBA
```




## Create an empty directory using `mkdir`:
   - `mkdir` stands for "make directory." This command is used to create a new, empty directory (folder) in the file system.
   - **Example**: 
     ```bash
     mkdir new_directory
     ```
     This command creates a directory named "new_directory" in the current directory.

## Create an empty file using `touch`:
   - `touch` is used to create an empty file or update the timestamp of an existing file (modifying its last accessed and modified time).
   - **Example**:
     ```bash
     touch new_file.txt
     ```
     This command creates an empty file named "new_file.txt" in the current directory. If "new_file.txt" already exists, it simply updates the file's timestamp.

## Copy files with `cp <original_file> <copy_file>`:
   - `cp` stands for "copy." It duplicates a file from one location to another or renames it by copying the original file's content to a new one.
   - **Example**:
     ```bash
     cp original.txt copy.txt
     ```
     This command copies the file "original.txt" and creates a duplicate called "copy.txt" in the same directory.

## Copy complete directories with `cp -r <original_directory> <copy_directory>`:
   - When copying directories, the `-r` (recursive) flag is essential as it enables copying all files and subdirectories within a directory.
   - **Example**:
     ```bash
     cp -r folder_a folder_b
     ```
     This command copies the contents of "folder_a" into a new directory named "folder_b." All files, directories, and their contents within "folder_a" are duplicated into "folder_b."

## Move files or rename them with `mv`:
   - `mv` stands for "move." It moves files or directories from one location to another. It can also rename files or directories.
   - **Example - Moving**:
     ```bash
     mv file.txt /new/location/
     ```
     This command moves "file.txt" to "/new/location/" directory.
   - **Example - Renaming**:
     ```bash
     mv old_name.txt new_name.txt
     ```
     This command renames "old_name.txt" to "new_name.txt" within the same directory.

## Delete files and directories with `rm` and `rmdir`:
   - **`rm` (remove):** Deletes files or directories. Use caution, as deletions are permanent.
     - **Example**:
       ```bash
       rm file.txt
       ```
       This command deletes "file.txt."
     - **To delete a directory and its contents**, add the `-r` flag:
       ```bash
       rm -r directory_name
       ```
       This recursively deletes "directory_name" and everything inside it.

   - **`rmdir` (remove directory):** Deletes only empty directories.
     - **Example**:
       ```bash
       rmdir empty_directory
       ```
       This command removes "empty_directory" only if it is empty. For directories with files or other directories, use `rm -r`.


> ### Caution while using `mv` and `rm` - Deletions are permanent 





## Nano Commands
- **Open a file**: `nano filename`  
  Opens "filename" in nano.
- **Save changes**: `Ctrl + O` (then press Enter)  
  Writes changes to the file.
- **Exit nano**: `Ctrl + X`  
  Closes nano, prompting to save if there are unsaved changes.
- **Cut line**: `Ctrl + K`  
  Cuts the current line.
- **Paste**: `Ctrl + U`  
  Pastes the last cut line.

## Vim Commands
- **Open a file**: `vim filename`  
  Opens "filename" in vim.
- **Enter Insert mode**: Press `i`  
  Allows text editing.
- **Save and exit**: `:wq` (while in Command mode)  
  Writes changes and quits vim.
- **Exit without saving**: `:q!`  
  Exits vim, discarding any changes.
- **Switch to Command mode**: Press `Esc`  
  Exits Insert mode and returns to Command mode.

---

**Note**: `nano` is simpler and more intuitive for beginners, while `vim` offers powerful editing features for advanced users.

[Back to Main Page](./README.md)