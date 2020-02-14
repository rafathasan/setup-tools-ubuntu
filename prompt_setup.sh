#!/bin/bash

cd $1

while getopts "va:" opt; do
	case $opt in
	v)
		echo "
Setup Development Tool 0.1 written in Bash
Rafat Hasan <rafathasankhan@gmail.com>

USAGE:
	setdev [ARGS] [OPTIONS]

Options:
	-a <Directory>			Change directory
	-v				Print setdev version
" >&2
		exit
		;;
	a)
		cd $OPTARG
		echo "Current directory changed: $(pwd)"
		;;

	\?)
		echo "Invalid option: -$OPTARG" >&2
		exit
		;;
	:)
		echo "Option -$OPTARG requires an argument." >&2
		exit
		;;
	esac
done

LIGHTCYAN='\033[0;36m'
RED='\033[0;31m'
NOCOLOR='\033[0m'

msg() {
	echo "Download $1 to Directory: ~/Download"
}
warn() {
	echo -e "${RED}$1 ($2) file not found in ~/Download, Press [Enter] to try again..........${NOCOLOR}"
	read
}

prompt() {
	msg $1
	file=$(find ~/Downloads -name $3)
	while [ -z "$file" ]; do
		if [ -n "$(which browse)" ]; then
			browse $2
		else
			echo -e "No browser found. Download manualy: ${LIGHTCYAN}$2${NOCOLOR}"
		fi

		warn $1 $3
		file=$(find ~/Downloads -name $3)
	done

	if [ $(echo "$file" | wc -l) -gt 1 ]; then
		echo "$file"
		read -p "Select one file.......Enter[1, 2, 3....]" sel
		file=$(echo "$file" | cut -f$sel -d$'\n')
	fi
	echo "$1 file selected : $file"
}
###################################################################################

vscode() {
	#########Install Vscode#########
	prompt "Vscode" "https://code.visualstudio.com/" "code*.deb"

	sudo dpkg -i $file
}

genymotion() {
	#########Install Genymotion#########
	sudo apt install virtualbox -y

	prompt "Genymotion" "https://www.genymotion.com/fun-zone/" "genymotion*.bin"

	chmod +x $file
	sudo $file
}

flutter() {
	#########Install Flutter#########
	sudo apt install git -y

	prompt "Flutter" "https://flutter.dev/docs/get-started/install/linux" "flutter*.tar.xz"

	sudo tar xfv $file -C /opt/
	sudo chown $(whoami) -R /opt/flutter
	export PATH="$PATH:/opt/flutter/bin"

	flutter doctor
}

android-studio() {
	#########Install Android Studio#########
	prompt "Android Studio" "https://developer.android.com/studio/" "android-studio*.tar.gz"

	sudo tar xfv $file -C /opt/
	sudo chown $(whoami) -R /opt/android-studio
}

nodejs() {
	sudo apt-get install curl -y
	curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
	sudo apt-get install nodejs -y
	sudo apt install npm -y
	node -v
}

reactjs() {
	if [ -n "$(which npm)" ]; then
		sudo npm i -g create-react-app
	else
		echo -e "${RED} npm not found. Installing npm.......${NOCOLOR}"
		nodejs
		sudo npm i -g create-react-app
	fi
}

express() {
	if [ -n "$(which npm)" ]; then
		sudo npm i -g express
	else
		echo -e "${RED} npm not found. Installing npm.......${NOCOLOR}"
		nodejs
		sudo npm i -g express
	fi
}

mongodb() {
	sudo apt install mongodb -y
	sudo systemctl status mongodb
	mongo --eval 'db.runCommand({ connectionStatus: 1 })'
}

angularjs() {

	if [ -n "$(which npm)" ]; then
		sudo npm install -g @angular/cli
	else
		echo -e "${RED} npm not found. Installing npm.......${NOCOLOR}"
		nodejs
		sudo npm install -g @angular/cli
	fi
}

tdd() {
	echo "Enter a feature name eg. home,dashboard:"
	read feature
	if [ -z $feature ]; then
		echo "Exit"
		exit 0
	fi
	mkdir core
	mkdir core/error
	mkdir core/usecases
	mkdir features
	mkdir features/$feature
	mkdir features/$feature/data
	mkdir features/$feature/data/datasources
	mkdir features/$feature/data/models
	mkdir features/$feature/data/repositories
	mkdir features/$feature/domain
	mkdir features/$feature/domain/entities
	mkdir features/$feature/domain/repositories
	mkdir features/$feature/domain/usecases
	mkdir features/$feature/presentation
	mkdir features/$feature/presentation/bloc
	mkdir features/$feature/presentation/pages
	mkdir features/$feature/presentation/widgets
	mkdir test
	mkdir test/core
	mkdir test/core/error
	mkdir test/core/usecases
	mkdir test/features
	mkdir test/features/$feature
	mkdir test/features/$feature/data
	mkdir test/features/$feature/data/datasources
	mkdir test/features/$feature/data/models
	mkdir test/features/$feature/data/repositories
	mkdir test/features/$feature/domain
	mkdir test/features/$feature/domain/repositories
	mkdir test/features/$feature/domain/usecases
}

qemukvm() {
	sudo apt-get install qemu-kvm virt-manager -y
	#sudo service libvirtd start
	#sudo update-rc.d libvirtd enable
	#sudo adduser $(whoami) libvirtd
	echo "Reboot Required !!!!!!!!!!"
}

cudatoolkit(){
	echo "CUDA Toolkit 10.2......"
	wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
	sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
	wget http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
	sudo dpkg -i cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
	sudo apt-key add /var/cuda-repo-10-2-local-10.2.89-440.33.01/7fa2af80.pub
	sudo apt-get update
	sudo apt-get -y install cuda
}

###################################################################################

declare -a title
title[1]="Android stack: Vscode - Flutter - Android Studio - Genymotion
"
title[2]="MERN stack: MongoDB - Express - React - Node.js
"
title[3]="MEAN stack: MongoDB - Express - AngularJS - Node.js
"
title[4]="Clean Architecture (Test Driven Development) 
"
title[5]="Virtulization: QEMU - KVM
"
title[6]="GPU API: CUDA Toolkit 10.2
"

declare -a module
module[1]="module.android"
module[2]="module.mern"
module[3]="module.mean"
module[4]="module.TDD"
module[5]="module.vm"
module[6]="module.cuda"

module.android() {
	vscode
	genymotion
	flutter
	android-studio
}

module.mern() {
	nodejs
	reactjs
	express
	mongodb
}

module.mean() {
	nodejs
	angularjs
	express
	mongodb
}

module.TDD() {
	tdd
}

module.vm() {
	qemukvm
}

module.cuda() {
	cudatoolkit
}


for i in "${!title[@]}"; do echo "$i) ${title[$i]}"; done

read option
${module[$option]}
