# Bash Scripting

## Commands used to manage inside the server

* ls
* ll is equivalent to ls -l, it shows the content of the folder/path we are in, in the form of a list.
* ls -lh is equivalent to ll but also reports the size of the files/directories of the directory we are located in.
* cd
    * cd ..
    * cd path

* df -h (disk free): if informs about the total space of our system, available and ocuppied. -h shows the information in GB, MB and KB format.
* du -h [filename or path/to/directory]: du stands for disk usage. It is used to estimate file and directory space usage
* htop used to monitor system processes in real-time, check the available cores/threads and the cores being 
    *-u –user=USERNAME : Used to show only the processes of a given user