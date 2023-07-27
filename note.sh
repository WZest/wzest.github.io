#!/bin/bash 

file="$HOME/wz-notes/docs"
wfilename="$HOME/wz-notes/docs/week-$(date  +%U%m%Y).md"
FileName="$HOME/wz-notes/docs/note-$(date  +%d%m%Y-%H%M%S).md"

mkdocsyml="$HOME/wz-notes/mkdocs.yml"

date_nav="    - week-$(date +%U): 'week-$(date +%U%m%Y)'"
export date_nav

title="${@:2}"
#if [ "$1" == "n" ]; then
#  echo "youpi";
#fi 
if [ ! -f "$wfilename" ]; then
    touch "$wfilename"
    #echo "  - week-$(date +%U): 'week-$(date +%U%m%Y)'" >> $mkdocsyml
    perl -pi -e '$_ .= qq($ENV{date_nav}\n) if /Week:/' $mkdocsyml


fi 

foo=$(echo "$FileName" | sed -r "s/.+\/(.+)\..+/\1/")

if [ ! -f "$FileName" ]; then
 echo "<!---ID: $foo--->
# __"$title"__
----

[:octicons-comment-discussion-16:&nbsp; Index][Index]{ .md-button }
[Index]: http://127.0.0.1:8000/
:octicons-clock-24:{ style="color:green" } $(date +%H:%M:%S)" > "$FileName";
fi
#bol=$(grep -A 1 "ID" $FileName)

#nvim -c ":set spell spelllang=en" \
nvim -c "norm ggjA" "$FileName"
 #  -c ":autocmd BufWritePost * silent !~/wz-notes/indexnotes.sh"\
 #   -c "startinsert" "$FileName"
cat "$FileName" >> "$wfilename" 
sleep 1 
#sleep 1 
echo "<!--- IDW: ($wfilename)($foo.md) --->" >> $FileName 
exec ~/wz-notes/./indexnotes.sh "$1" 
