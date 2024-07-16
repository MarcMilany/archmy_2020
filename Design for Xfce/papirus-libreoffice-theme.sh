#!/bin/sh
# papirus-libreoffice-theme

set -e

gh_repo="papirus-libreoffice-theme"
gh_desc="Papirus LibreOffice themes"

cat <<- EOF



      ppppp                         ii
      pp   pp     aaaaa   ppppp          rr  rrr   uu   uu     sssss
      ppppp     aa   aa   pp   pp   ii   rrrr      uu   uu   ssss
      pp        aa   aa   pp   pp   ii   rr        uu   uu      ssss
      pp          aaaaa   ppppp     ii   rr          uuuuu   sssss
                          pp
                          pp


  $gh_desc
  https://github.com/PapirusDevelopmentTeam/$gh_repo


EOF

temp_dir="$(mktemp -d)"

echo "=> Getting the latest version from GitHub ..."
wget -O "/tmp/$gh_repo.tar.gz" \
  https://github.com/PapirusDevelopmentTeam/$gh_repo/archive/master.tar.gz
echo "=> Unpacking archive ..."
tar -xzf "/tmp/$gh_repo.tar.gz" -C "$temp_dir"
echo "=> Deleting old $gh_desc ..."
sudo rm -f "/usr/share/libreoffice/share/config/images_epapirus.zip"
sudo rm -f "/usr/share/libreoffice/share/config/images_papirus.zip"
sudo rm -f "/usr/share/libreoffice/share/config/images_papirus_dark.zip"
echo "=> Installing ..."
sudo mkdir -p "/usr/share/libreoffice/share/config"
sudo cp -R \
  "$temp_dir/$gh_repo-master/images_epapirus.zip" \
  "$temp_dir/$gh_repo-master/images_papirus.zip" \
  "$temp_dir/$gh_repo-master/images_papirus_dark.zip" \
  "/usr/share/libreoffice/share/config"
for dir in \
  /usr/lib64/libreoffice/share/config \
  /usr/lib/libreoffice/share/config \
  /usr/local/lib/libreoffice/share/config \
  /opt/libreoffice*/share/config; do
  [ -d "$dir" ] || continue
  sudo ln -sf "/usr/share/libreoffice/share/config/images_epapirus.zip" "$dir"
  sudo ln -sf "/usr/share/libreoffice/share/config/images_papirus.zip" "$dir"
  sudo ln -sf "/usr/share/libreoffice/share/config/images_papirus_dark.zip" "$dir"
done
echo "=> Clearing cache ..."
rm -rf "/tmp/$gh_repo.tar.gz" "$temp_dir"
echo "=> Done!"