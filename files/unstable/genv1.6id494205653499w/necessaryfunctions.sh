#!/bin/env bash
# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
# Hosting https://sdrausty.github.io/TermuxArch courtesy https://pages.github.com
# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
# https://sdrausty.github.io/TermuxArch/README has information about this project. 
################################################################################

callsystem() {
	declare COUNTER=""
	if [[ "$cpuabi" = "$cpuabix86" ]] || [[ "$cpuabi" = "$cpuabix86_64" ]];then
		getimage
	else
		if [[ "$mirror" = "os.archlinuxarm.org" ]] || [[ "$mirror" = "mirror.archlinuxarm.org" ]]; then
			until ftchstnd;do
				ftchstnd ||: 
				sleep 2
				printf "\\n"
				COUNTER=$((COUNTER + 1))
				if [[ "$COUNTER" = 4 ]];then 
					printmax 
					exit
				fi
			done
		else
			ftchit
		fi
	fi
}

copystartbin2path() {
	if [[ ":$PATH:" == *":$HOME/bin:"* ]] && [[ -d "$HOME"/bin ]]; then
		BPATH="$HOME"/bin
	else
		BPATH="$PREFIX"/bin
	fi
	cp "$installdir/$startbin" "$BPATH"
	printf "\\e[0;34m 🕛 > 🕦 \\e[1;32m$startbin \\e[0mcopied to \\e[1m$BPATH\\e[0m.\\n\\n"
}

copystartbin2pathq() {
	while true; do
	printf "\\e[0;34m 🕛 > 🕚 \\e[0mCopy \\e[1m$startbin\\e[0m to \\e[1m$BPATH\\e[0m?  "'\033]2; 🕛 > 🕚 Copy to $PATH [Y|n]?\007'
	read -n 1 -p "Answer yes or no [Y|n] " answer
	if [[ "$answer" = [Yy]* ]] || [[ "$answer" = "" ]];then
		cp "$installdir/$startbin" "$BPATH"
		printf "\\n\\e[0;34m 🕛 > 🕦 \\e[0mCopied \\e[1m$startbin\\e[0m to \\e[1m$BPATH\\e[0m.\\n\\n"
		break
	elif [[ "$answer" = [Nn]* ]] || [[ "$answer" = [Qq]* ]];then
		printf "\\n"
		break
	else
		printf "\\n\\e[0;34m 🕛 > 🕚 \\e[0mYou answered \\e[33;1m$answer\\e[0m.\\n\\n\\e[0;34m 🕛 > 🕚 \\e[0mAnswer yes or no [Y|n]\\n\\n"
	fi
	done
}

detectsystem() {
	printdetectedsystem
	if [[ "$cpuabi" = "$cpuabi5" ]];then
		armv5l
	elif [[ "$cpuabi" = "$cpuabi7" ]];then
		detectsystem2 
	elif [[ "$cpuabi" = "$cpuabi8" ]];then
		aarch64
	elif [[ "$cpuabi" = "$cpuabix86" ]];then
		i686 
	elif [[ "$cpuabi" = "$cpuabix86_64" ]];then
		x86_64
	else
		printmismatch 
	fi
}

detectsystem2() {
	if [[ "$(getprop ro.product.device)" == *_cheets ]];then
		armv7lChrome 
	else
		armv7lAndroid  
	fi
}

lkernid() {
	declare kid=""
	ur="$("$PREFIX"/bin/applets/uname -r)"
	declare -i KERNEL_VERSION="$(echo "$ur" |awk -F'.' '{print $1}')"
	declare -i MAJOR_REVISION="$(echo "$ur" |awk -F'.' '{print $2}')"
	declare -- tmp="$(echo "$ur" |awk -F'.' '{print $3}')"
	declare -- MINOR_REVISION="$(echo "${tmp:0:3}" |sed 's/[^0-9]*//g')"
	if [[ "$KERNEL_VERSION" -le 2 ]]; then
		kid=1
	else
		if [[ "$KERNEL_VERSION" -eq 3 ]]; then
			if [[ "$MAJOR_REVISION" -lt 2 ]]; then
				kid=1
			else
				if [[ "$MAJOR_REVISION" -eq 2 ]] && [[ "$MINOR_REVISION" -eq 0 ]]; then
					kid=1
				fi
			fi
		fi
	fi
}

lkernid 

mainblock() { 
	namestartarch 
	spaceinfo
	prepinstalldir
	detectsystem 
	wakeunlock 
	printfooter
	"$installdir/$startbin" ||:
# 	"$startbin" help
	printstarthelp
	printfooter2
}

makefinishsetup() {
	binfnstp=finishsetup.sh  
	printf "$filehdr1" > root/bin/$binfnstp
	printf "$filehdr2" >> root/bin/$binfnstp
	cat >> root/bin/"$binfnstp" <<- EOM
versionid="gen.v1.6 id494205653499"
	printf "\\n\\e[1;34m:: \\e[1;37mRemoving redundant packages for Termux PRoot installation…\\n"
	EOM
	if [[ -e "$HOME"/.bash_profile ]];then
		grep "proxy" "$HOME"/.bash_profile | grep "export" >> root/bin/"$binfnstp" 2>/dev/null ||:
	fi
	if [[ -e "$HOME"/.bashrc ]];then
		grep "proxy" "$HOME"/.bashrc  | grep "export" >> root/bin/"$binfnstp" 2>/dev/null ||:
	fi
	if [[ -e "$HOME"/.profile ]];then
		grep "proxy" "$HOME"/.profile | grep "export" >> root/bin/"$binfnstp" 2>/dev/null ||:
	fi
	if [[ -z "${lcr:-}" ]] ; then
	 	if [[ "$cpuabi" = "$cpuabi5" ]];then
	 		printf "pacman -Rc linux-armv5 linux-firmware --noconfirm --color=always 2>/dev/null ||:\\n" >> root/bin/"$binfnstp"
	 	elif [[ "$cpuabi" = "$cpuabi7" ]];then
	 		printf "pacman -Rc linux-armv7 linux-firmware --noconfirm --color=always 2>/dev/null ||:\\n" >> root/bin/"$binfnstp"
	 	elif [[ "$cpuabi" = "$cpuabi8" ]];then
	 		printf "pacman -Rc linux-aarch64 linux-firmware --noconfirm --color=always 2>/dev/null ||:\\n" >> root/bin/"$binfnstp"
	 	fi
		if [[ "$cpuabi" = "$cpuabix86" ]];then
			printf "./root/bin/keys x86\\n" >> root/bin/"$binfnstp"
		elif [[ "$cpuabi" = "$cpuabix86_64" ]];then
			printf "./root/bin/keys x86_64\\n" >> root/bin/"$binfnstp"
		else
	 		printf "./root/bin/keys\\n" >> root/bin/"$binfnstp"
		fi
		if [[ "$cpuabi" = "$cpuabix86" ]] || [[ "$cpuabi" = "$cpuabix86_64" ]];then
			printf "./root/bin/pci gzip sed \\n" >> root/bin/"$binfnstp"
		else
	 		printf "./root/bin/pci \\n" >> root/bin/"$binfnstp"
		fi
	fi
	cat >> root/bin/"$binfnstp" <<- EOM
	printf "\\n\\e[1;32m==> \\e[0;32m"
   	locale-gen ||:
	printf "\\n\\e[1;34m 🕛 > 🕤 Arch Linux in Termux is installed and configured 📲  \\e[0m" '\033]2; 🕛 > 🕤 Arch Linux in Termux is installed and configured 📲 \007'
	EOM
	chmod 770 root/bin/"$binfnstp" 
}

makesetupbin() {
	printf "$filehdr1" > root/bin/setupbin.sh 
	printf "$filehdr2" >> root/bin/setupbin.sh 
	cat >> root/bin/setupbin.sh <<- EOM
	unset LD_PRELOAD
versionid="gen.v1.6 id494205653499"
	EOM
	echo "$prootstmnt /root/bin/finishsetup.sh ||:" >> root/bin/setupbin.sh 
	chmod 700 root/bin/setupbin.sh
}

makestartbin() {
	printf "$filehdr1" > root/bin/$startbin
	printf "$filehdr2" >> root/bin/$startbin 
	cat >> "$startbin" <<- EOM
versionid="gen.v1.6 id494205653499"
	unset LD_PRELOAD
	declare -g ar2ar="\${@:2}"
	declare -g ar3ar="\${@:3}"
	printusage() { 
	printf "\\n\\e[0;32mUsage:  \\e[1;32m$startbin \\e[0;32mStart Arch Linux as root.  This account should only be reserved for system administration.\\n\\n	\\e[1;32m$startbin command command \\e[0;32mRun Arch Linux command from Termux as root user.\\n\\n	\\e[1;32m$startbin login user \\e[0;32mLogin as user.  Use \\e[1;32maddauser user \\e[0;32mfirst to create a user and the user's home directory.\\n\\n	\\e[1;32m$startbin raw \\e[0;32mConstruct the \\e[1;32mstartarch \\e[0;32mproot statement.  For example \\e[1;32mstartarch raw su - user \\e[0;32mwill login to Arch Linux as user.  Use \\e[1;32maddauser user \\e[0;32mfirst to create a user and the user's home directory.\\n\\n	\\e[1;32m$startbin su user command \\e[0;32mLogin as user and execute command.  Use \\e[1;32maddauser user \\e[0;32mfirst to create a user and the user's home directory.\\n\\n\\e[0m"'\033]2; TermuxArch '$startbin' help 📲  \007' 
	}

	# [] Default Arch Linux in Termux PRoot root login.
	if [[ -z "\${1:-}" ]];then
	EOM
		echo "$prootstmnt /bin/bash -l  " >> "$startbin"
	cat >> "$startbin" <<- EOM
		printf '\033]2; TermuxArch $startbin 📲  \007'
	# [?|help] Displays usage information.
	elif [[ "\$1" = [?]* ]] || [[ "\$1" = -[?]* ]] || [[ "\$1" = --[?]* ]] || [[ "\$1" = [Hh]* ]] || [[ "\$1" = -[Hh]* ]] || [[ "\$1" = --[Hh]* ]];then
		printusage
	# [command args] Execute a command in BASH as root.
	elif [[ "\$1" = [Cc]* ]] || [[ "\$1" = -[Cc]* ]] || [[ "\$1" = --[Cc]* ]];then
		printf '\033]2; $startbin command args 📲  \007'
		touch $installdir/root/.chushlogin
	EOM
		echo "$prootstmnt /bin/bash -lc \"\$ar2ar\" " >> "$startbin"
	cat >> "$startbin" <<- EOM
		printf '\033]2; $startbin command args 📲  \007'
		rm -f $installdir/root/.chushlogin
	# [login user|login user [options]] Login as user [plus options].  Use \`addauser user\` first to create this user and the user's home directory.
	elif [[ "\$1" = [Ll]* ]] || [[ "\$1" = -[Ll]* ]] || [[ "\$1" = --[Ll]* ]] || [[ "\$1" = [Uu]* ]] || [[ "\$1" = -[Uu]* ]] || [[ "\$1" = --[Uu]* ]] ;then
		printf '\033]2; $startbin login user [options] 📲  \007'
	EOM
		echo "$prootstmnt /bin/su - \"\$ar2ar\" " >> "$startbin"
	cat >> "$startbin" <<- EOM
		printf '\033]2; $startbin login user [options] 📲  \007'
	# [raw args] Construct the \`startarch\` proot statement.  For example \`startarch r su - archuser\` will login as user archuser.  Use \`addauser user\` first to create this user and the user home directory.
	elif [[ "\$1" = [Rr]* ]] || [[ "\$1" = -[Rr]* ]] || [[ "\$1" = --[Rr]* ]];then
		printf '\033]2; $startbin raw args 📲  \007'
	EOM
		echo "$prootstmnt /bin/\"\$ar2ar\" " >> "$startbin"
	cat >> "$startbin" <<- EOM
		printf '\033]2; $startbin raw args 📲  \007'
	# [su user command] Login as user and execute command.  Use \`addauser user\` first to create this user and the user's home directory.
	elif [[ "\$1" = [Ss]* ]] || [[ "\$1" = -[Ss]* ]] || [[ "\$1" = --[Ss]* ]];then
		printf '\033]2; $startbin su user command 📲  \007'
		if [[ "\$2" = root ]];then
			touch $installdir/root/.chushlogin
		else
			touch $installdir/home/"\$2"/.chushlogin
		fi
	EOM
		echo "$prootstmnt /bin/su - \"\$2\" -c \"\$ar3ar\" " >> "$startbin"
	cat >> "$startbin" <<- EOM
		printf '\033]2; $startbin su user command 📲  \007'
		if [[ "\$2" = root ]];then
			rm -f $installdir/root/.chushlogin
		else
			rm -f $installdir/home/"\$2"/.chushlogin
		fi
	else
		printusage
	fi
	EOM
	chmod 700 "$startbin"
}

makesystem() {
	wakelock
	callsystem
	printmd5check
	md5check
	printcu 
	rm -f "$installdir"/*.tar.gz "$installdir"/*.tar.gz.md5
	printdone 
	printconfigup 
	touchupsys 
}

md5check() {
	if "$PREFIX"/bin/applets/md5sum -c "$file".md5 1>/dev/null ; then
		printmd5success
		printf "\\e[0;32m"
		set +Ee	
		preproot & spinner "Unpacking" "$file…" 
 		set -Ee
	else
		rm -f "$installdir"/*.tar.gz "$installdir"/*.tar.gz.md5
		printmd5error
	fi
}

preprootdir() {
	cd "$installdir"
	mkdir -p etc 
	mkdir -p var/binds 
	mkdir -p root/bin
	mkdir -p usr/bin
}

prepinstalldir() {
	preprootdir
	addREADME
	addae
	addauser
	addbash_logout 
	addbash_profile 
	addbashrc 
	addcdtd
	addcdth
	addcdtmp
	addch 
	adddfa
	addfbindexample
	addbinds
	addexd
	addga
	addgcl
	addgcm
	addgp
	addgpl
	addkeys
	addmotd
	addmoto
	addpc
	addpci
	addprofile 
	addresolvconf 
	addt 
	addtour
	addtrim 
	addyt
	addwe  
	addv 
	makefinishsetup
	makesetupbin 
	makestartbin 
}

preproot() {
	if [[ "$(ls -al "$installdir"/*z | awk '{ print $5 }')" -gt 557799 ]] ; then
		if [[ "$cpuabi" = "$cpuabix86" ]] || [[ "$cpuabi" = "$cpuabix86_64" ]];then
	 		proot --link2symlink -0 bsdtar -xpf "$file" --strip-components 1  
		else
	 		proot --link2symlink -0 "$PREFIX"/bin/applets/tar -xpf "$file" 
		fi
	else
		printf "\\n\\n\\e[1;31m%s \\e[0;32m%s \\e[1;31m%s\\n\\n\\e[0m" "Download Exception!  Execute" "bash setupTermuxArch.sh $args" "again…"
		printf "\\e]2;%s\\007" "Execute \`bash setupTermuxArch.sh $args\` again…"
		exit
	fi
}

runfinishsetup() {
	printf "\\e[0m"
	if [[ "$fstnd" ]]; then
		nmir="$(echo "$nmirror" |awk -F'/' '{print $3}')"
		sed -e '/http\:\/\/mir/ s/^#*/# /' -i "$installdir"/etc/pacman.d/mirrorlist
		sed -e "/$nmir/ s/^# *//" -i "$installdir"/etc/pacman.d/mirrorlist
	else
	if [[ "$ed" = "" ]];then
		editors 
	fi
	if [[ ! "$(sed 1q  "$installdir"/etc/pacman.d/mirrorlist)" = "# # # # # # # # # # # # # # # # # # # # # # # # # # #" ]];then
		editfiles
	fi
		"$ed" "$installdir"/etc/pacman.d/mirrorlist
	fi
	printf "\\n"
	"$installdir"/root/bin/setupbin.sh 
}

setlanguage() { 
 	_LANG="$(getprop persist.sys.locale)"
	_LANGU="${_LANG:2:1}"
	if [[ "$_LANGU" != "-" ]];then
		_LANG="$(getprop ro.product.locale)"
		_LANGU="${_LANG:2:1}"
	fi
	if [[ "$_LANGU" != "-" ]];then
		_LANG="$(en-US)"
	fi
	_LANGUAGE="${_LANG//-/_}"
}
setlanguage

setlocale() {
	setlanguage
	echo LANG="$_LANGUAGE".UTF-8 >> etc/locale.conf 
	echo LANGUAGE="$_LANGUAGE".UTF-8 >> etc/locale.conf 
	if [[ -e etc/locale.gen ]]; then
		sed -i "/\\#$_LANGUAGE.UTF-8 UTF-8/{s/#//g;s/@/-at-/g;}" etc/locale.gen 
	else
		cat >  etc/locale.gen <<- EOM
		$_LANGUAGE.UTF-8 UTF-8 
		EOM
	fi
}

touchupsys() {
	addmotd
	setlocale
	runfinishsetup
	rm -f root/bin/finishsetup.sh
	rm -f root/bin/setupbin.sh 
}

wakelock() {
	printwla 
	am startservice --user 0 -a com.termux.service_wake_lock com.termux/com.termux.app.TermuxService > /dev/null
	printdone 
}

wakeunlock() {
	printwld 
	am startservice --user 0 -a com.termux.service_wake_unlock com.termux/com.termux.app.TermuxService > /dev/null
	printdone 
}

## EOF
