#!/bin/bash

set -euo pipefail

dir="/var/log/SysAdmin-Logs"
update_file="$dir/update.log"
install_file="$dir/install.log"
files=("$update_file" "$install_file")

timestamp=$(date +"%Y-%m-%d")

updates=("apt-get update" "apt-get upgrade -y" "apt-get dist-upgrade -y" "apt-clean" "apt-get autoremove -y")
dependencies=("python3" "python3-pip" "python3-venv" "build-essential" "libssl-dev" "libffi")

function Validate_Root {
        if [[ "$EUID" -ne 0 ]]; then
                echo "You must be root to run this script..."
                exit 1
        fi
}

function Validate_LogPath {
        local dir="$1"
        if [ ! -d "$dir" ]; then
                echo "Creating directory $dir"
                mkdir -v "$dir"
        fi
}

function Validate_LogFiles {
        local lst="$1"
        for i in "${lst[@]}"; do
            if [ ! -e "$i" ]; then
                echo "Creating file: '$i'"
                touch "$i"
        fi
}

function System_Update {
        local update="$1"
        for i in "${update[@]}"; do
                if ! bash -c "$i"; then
                        echo "$timestamp --Update '$i': Failed to install." >> "$update_file"
                        exit 1
                fi
        done
        echo "$timestamp --Update '$i' Completed" >> "$update_file"
}

function Install_Pip {
        if command -v pip >/dev/null 2>&1; then
                echo "Pip is installed"
                pip --version
        else
                echo "Installing Pip"
                if ! apt install pip -y; then
                        echo "$timestamp --Pip installation failed" >> $install_file
                        exit 1
                fi
                echo "$timestamp --Pip has been installed" >> $install_file
                pip --version
        fi
}

function Install_Dependencies {
        local dependent="$1"
        for i in "${dependent[@]}"; do
                if ! bash -c "$i"; then
                        echo "$timestamp --'$i': Failed to install" >> $install_file
                        exit 1
                else
                        echo "'$i' Dependency all ready installed"
                fi
        done
        echo "$timestamp --'$i' Installation Complete" >> $install_file
}

function main() {

    Validate_Root
    Validate_LogPath "$dir"
    Validate_Files "$files"
    System_Update "$updates"
    Install_Pip
    Install_Dependencies "$dependencies"

    if command -v netmiko >/dev/null 2>&1; then
        echo "Netmiko is installed"
        netmiko --version
    else
        echo "Installing Netmiko"
        if ! apt install netmiko -y; then
            echo "$timestamp --Netmiko installation failed" >> $install_file
            exit 1
        fi
            echo "$timestamp --Netmiko has been installed" >> $install_file
            netmiko --version
        fi

}

main "$@"

