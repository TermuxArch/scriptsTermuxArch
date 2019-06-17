#!/bin/bash -e
# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
# Hosting https://sdrausty.github.io/TermuxArch courtesy https://pages.github.com
# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
# https://sdrausty.github.io/TermuxArch/README has information about this project. 
################################################################################

callsystem ()
{
	mkdir -p $HOME$rootdir
	cd $HOME$rootdir
	detectsystem
}

copybin2path ()
{
	printf "\033[0;34m 🕛 > 🕚 \033[0m"
	if [[ ":$PATH:" == *":$HOME/bin:"* ]] && [ -d $HOME/bin ]; then
		BPATH=$HOME/bin
	else
		BPATH=$PREFIX/bin
	fi
	while true; do
	printf "Copy \033[1m$bin\033[0m to \033[1m$BPATH\033[0m?  " 
	read -p "Answer yes or no [Y|n]. " answer
	if [[ $answer = [Yy]* ]] || [[ $answer = "" ]];then
		cp $HOME$rootdir/$bin $BPATH
		printf "\n\033[0;34m 🕛 > 🕦 \033[0mCopied \033[1m$bin\033[0m to \033[1m$PREFIX/bin\033[0m.\n\n"
		break
	elif [[ $answer = [Nn]* ]] || [[ $answer = [Qq]* ]];then
		printf "\n"
		break
	else
		printf "\n\033[0;34m 🕛 > 🕚 \033[0mYou answered \033[33;1m$answer\033[0m.\n\n\033[0;34m 🕛 > 🕚 \033[0mAnswer Yes or No (y|n).\n"
	fi
	done
}

detectsystem ()
{
	printdetectedsystem
	if [ $(getprop ro.product.cpu.abi) = armeabi ];then
		armv5l
	elif [ $(getprop ro.product.cpu.abi) = armeabi-v7a ];then
		detectsystem2 
	elif [ $(getprop ro.product.cpu.abi) = arm64-v8a ];then
		aarch64
	elif [ $(getprop ro.product.cpu.abi) = x86 ];then
		i686 
	elif [ $(getprop ro.product.cpu.abi) = x86_64 ];then
		x86_64
	else
		printmismatch 
	fi
}

detectsystem2 ()
{
	if [[ $(getprop ro.product.device) == *_cheets ]];then
		armv7lChrome 
	else
		armv7lAndroid  
	fi
}

mainblock ()
{ 
	rmarchq
	spaceinfoq
	callsystem 
	termux-wake-unlock
#	rm $HOME$rootdir/root/bin/setupbin.sh
	printfooter
	$HOME$rootdir/$bin 
}

makebin ()
{
	makestartbin 
	printconfigq 
	touchupsys 
}

makesetupbin ()
{
	cat > root/bin/setupbin.sh <<- EOM
	#!$PREFIX/bin/bash -e
	unset LD_PRELOAD
	exec proot --link2symlink -0 -r $HOME$rootdir/ -b /dev/ -b /sys/ -b /proc/ -b /storage/ -b $HOME -w $HOME /bin/env -i HOME=/root TERM="$TERM" PS1='[termux@arch \W]\$ ' LANG=$LANG PATH=/bin:/usr/bin:/sbin:/usr/sbin $HOME$rootdir/root/bin/finishsetup.sh
	EOM
	chmod 700 root/bin/setupbin.sh
}

makestartbin ()
{
	cat > $bin <<- EOM
	#!$PREFIX/bin/bash -e
	unset LD_PRELOAD
	exec proot --link2symlink -0 -r $HOME$rootdir/ -b /dev/ -b /sys/ -b /proc/ -b /storage/ -b $HOME -w $HOME /bin/env -i HOME=/root TERM="$TERM" PS1='[termux@arch \W]\$ ' LANG=$LANG PATH=/bin:/usr/bin:/sbin:/usr/sbin /bin/bash --login
	EOM
	chmod 700 $bin
}

makesystem ()
{
	printwla 
	termux-wake-lock 
	printdone 
	if [ $(getprop ro.product.cpu.abi) = x86 ] || [ $(getprop ro.product.cpu.abi) = x86_64 ];then
		getimage
	else
		if [ "$mirror" = "os.archlinuxarm.org" ] || [ "$mirror" = "mirror.archlinuxarm.org" ]; then
			ftchstnd 
		else
			ftchit
		fi
	fi
	printmd5check
	if md5sum -c $file.md5 1>/dev/null ; then
		printmd5success
		preproot 
	else
		rmarchrm 
		printmd5error
	fi
	rm *.tar.gz *.tar.gz.md5
	makebin 
}

preproot ()
{
	if [ $(du $HOME$rootdir/*z | awk {'print $1'}) -gt 112233 ];then
		if [ $(getprop ro.product.cpu.abi) = x86 ] || [ $(getprop ro.product.cpu.abi) = x86_64 ];then
			#cd $HOME
			#proot --link2symlink -0 $PREFIX/bin/applets/tar xf $HOME$rootdir$file 
			#cd $HOME$rootdir
			proot --link2symlink -0 bsdtar -xpf $file --strip-components 1 
		else
			proot --link2symlink -0 $PREFIX/bin/applets/tar xf $file 
		fi
	else
		printf "\n\n\033[1;31mDownload Exception!  Execute \033[0;32mbash setupTermuxArch.sh\033[1;31m again…\n"'\033]2;  Thank you for using setupTermuxArch.sh.  Execute `bash setupTermuxArch.sh` again…\007'
		exit
	fi
}

runfinishsetup ()
{
	if [[ $ed = "" ]];then
		editors 
	fi
	$ed $HOME$rootdir/etc/pacman.d/mirrorlist
	while true; do
		printf "\n\033[0;32mWould you like to run \033[1;32mlocale-gen\033[0;32m to generate the en_US.UTF-8 locale, or edit \033[1;32m/etc/locale.gen\033[0;32m specifying your preferred language(s) before running \033[1;32mlocale-gen\033[0;32m?  "
		read -p "Answer run or edit [R|e]. " ye
	if [[ $ye = [Rr]* ]] || [[ $ye = "" ]];then
		break
	elif [[ $ye = [Ee]* ]];then
		$ed $HOME$rootdir/etc/locale.gen
		break
	else
		printf "\nYou answered \033[1;36m$ye\033[1;32m.\n"
		printf "\nAnswer run or edit [R|e].  \n"
	fi
	done
	$HOME$rootdir/root/bin/setupbin.sh 
}

runfinishsetupq ()
{
	while true; do
		printf "\n\033[0;32mWould you like to run \033[1;32mfinishsetup.sh\033[0;32m to complete the Arch Linux configuration now, or at a later time?  Now is recommended; "
		read -p "Answer now or later [N|l]. " nl
	if [[ $nl = [Nn]* ]] || [[ $nl = "" ]];then
		runfinishsetup 
		break
	elif [[ $nl = [Ll]* ]];then
		printf "\n\033[0;32mSet the geographically nearby mirror in \033[1;32m/etc/pacman.d/mirrorlist\033[0;32m first.  Then use \033[1;32m$HOME$rootdir/root/bin/setupbin.sh\033[0;32m in Termux to run \033[1;32mfinishsetup.sh\033[0;32m or simply \033[1;32mfinishsetup.sh\033[0;32m in Arch Linux Termux PRoot."
		break
	else
		printf "\nYou answered \033[1;36m$nl\033[1;32m.\n"
		printf "\nAnswer now or later [N|l].\n"
	fi
	done
	printf "\n"
}

setlocalegen()
{
	if [ -e etc/locale.gen ]; then
		sed -i '/\#en_US.UTF-8 UTF-8/{s/#//g;s/@/-at-/g;}' etc/locale.gen 
	else
		cat >  etc/locale.gen <<- EOM
		en_US.UTF-8 UTF-8 
		EOM
	fi
}

touchupsys ()
{
	mkdir -p root/bin
	addauser
	addauserps
	addbash_profile 
	addbashrc 
	adddfa
	addga
	addgcl
	addgcm
	addgp
	addgpl
	addmotd
	addprofile 
	addresolvconf 
	addt 
	addyt 
	addv 
	setlocalegen
	makefinishsetup
	makesetupbin 
	runfinishsetupq
}

