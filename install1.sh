#!/bin/sh
 echo ' will start installing packages for your intiall setup of desktop'
#sudo apt-get install chromium-browser
#firefox https://repo.continuum.io/archive/ 
#installin curl
sudo apt-get install curl


# downloading and installing anaconda 

read -r -p ' do you want to download a version of anaconda by me? wait my name is instass (y or n) ' input
 
case $input in
    [yY][eE][sS]|[yY])
	curl -O https://repo.anaconda.com/archive/Anaconda3-2019.03-Linux-x86_64.sh
 ;;
    [nN][oO]|[nN])
 echo "No"
       ;;
    *)
 echo "Invalid input..."
 continue
 ;;
esac
	
