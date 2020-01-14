#!/bin/bash

LIGHTCYAN='\033[0;36m'
RED='\033[0;31m'
NOCOLOR='\033[0m'

msg(){
	echo "Download $1 to Directory: ~/Download"
}
warn(){
	echo -e "${RED}$1 ($2) file not found in ~/Download, Press [Enter] to try again..........${NOCOLOR}"
	read
}


prompt(){
	msg $1
	file=$(find ~/Downloads -name $3)
	while [ -z "$file" ]
	do
		if [ -n "$(which xdg-open)" ]
		then
		  xdg-open $2
		else
		  echo -e "No browser found. Download manualy: ${LIGHTCYAN}$2${NOCOLOR}"
		fi

		warn $1 $3
		file=$(find ~/Downloads -name $3)
	done
	
	if [ $(echo "$file" | wc -l) -gt 1 ]
	then
		echo "$file"		
		read -p "Select one file.......Enter[1, 2, 3....]" sel
		file=$(echo "$file" | cut -f$sel -d$'\n')	
	fi
	echo "$1 file selected : $file"
}
###################################################################################


#########Install Vscode#########
prompt "Vscode" "https://code.visualstudio.com/" "code*.deb"

sudo dpkg -i $file

#########Install Genymotion#########
sudo apt install virtualbox -y

prompt "Genymotion" "https://www.genymotion.com/fun-zone/" "genymotion*.bin"

chmod +x $file
$file

#########Install Flutter#########
sudo apt install git -y

prompt "Flutter" "https://flutter.dev/docs/get-started/install/linux" "flutter*.tar.xz"

sudo tar xfv $file -C /opt/
sudo chown $(whoami) -R /opt/flutter
export PATH="$PATH:/opt/flutter/bin"

flutter doctor

#########Install Android Studio#########
prompt "Adnroid Studio" "https://flutter.dev/docs/get-started/install/linux" "android-studio*.tar.gz"

sudo tar xfv $file -C /opt/
sudo chown $(whoami) -R /opt/android-studio
