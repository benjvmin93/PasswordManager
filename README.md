# PasswordManager
A simple interactive password manager for Linux.

# Informations
The script creates a folder in the ```/home/$user/``` folder, with read and write rights to the current user.

# How to use

### Usage:

To run the script: ```./pmanager.sh```

### Options:

  ```--add```: add a new password.
  
  ```--get```: get a password.
  
  ```--list [$labelName]```: list all saved accounts. If ```$labelName``` is specified, lists only the accounts contained inside the ```$labelName``` folder.
  
  ```--delete```: delete an account. If ```$labelName``` is specified, delete the entire ```$labelName``` folder.
