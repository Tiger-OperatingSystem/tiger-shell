#!/bin/bash

# Calendário do Tiger OS, ele substitui o calendário padrão do XFCE através do monitor generico


[ "${1}" = "--display-dialog" ] && {
  choose_date=$(yad --calendar --mouse --undecorated --close-on-unfocus --skip-taskbar --width=480 --heigth=380 --borders=32 --button="Abrir no Google Agenda":0 --date-format='%Y/%m/%d')

  [ "${?}" = "0" ] && {
    exo-open --launch WebBrowser "https://calendar.google.com/calendar/u/0/r/day/${choose_date}"
    exit ${?}
  }
  exit 0
}

SELF=$(readlink -f "${0}")

# O generic-monitor do XFCE da LTS 20.04 do Ubuntu não centraliza automaticamente o texto
# isso foi corrigido no 22.04 mas ainda não foi lançado
time=$(date '+   %H:%M%n %d/%m/%Y ')
# time=$(date '+%H:%M%n %d/%m/%Y ')

tooltip=$(date '+Hoje é %d de %B de %Y')

echo "<txt>${time}</txt><txtclick>${SELF} --display-dialog</txtclick><tool>${tooltip}</tool>"
