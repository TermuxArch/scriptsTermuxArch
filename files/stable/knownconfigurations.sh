#!/bin/env bash
# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
# Hosted sdrausty.github.io/TermuxArch courtesy https://pages.github.com
# https://sdrausty.github.io/TermuxArch/README has info about this project. 
# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
# _STANDARD_="function name" && STANDARD="variable name" are under construction.
################################################################################
# `setupTermuxArch.sh manual` shall create `setupTermuxArchConfigs.sh` from this file in the working directory.  Run `setupTermuxArch.sh` and `setupTermuxArchConfigs.sh` loads automaticaly.  `setupTermuxArch.sh help` has more information.  Change CMIRROR (https://wiki.archlinux.org/index.php/Mirrors and https://archlinuxarm.org/about/mirrors) to desired geographic location in `setupTermuxArchConfigs.sh` to resolve 404 and checksum issues.  The following user configurable variables are available in this file:   
# CMIRROR="http://mirror.archlinuxarm.org/"
CMIRROR="http://os.archlinuxarm.org/"
# dm=aria2c	# Works wants improvement 
# dm=axel tba	# Not fully implemented
# dm=lftp 	# Works wants improvement 
# dm=curl	# Works 
# dm=wget	# Works 
# DMVERBOSE="-v" # Uncomment for verbose download manager output with curl and wget;  for verbose output throughout runtime, change this setting setting in `setupTermuxArch.sh` also.  
KOE=1

_AARCH64_() {
	file=ArchLinuxARM-aarch64-latest.tar.gz
	CMIRROR=os.archlinuxarm.org
	path=/os/
	_MAKESYSTEM_ 
}

_ARMV5L_() {
	file=ArchLinuxARM-armv5-latest.tar.gz
	CMIRROR=os.archlinuxarm.org
	path=/os/
	_MAKESYSTEM_ 
}

armv7lAndroid () {
	file=ArchLinuxARM-armv7-latest.tar.gz 
	CMIRROR=os.archlinuxarm.org
	path=/os/
	_MAKESYSTEM_ 
}

armv7lChrome() {
	file=ArchLinuxARM-armv7-chromebook-latest.tar.gz
	CMIRROR=os.archlinuxarm.org
	path=/os/
	_MAKESYSTEM_ 
}

# Information at https://www.archlinux.org/news/phasing-out-i686-support/ and https://archlinux32.org/ regarding why i686 is currently frozen at release 2017.03.01-i686.  $file is read from md5sums.txt

_I686_() { 
	CMIRROR=archive.archlinux.org
	path=/iso/2017.03.01/
	_MAKESYSTEM_ 
}

_X86_64_() { # $file is read from md5sums.txt
	CMIRROR=CMIRROR.rackspace.com
	path=/archlinux/iso/latest/
	_MAKESYSTEM_ 
}

## To regenerate the start script use \`setupTermuxArch.sh re[fresh]\`.  An example is included for convenience.  Usage: PROOTSTMNT+=\"-b host_path:guest_path \" The space before the last double quote is necessary.  Appending to the PRoot statement can be accomplished on the fly by creating a *.prs file in /var/binds.  The format is straightforward, `PROOTSTMNT+="option command "`.  The space is required before the last double quote.  `info proot` and `man proot` have more information about what can be configured in a proot init statement.  `setupTermuxArch.sh manual refresh` will refresh the installation globally.  If more suitable configurations are found, share them at https://github.com/sdrausty/TermuxArch/issues to improve TermuxArch.  

_PR00TSTRING_() { 
PROOTSTMNT="exec proot "
if [[ -z "${KID:-}" ]] ; then
	PROOTSTMNT+=""
elif [[ "$KID" ]] ; then
 	PROOTSTMNT+="--kernel-release=4.14.15 "
fi
if [[ "$KOE" ]] ; then
	PROOTSTMNT+="--kill-on-exit "
fi
PROOTSTMNT+="--link2symlink -0 -r $INSTALLDIR "
if [[ -f /proc/stat ]] ; then
	if [[ ! "$(head /proc/stat)" ]] ; then
		PROOTSTMNT+="-b $INSTALLDIR/var/binds/fbindprocstat:/proc/stat " 
	fi
else
	PROOTSTMNT+="-b $INSTALLDIR/var/binds/fbindprocstat:/proc/stat " 
fi
if [[ -n "$(ls -A "$INSTALLDIR"/var/binds/*.prs)" ]] ; then
    for PRSFILES in "$INSTALLDIR"/var/binds/*.prs ; do
      . "$PRSFILES"
    done
fi
PROOTSTMNT+="-b \"\$ANDROID_DATA\" -b /dev/ -b \"\$EXTERNAL_STORAGE\" -b \"\$HOME\" -b /proc/ -b /storage/ -b /sys/ -w \"\$PWD\" /usr/bin/env -i HOME=/root TERM=$TERM "
}
_PR00TSTRING_

## EOF
