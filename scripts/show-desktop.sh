#!/bin/sh
xprop -root  _NET_SHOWING_DESKTOP|egrep '= 1' && {
  wmctrl -k off ;
} || {
  wmctrl -k on ;
}
