#!/bin/bash

[ ! "${EUID}" = "0" ] && {
  echo "Execute esse script como root:"
  echo
  echo "  sudo ${0}"
  echo
  exit 1
}

HERE="$(dirname "$(readlink -f "${0}")")"

working_dir=$(mktemp -d)

mkdir -p "${working_dir}/usr/bin"
mkdir -p "${working_dir}/usr/share/tiger-shell/scripts/"
# mkdir -p "${working_dir}/usr/share/xsessions"
mkdir -p "${working_dir}/usr/share/applications"
mkdir -p "${working_dir}/DEBIAN/"

mkdir -p "${working_dir}/usr/share/tiger/xfce-config/applications/"
cp "zzTigerShell-reset.desktop" "${working_dir}/usr/share/tiger/xfce-config/applications/zzTigerShell-reset.desktop"

(
 echo "Package: tiger-shell"
 echo "Priority: required"
 echo "Version: $(date +%y.%m.%d%H%M%S)"
 echo "Architecture: amd64"
 echo "Maintainer: Natanael Barbosa Santos"
 echo "Depends: "
 echo "Description: $(cat ${HERE}/README.md  | sed -n '1p')"
 echo
) > "${working_dir}/DEBIAN/control"

cp -rf "configs"   "${working_dir}/usr/share/tiger-shell/"
cp -rf "scripts"/* "${working_dir}/usr/share/tiger-shell/scripts/"
cp "tiger-shell.sh" "${working_dir}/usr/bin"
cp "Tiger-Shell-reset.sh" "${working_dir}/usr/bin"

chmod +x "${working_dir}/usr/bin/Tiger-Shell-reset.sh"

# cp tiger-session.desktop  "${working_dir}/usr/share/xsessions"

echo "Downloading Whisker Menu scripts..."

wget -qO whisker_scripts.zip "https://github.com/Tiger-OperatingSystem/whisker-scripts/archive/refs/heads/main.zip"
unzip whisker_scripts.zip

mv "whisker-scripts-main/src"/* "${working_dir}/usr/share/tiger-shell/scripts/"

echo "Compiling YML to Whisker Menu Actions..."

count=$(ls whisker-scripts-main/actions/ | wc -l)

(
  echo
  echo "search-actions=${count}"
  echo

  for i in $(seq 1 ${count}); do
    file_name="whisker-scripts-main/actions/"$(ls whisker-scripts-main/actions/ | sed -n "${i}p")
  
    name=$(grep "^name: " "${file_name}" | cut -c 7-)
    pattern=$(grep "^pattern: " "${file_name}"  | cut -c 10-)
    url=$(grep "^url: " "${file_name}"  | cut -c 6-)
    type=$(grep "^type: " "${file_name}" | cut -c 7-)
    
    [ "${type}" = "website" ] && {
      url="exo-open --launch WebBrowser ${url}"
    }
    
    echo "[action$((${i}-1))]"
    echo "name=${name}"
    echo "pattern=${pattern}"
    echo "command=${url}"
    echo "regex=false"
    echo
  done
) | tee -a "${working_dir}/usr/share/tiger-shell/configs/xfce4/panel/whiskermenu-1.rc"

rm -rfv ${whisker-scripts-main}

echo "Making executables..."

chmod -R a+x "${working_dir}/usr/bin/"
chmod -R a+x "${working_dir}/usr/share/tiger-shell/scripts/"

echo "Building deb file..."

dpkg -b ${working_dir}
rm -rfv ${working_dir}

mv "${working_dir}.deb" "${HERE}/tiger-shell.deb"

chmod 777 "${HERE}/tiger-shell.deb"
chmod -x  "${HERE}/tiger-shell.deb"
