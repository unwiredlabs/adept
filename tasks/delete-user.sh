#delete "test" user
ssh -t -t "$line" \
'hostname;
echo -ne "Delete test user \t" &&
sudo deluser --remove-home test &&  echo "Done";
exit;'
