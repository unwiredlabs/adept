out=$(
printf "\n\n\n SSH to *$line*\n\n\n"
ssh -t -t "$line" \
'hostname &&
echo -ne " Installing redis \t" &&
sudo apt-get install -qq redis-server php5-redis && echo "Done" &&
echo -ne " Restarting redis \t" &&
sudo service redis-server restart 1>/dev/null &&  echo "Done";
echo -ne " Restarting apache \t" &&
sudo service apache2 restart 1>/dev/null  &&  echo "Done";
echo -ne " Restarting php5-fpm  \t" &&
sudo service php5-fpm restart 1>/dev/null  &&  echo "Done";
exit;')
printf "%s\n\n" "$out"
