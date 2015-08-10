out=$(printf "\n\n\n SSH to *$line*\n\n\n"
ssh -t -t "$line" \
'hostname &&
echo -ne "Installing unattended upgrades \t" &&
sudo apt-get install -qq unattended-upgrades  && echo "Done" &&
echo -ne "Initating the unattended upgrades \t" &&
echo -e "APT::Periodic::Update-Package-Lists \"1\";\nAPT::Periodic::Unattended-Upgrade \"1\";\n" > /etc/apt/apt.conf.d/20auto-upgrades && echo "Done" &&
/etc/init.d/unattended-upgrades restart;
exit;')
printf "%s\n\n" "$out"
