#!/bin/bash

#########################################################################################

function help() {
cat <<\EOF
###############################################################
#                                                             #
#  Tiger Shell v1.0 - O script de inicialização do Tiger OS   #
#                                                             #
###############################################################

  O que é?
 -------------

 Esse script permite inicializar o XFCE usando um conjunto
 de configurações específico como layouts de paineis

  Como usar?
 ------------

 Usualmente esse script é chamado automaticamente no login
 porém após o login ele pode ser usado para recarregar as
 configurações:

   * --config-dir=

     Define o local de onde o script vai copiar os arquivos
     de  configurações

   * --refresh

     Recarrega os paineis e sai sem carregar o XFCE 4

  Créditos
 ------------

 Atualmente desenvolvido e mantido por sudo-give-me-coffee
 Natanael Barbosa Santos

  Bugs
 ------------

 Caso experimente algum bug ou falha por favor reporte em
 https://github.com/Tiger-OperatingSystem/tiger-shell


EOF
exit
}

#########################################################################################

SKIP_XFCE=0

for arg in ${@}; do
  [ "${arg}" = "-h" ]        && help
  [ "${arg}" = "--help" ]    && help

  [ "${arg}" = "--refresh" ] && {
    SKIP_XFCE=1
    [ -f "${HOME}/.tiger-firstrun" ] && rm "${HOME}/.tiger-firstrun"
    shift
  }

  echo "${arg}" | grep -q ^"--config-dir=" && {
    TIGER_OS_CONFIG_DIR=$(echo "${arg}" | cut -c 14-)
    shift
  }

done

#########################################################################################

[ "${TIGER_OS_CONFIG_DIR}" = "" ] && {
  TIGER_OS_CONFIG_DIR="/usr/share/tiger-shell/configs"
} || {
  rm "${HOME}/.tiger-firstrun"
}

#########################################################################################

[ -z "${XDG_CONFIG_HOME}" ] && {
  export XDG_CONFIG_HOME="${HOME}/.config"
}

#########################################################################################

[ ! -f "${HOME}/.tiger-firstrun" ] && {
  killall xfconfd
  mkdir -p "${XDG_CONFIG_HOME}"

  yes | /usr/bin/cp --no-preserve=ownership,timestamps -rf "${TIGER_OS_CONFIG_DIR}"/* "${XDG_CONFIG_HOME}"

  touch "${HOME}/.tiger-firstrun"
}

#########################################################################################

[ "${SKIP_XFCE}" = "1" ] && {
  exec xfce4-panel --restart
} || {
  /usr/lib/x86_64-linux-gnu/polkit-mate/polkit-mate-authentication-agent-1 &  
  (
     mkdir -p "$(xdg-user-dir DESKTOP)/"
     cd  "$(xdg-user-dir DESKTOP)/";
     df | grep -w / | grep -q '/cow' && {
       cp /usr/share/applications/os-install.desktop os-install.desktop
       chmod +x os-install.desktop;
       gio set -t string os-install.desktop metadata::xfce-exe-checksum "$(sha256sum os-install.desktop | awk '{print $1}')";
     }
  )
  exec startxfce4.orig ${@}
}
