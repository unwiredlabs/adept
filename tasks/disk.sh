out=$(printf "\n\n\n SSH to *$line*\n\n\n"
ssh -t -t "$line" \
'hostname &&
df -h &&
exit')
printf "%s\n\n" "$out"
