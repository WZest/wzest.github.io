

LTIME=`stat -c %y $1`

while true    
do
   ATIME=`stat -c %y $1`
   if [[ "$ATIME" != "$LTIME" ]]
   then    
        echo "Edited: $(date +%H:%M:%S)" >> $1
        LTIME=$ATIME
        break
   fi
done

