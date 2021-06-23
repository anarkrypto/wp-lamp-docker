#!/bin/bash

# VERSION
version='1.0'

# OUTPUT VARS
TERM=xterm
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
bold=`tput bold`
reset=`tput sgr0`

# FLAGS & ARGUMENTS
quiet='false'
verbose='true'

# Check if running as root
if [ "$EUID" -ne 0 ]
  then echo "${red}Please run as root: ${reset}${bold}sudo ./build.sh${reset}"
  exit
fi

# PRINT INSTALLER DETAILS
[[ $quiet = 'false' ]] && echo "${green} -----------------------${reset}"
[[ $quiet = 'false' ]] && echo "${green}${bold} WordPress Lamp Docker ${version}${reset}"
[[ $quiet = 'false' ]] && echo "${green} -----------------------${reset}"
[[ $quiet = 'false' ]] && echo ""

# VERIFY TOOLS INSTALLATIONS
docker -v &> /dev/null
if [ $? -ne 0 ]; then
    echo "${red}Docker is not installed. Please follow the install instructions for your system at https://docs.docker.com/install/.${reset}";
    exit 2
fi

docker-compose --version &> /dev/null
if [ $? -ne 0 ]; then
    echo "${red}Docker Compose is not installed. Please follow the install instructions for your system at https://docs.docker.com/compose/install/.${reset}"
    exit 2
fi

# Set Apache db name, user and password
DB_NAME="wp_db"
DB_USER="wp_user"
DB_PASSWD=$(openssl rand -base64 32 | tr '/' '_')

# Save to .env file
echo "DB_NAME=$DB_NAME" > .env
echo "DB_USER=$DB_USER" >> .env
echo "DB_PASSWD=$DB_PASSWD" >> .env

# Copy machine timezone
cp /etc/timezone ./assets/timezone

if [[ $quiet = 'false' ]]; then
    if [[ $verbose = 'false' ]]; then
        docker-compose up -d
    else
        docker-compose --verbose  up -d
    fi
else
    docker-compose  up -d &> /dev/null
fi

# Check errors
if [ $? -ne 0 ]; then
    echo "${red}It seems errors were encountered while spinning up the containers. ${reset}"
    exit 2
fi

# Remove .env file
rm .env

# Remove machine timezone copy
rm ./assets/timezone

# Print MySQL db, user and passwd to save
echo ""
echo "${green} -----------------------${reset}"
echo "${yellow}Save your MySQL auth info:${reset}"
echo "${green}Database: ${reset}${bold}$DB_NAME${reset}"
echo "${green}User: ${reset}${bold}$DB_USER${reset}"
echo "${green}Password: ${reset}${bold}$DB_PASSWD${reset}"
echo "${green} -----------------------${reset}"
echo ""

# CHECK NODE INITIALIZATION
[[ $quiet = 'false' ]] && echo ""
[[ $quiet = 'false' ]] && printf "=> ${yellow}Waiting for LAMP to fully initialize... "

while ! curl -sL localhost:8081 &> /dev/null; do sleep 1; done

[[ $quiet = 'false' ]] && printf "${green}Done! Open in your browser: http://localhost:8081${reset}\n\n"
