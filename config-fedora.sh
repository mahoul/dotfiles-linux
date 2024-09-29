#!/bin/bash

get_required_packages(){
	cat <<-EOF
	bat
	btop
	colordiff
	dconf-editor
	exa
	feh
	fontawesome-fonts
	git
	gnome-shell-extension-pop-shell
	gnome-tweaks
	htop
	kitty
	kitty-doc
	jetbrains-mono-fonts
	krb5-workstation
	mc
	mozilla-fira-sans-fonts
	net-tools
	nmap
	nss-tools
	powerline
	powerline-fonts
	virt-viewer
	stow
	tmux
	tmux-powerline
	vim
	vim-airline
	vim-powerline
	virt-viewer
	xdotool
	xprop
	xrandr
	EOF
}

missing_pkgs(){
	for pkg in $(get_required_packages); do
		sudo rpm -q $pkg &>/dev/null || return 1
	done
	return 0
}

[ -d $HOME/bin ] && export PATH=$HOME/bin:$PATH

# Check if all required packages are installed and 
# launch installation if any of them is missing.
#
if ! missing_pkgs; then
	get_required_packages | xargs sudo yum install -y
fi

# Enable flatpaks and install them
#
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y \
	com.brave.Browser \
	com.hamrick.VueScan \
	io.github.mimbrero.WhatsAppDesktop \
	org.telegram.desktop \
	com.spotify.Client \
	org.remmina.Remmina \
	org.flameshot.Flameshot \
	com.visualstudio.code \
	
cd stow
stow -vvv --adopt -t ~/ bash gnome-settings htop kitty tmux
cd -

bash gnome-settings-tweaks.sh

