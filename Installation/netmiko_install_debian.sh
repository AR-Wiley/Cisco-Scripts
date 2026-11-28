#!/bin/bash

set -euo pipefail

dir="/var/log/Install_Logs"
file="/var/log/Install_Logs/install"
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

function Validate_LogFile {

        local file="$1"

        if [ ! -e "$file" ]; then
                echo "Creating file: $file"
                touch "$file"
        fi
}

function System_Update {

        local update="$1"

        for i in "${update[@]}"; do
                if ! bash -c "$i"; then
                        echo "'$i': Failed to install..."
                        exit 1
                fi
        done

        echo "Updates Completed"
}

function Install-Pip {

        if command -v pip >/dev/null 2>&1; then
                echo "Pip is installed..."
                pip --version
        else
                echo "Installing Pip..."

                if ! apt install pip -y; then
                        echo "Pip installation failes..."
                        exit 1
                fi

                echo "Pip has been installed..."
                pip --version
        fi
}

function Install_Dependencies {

        local dependent="$1"

        for i in "${dependent[@]}"; do
                if ! bash -c "$i"; then
                        echo "'$i': Failed to install..."
                        exit 1
                else
                        echo "Dependency all ready installed..."
                fi
        done

        echo "Installation Complete"
}


function Install_Netmiko {

        if command -v netmiko >/dev/null 2>&1; then
                echo "Netmiko is installed..."
                netmiko --version
        else
                echo "Installing Netmiko..."

                if ! apt install netmiko -y; then
                        echo "Netmiko installation failes..."
                        exit 1
                fi

                echo "Netmiko has been installed..."
                netmiko --version
        fi
}


Validate_Root
Validate_LogPath "$dir"
Validate_LogFile "$file"
System_Update "$updates"
Install-Pip
Install_Dependencies "$dependencies"
Install_Netmiko 


