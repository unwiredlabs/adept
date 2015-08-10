out=$(printf "\n*SSH to $line*\n\n"
ssh -t -t "$line" \
'hostname;
echo -ne "Git pull \t";
cd /var/www/ &&
git clone https://github.com/phpmyadmin/phpmyadmin.git -q && echo Done ;
exit')
printf "%s\n\n" "$out"
