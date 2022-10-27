# PasswordManager
A simple interactive password manager for Linux.

# Informations
The script creates a folder ```/home/$user/.pmanager/$user```, with read and write rights to the current user.
Your session password is required once to grant these accesses.

# How to use

### Usage:

To run the script: ```./pmanager.sh```

### Options:

  ```--add```: add a new password.
  
  ```--get```: get a password.
  
  ```--list [$labelName]```: list all saved accounts. If ```$labelName``` is specified, lists only the accounts contained inside the ```$labelName``` folder.
  
  ```--delete```: delete an account. If ```$labelName``` is specified, delete the entire ```$labelName``` folder.
