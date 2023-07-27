#!/bin/bash

#NOTE: n'oublie pas le livere de memoire
#HACK: https://devhints.io/bash#conditionals  https://www.youtube.com/watch?v=X26V12CEplY
#PERF: avec versionage
#FIX: Handel if no argument passed
#TODO: Creat a Note 
#TODO: Creat a Week-Not
#TODO: Edit Note
#TODO: Implement the App for the terminal (FZF)
#TODO: Config file 
#DONE: 
#
set -o pipefail
set -e 
set -u
#-----Notes Paths-------#
file="$HOME/wz-notes/docs"
file_name=$(date +%d%m%Y-%H%M%S)
note_name="note-$file_name"
note_name_md="note-$file_name.md"
note_file_name="$file/$note_name_md"
note_name1=$(echo "$note_file_name" | sed -r "s/.+\/(.+)\..+/\1/")
note_title="${@:2}"
note_core="${@:3}"
#note_type="${1:-default}"
last_note=$(find ~/wz-notes/docs -type f -printf '%T@ %p\n'| sort -n | tail -1 | cut -b 46-68)
index_note=$(ls -rt ~/wz-notes/docs | cat -n |tail -1 | cut -f1 )
week_file_name="$HOME/wz-notes/docs/week-$(date +%U%m%Y).md"
mkdocsyml="$HOME/wz-notes/mkdocs.yml"
#file_name_witoutd_md_foo=$(echo "$FileName" | sed -r "s/.+\/(.+)\..+/\1/")
#titel_bol=$(grep -A 1 "ID" "$FileName"|grep -o "^\# __.*"|grep -oP "(?<=# __).*(?=__)")
#bal1=$(echo "[$title_bol]($file_name_witoutd_md_foo)  ")
bal=$(echo "[$note_title]($note_name_md)  ")
index_file="$HOME/wz-notes/docs/index.md"

#note_to_edit=$(grep -oP "(?<=ID: \[).*(?=\])" ~/wz-notes/docs/*.md | grep -oP "(?<=docs/).*"| fzf --height 40% --reverse )
#note_to_edit_dm=$(grep -oP "(?<=ID: \[).*(?=\])" ~/wz-notes/docs/*.md | dmenu -l 19 -sf "#689d6a" -nb "#282828" -nf "#fe8019" -sb "#3c3836" -fn "Ubuntu-14"  -p "Edit Note:"| grep -oP "(?=note).*(?=:)")


function args(){
  #if [ -z ${1:-default} ]
  if [ -z $@ ]
  then 
      echo "No 'Title' Intred Please Insert Title.--help for help."
      exit 1 
  fi
}

function create_note(){
  if [ ! -f "$note_file_name" ]; then
    touch "$note_file_name"
    wait
    echo "<!---ID: $note_name--->
# __"$note_title"__
----
"$note_core"

[:octicons-comment-discussion-16:&nbsp; Index][Index]{ .md-button }
[Index]: http://127.0.0.1:8000/
:octicons-clock-24:{ style="color:green" }  
$(date +%H:%M:%S)  " > "$note_file_name";
wait
echo "<!--- ID: [$note_title]($last_note) --->" >> $note_file_name
echo "<!--- IDW: ($week_file_name)($note_name.md) --->" >> $note_file_name
echo "$index_note-$bal  " >> $index_file
echo "$index_note-$bal  "
wait
nvim -c "norm ggjA" "$note_file_name"
wait
cat "$note_file_name" >> "$week_file_name" 
  fi
}

function creat_week_note(){
  if [ ! -f $week_file_name ]
  then
    touch "$week_file_name"
    wait
    #perl -pi -e '$_ .= qq($ENV{date_nav}\n) if /Week:/' $mkdocsyml
    #echo "<!--- ID: [$title_bol]($FileA) --->" >> $FileName
    #echo "$NbrFile-$bal  " >> $fileIndex
    fi
}


function edit_note(){
#  while [ -z $1 ]; do
#    case $1 in
#      "Edit" ) $note_to_edit  break : ;;
#      #"Editdm" ) $note_to_edit_dm ;;
#    esac
#  done
#
if [ -z $1 ] 
then
  note_to_edit=$(grep -oP "(?<=ID: \[).*(?=\])" ~/wz-notes/docs/*.md | grep -oP "(?<=docs/).*"| fzf --height 40% --reverse +s) 
  
  wait
  bolbol=$note_to_edit | grep -oP "(?<=docs/).*(?=\:)"
  echo $bolbol
  #nvim $($note_to_edit | grep -oP "(?<=docs/).*(?=\:)")
#  if [ -f $note_to_edit ]
#  then
#    echo $note_to_edit
#    nvim $note_to_edit
#  fi
fi
}

#-------Program Begin------------#
if [ -z $@ ]
#-----Check for arguments--------#
  then 
      echo "No 'Title' Intred Please Insert Title.--help for help."
      exit 1 
  else
#------excute auther func ------#
    create_note
    creat_week_note
fi


