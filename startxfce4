#!/bin/bash

[ -z "${XDG_CONFIG_HOME}" ] && {
  export XDG_CONFIG_HOME="${HOME}/.config"
}

[ ! -f "${HOME}/.tiger-firstrun" ] && {
  killall xfconfd
  mkdir -p "${XDG_CONFIG_HOME}"
  
  yes | /usr/bin/cp -rf "/usr/share/tiger-shell/configs"/* "${XDG_CONFIG_HOME}"
  
  touch "${HOME}/.tiger-firstrun"
}

exec startxfce4.orig
