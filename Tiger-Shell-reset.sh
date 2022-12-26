#!/bin/bash

yad --borders=32 --width=640 --button="Não, cancele":1 --button="Sim, resete a interface":0 --title="Resetar o Tiger Shell" --center \
    --text="<big><b>Como deseja resetar o Tiger Shell?</b></big>\nNote que essa ação <b>NÃO</b> pode ser desfeita, seus arquivos não serão afetados\n"  && { 
        tiger-shell.sh --refresh;
}