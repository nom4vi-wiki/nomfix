#!/bin/bash

set -e

cd magisk-module

font_dir_="system/fonts"
font_name_="NomNaTong-Regular.ttf"
font_path_="${font_dir_}/${font_name_}"
font_ver_="5.15"
font_url_="https://github.com/nomfoundation/font/releases/download/v${font_ver_}/${font_name_}"
etc_dir_="system/etc"
module_ver_="3"
out_name_="nomfix_v${module_ver_}.zip"

set -x

if [ ! -e "$font_path_" ]
then
  mkdir -p "$font_dir_"
  wget "$font_url_" -O "$font_path_" || { rm -f "$font_path_"; exit 1; }
fi

mkdir -p "$etc_dir_"
zip -9 ../"$out_name_" -r .
