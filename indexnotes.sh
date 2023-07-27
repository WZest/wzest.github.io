#!/bin/bash

NbrFile=$(ls -rt ~/wz-notes/docs | cat -n |tail -1 | cut -f1 )
FileA=$(find ~/wz-notes/docs -type f -printf '%T@ %p\n'| sort -n | tail -1 | cut -b 46-68)
FileName="$HOME/wz-notes/docs/$FileA"
fileIndex="$HOME/wz-notes/docs/index.md"
foo=$(echo "$FileName" | sed -r "s/.+\/(.+)\..+/\1/")
bol=$(grep -A 1 "ID" "$FileName"|grep -o "^\# __.*"|grep -oP "(?<=# __).*(?=__)")
bal=$(echo "[$bol]($foo)  ")
echo "<!--- ID: [$bol]($FileA) --->" >> $FileName
echo "$NbrFile-$bal  " >> $fileIndex

mkdocsyml="$HOME/wz-notes/mkdocs.yml"
notes="Notes:"
nav_notes="    - $bol: '$FileA'"
export nav_notes

if [ "$1" == "-n"  ]; then
  perl -pi -e '$_ .= qq($ENV{nav_notes}\n) if /Notes:/' $mkdocsyml
fi 

if [ "$1" == "-i"  ]; then
  perl -pi -e '$_ .= qq($ENV{nav_notes}\n) if /Idea:/' $mkdocsyml
fi 

wfilename="$HOME/wz-notes/docs/week-$(date  +%U%m%Y).md"

