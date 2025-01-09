# Linux High Performance Computing Server Commands Guide

For my Master's Thesis, I used the High Performance Computing cluster of the Biological Station of Doñana (EBD-CSIC).


## Server Specifications

This cluster has the following specification:

* CentOS Linux release 7.3.1611 (Core)
* 64 cores
* CPU Intel Xeon CPU E7-8891 v3 @ 2.80GHz
* 480Gb RAM


## Connecting to the server

To connect to the server, I need to be inside the EBD network physically or via VPN and connect via SSH:
```bash
ssh <user.name>@genomics-a.ebd.csic.es
```

## Basic Commands and Navigation 

```bash
# know my current directory
pwd

# change directory
cd

# go to previous directory
..

# short-cuts for going back to my home directory
cd ~/
cd $HOME

# view the folders and files
ls

# check the folders and files in the form of a list
ls -l
ll

# make a folder:
mkdir <new_directory>

# make a text file:
touch <new_file>.txt
nano <new_file>.txt

# visualize the first or last lines of a file
head <file>
tail <file>

# view a whole file
cat file

# view compressed file
zcat <file>

# visualize only the first lines of a compressed file:
zcat <file> | head

# visualize lines with a concrete word or symbol
cat <file> | grep ">"

# count lines
cat <file> | grep -c ">"

# give permissions
chmod [options] [mode] [File_name] 

# short-cuts for chmod
    # gives all three permissions read, write and execute to everyone (owner, group and other)
chmod 777 [file_name]
    # the owner can write, read and execute a file, group and other can only read and execute a file.
chmod 755 [file_name]

# wildcard *
# "*" is a wildcard that means any character (joker card). If we want to do something for all files ending in .fq.gz que can use *.fq.gz, instead of creating a for loop

# getting information about the programmes installed locally, in the current user/environment
genhelp

# refresh the current shell environment with the latest changes made to the .bashrc file without starting a new shell session
source ~/.bashr

# information about the total space of our system, available and ocuppied
    # -h shows the information in human-understandable format: GB, MB and KB format
    # df stands for "disk free"
 df -h

# estimating file and directory space usage
    # du stands for disk usage
du -h _filename_or_path/to/directory

```

## Copying, moving and removing files and making alias

```bash
# copy a file
cp <old_file> <new_file>

# copy directory (a recursive copy)
cp -r <old_directory> <new_directory>

# copy parts of a file (e.g. using head function)
head -n 1000 <file_to_copy> > <path>/<name_of_new_file>
    # copying the first 100 lines of a file into a new file. e.g.
head -n 1000 log > /path/to/directory/first_1000_lines.log    

# make a symbolic link
ln -s <old_file> <new_file>
    # ln stands for "link" and "-s" stands for symbolic

# move a file
mv <file> <new_folder>

# remove a file
rm <file>

# remove a folder and its content
rm -r <folder>

``` 

Symbolic links and hard links:
* symbolic links point to the name or path of the original file, not to the file's data (inode) directly. If the original file is deleted or moved, the symbolic link becomes broken, since it depends on the file's location and path. On the same note, symlinks can link to directories (e.g., shortcuts). Best for creating shortcuts or links across different locations.
* hard links (without -s) are additional directory entries for the same inode (physical data) as the original file, point to the same data. Uses minimal space (only new directory entry) since it is not a copy. Changes in the original data or in any of the hard links affect all hard links, they are not really independent like a copy.
The file data remains accessible as long as there is a hard link, even if the original file is deleted. Best for creating additional names for the same file within the same file system.


## Installing packages

```bash
# download from link
wget <link_to_the_file>

# install the file downloaded
bash <file> -u

```


### Installing Mamba

We installed mamba (instead of using conda) because of it being supposedly faster and newer.

```bash
wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh

# If you'd prefer that conda's base environment not be activated on startup, set the auto_activate_base parameter to false:
conda config --set auto_activate_base false

# For changes to take effect, close and re-open your current shell --> instead what we did is the following command line 
# or source ~/.bashrc
```

## Environments

It's best to create an environment for every task. Sometimes packages need different versions of software and, if installed in the same environment, they may clash. Resolving these conflicts could be more demanding than creating different environments for each task beforehand.
 
```bash
# creating an evironment
mamba create -n env_name

# activating an environment 
mamba activate env_name

# installing a package in the environment once the environment is activated (e.g. fastqc)
mamba install -c bioconda fastqc

# cheking if the software was installed correctly
which fastqc 
fastqc --version
fastqc -h # which displays the help

# listing all environments
mamba env list

# deactivating the environment
mamba deactivate

# removing an environment
mamba env remove -n env_name

```


## Good Practices

Since the Server does not have a SLURM Queueing System, we should be aware of the processes currently running. 
Therefore, it is a good practice to check the server, the amount of threads that are being used by the running processes and how many people are using it.

```bash
# monitoring current running processes, checking the available threads of the server and the threads being used. Real-time, dynamic view of system processes.
    # -u –user=USERNAME Used to show only the processes of a given user
htop
top
```

When running a process in the background, if the session is closed the progress can be lost, hence the following introduction of an alternative method that consists of creating "screens".


## Screen

By using the screen command, you can create a virtual terminal that persists even if your connection to the server is lost or the terminal session is closed. This allows you to run processes in the background and return to them later.

screen also allows you to create multiple windows within a session, each with its own shell or process. This way it is possible to manage several tasks simultaneously.

```bash

# starting a new screen session
screen

# creating named screen session for easier identification and reattachment
screen -S session_name

# detaching from a screen session
    # key combination Ctrl-a followed by d 
    # This leaves the screen session running in the background on the server.

# listing active screen sessions along with their IDs
screen -ls

# reattaching to a screen session
# you must know the ID of the session you want to reattach to 
screen -r session_id

# reattaching to a named session
screen -r session_name

# exiting a screen session
    # type exit or press Ctrl-d until all shells in the session are closed

# delete a screen when detached
screen -S session_name_or_id -X quit

# terminate all screen sessions
pkill screen

```


If the process is short and we wanted to run the process in the background:

```bash

# run a command in the background in the first place
command_name &

# combine with nohup or disown to keep processes running even after the terminal is closed:
nohup command_name &

# list running, suspended and background jobs
jobs
    # used to find job IDs
jobs -l 
    # adds the PID of each job to the output of jobs.

# snapshot (static) list processes at the moment the command is run
ps

# suspend a process in the background
kill -STOP 12345  # Suspend process with PID 12345

# bring a background process to the foreground
fg %job_id
fg process_id

# suspend a process in the foreground
    # Ctrl+z

# resuming execution of a suspended process in the background, as if they had been started with &
bg %job_id
bg process_id

```


## Creating symlinks for raw data files

In order to prevent using up too much space in the server, I created symlinks in a folder of my own to the actual data files in the original data folder.

```bash
find /home/igmestre/ecoevodevo/raw_reads/RNA/hyeunji_populations_2020/F19FTSEUHT0334_LARuxjE/Clean/ -type f -exec ln -s {} . ';'

# finds the raw reads files, cheching if they are files (-f) (inside the clean folder, inside every folder with the name of the populations, looking for the files)
# combination of several functions: -exec (execute) ln -s (the symlink) {} 
# the execute command acts similarly to a pipe
# . meaning the current directory, and ; meaning line break every time it performs again, for each file.
```


