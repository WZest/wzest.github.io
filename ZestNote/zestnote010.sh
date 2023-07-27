#!/bin/bash

#------------TODO Liste---------#
#NOTE: n'oublie pas le livere de memoire
#HACK: https://devhints.io/bash#conditionals  https://www.youtube.com/watch?v=X26V12CEplY
#HACK: if [[ "${1}" == "word"]] || return 1 best parctice
#PERF: avec versionage
#DONE::  Handel if no argument passed
#DONE: Creat a Note 
#DONE: Creat a Week-Not
#DONE: Edit Note
#DONE: Implement the App for the terminal (FZF)
#TODO: Link note
#TODO: Config file 
#TODO: Run the server 

set -o pipefail
#set -ex 
set -u

SOURCE="$PWD"
SETTINGS_FILE="$SOURCE/settings.json"
SETTINGS_JSON=`cat "$SETTINGS_FILE"`

declare -A SETTINGS

get_settings() {
  local PARAMS="$#"
  local JSON=`jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]" <<< "$1"`
  local KEYS=''

  if [ $# -gt 1 ]; then
    KEYS="$2"
  fi

  while read -r PAIR; do
    local KEY=''
    if [ -z "$PAIR" ]; then
      break
    fi
    IFS== read PAIR_KEY PAIR_VALUE <<< "$PAIR"
    if [ -z "$KEYS" ]; then
      KEY="$PAIR_KEY"
    else
      KEY="$KEYS:$PAIR_KEY"
    fi
    res=$(jq -e . 2>/dev/null <<< "$PAIR_VALUE")
    exitCode=$?
#    echo "$PAIR_VALUE" | grep -E ^\-?[0-9]*\.?[0-9]+$
    check=`echo "$PAIR_VALUE" | grep -E ^\-?[0-9]*\.?[0-9]+$`
    # if [ "${res}" ] && [ $exitCode -eq "0" ] && [[ ! "${PAIR_VALUE}" == ?(-)+([0-9]) ]]  ALTERNATIVE, works only for integer (not floating point)
    if [ "${res}" ] && [ "$exitCode" -eq "0" ] && [[ "$check" == '' ]];
    then
      get_settings "$PAIR_VALUE" "$KEY"
    else
      SETTINGS["$KEY"]="$PAIR_VALUE"
    fi
  done <<< "$JSON"
} 

get_settings "$SETTINGS_JSON"

#-----Notes Paths-------#
file_extension="${SETTINGS[0:file_setting:file_extension]}"
file="$HOME/wz-notes/docs"
file_name=$(date +%d%m%Y-%H%M%S)
note_name="note-$file_name"
note_name_md="note-$file_name$file_extension"
note_file_name="$file/$note_name_md"
note_name1=$(echo "$note_file_name" | sed -r "s/.+\/(.+)\..+/\1/")
#note_title="${2:-Default}"
note_title="${2:-Default}"
note_core="${3:-Default}"
#note_type="${1:-default}"
last_note=$(find ~/wz-notes/docs -type f -printf '%T@ %p\n'| sort -n | tail -1 | cut -b 46-68)
index_note=$(ls -rt ~/wz-notes/docs | cat -n |tail -1 | cut -f1 )
week_file_name="$HOME/wz-notes/docs/week-$(date +%U%m%Y).md"
mkdocsyml="$HOME/wz-notes/mkdocs.yml"
bal=$(echo "[$note_title]($note_name_md)  ")
index_file="$HOME/wz-notes/docs/index.md"

PROG="${0##/}" # Scriptname
MKDOCS="$HOME/.local/bin/mkdocs"
MDBOOK="$HOME/.cargo/bin/mdbook"
NVIM="/usr/bin/nvim"

#-----------Create Note------------#
function create_note(){
  if [[ ! -f "${note_file_name:?file not found}" ]] || return 1 ; then
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
  fi
}

#----------------Edit Note---------#
function edit_note(){
  tempfile=$(mktemp)
  #note_to_edit=$(grep -oP "(?<=ID: \[).*(?=\])" ~/wz-notes/docs/*.md | grep -oP "(?<=docs/).*"| fzf --height 40% --reverse +s > $tempfile )
  note_to_edit=$(grep -oP "(?<=ID: \[).*(?=\])" ~/wz-notes/docs/*.md | grep -oP "(?<=docs/).*"| dmenu -l 19 -sf "#689d6a" -nb "#282828" -nf "#fe8019" -sb "#3c3836" -fn "Ubuntu-14"  -p "Edit Note:"> $tempfile )
  bolbol=$(grep -oP ".*.md" $tempfile)
  nvim "$file/$bolbol"
  wait
  rm "$tempfile"
}

#------------JSON File setting---------#
function settings() {
  if [ ! -f "$SETTINGS_FILE" ];
  then
    touch "$SETTINGS_FILE"
    wait
    echo "[
    {
      "file_setting":{
      "dir_name": \"\",
      "file_name": \"\",
      "file_extension": \"\"
    }

  },

  {
    "serve_setting": {
    "file_naming": {
    "dir_name": \"\",
    "file_name_date": \"\"
  }
}
}
]" > "$SETTINGS_FILE";
  fi
} 

#------------JSON Update ------------#
function update_json(){
        get_settings "$SETTINGS_JSON";
        original=${SETTINGS["${1:-}:${2:-}:${3:-file1}"]};
        tmpfile=$(mktemp);
        cp $SETTINGS_FILE "$tmpfile" ;
        sed -i "s/\"${3:-file}\"\: \"$original\"/\"${3:-file}\"\: \"${4:-new}\"/" $tmpfile;
        tmpfilecat=`cat $tmpfile`;
        get_settings "$tmpfilecat";
        cp "$tmpfile" "$SETTINGS_FILE" ;
        wait;
        rm "$tmpfile";
      }

#------------App Usage-------------#
usage() {
  printf '\e]8;;127.0.0.1:8000\e\\sersver runing at 127.0.0.1:8000\e]8;;\e\\\n'
  echo -e "\e[30;43m ZestNote ${RST} note-taking software application that operates on Markdown files."
  echo "Usage: ${0} [options] [TITLE] [NOTE-CORE] [file ...] " 
  echo "  -h    --help                       Display help"
  echo -e "${GRN}  -n    --note [title] [note-core]   Create the Note"
  echo -e "${RED_B}  -e    --edit [file]                Edit the Note"
  echo "  -s    --settings                   Edit Settings"
  echo "  -m    --Server                     Run Server"
  echo "  -q    --exit                       Exit ZestNote"

  exit 1
}

GRN='\e[32;1m'
RST='\e[0m'

RED_B='\e[31;1m'
GRN_B='\e[32;1m'
YLW='\e[33;1m'

#-------Update Settings------------#
settings_json() {

  while true; do
    echo -e "${GRN_B}Settings:${RST}\n" 
    echo -e "${GRN_B}Notes Settings:${RST}" 
    echo -e "${YLW}a${RST} - New Directory Name:          [ ${GRN_B}${SETTINGS[0:file_setting:dir_name]}${RST} ]"
    echo -e "${YLW}b${RST} - New File Name:               [ ${GRN_B}${SETTINGS[0:file_setting:file_name]}${RST} ]"
    echo -e "${YLW}c${RST} - Extension Name:              [ ${GRN_B}${SETTINGS[0:file_setting:file_extension]}${RST} ]\n"

    echo -e "${GRN_B}Server Settings:${RST}" 
    echo -e "${YLW}e${RST} - Server Name:                 [ ${GRN_B}${SETTINGS[1:server_setting:server_name]}${RST} ]"
    echo -e "${YLW}f${RST} - Server Link:                 [ ${GRN_B}${SETTINGS[1:server_setting:server_link]}${RST} ]"
    echo -e "${YLW}g${RST} - Server Port:                 [ ${GRN_B}${SETTINGS[1:server_setting:server_port]}${RST} ]\n"


    echo -e "${YLW}q${RST} - Exit \n" 

    read -n1 -p $"Please Entre Your Choice [a/b/c/e/f/g/q] is: " choice

    case $choice in

      a)echo -e $'\n';
        echo -e "Directory Name:                  [ ${RED_B}${SETTINGS[0:file_setting:dir_name]}${RST} ]";
        read -r -p "New Directory Name: " dir_note;
        echo -e $'\n';
        update_json "0" "file_setting" "dir_name" "$dir_note" ; 
        wait;;


      b) echo -e $'\n';
        echo -e "File Name:           [ ${RED_B}${SETTINGS[0:file_setting:file_name]}${RST} ]";
        read -r -p "New Directory Name: " note;
        echo -e $'\n';
        update_json "0" "file_setting" "file_name" "$note" ; 
        wait;;

      c) echo -e $'\n';
        echo "File Extension: ${SETTINGS[0:file_setting:file_extension]}";
        read -r -p "New Extension Name: " ext_note;
        echo -e $'\n';
        update_json "0" "file_setting" "file_extension" "$ext_note" ;
        wait;;

      e) echo -e $'\n';
        echo "Server Name: ${SETTINGS[1:server_setting:server_name]}";
        read -r -p "New Extension Name: " srv_name;
        echo -e $'\n';
        update_json "1" "server_setting" "server_name" "$srv_name" ;
        wait;;

      f) echo -e $'\n';
        echo "File Extension: ${SETTINGS[1:server_setting:server_link]}";
        read -r -p "New Extension Name: " ser_link;
        echo -e $'\n';
        update_json "1" "server_setting" "server_link" "$ser_link" ;
        wait;;

      g) echo -e $'\n';
        echo "File Extension: ${SETTINGS[1:server_setting:server_port]}";
        read -r -p "New Extension Name: " ser_port;
        echo -e $'\n';
        update_json "1" "server_setting" "server_port" "$ser_port" ;
        wait;;


      q) exit 1;;

      *) echo -e $'\n';
        echo -e "${YLW}Unrecognized selection: $choice ${RST} ReInter another choice " ;
         echo -e $'\n';;
    esac
  done
}

#-------------------Server----------------------#
function server(){

  server_name=${SETTINGS[1:server_setting:server_name]}
  server_link=${SETTINGS[1:server_setting:server_link]}
  server_port=${SETTINGS[1:server_setting:server_port]}

if [[ $(ps -ef | grep -c mkdocs) -ne 1 ]]; 
then 
  echo "yes it's runing";
  usage
else 
  cd ~/wz-notes/
  wait
  exec bash -c "${server_name} serve -a ${server_link}:${server_port}" &>/dev/null &
  echo -e "server runing at: ${server_name} => ${server_link}:${server_port}"
  usage

fi
}

log() {
  local MESSAGE="${@:? Message not found}"
  echo "${MESSAGE}"
}

#-----------Whit getopts----------#
# check if no argments
if [[ ! $@ =~ ^\-.+ ]]
then
#-------Program installation check Check------------#
if [[ ! -x  "$NVIM" && ! -x "$MDBOOK" ]]; then
    echo "${PROG}: $NVIM not found, install it first" >&2
    exit 1
fi
  usage
fi

while getopts ':n: :e :s :h :m :q' OPTIONS;do
  case "$OPTIONS" in 
    n)
      create_note
      creat_week_note
      log "Note Created"
      ;;
    e)
      edit_note
      ;;
    s)
      settings_json
      settings
      ;;
    h)
      usage
      ;;
    m) 
      server
      ;;
    q)
      exit 1
      ;;
  esac
done

