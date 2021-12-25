#!/bin/bash

[ "${1}" = "--display-dialog" ] && {
  choose_date=$(yad --calendar --mouse --undecorated --close-on-unfocus --skip-taskbar --width=480 --heigth=380 --borders=32 --button="Abrir no Google Agenda":0 --date-format='%Y/%m/%d')

  [ "${?}" = "0" ] && {
    exo-open --launch WebBrowser "https://calendar.google.com/calendar/u/0/r/day/${choose_date}"
    exit ${?}
  }
  exit 0
}

SELF=$(readlink -f "${0}")


time=$(date '+%H:%M%n %d/%m/%Y ')

tooltip=$(date '+Hoje é %d de %B de %Y')

echo "<txt>${time}</txt><txtclick>${SELF} --display-dialog</txtclick><tool>${tooltip}</tool>"
