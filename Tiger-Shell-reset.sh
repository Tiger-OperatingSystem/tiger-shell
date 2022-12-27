#!/bin/bash

yad --borders=32 --width=640 --button="Não, cancele":1 --button="Sim, resete a interface":0 --title="Resetar o Tiger Shell" --center \
    --text="<big><b>Deseja resetar a interface do TigerOS?</b></big>\nNote que essa ação <b>NÃO</b> pode ser desfeita, mas seus arquivos não serão afetados\n"  && { 
        tiger-shell.sh --refresh;
}

xfce4-settings-manager
