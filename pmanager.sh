#!/bin/bash

# Interactive password manager for Linux.

user=$(whoami)

function begin() {
    echo "   ___                                    _                                               "
    echo "  / _ \__ _ ___ _____      _____  _ __ __| |   _ __ ___   __ _ _ __   __ _  __ _  ___ _ __ "
    echo " / /_)/ _\` / __/ _\ \ /\ / / _ \| '__/ _  \`|  | '_ \` _\ / _ \` | '_ \ / _ \`|/ _\` |/ _ \ '__|"
    echo "/ ___/ (_| \__ \__ \\ V  V / (_) | | | (_|  |  | | | | | | (_| | | | | (_| | (_| |  __/ |   "
    echo "\/    \__,_|___/___/\_/\_/ \___/|_|  \__,_ |  |_| |_| |_|\__,_|_| |_|\__,_|\__, |\___|_|   "
    echo "                                                                           |___/            "
}                                                                                                                                                       

# Usage: ./pManager {--add} | {--get} | {--list} [labelName]
function usage() {
    begin
    echo 'Usage:'
    echo -e "\t./pmanager.sh"
    echo 'Options:'
    echo -e "\t--add: add a new password."
    echo -e "\t--get: get a password."
    echo -e "\t--list [\$labelName]: list all saved accounts. If \$labelName is specified, lists only the accounts contained inside the \$labelName folder."
    echo -e "\t--delete [\$labelName]: delete an account. If \$labelName is specified, delete the entire \$labelName folder."

    exit 0
}

# Get a password according to the label and username.
function get-account() {
    echo -n 'Enter the label of the account you want to retreive: '
    read label
    echo "List of accounts for $label:"
    ls -Q ~/.pmanager/$user/$label

    echo -n "Enter the username which you want to get the password: "
    read username
    if [[ ! -f "~/.pmanager/$user/$label/$username" ]]; then
        echo -n 'Password: '
        cat ~/.pmanager/$user/$label/$username
    else
        echo "$username does not exist."
    fi
    exit 0
}

# Add an account to the list.
function add-account() {
    echo 'Please enter the label for the new account to save:'
    read passLabel
    mkdir -vp ~/.pmanager/$user/$passLabel
    echo "Please enter a username for $passLabel"
    read username
    echo "Please enter the password of $passLabel for $username"
    read -s password
    echo "$password" > ~/.pmanager/$user/$passLabel/$username

    echo "New account for $passLabel has been set."
    exit 0
}

# Lists all accounts.
function list-accounts() {
    if [ "$1" != "" ] && [[ ! -d ~/.pmanager/$user/$1 ]]; then
        echo "~/.pmanager/$user/$1 does not exist."
        exit 1
    fi
    echo "Saved accounts for $user:"
    if [ "$1" == "" ]; then
        for label in $(ls ~/.pmanager/$user); do
            echo -e "\t* $label:"
            for f in $(ls ~/.pmanager/$user/$label); do
                echo -e "\t\t- $f ";
            done
        done
    else
        echo -e "\t* $1:"
        for f in $(ls ~/.pmanager/$user/$1); do
            echo -e "\t\t- $f ";
        done
    fi
}

# Lists all labels.
function list-labels() {
    echo "Labels:"
    for label in $(ls ~/.pmanager/$user/); do
        echo -e "\t* $label"
    done
}

# Delete an account.
# If label directory is empty after the account deletion, then delete the label directory.
function delete-accounts() {
    list-labels
    echo 'Enter the label in which you would like to delete the account:'
    read label
    if ! [[ ! -d "~/.pmanager/$user/$label" ]]; then
        echo "Error: ~/.pmanager/$user/$label does not exist."
        exit 1
    fi
    list-accounts $label
    echo "Enter the account in $label folder you would like to delete:"
    read account
    rm -v ~/.pmanager/$user/$label/$account

    if [ "$(ls ~/.pmanager/$user/$label)" == "" ]; then
        rm -vr ~/.pmanager/$user/$label
    fi 
}

# Parse different commands.
function run_ui() {
    echo -e "Hello $user!\n"
    CMD=$1
    ARG=$2
    
    case $CMD in 
        --add)
            add-account
            ;;
        --get)
            get-account
            ;;
        --list)
            list-accounts $ARG
            ;;
        --delete)
            delete-accounts
            ;;
        *)
            usage
            ;;
    esac
}

# Initialize the password manager config if first time to use.
function init_PassManager() {
    if [ ! -d "~/.pmanager" ]; then
        mkdir -v ~/.pmanager
    fi
    if [[ ! -d "~/.pmanager/$user" ]]; then
        mkdir -v ~/.pmanager/$user
        sudo chown -vR $user ~/.pmanager/$user
    fi
}

# Run program.
function run() {
    if [ "$#" -eq 0 ]; then
        usage
    fi

    init_PassManager
    run_ui $@
}

run $@
