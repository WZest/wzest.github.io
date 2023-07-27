#!/bin/bash

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
                check=`echo "$PAIR_VALUE" | grep -E ^\-?[0-9]*\.?[0-9]+$`
          # if [ "${res}" ] && [ $exitCode -eq "0" ] && [[ ! "${PAIR_VALUE}" == ?(-)+([0-9]) ]]  ALTERNATIVE, works only for integer (not floating point)
          if [ "${res}" ] && [ $exitCode -eq "0" ] && [[ "$check" == '' ]]
            then
                get_settings "$PAIR_VALUE" "$KEY"
               else
            SETTINGS["$KEY"]="$PAIR_VALUE"
        fi
           
       

    done <<< "$JSON"
}
get_settings "$SETTINGS_JSON"

echo ${SETTINGS[1:file_setting:file_naming:file_name_date]}
echo ${SETTINGS[0:file_settings:dir_name]}
original=${SETTINGS[0:file_settings:dir_name]}
new=${SETTINGS[1:file_setting:file_naming:file_name_date]}
sed -i "s/$original/$new/" settings.json

