#!/bin/bash

# note_to_edit=`grep -oP "(?<=ID: \[).*(?=\])" ~/wz-notes/docs/*.md | grep -oP "(?<=docs/).*" | dmenu -l 19 -sf "#689d6a" -nb "#282828" -nf "#fe8019" -sb "#3c3836" -fn "Ubuntu-14"  -p "Edit Note:"| grep -oP "(?=note).*(?=:)"`

exec ~/wz-notes/./test.sh ~/wz-notes/docs/$1

