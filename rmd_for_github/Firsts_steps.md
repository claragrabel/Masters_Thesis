* wildcard means any character (joker card), if we want to do something for all files ending in .fq.gz que can use *.fq.gz. Instead of creating a for loop
ll is the same as ls -l

genhelp tells you about the programmes installed locally, in the current user/environment

we will install mamba instead of conda cuase it's supposed to be faster and newer, we looked how to install it in bash up.

https://mamba.readthedocs.io/en/latest/installation/mamba-installation.html
Fresh install (recommended)

wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh

Do you accept the license terms? [yes|no]
yes

If you'd prefer that conda's base environment not be activated on startup,
   set the auto_activate_base parameter to false:

conda config --set auto_activate_base false


For changes to take effect, close and re-open your current shell --> instead what we did is the following command line 
source ~/.bashrc


find /home/igmestre/ecoevodevo/raw_reads/RNA/hyeunji_populations_2020/F19FTSEUHT0334_LARuxjE/Clean/ -type f -exec ln -s {} . ';'


finds the raw reads files : if they are files (-f) (inside the clean folder, inside every folder with the name of the populations, the files)
combination of several functions: -exec (execute) ln -s (the symlink) {}
 is like a pipe (tubería) . meaning the current folder, and ; probably meaning line break every time it performs again, for each file.

find /home/igmestre/ecoevodevo/raw_reads/RNA/hyeunji_populations_2020/F19FTSEUHT0334_LARuxjE/Clean/*/* -type f -exec ln -s {} . ';'

I don't know if this version with the * would've worked the same


Proceed with the fastqc of the raw reads

It's best to create an environment for every task, cause sometimes they need diff versions of python, or any ther software and they clash. Resolving conflicts is more demading than creating diff environments.

mamba create -n env_fastqc

mamba activate env_fastqc

mamba install -c bioconda fastqc

to check if it was installed correctly: which fastqc or fastqc --version or fastqc -h (which displays the help)

BEFORE RUNNING THE FASTQC

Check the server, how many processes are running, how many people using it... or run my process in the background (segundo plano)
AND if we have to close the session, it would stop running the process, so we have 2 options:
+ either create a new screen

# Screen

using the "screen" command in a Unix-like operating system (such as Linux) to create a session that allows you to run processes in the background even if you disconnect from the server. This is particularly useful in remote server management scenarios.

+ Persistent Sessions: When you connect to a server via SSH or another remote access method, your session is associated with the terminal you are using. If you close the terminal or disconnect, your session and any processes you started will be terminated.

+ Background Processes: By using the screen command, you can create a virtual terminal that persists even if your connection is lost. This allows you to run processes in the background and return to them later.

+ Multiple Windows: screen also allows you to create multiple windows within a session, each with its own shell or process. This is beneficial for multitasking and managing various tasks simultaneously.

+ Long-Running Processes: This is especially useful for long-running processes or tasks that you want to keep running even if you disconnect. It's a way to ensure continuity in server-side operations.

To run a command in the background in the first place, place an ampersant right after the command you want to execute.
command_name &

If you've already started a process and want to move it to the background, you can use the bg (background) command.

+ Start a process in the foreground (without using "&")
long_running_command

+ Press Ctrl+z to suspend the foreground process

+ Use the "bg" command to move the suspended process to the background
bg

If you have multiple background jobs, you can use the jobs command to list them and the fg command to bring a background process to the foreground:

+ List background jobs
jobs

+ Bring a background process to the foreground (replace "1" with the job number)
fg %1


Starting a New Screen Session:

Open MobaXterm and connect to your remote server via SSH.
To start a new screen session, simply type the following command in the terminal:
bash
Copy code
screen
This will create a new screen session, and you can start running commands within it.
Detaching from a Screen Session:

To detach from the screen session, use the key combination Ctrl-a followed by d (just like in a standard terminal):
bash
Copy code
Ctrl-a, then d
This leaves the screen session running in the background on the server.
Listing Screen Sessions:

You can list existing screen sessions using the command:
bash
Copy code
screen -ls
This will show you the list of active screen sessions along with their IDs.
Reattaching to a Screen Session:

To reattach to a detached screen session, you need to know the session ID. Use the following command:
bash
Copy code
screen -r session_id
Replace session_id with the actual ID of the screen session you want to reattach to.
Creating Named Screen Sessions:

You can create a named screen session for easier identification and reattachment:
bash
Copy code
screen -S session_name
To reattach to a named session:
bash
Copy code
screen -r session_name
Exiting a Screen Session:

To exit a screen session, you can simply type exit or press Ctrl-d until all shells in the session are closed.


# fastqc

fastqc: This is the command to execute FastQC.

./*.fq.gz: This specifies the input files for FastQC. The ./ represents the current directory, and *.fq.gz is a wildcard that matches all files with the extension .fq.gz (compressed FASTQ files).

-o ../fastqc_raw: This option specifies the output directory where FastQC will save the results. In this case, it's set to ../fastqc_raw, indicating that the results will be saved in a directory named fastqc_raw one level up from the current directory.

--nogroup: This option tells FastQC not to generate an additional data file containing the results for each individual sequence. Instead, it will generate a single report for all sequences in the input files.

HTML Reports:

The main output is a set of HTML reports that can be opened in a web browser. These reports contain various modules assessing different aspects of the sequencing data quality, such as per-base sequence quality, per-sequence quality scores, GC content distribution, sequence length distribution, and more.
Data Files:

FastQC may generate additional data files that contain detailed information used to generate the plots and graphs in the HTML reports. However, since you used the --nogroup option, it won't generate individual sequence reports.
Images:

Images, such as quality score distribution plots and sequence content graphs, are often included in the HTML reports.
Summary Information:

A summary section in the HTML reports provides an overall assessment of the data quality, highlighting any potential issues or areas of concern.
By examining the FastQC reports, you can quickly identify if there are issues with the data, such as poor sequencing quality, overrepresented sequences, or adapter contamination. This initial quality control step is crucial before proceeding with downstream analysis, such as alignment, transcript quantification, and differential expression analysis in a typical RNA-seq workflow.