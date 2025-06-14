# https://topjohnwu.github.io/Magisk/guides.html#shell-scripts-sh
MODDIR="${0%/*}"

# reg our new fonts at end
# XXX: ensure lang ID dont collide w/ anything else
sed_cmds_='\|<\/familyset>|i'
font_name_='NomNaTong-Regular\.ttf'
attrs_='weight="400" style="normal"'
inner_="<font ${attrs_}>${font_name_}<\\/font>"
font_def_="<family lang=\"und-Nomn\">\\n    ${inner_}\\n  <\\/family>"
head_='<\!-- nomfix begin -->'
tail_='<\!-- nomfix end -->'
sed_script_="${sed_cmds_} \\  ${head_}\\n  ${font_def_}\\n  ${tail_}"

etc_dir_=/system/etc
xml_names_="fonts.xml font_fallback.xml"

# display msg in manager
function set_status_txt ()
{
  sed -i -r "s/(description=)(.* \\| )?(.*)/\\1$1 | \\3/" \
    "$MODDIR"/module.prop
}

# in case we crash script later
# FIXME: hide status upon reboot
set_status_txt '👾 Unknown error'

err_=0

# always re-clone XML from system
# this'll let us survive ROM upds
for xml_name_ in $xml_names_
do
  font_xml_="$etc_dir_"/"$xml_name_"
  mod_font_xml_="${MODDIR}${font_xml_}"

  # in case it no longer exist
  rm -f "$mod_font_xml_"

  if ! cp -p "$font_xml_" "$mod_font_xml_"
  then
    set_status_txt "😿 Failed to copy ${xml_name_}"
    err_=1
    continue
  fi

  # modify local copy
  if ! sed -i "$sed_script_" "$mod_font_xml_"
  then
    set_status_txt "😿 Pattern failed for ${xml_name_}"
    err_=1
    # mbe harmless
  fi
done

if [ $err_ -eq 0 ]
then
  set_status_txt '👾 Everything is OK'
fi
