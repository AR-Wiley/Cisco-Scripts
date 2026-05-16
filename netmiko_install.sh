#!/bin/bash

set -euo pipefail

if [[ "$EUID" -ne 0 ]]; then
        echo "You must be root to run this script..."
        exit 1
fi

dir="/var/log/Install_Logs"
file="/var/log/Install_Logs/install"
timestamp=$(date +"%Y-%m-%d")

function Validate_LogPath {

        if [ ! -d "$dir" ]; then
                echo "Creating directory $dir"
                mkdir -v "$dir"
        fi

}

function Validate_LogFile {

        if [ ! -e "$file" ]; then
                echo "Creating file: $file"
                touch "$file"
        fi
}

function System_Update {

        local updates=("apt-get update"
                "apt-get upgrade -y"
                "apt-get dist-upgrade -y"
                "apt-clean"
                "apt-get autoremove -y"
        )

        for i in "${updates[@]}"; do
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

        local dependencies=("python3"
                "python3-pip"
                "python3-venv"
                "build-essential"
                "libssl-dev"
                "libffi"
        )

        for i in "${dependencies[@]}"; do
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


}
