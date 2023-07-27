#!/bin/bash

note_or_idee=`echo -e "-n\n-i" | dmenu -l 3 -sf "#689d6a" -nb "#282828" -nf "#fe8019" -sb "#3c3836" -fn "Ubuntu-14" -p "wz-notes"`
note_title=`:|dmenu -i -sf "#689d6a" -nb "#282828" -nf "#fe8019" -sb "#3c3836" -fn "Ubuntu-14"  -p "Note Title:"`
rtrn=$?

if test "$rtrn" = "0"; then
  exec ~/wz-notes/./note.sh $note_or_idee $note_title
fi
