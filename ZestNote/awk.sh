tmpfile=$(mktemp)
cp settings.json "$tmpfile" &&
awk '{sub(/dir_name/,"Hello")}1' "$tmpfile" > "settings.json"
rm "$tmpfile"
