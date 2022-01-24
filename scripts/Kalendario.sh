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

current_version=$(xfce4-panel --version | grep -m1 '^xfce4-panel' | cut -d' ' -f2)

problematic_version="4.14.3"

hightest_version=$(echo -e "${current_version}\n${problematic_version}" | sort -V | tail -n1)

[ "${problematic_version}" = "${hightest_version}" ] && {
  time=$(date '+   %H:%M%n %d/%m/%Y ')
} || {
  time=$(date '+%H:%M%n %d/%m/%Y ')
}

tooltip=$(date '+Hoje é %d de %B de %Y')

echo "<txt>${time}</txt><txtclick>${SELF} --display-dialog</txtclick><tool>${tooltip}</tool>"
