#!/bin/bash
#phrase=`grep -o "^\# __.*" ~/wz-notes/docs/*.md|grep -oP "(?<=# __).*(?=__)" | dmenu -i -l 20`
#phrase2=`grep -o "^\<!---.*" ~/wz-notes/docs/*.md|grep -oP "(?<=ID:).*(?=-->)" | dmenu -i -l 20`
#phrase2=`grep -oPh "(?<=ID:).*(?=.md)" ~/wz-notes/docs/*.md | dmenu -l 30`
#phrase3=`grep -l $phrase2 ~/wz-notes/docs/*.md`
#phrase4=`grep -oPh "(?<=ID:).*(?=.md)" ~/wz-notes/docs/*.md | dmenu -l 30 | grep -oP "(?<=\]\().*"`
phrase4=`grep -oP "(?<=ID: \[).*(?=\])" ~/wz-notes/docs/*.md | grep -oP "(?<=docs/).*" | dmenu -l 19 -sf "#689d6a" -nb "#282828" -nf "#fe8019" -sb "#3c3836" -fn "Ubuntu-14"  -p "Edit Note:"| grep -oP "(?=note).*(?>=.md)"`
# with ls ls -rt *.md | xargs grep -oP "(?<=ID: \[).*(?=\])" ~/wz-notes/docs/*.md | grep -oP "(?<=docs/).*" | dmenu -l 19 | grep -oP "(?=note).*(?=:)"
 #phrase=`ls ~/wz-notes/docs| \
  # dmenu -i -l 20`
#mut=`echo -e "-n\n-i" | dmenu -l 3 -fn "Ubuntu-14" -p "wz-notes"`

#put=`:|dmenu -i -fn "Ubuntu-14" -p "Note Title:"`
rtrn=$?

if test "$rtrn" = "0"; then
  echo "/$phrase4" | xsel -ib
#  exec ~/wz-notes/./note.sh $mut $put
#
fi
