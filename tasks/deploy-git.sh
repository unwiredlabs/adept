out=$(
printf "\n\n\n SSH to *$line*\n\n\n"
ssh -t -t "$line" \
'hostname &&
echo -ne " Installing GIT \t" &&
sudo apt-get install -qq GIT && echo "Done" &&
exit;')
printf "%s\n\n" "$out"
