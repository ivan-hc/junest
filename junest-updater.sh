#!/usr/bin/env bash

# DOWNLOAD THE ARCHIVE
wget $(curl -Ls https://api.github.com/repos/ivan-hc/junest/releases/latest | sed 's/[()",{} ]/\n/g' | grep -oi "https.*tar.gz$" | head -1)

# SET APPDIR AS A TEMPORARY $HOME DIRECTORY, THIS WILL DO ALL WORK INTO THE APPDIR
HOME="$(dirname "$(readlink -f $0)")"

# DOWNLOAD AND INSTALL JUNEST (DON'T TOUCH THIS)
git clone https://github.com/fsquillace/junest.git ~/.local/share/junest
./.local/share/junest/bin/junest setup -i junest-x86_64.tar.gz

# BYPASS SIGNATURE CHECK LEVEL
#sed -i 's/#SigLevel/SigLevel/g' ./.junest/etc/pacman.conf
#sed -i 's/Required DatabaseOptional/Never/g' ./.junest/etc/pacman.conf

# UPDATE ARCH LINUX IN JUNEST
./.local/share/junest/bin/junest -- sudo pacman -Syy
#./.local/share/junest/bin/junest -- sudo pacman --noconfirm -Syu

# INSTALL YAY
./.local/share/junest/bin/junest -- sudo pacman --noconfirm -Rcns yay
./.local/share/junest/bin/junest -- sudo pacman --noconfirm -S --needed git base-devel
./.local/share/junest/bin/junest -- git clone https://aur.archlinux.org/yay.git
cd yay
echo yes | $HOME/.local/share/junest/bin/junest -- makepkg -si
cd ..
yayver=$(cat ./yay/PKGBUILD | grep "pkgver=" | head -1 | cut -c 8-)
./.local/share/junest/bin/junest -- sudo pacman --noconfirm -U ./yay/yay-"$yayver"*.zst ./yay/yay-debug-"$yayver"*.zst

# DEBLOAT
./.local/share/junest/bin/junest -- sudo pacman --noconfirm -Rcns base-devel go
echo yes | ./.local/share/junest/bin/junest -- sudo pacman -Scc

echo -e 'SUCCESS!\n'
