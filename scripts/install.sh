#!/bin/bash

#links
API="http://api.shwitter.localhost"
FRONTEND="http://shwitter.localhost"

REACT_REPO=git@github.com:Shwitter/shwitter-com-react.git
API_REPO=git@github.com:Shwitter/shwitter-com-nodeJS.git

#colors
NONE='\033[00m'
RED='\033[0;31m'
BLUE='\033[1;36m'
YELLOW='\033[1;33m'

clear

echo -e "${RED}[1/5] Stopping containers...\n\v${NONE}"
make stop

echo -e "${RED}[2/5] Checking and cloning repos...\n\v${NONE}"
[[ -d shwitter-com-react ]] || git clone -b develop ${REACT_REPO}
[[ -d shwitter-com-nodeJS ]] || git clone -b develop ${API_REPO}

echo -e "${RED}[3/5] Starting up containers...\n\v${NONE}"
make up

echo -e "\n${RED}[4/5] Building API ...\n\v${NONE}"
docker-compose exec shwitter.api chown -R node:node ../node 
docker-compose exec --user node shwitter.api npm install 

echo -e "\n${RED}[5/5] Building Frontend...\n\v${NONE}"
docker-compose exec shwitter.frontend chown -R node:node ../node 
docker-compose exec --user node shwitter.frontend npm install 

echo -e "\n${YELLOW}TODO: run in new tabs\n\v    api server start:${NONE}${BLUE} 'make api-start' \n\v${YELLOW}    front server start:${NONE}${BLUE} 'make front-start'\n\v${NONE}"


echo -e "\n${RED}\n\vAPI${NONE}  - " ${BLUE}${API}${NONE}"${RED}\n\vFRONTEND${NONE} - " ${BLUE}${FRONTEND}${NONE}""
