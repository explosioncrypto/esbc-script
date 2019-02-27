#!/bin/bash

RED='\033[0;91m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m' 

#Checking Server status
if ! /usr/local/bin/esbcoin-cli getinfo >/dev/null 2>&1; then
    echo -e "${GREEN}I will start ESBC server, then i check for Daemon version... ${NC}"
    esbcoind
    sleep 10s 
else
    echo -e "${GREEN} Server is running, i will check if version is correct! ${NC}"
    sleep 2s
    fi	
	
#Version Checking
/usr/local/bin/esbcoin-cli --version
if [ "$(/usr/local/bin/esbcoin-cli --version)" = "ESBC Core RPC client version 2.0.4.14" ]; then
    echo -e "${GREEN} Version of Daemon is correct! ${NC}"
else
    echo -e "${YELLOW} Version of Daemon is Incorrect! ${NC}"
	sleep 1s
	echo -e "${YELLOW} I will force update of the daemon! ${NC}"
	sleep 1s
	echo -e "${GREEN} Stopping ESBC Server and will update Daemon! ${NC}"
	esbcoin-cli stop
    sleep 4s
    rm -rf .esbcoin/mncache.dat .esbcoin/mnpayments.dat .esbcoin/peers.dat
    rm -rf /usr/local/bin/esbcoin*
    rm -rf esbc-daemon-linux-x86_64*
    wget https://github.com/BlockchainFor/ESBC2/releases/download/2.0.4.14/esbc-daemon-linux-x86_64-static.tar.gz
    tar -xvf esbc-daemon-linux-x86_64-static.tar.gz
    sudo chmod -R 755 esbcoin-cli
    sudo chmod -R 755 esbcoind
    cp -p -r esbcoind /usr/local/bin
    cp -p -r esbcoin-cli /usr/local/bin
    rm -rf esbc-daemon-linux-x86_64-static.tar.gz
    esbcoind -daemon
    esbcoin-cli --version
	echo -e "${GREEN} Daemon Succesfully updated! ${NC}"
	echo -e "${GREEN} Confirming Daemon status... ${NC}"
	fi
	
#Checked Status
sleep 3s
echo -e "${GREEN} Status Checked! ${NC}"
sleep 1s

#Bootstrap Installation 
echo "Do you want me to install Bootstrap?[y/n]"
read DOSETUP

if [[ $DOSETUP =~ "n" ]] ; then
      echo -e "${GREEN}Bootstrap Installation is aborted... ${NC}"
fi

if [[ $DOSETUP =~ "y" ]] ; then
      echo -e "${GREEN}I will install bootstrap, will stop Server soon ... ${NC}"
	  sleep 1s
	  echo -e "${GREEN}Stopping Server and preparing installation... ${NC}"
	  esbcoin-cli stop
	  sleep 2s
	  rm -rf .esbcoin/blocks .esbcoin/chainstate
      echo -e "${GREEN} Removing the current blockchain data... ${NC}"
      sleep 2s
      echo -e "${GREEN} I will start downloading the blockchain files in 5 seconds... ${NC}"
      sleep 5s
	  wget http://files.esbproject.online/bootstrap.zip
	  sleep 2s
	  echo -e "${GREEN} Now i will install the actual blockchain data! ${NC}"
	  sleep 1s
	  sudo apt-get install unzip
	  unzip bootstrap.zip -d .esbcoin
	  echo -e "${GREEN} Files succesfully installed! ${NC}"
	  sleep 1s
      echo -e "${GREEN} Removing .zip file from your directory ${NC}"
	  rm -rf bootstrap.zip 
	  echo -e "${GREEN} Starting the Server... ${NC}"
	  sleep 1s
	  esbcoind -daemon
	  esbcoin-cli --version
	  rm -rf esbc-updatepro.sh
else
      echo -e "${YELLOW}Bootstrap Installation has failed... ${NC}"
	  sleep 2s 
	  esbcoin-cli --version
	  rm -rf esbc-updatepro.sh
fi
