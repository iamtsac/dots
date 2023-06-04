#! /bin/bash

/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
setxkbmap -layout us,gr -option grp:win_space_toggle
nvidia-settings --load-config-only
sudo liquidctl --match kraken set fan speed  20 30  30 50  34 80  40 90  50 100
sudo liquidctl --match kraken set pump speed  70
xrdb -merge /home/tsac/.Xresources
emacs --daemon &
#picom --config  $HOME/.config/picom/picom.conf &

