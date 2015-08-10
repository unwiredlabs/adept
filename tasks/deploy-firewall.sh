out=$(printf "\n*SSH to $line*\n\n"
ssh -t -t "$line" \
'hostname;
netstat -ntlp | grep LISTEN  &&
echo "Resetting firewall" &&
yes | sudo ufw reset;
echo "Configuring firewall" &&
echo "If there is an error, run $ sudo apt-get install linux-image-$(uname -r)" &&
echo "If there is still an error, disable ip6 in /etc/default/ufw" &&
sudo ufw disable &&
sudo ufw allow 22/tcp &&
sudo ufw default deny incoming &&
sudo ufw default allow outgoing &&
sudo ufw allow 80/tcp &&
sudo ufw allow 8080/tcp &&
yes | sudo ufw enable &&
sudo ufw status verbose && echo "Done" &&
exit;
')
printf "%s\n\n" "$out"
