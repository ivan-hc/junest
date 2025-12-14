#!/usr/bin/env bash

# DOWNLOAD THE ARCHIVE
if ! test -f ./junest-x86_64.tar.gz; then
	wget https://github.com/ivan-hc/junest/releases/download/continuous-stock/junest-x86_64.tar.gz || exit 1
 	#wget $(curl -Ls https://api.github.com/repos/ivan-hc/junest/releases/latest | sed 's/[()",{} ]/\n/g' | grep -oi "https.*tar.gz$" | head -1) || exit 1
fi

# SET APPDIR AS A TEMPORARY $HOME DIRECTORY, THIS WILL DO ALL WORK INTO THE APPDIR
HOME="$(dirname "$(readlink -f $0)")"

# DOWNLOAD AND INSTALL JUNEST (DON'T TOUCH THIS)
if ! test -d ./.local/share/junest; then
	git clone https://github.com/fsquillace/junest.git ~/.local/share/junest
	./.local/share/junest/bin/junest setup -i junest-x86_64.tar.gz
fi

# UPDATE ARCH LINUX IN JUNEST
./.local/share/junest/bin/junest -- sudo pacman -Syy
./.local/share/junest/bin/junest -- sudo pacman --noconfirm -Syu

# INSTALL YAY
./.local/share/junest/bin/junest -- sudo pacman --noconfirm -Rcns yay
./.local/share/junest/bin/junest -- sudo pacman --noconfirm -S --needed git base-devel
./.local/share/junest/bin/junest -- git clone https://aur.archlinux.org/yay.git
cd yay || exit 1
echo yes | $HOME/.local/share/junest/bin/junest -- makepkg -si
cd .. || exit 1
yayver=$(cat ./yay/PKGBUILD | grep "pkgver=" | head -1 | cut -c 8-)
./.local/share/junest/bin/junest -- sudo pacman --noconfirm -U ./yay/yay-"$yayver"*.zst ./yay/yay-debug-"$yayver"*.zst

# DEBLOAT
./.local/share/junest/bin/junest -- sudo pacman --noconfirm -Rcns base-devel go
echo yes | ./.local/share/junest/bin/junest -- sudo pacman -Scc

echo -e 'SUCCESS!\n'
