#!/bin/sh

# DOWNLOAD THE ARCHIVE
wget https://github.com/ivan-hc/junest/releases/download/continuous/junest-x86_64.tar.gz

# SET APPDIR AS A TEMPORARY $HOME DIRECTORY, THIS WILL DO ALL WORK INTO THE APPDIR
HOME="$(dirname "$(readlink -f $0)")" 

# DOWNLOAD AND INSTALL JUNEST (DON'T TOUCH THIS)
git clone https://github.com/fsquillace/junest.git ~/.local/share/junest
./.local/share/junest/bin/junest setup -i junest-x86_64.tar.gz

# INSTALL YAY
./.local/share/junest/bin/junest -- sudo pacman --noconfirm -Rcns yay
./.local/share/junest/bin/junest -- sudo pacman --noconfirm -S --needed git base-devel
./.local/share/junest/bin/junest -- git clone https://aur.archlinux.org/yay.git
./.local/share/junest/bin/junest -- cd yay
./.local/share/junest/bin/junest -- makepkg -si

# BYPASS SIGNATURE CHECK LEVEL
#sed -i 's/#SigLevel/SigLevel/g' ./.junest/etc/pacman.conf
#sed -i 's/Required DatabaseOptional/Never/g' ./.junest/etc/pacman.conf

# UPDATE ARCH LINUX IN JUNEST
./.local/share/junest/bin/junest -- sudo pacman --noconfirm -Rcns base-devel
./.local/share/junest/bin/junest -- sudo pacman -Syy
./.local/share/junest/bin/junest -- sudo pacman --noconfirm -Syu
echo yes | ./.local/share/junest/bin/junest -- sudo pacman -Scc

echo 'SUCCESS!\n'
