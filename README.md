SSH Key Deploy Script
=====================

Author: Mirko Kaiser, http://www.KaiserSoft.net   
Project URL: https://github.com/KaiserSoft/SSH-Key-Deploy/     
Copyright (C) 2015 Mirko Kaiser    
First created in Germany on 2015-09-20    
License: New BSD License

Support the software with Bitcoins !thank you!: 	 19wNLGAGfBzSpWiqShBZdJ2FsEcMzvLVLt

Support the software with Bitcoin Cash !thank you!:  12B6uJgCmU73VTRRvtkfzB2zrXVjetcFt9


# New Version #
There is now an alternative version available which stores the SSH keys in an SQLite3 database 
and allows you to create key groups. So one database for all the keys but you may choose wich 
keys are deployed on a server by specifing the group name.
Please see: https://github.com/KaiserSoft/SSH-Key-Deploy-v2/


# About #
script to simplify management of the authorized_keys file
* copy any .pub files which should be included into ./active/
* copy any .pub files which should be removed into ./remove/

Works great in combination with git. fork or copy the files into your own git repository
and add your public files to your git repository.     
This makes it easy to deploy your ssh keys across multiple servers and could even be
used to rebuild authorized_keys automatically 


Examples
========

Show command examples ... pretty much what you see here
* ./ssh-key-deploy.sh --help

Update authorized_keys of the current user
* ./ssh-key-deploy.sh

Delete authorized_key first, then update authorized_keys of the current user
* ./ssh-key-deploy.sh --force
    
Update specific file
* ./ssh-key-deploy.sh /home/foo/authorized_key


