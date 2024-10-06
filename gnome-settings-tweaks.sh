#!/bin/env bash

# Add GNOME extensions
curl -L --output /tmp/user-theme.zip \
https://extensions.gnome.org/extension-data/user-themegnome-shell-extensions.gcampax.github.com.v58.shell-extension.zip
curl -L --output /tmp/custom_hot_corners_extended.zip \
https://github.com/G-dH/custom-hot-corners-extended/releases/latest/download/custom-hot-corners-extended@G-dH.github.com.zip
curl -L --output /tmp/dash_to_dock.zip \
https://github.com/micheleg/dash-to-dock/releases/download/extensions.gnome.org-v96/dash-to-dock@micxgx.gmail.com.zip
curl -L --output /tmp/bingwallpaper.zip \
https://extensions.gnome.org/extension-data/BingWallpaperineffable-gmail.com.v50.shell-extension.zip

# Install it from tmp
for ext in user-theme.zip custom_hot_corners_extended.zip dash_to_dock.zip bingwallpaper.zip; do
	gnome-extensions install -f /tmp/$ext
done

#Add GNOME keyboard shortcuts and User Theme Legacy
cat gnome-settings-dconf.dump | dconf load /

