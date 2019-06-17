#!/bin/bash -e
# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
# Hosting https://sdrausty.github.io/TermuxArch courtesy https://pages.github.com
# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
# https://sdrausty.github.io/TermuxArch/README has information about this project. 
################################################################################

addae ()
{
	cat > root/bin/ae <<- EOM
	#!/bin/bash -e
	# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
	# Contributed by https://github.com/cb125
	# Hosting https://sdrausty.github.io/TermuxArch courtesy https://pages.github.com
	# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
	# https://sdrausty.github.io/TermuxArch/README has information about this project. 
	################################################################################
	watch cat /proc/sys/kernel/random/entropy_avail
	EOM
	chmod 770 root/bin/ae 
}

addauser ()
{
	# Add Arch Linux user.
	cat > root/bin/addauser <<- EOM
	#!/bin/bash -e
	# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
	# Hosting https://sdrausty.github.io/TermuxArch courtesy https://pages.github.com
	# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
	# https://sdrausty.github.io/TermuxArch/README has information about this project. 
	################################################################################
	useradd \$1
	cp -r /root /home/\$1
	su - \$1
	EOM
	chmod 770 root/bin/addauser 
}

addauserps ()
{
	# Add Arch Linux user and create user login Termux startup script. 
	cat > root/bin/addauserps <<- EOM
	#!/bin/bash -e
	# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
	# Hosting https://sdrausty.github.io/TermuxArch courtesy https://pages.github.com
	# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
	# https://sdrausty.github.io/TermuxArch/README has information about this project. 
	################################################################################
	useradd \$1
	cp -r /root /home/\$1
	su - \$1
	EOM
	echo "cat > $HOME/bin/${bin}user\$1 <<- EOM " >> root/bin/addauserps 
	cat >> root/bin/addauserps <<- EOM
	#!/bin/bash -e
	# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
	# Hosting https://sdrausty.github.io/TermuxArch courtesy https://pages.github.com
	# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
	# https://sdrausty.github.io/TermuxArch/README has information about this project. 
	################################################################################
	unset LD_PRELOAD
	exec proot --kill-on-exit --link2symlink -0 -r $installdir -b /dev/ -b \$ANDROID_DATA -b \$EXTERNAL_STORAGE -b /proc/ -w "\$PWD" /bin/env -i HOME=/root TERM=\$TERM /bin/su - \$1 --login
	EOM
	echo EOM >> root/bin/addauserps 
	cat >> root/bin/addauserps <<- EOM
	chmod 770 $HOME/bin/${bin}user\$1
	EOM
	chmod 770 root/bin/addauserps 
}

addauserpsc ()
{
	# Add Arch Linux user and create user login Termux startup script. 
	cat > root/bin/addauserpsc <<- EOM
	#!/bin/bash -e
	# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
	# Hosting https://sdrausty.github.io/TermuxArch courtesy https://pages.github.com
	# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
	# https://sdrausty.github.io/TermuxArch/README has information about this project. 
	################################################################################
	useradd \$1
	cp -r /root /home/\$1
	su - \$1
	EOM
	echo "cat > $HOME/bin/${bin}user\$1 <<- EOM " >> root/bin/addauserpsc 
	cat >> root/bin/addauserpsc <<- EOM
	#!/bin/bash -e
	# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
	# Hosting https://sdrausty.github.io/TermuxArch courtesy https://pages.github.com
	# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
	# https://sdrausty.github.io/TermuxArch/README has information about this project. 
	################################################################################
	unset LD_PRELOAD
	exec proot --kill-on-exit --link2symlink -0 -r $installdir -b /dev/ -b \$ANDROID_DATA -b \$EXTERNAL_STORAGE -b /proc/ -w "\$PWD" /bin/env -i HOME=/root TERM=\$TERM /bin/su - \$1 --login
	EOM
	echo EOM >> root/bin/addauserpsc 
	cat >> root/bin/addauserpsc <<- EOM
	chmod 770 $HOME/bin/${bin}user\$1
	EOM
	chmod 770 root/bin/addauserpsc 
}

addbash_profile ()
{
	cat > root/.bash_profile <<- EOM
	PATH=\$HOME/bin:\$PATH
	. \$HOME/.bashrc
	PS1="[\A\[\033[0;32m\] \W \[\033[0m\]]\\$ "
	EOM
	if [ -e $HOME/.bash_profile ] ; then
		grep proxy $HOME/.bash_profile |grep "export" >>  root/.bash_profile 2>/dev/null||:
	fi
}

addbashrc ()
{
	cat > root/.bashrc <<- EOM
	if [ ! -e \$HOME/.hushlogin ] && [ ! -e \$HOME/.chushlogin ];then
		. /etc/motd
	fi
	if [ -e \$HOME/.chushlogin ];then
		rm \$HOME/.chushlogin
	fi
	alias c='cd .. && pwd'
	alias ..="cd ../.. && pwd"
	alias ...="cd ../../.. && pwd"
	alias ....="cd ../../../.. && pwd"
	alias .....="cd ../../../../.. && pwd"
	alias d='du -hs'
	alias e='logout'
	alias g='ga; gcm; gp'
	alias gca='git commit -a'
	alias gcam='git commit -am'
	#alias gp='git push https://username:password@github.com/username/repository.git master'
	alias h='history >> \$HOME/.historyfile'
	alias j='jobs'
	alias l='ls -alG'
	alias lr='ls -alR'
	alias ls='ls --color=always'
	alias p='pwd'
	alias pcs='pacman  -S --color=always'
	alias pcss='pacman  -Ss --color=always'
	alias q='logout'
	alias rf='rm -rf'
	EOM
	if [ -e $HOME/.bashrc ] ; then
		grep proxy $HOME/.bashrc |grep "export" >>  root/.bashrc 2>/dev/null||:
	fi
}

addce ()
{
	cat > root/bin/ce <<- EOM
	#!/bin/bash -e
	# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
	# Hosting https://sdrausty.github.io/TermuxArch courtesy https://pages.github.com
	# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
	# https://sdrausty.github.io/TermuxArch/README has information about this project. 
	# Create entropy by doing things on device.
	################################################################################
	printf "\033[1;32m"'\033]2;  Thank you for using \`ce\` from TermuxArch 📲  \007'
	t=240
	for i in {1..5}; do
		\$(nice -n 20 find / -type f -exec cat {} \\; >/dev/null 2>/dev/null & sleep \$t ; kill \$! 2>/dev/null) &
		\$(nice -n 20 ls -alR / >/dev/null 2>/dev/null & sleep \$t ; kill \$! 2>/dev/null) &
		\$(nice -n 20 find / >/dev/null 2>/dev/null & sleep \$t ; kill \$! 2>/dev/null) &
		\$(nice -n 20 cat /dev/urandom >/dev/null & sleep \$t ; kill \$! 2>/dev/null) &
	done
	for i in {1..1200}; do
	#	printf "Available entropy reading \$i of \$t	"
		printf %b \$(cat /proc/sys/kernel/random/entropy_avail 2>/dev/null) " "
		sleep 0.2
	done
	EOM
	chmod 770 root/bin/ce 
}

addces ()
{
	cat > bin/ce <<- EOM
	#!/bin/bash -e
	# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
	# Hosting https://sdrausty.github.io/TermuxArch courtesy https://pages.github.com
	# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
	# https://sdrausty.github.io/TermuxArch/README has information about this project. 
	# Create entropy Termux startup file.
	################################################################################
	unset LD_PRELOAD
	EOM
	if [[ "$kid" -eq 1 ]]; then
		cat >> bin/ce <<- EOM
		exec proot --kill-on-exit --kernel-release=4.14.15 --link2symlink -0 -r $installdir -b /dev/ -b \$ANDROID_DATA -b \$EXTERNAL_STORAGE -b /proc/ -w "\$PWD" /bin/env -i HOME=/root TERM=\$TERM $installdir/root/bin/ce 
		EOM
	else
		cat >> bin/ce <<- EOM
		exec proot --kill-on-exit --link2symlink -0 -r $installdir -b /dev/ -b \$ANDROID_DATA -b \$EXTERNAL_STORAGE -b /proc/ -w "\$PWD" /bin/env -i HOME=/root TERM=\$TERM $installdir/root/bin/ce 
		EOM
	fi
	chmod 770 bin/ce 
}

addexd () {
	cat > bin/exd <<- EOM
	#!/bin/bash -e
	# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
	# Hosting https://sdrausty.github.io/TermuxArch courtesy https://pages.github.com
	# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
	# https://sdrausty.github.io/TermuxArch/README has information about this project. 
	################################################################################
	export DISPLAY=:0 PULSE_SERVER=tcp:127.0.0.1:4712
	EOM
	chmod 770 bin/exd 
}

adddfa () {
	cat > root/bin/dfa <<- EOM
	#!/bin/bash -e
	# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
	# Hosting https://sdrausty.github.io/TermuxArch courtesy https://pages.github.com
	# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
	# https://sdrausty.github.io/TermuxArch/README has information about this project. 
	################################################################################
	units=\`df 2>/dev/null | awk 'FNR == 1 {print \$2}'\`
	usrspace=\`df 2>/dev/null | grep "/data" | awk {'print \$4'}\`
	printf "\033[0;33m\$usrspace \$units of free user space is available on this device.\n\033[0m"
	EOM
	chmod 770 root/bin/dfa 
}

addga ()
{
	cat > root/bin/ga  <<- EOM
	#!/bin/bash -e
	# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
	# Hosting https://sdrausty.github.io/TermuxArch courtesy https://pages.github.com
	# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
	# https://sdrausty.github.io/TermuxArch/README has information about this project. 
	################################################################################
	if [ ! -e /usr/bin/git ] ; then
		pacman --noconfirm --color=always -Syu git
		git add .
	else
		git add .
	fi
	EOM
	chmod 770 root/bin/ga 
}

addgcl ()
{
	cat > root/bin/gcl  <<- EOM
	#!/bin/bash -e
	# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
	# Hosting https://sdrausty.github.io/TermuxArch courtesy https://pages.github.com
	# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
	# https://sdrausty.github.io/TermuxArch/README has information about this project. 
	################################################################################
	if [ ! -e /usr/bin/git ] ; then
		pacman --noconfirm --color=always -Syu git 
		git clone \$@
	else
		git clone \$@
	fi
	EOM
	chmod 770 root/bin/gcl 
}

addgcm ()
{
	cat > root/bin/gcm  <<- EOM
	#!/bin/bash -e
	# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
	# Hosting https://sdrausty.github.io/TermuxArch courtesy https://pages.github.com
	# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
	# https://sdrausty.github.io/TermuxArch/README has information about this project. 
	################################################################################
	if [ ! -e /usr/bin/git ] ; then
		pacman --noconfirm --color=always -Syu git 
		git commit
	else
		git commit
	fi
	EOM
	chmod 770 root/bin/gcm 
}

addgpl ()
{
	cat > root/bin/gpl  <<- EOM
	#!/bin/bash -e
	# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
	# Hosting https://sdrausty.github.io/TermuxArch courtesy https://pages.github.com
	# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
	# https://sdrausty.github.io/TermuxArch/README has information about this project. 
	################################################################################
	if [ ! -e /usr/bin/git ] ; then
		pacman --noconfirm --color=always -Syu git 
		git pull
	else
		git pull
	fi
	EOM
	chmod 770 root/bin/gpl 
}

addgp ()
{
	cat > root/bin/gp  <<- EOM
	#!/bin/bash -e
	# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
	# Hosting https://sdrausty.github.io/TermuxArch courtesy https://pages.github.com
	# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
	# https://sdrausty.github.io/TermuxArch/README has information about this project. 
	# git push https://username:password@github.com/username/repository.git master
	################################################################################
	if [ ! -e /usr/bin/git ] ; then
		pacman --noconfirm --color=always -Syu git 
		git push
	else
		git push
	fi
	EOM
	chmod 700 root/bin/gp 
}

addmotd ()
{
	cat > etc/motd  <<- EOM
	printf "\033[1;34mWelcome to Arch Linux in Termux!  Enjoy!\nChat:    \033[0mhttps://gitter.im/termux/termux/\n\033[1;34mHelp:    \033[0;34minfo query \033[1;34mand \033[0;34mman query\n\033[1;34mPortal:  \033[0mhttps://wiki.termux.com/wiki/Community\n\n\033[1;34mInstall a package: \033[0;34mpacman -S package\n\033[1;34mMore  information: \033[0;34mpacman [-D|F|Q|R|S|T|U]h\n\033[1;34mSearch   packages: \033[0;34mpacman -Ss query\n\033[1;34mUpgrade  packages: \033[0;34mpacman -Syu\n\n\033[0m"
	EOM
}

addpc () {
	cat > root/bin/pc  <<- EOM
	#!/bin/bash -e
	# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
	# Hosting https://sdrausty.github.io/TermuxArch courtesy https://pages.github.com
	# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
	# https://sdrausty.github.io/TermuxArch/README has information about this project. 
	################################################################################
	pacman --noconfirm --color=always -Syu \$@ 
	trim
	EOM
	chmod 700 root/bin/pc 
}

addpci () {
	cat > root/bin/pci  <<- EOM
	#!/bin/bash -e
	# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
	# Hosting https://sdrausty.github.io/TermuxArch courtesy https://pages.github.com
	# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
	# https://sdrausty.github.io/TermuxArch/README has information about this project. 
	################################################################################
	pacman --noconfirm --color=always -S \$@ 
	trim
	EOM
	chmod 700 root/bin/pci 
}

addprofile ()
{
	cat > root/.profile <<- EOM
	. \$HOME/.bash_profile
	EOM
	if [ -e $HOME/.profile ] ; then
		grep "proxy" $HOME/.profile |grep "export" >>  root/.profile 2>/dev/null||:
	fi
}

addresolvconf ()
{
	rm etc/resolv* 2>/dev/null||:
	cat > etc/resolv.conf <<- EOM
	nameserver 8.8.8.8
	nameserver 8.8.4.4
	EOM
}

addt ()
{
	cat > root/bin/t  <<- EOM
	#!/bin/bash -e
	# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
	# Hosting https://sdrausty.github.io/TermuxArch courtesy https://pages.github.com
	# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
	# https://sdrausty.github.io/TermuxArch/README has information about this project. 
	################################################################################
	if [ ! -e /usr/bin/tree ] ; then
		pacman --noconfirm --color=always -Syu tree 
		tree \$@
	else
		tree \$@
	fi
	EOM
	chmod 770 root/bin/t 
}

addthstartarch ()
{
	cat > root/bin/th$startbin <<- EOM
	#!/bin/bash -e
	# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
	# Hosting https://sdrausty.github.io/TermuxArch courtesy https://pages.github.com
	# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
	# https://sdrausty.github.io/TermuxArch/README has information about this project. 
	################################################################################
	echo $startbin help
	$startbin help
	sleep 1
	echo $startbin command "pwd && whoami"
	$startbin command "pwd && whoami"
	sleep 1
	echo $startbin login user 
	$startbin login user 
	echo $startbin raw su user -c "pwd && whoami"
	$startbin raw su user -c "pwd && whoami"
	sleep 1
	echo $startbin su user "pwd && whoami"
	$startbin su user "pwd && whoami"
	echo th$startbin done
	EOM
	chmod 770 root/bin/th$startbin
}

addtour ()
{
	cat > root/bin/tour <<- EOM
	#!/bin/bash -e
	# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
	# Hosting https://sdrausty.github.io/TermuxArch courtesy https://pages.github.com
	# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
	# https://sdrausty.github.io/TermuxArch/README has information about this project. 
	################################################################################
	printf "\n\033[1;32m==> \033[1;37mRunning \033[1;32mlr ~\033[1;37m\n\n"
	ls -R --color=always ~
	sleep 1
	printf "\n\033[1;32m==> \033[1;37mRunning \033[1;32mt ~\033[1;37m\n\n"
	t ~
	sleep 1
	printf "\n\033[1;32m==> \033[1;37mRunning \033[1;32mcat ~/.bash_profile\033[1;37m\n\n"
	cat ~/.bash_profile
	sleep 1
	printf "\n\033[1;32m==> \033[1;37mRunning \033[1;32mcat ~/.bashrc\033[1;37m\n\n"
	cat ~/.bashrc
	sleep 1
	printf "\n\033[1;32m==> \033[1;37mShort tour is complete.  Run this script again at a later time and you might be surprised at how the environment changes.\n\n"
	EOM
	chmod 770 root/bin/tour 
}

addtrim ()
{
	cat > root/bin/trim <<- EOM
	#!/bin/bash -e
	# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
	# Hosting https://sdrausty.github.io/TermuxArch courtesy https://pages.github.com
	# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
	# Contributed by @cswl 
	# https://sdrausty.github.io/TermuxArch/README has information about this project. 
	################################################################################
	echo [1/4] rm -rf /boot/
	rm -rf /boot/
	echo [2/4] rm -rf /usr/lib/firmware
	rm -rf /usr/lib/firmware
	echo [3/4] rm -rf /usr/lib/modules
	rm -rf /usr/lib/modules
	echo [4/4] pacman -Scc --noconfirm --color=always
	pacman -Scc --noconfirm --color=always
	echo trim:done
	EOM
	chmod 770 root/bin/trim 
}

addv ()
{
	cat > root/bin/v  <<- EOM
	#!/bin/bash -e
	# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
	# Hosting https://sdrausty.github.io/TermuxArch courtesy https://pages.github.com
	# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
	# https://sdrausty.github.io/TermuxArch/README has information about this project. 
	################################################################################
	if [ ! -e /usr/bin/vim ] ; then
		pacman --noconfirm --color=always -Syu vim 
		vim \$@
	else
		vim \$@
	fi
	EOM
	chmod 770 root/bin/v 
}

addwe ()
{
	cat > bin/we <<- EOM
	#!/bin/bash -e
	# Watch available entropy on device.
	# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
	# Hosting https://sdrausty.github.io/TermuxArch courtesy https://pages.github.com
	# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
	# https://sdrausty.github.io/TermuxArch/README has information about this project. 
	# cat /proc/sys/kernel/random/entropy_avail contributed by https://github.com/cb125
	################################################################################

	i=1
	multi=16
	entropy0=\$(cat /proc/sys/kernel/random/entropy_avail 2>/dev/null) 

	printintro ()
	{
		printf "\n\033[1;32mTermuxArch Watch Entropy:\n"'\033]2; TermuxArch Watch Entropy 📲  \007'
	}

	printtail ()
	{
		printf "\n\n\033[1;32mWatch Entropy from TermuxArch 🏁 \n\n"'\033]2; Watch Entropy courtesy TermuxArch 🏁 \007'
	}

	printusage ()
	{
		printf "\n\033[0;32mUsage:  \033[1;32mwe \033[0;32m Watch Entropy simple.\n\n	\033[1;32mwe sequential\033[0;32m Watch Entropy sequential.\n\n	\033[1;32mwe simple\033[0;32m Watch Entropy simple.\n\n	\033[1;32mwe verbose\033[0;32m Watch Entropy verbose.\n\n"'\033]2; Watch Entropy courtesy TermuxArch 📲  \007'
	}

	infif ()
	{
		if [[ \$entropy0 = "inf" ]] || [[ \$entropy0 = "" ]] || [[ \$entropy0 = "0" ]];then
			entropy0=1000
			printf "\033[1;32m∞^∞infifinfif2minfifinfifinfifinfif∞=1\033[0;32minfifinfifinfifinfif\033[0;32m∞==0infifinfifinfifinfif\033[0;32minfifinfifinfif∞"
		fi
	}

	en0=\$((\${entropy0}*\$multi))

	esleep ()
	{
		int=\$(echo "\$i/\$entropy0" | bc -l)
		for i in {1..5}; do
			if (( \$(echo "\$int > 0.1"|bc -l) ));then
				tmp=\$(echo "\${int}/100" | bc -l)
				int=\$tmp
			fi
			if (( \$(echo "\$int > 0.1"|bc -l) ));then
				break
			fi
		done
	}

	1sleep ()
	{
		sleep 0.1
	}
	
	bcif ()
	{
		commandif=\$(command -v getprop) ||:
		if [[ \$commandif = "" ]];then
			abcif=\$(command -v bc) ||:
			if [[ \$abcif = "" ]];then
				printf "\033[1;34mInstalling \033[0;32mbc\033[1;34m…\n\n\033[1;32m"
				pacman -Syu bc --noconfirm --color=always
				printf "\n\033[1;34mInstalling \033[0;32mbc\033[1;34m: \033[1;32mDONE\n\033[0m"
			fi
		else
			tbcif=\$(command -v bc) ||:
			if [[ \$tbcif = "" ]];then
				printf "\033[1;34mInstalling \033[0;32mbc\033[1;34m…\n\n\033[1;32m"
				pkg install bc --yes
				printf "\n\033[1;34mInstalling \033[0;32mbc\033[1;34m: \033[1;32mDONE\n\033[0m"
			fi
		fi
	}

	entropysequential ()
	{
	printf "\n\033[1;32mWatch Entropy Sequential:\n\n"'\033]2; Watch Entropy Sequential 📲  \007'
	for i in \$(seq 1 \$en0); do
		entropy0=\$(cat /proc/sys/kernel/random/entropy_avail 2>/dev/null) 
		infif 
		printf "\033[1;30m \$en0 \033[0;32m\$i \033[1;32m\${entropy0}\n"
		1sleep 
	done
	}

	entropysimple ()
	{
	printf "\n\033[1;32mWatch Entropy Simple:\n\n"'\033]2; Watch Entropy Simple 📲  \007'
	for i in \$(seq 1 \$en0); do
		entropy0=\$(cat /proc/sys/kernel/random/entropy_avail 2>/dev/null) 
		infif 
		printf "\033[1;32m\${entropy0} " 
		1sleep 
	done
	}

	entropyverbose ()
	{
	printf "\n\033[1;32mWatch Entropy Verbose:\n\n"'\033]2; Watch Entropy Verbose 📲  \007'
	for i in \$(seq 1 \$en0); do
		entropy0=\$(cat /proc/sys/kernel/random/entropy_avail 2>/dev/null) 
		infif 
		printf "\033[1;30m \$en0 \033[0;32m\$i \033[1;32m\${entropy0} \033[0;32m#E&&√♪"
		esleep 
		sleep \$int
		entropy1=\$(cat /proc/sys/kernel/random/uuid 2>/dev/null) 
		infif 
		printf "\$entropy1" 
		esleep 
		sleep \$int
		printf "&&π™♪&##|♪FLT" 
		esleep 
		sleep \$int
		printf "\$int♪||e"
		esleep 
		sleep \$int
	done
	}

	# [we sequential] Run sequential watch entropy.
	if [[ \$1 = [Ss][Ee]* ]] || [[ \$1 = -[Ss][Ee]* ]] || [[ \$1 = --[Ss][Ee]* ]];then
		printintro 
		entropysequential 
	# [we simple] Run simple watch entropy.
	elif [[ \$1 = [Ss]* ]] || [[ \$1 = -[Ss]* ]] || [[ \$1 = --[Ss]* ]];then
		printintro 
		entropysimple 
	# [we verbose] Run verbose watch entropy.
	elif [[ \$1 = [Vv]* ]] || [[ \$1 = -[Vv]* ]] || [[ \$1 = --[Vv]* ]];then
		printintro 
		bcif
		entropyverbose 
	# [] Run default watch entropy.
	elif [[ \$1 = "" ]];then
		printintro 
		entropysequential 
	else
		printusage
	fi
	printtail 
	EOM
	chmod 770 bin/we 
}

addyt ()
{
	cat > root/bin/yt  <<- EOM
	#!/bin/bash -e
	# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
	# Hosting https://sdrausty.github.io/TermuxArch courtesy https://pages.github.com
	# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
	# https://sdrausty.github.io/TermuxArch/README has information about this project. 
	################################################################################
	if [ ! -e /usr/bin/youtube-dl ] ; then
		pacman --noconfirm --color=always -Syu python-pip
		pip install youtube-dl
		youtube-dl \$@
	else
		youtube-dl \$@
	fi
	EOM
	chmod 770 root/bin/yt 
}

