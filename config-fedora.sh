#!/bin/bash

add_rpm_fusion_repos(){
	sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
}

download_latest_vscode(){
	curl -L 'https://code.visualstudio.com/sha/download?build=stable&os=linux-rpm-x64' -o /tmp/vscode-x86_64.rpm 
}

get_required_packages(){
	cat <<-EOF
	bat
	btop
	colordiff
	dconf-editor
	exa
	feh
	fontawesome-fonts
	fzf
	git
	gnome-shell-extension-pop-shell
	gnome-tweaks
	htop
	lshw
	kodi
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
	sssd-tools
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
	zsh
	EOF
}

missing_pkgs(){
	for pkg in $(get_required_packages); do
		sudo rpm -q $pkg &>/dev/null || return 1
	done
	return 0
}

[ -d $HOME/bin ] && export PATH=$HOME/bin:$PATH

# Add RPM fusion repos
add_rpm_fusion_repos
download_latest_vscode

# Check if all required packages are installed and 
# launch installation if any of them is missing.
#
if ! missing_pkgs; then
	get_required_packages | xargs sudo yum install -y
fi

# Install remote vscode
sudo yum install -y /tmp/vscode-x86_64.rpm

# Enable CODECS
sudo dnf swap -y 'ffmpeg-free' 'ffmpeg' --allowerasing # Switch to full FFMPEG.
sudo dnf group install -y Multimedia
sudo dnf update -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin # Installs gstreamer components. Required if you use Gnome Videos and other dependent applications.

# Enable AMD codecs
if `lshw -short -c processor 2>&1 | grep -q "Radeon.*Graphics"`; then
	sudo dnf swap -y mesa-va-drivers mesa-va-drivers-freeworld
    sudo dnf swap -y mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
fi

# Enable Oh my ZSH!
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Change my shell
if ! `sudo chmod -s $(which zsh) $USER`; then
	sudo sss_override user-add $USER -s $(which zsh)
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
	org.remmina.Remmina
	
cd stow
stow -vvv --adopt -t ~/ bash gnome-settings htop kitty tmux vim zsh
cd -

bash gnome-settings-tweaks.sh

