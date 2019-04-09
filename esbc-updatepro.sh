#!/bin/bash

RED='\033[0;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m' 
BLUE='\033[1;34m'
CYAN='\033[1;36m'

#Intro
clear

echo -e "${GREEN} ---------------ESBC Updater v2.1.0.2----------------+
 |                                                  |::
 |                                                  |::
 |               ___  __  ___   __                  |::
 |              |__  /__  |__) /                    |::
 |              |___ .__/ |__) \__                  |::
 |                                                  |::
 |     ${YELLOW}ESBC Updater v 2.1.0.2 which check your      ${GREEN}|::
 |            ${YELLOW}version and force update ${GREEN}             |::
 |                 ${YELLOW}By ${CYAN}RasmonT ${GREEN}                      |::
 +------------------------------------------------+::
 ::::::::::::::::::::::::::::::::::::::::::::::::::S${NC}"
echo -e "${GREEN}Processing... ${NC}"
sleep 2s

#Checking Server status
if ! /usr/local/bin/esbcoin-cli getinfo >/dev/null 2>&1; then
    echo -e "${GREEN}I will start ESBC server, then i check for Daemon version... ${NC}"
    esbcoind
    sleep 10s 
else
    echo -e "${GREEN}Server is running, i will check if version is correct! ${NC}"
    sleep 2s
    fi	
	
#Version Checking
/usr/local/bin/esbcoin-cli --version
if [ "$(/usr/local/bin/esbcoin-cli --version)" = "ESBC Core RPC client version 2.1.0.2" ]; then
    echo -e "${GREEN}Version of Daemon is correct! ${NC}"
else
    echo -e "${YELLOW}Version of Daemon is Incorrect! ${NC}"
	sleep 1s
	echo -e "${YELLOW}I will force update of the daemon! ${NC}"
	sleep 1s
	echo -e "${GREEN}Stopping ESBC Server and will update Daemon! ${NC}"
	esbcoin-cli stop
    sleep 4s
    rm -rf .esbcoin/mncache.dat .esbcoin/mnpayments.dat .esbcoin/peers.dat
    rm -rf /usr/local/bin/esbcoin*
    rm -rf esbc-daemon-linux-x86_64*
    wget https://github.com/BlockchainFor/ESBC2/releases/download/2.1.0.2/esbc-daemon-linux-x86_64-static.tar.gz
    tar -xvf esbc-daemon-linux-x86_64-static.tar.gz
    sudo chmod -R 755 esbcoin-cli
    sudo chmod -R 755 esbcoind
    cp -p -r esbcoind /usr/local/bin
    cp -p -r esbcoin-cli /usr/local/bin
    rm -rf esbc-daemon-linux-x86_64-static.tar.gz
    esbcoind -daemon
    esbcoin-cli --version
	echo -e "${GREEN}Daemon Succesfully updated! ${NC}"
	echo -e "${GREEN}Confirming Daemon status... ${NC}"
	fi
	
#Checked Status
sleep 3s
echo -e "${GREEN}Status Checked! ${NC}"
sleep 1s

#Bootstrap Installation 
echo "Do you want me to install Bootstrap?[y/n]"
read DOSETUP

if [[ $DOSETUP =~ "n" ]] ; then
      echo -e "${YELLOW}Bootstrap Installation is aborted... ${NC}"
      rm -rf esbc-updatepro.sh
      sleep 2s
      
      echo -e "${GREEN}Checking the masternode status... ${NC}"
sleep 2s

/usr/local/bin/esbcoin-cli masternode status
if [[ "$(/usr/local/bin/esbcoin-cli masternode status)" ==  "{"* ]]; then
    echo -e "${GREEN}Masternode is running! ${NC}"
	sleep 1s
    echo -e "${BLUE}Exitting updater... ${NC}"
	sleep 2s
	exit 1
else
    echo -e "${RED}ERROR: MN is not running! ${NC}"
	sleep 2s
	echo -e "${YELLOW}YOU NEED TO START YOUR MASTERNODE FROM WALLET${NC}"
	sleep 1s
    echo -e "${YELLOW}Press ${CYAN}Start Allias ${YELLOW}to run your masternode... ${NC}"
	sleep 1s
	echo -e "${YELLOW}This will take one minute... ${NC}"
	sleep 60s
	/usr/local/bin/esbcoin-cli masternode status
    if [[ "$(/usr/local/bin/esbcoin-cli masternode status)" ==  "{"* ]]; then
	echo -e "${GREEN}Masternode is running! ${NC}"
	sleep 1s
    echo -e "${BLUE}Exitting updater... ${NC}"
	sleep 2s
	exit 1
else
    echo -e "${RED}ERROR: MN is not running! ${NC}"
	sleep 1s
	echo -e "${RED}ERROR: Make sure you filled ${BLUE}Masternode.conf ${YELLOW}correctly... ${NC}"
	sleep 1s
    echo -e "${RED}ERROR: If you see this message please contact us at ${CYAN}Discord... ${NC}"
	echo -e "${BLUE}Exitting updater... ${NC}"
	sleep 2s
	exit 1
	fi	
    fi
fi

if [[ $DOSETUP =~ "y" ]] ; then
      echo -e "${GREEN}I will install bootstrap, will stop Server soon ... ${NC}"
	  sleep 1s
	  echo -e "${GREEN}Stopping Server and preparing installation... ${NC}"
	  esbcoin-cli stop
	  sleep 2s
	  rm -rf .esbcoin/blocks .esbcoin/chainstate .esbcoin/how-to-use.txt
      echo -e "${GREEN}Removing the current blockchain data... ${NC}"
      sleep 2s
      echo -e "${GREEN}I will start downloading the blockchain files in 5 seconds... ${NC}"
      sleep 5s
	  wget https://files.esbc.pro/bootstrap.zip
	  sleep 2s
	  echo -e "${GREEN}Now i will install the actual blockchain data! ${NC}"
	  sleep 1s
	  sudo apt-get install unzip
	  unzip bootstrap.zip -d .esbcoin
	  echo -e "${GREEN}Files succesfully installed! ${NC}"
	  sleep 1s
      echo -e "${GREEN}Removing .zip file from your directory ${NC}"
	  rm -rf bootstrap.zip 
	  echo -e "${GREEN}Starting the Server... ${NC}"
	  sleep 1s
	  esbcoind -daemon
	  esbcoin-cli --version
	  rm -rf esbc-updatepro.sh
	  sleep 2s
else
      echo -e "${RED}ERROR: Bootstrap Installation has failed... ${NC}"
	  sleep 2s 
	  esbcoin-cli --version
	  rm -rf esbc-updatepro.sh
	  echo -e "${RED}If this error happened please contact us at ${CYAN}Discord!  ${NC}"
	  sleep 2s
fi

#Masternode Checking after installation of bootstrap
echo -e "${GREEN}Loading the daemon after bootstrap installation... ${NC}"
sleep 35s
echo -e "${GREEN}Checking the masternode status... ${NC}"
sleep 2s

/usr/local/bin/esbcoin-cli masternode status
if [[ "$(/usr/local/bin/esbcoin-cli masternode status)" ==  "{"* ]]; then
    echo -e "${GREEN}Masternode is running! ${NC}"
	sleep 1s
    echo -e "${BLUE}Exitting updater... ${NC}"
	sleep 2s
	exit 1
else
    echo -e "${RED}ERROR: MN is not running! ${NC}"
	sleep 2s
	echo -e "${YELLOW}YOU NEED TO START YOUR MASTERNODE FROM WALLET${NC}"
	sleep 1s
    echo -e "${YELLOW}Press ${CYAN}Start Allias ${YELLOW}to run your masternode... ${NC}"
	sleep 1s
	echo -e "${YELLOW}This will take one minute... ${NC}"
	sleep 60s
	/usr/local/bin/esbcoin-cli masternode status
    if [[ "$(/usr/local/bin/esbcoin-cli masternode status)" ==  "{"* ]]; then
	echo -e "${GREEN}Masternode is running! ${NC}"
	sleep 1s
    echo -e "${BLUE}Exitting updater... ${NC}"
	sleep 2s
	exit 1
else
    echo -e "${RED}ERROR: MN is not running! ${NC}"
	sleep 1s
	echo -e "${RED}ERROR: Make sure you filled ${BLUE}Masternode.conf ${YELLOW}correctly... ${NC}"
	sleep 1s
    echo -e "${RED}ERROR: If you see this message please contact us at ${CYAN}Discord... ${NC}"
	echo -e "${BLUE}Exitting updater... ${NC}"
	sleep 2s
	exit 1
	fi	
fi
