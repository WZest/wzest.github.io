#!/bin/bash

note_to_edit=`grep -oP "(?<=ID: \[).*(?=\])" ~/wz-notes/docs/*.md | grep -oP "(?<=docs/).*" | dmenu -l 19 -sf "#689d6a" -nb "#282828" -nf "#fe8019" -sb "#3c3836" -fn "Ubuntu-14"  -p "Edit Note:"| grep -oP "(?=note).*(?=:)"`


link="~/wz-notes/docs/$note_to_edit"
rtrn=$?

export note_to_edit

if test "$rtrn" = "0"; then
  exec nvim ~/wz-notes/docs/$note_to_edit &

fi
exec ~/wz-notes/./test.sh ~/wz-notes/docs/$note_to_edit 

#LTIME=`stat -c %y $link`
#
#while true    
#do
#   ATIME=`stat -c %y $link`
#   if [[ "$ATIME" != "$LTIME" ]]
#   then    
#        echo "Edited: $(date +%H:%M:%S)" >> $link
#        LTIME=$ATIME
#        break
#   fi
# sleep 5
#done
#
