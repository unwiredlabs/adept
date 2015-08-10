out=$(
printf "\n\n\n SSH to *$line*\n\n\n"
ssh -t -t "$line" \
'hostname &&
echo -ne " Installing apache \t" &&
sudo apt-get install -qq apache2  && echo "Done" &&
echo -ne " Installing mysql \t" &&
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password your_password' &&
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password your_password' &&
sudo apt-get install -qq mysql-server && echo "Done" &&
echo -ne " Installing php php5-curl php5-json \t" &&
sudo apt-get install -qq php5-curl php5-fpm php5-json && echo "Done" &&
exit;')
printf "%s\n\n" "$out"

out=$(printf "\n\n\n sFTP to *$line*\n\n\n" &&
sftp $line <<< $'put ./config/my.cnf /etc/mysql/my.cnf' )
printf "%s\n\n" "$out"