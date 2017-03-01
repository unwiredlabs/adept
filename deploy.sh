#!/bin/bash
echo "
      █████╗ ██████╗ ███████╗██████╗ ████████╗
      ██╔══██╗██╔══██╗██╔════╝██╔══██╗╚══██╔══╝
      ███████║██║  ██║█████╗  ██████╔╝   ██║   
      ██╔══██║██║  ██║██╔══╝  ██╔═══╝    ██║   
      ██║  ██║██████╔╝███████╗██║        ██║   
      ╚═╝  ╚═╝╚═════╝ ╚══════╝╚═╝        ╚═╝   
"
echo "Deployment tool to run tasks on multiple SSH servers"
echo "Created by Unwired Labs (https://unwiredlabs.com)"

#Parse commandline
if (( ! "$#" > "1" )); then
    echo "Usage: <hosts-file> <task> <parallel>"
    echo "<hosts-file> mention hostname (without .txt extension) file stored in ./hosts e.g.
        app - for all app servers. You can also use a direct shortcut as mentioned in ~/.ssh/config"
    echo "<task> mention type of task . e.g.
        deploy - deploys
        init-repo - creates git repo
        update-config - updates config files, and restarts procs"
    echo "<parallel> 1 for executing parallely, 0 for sequential"
    exit
fi

typeDeploy="./tasks/$2.sh"
typeDeploy2="./tasks/local/$2@.sh"
typeHost="./hosts/$1.txt"
typeHost2="./hosts/local/$1@.txt"
typeExec="$3"

#Switching to current directory
dir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
cd $dir

#Make sure the script exists
if [ ! -f $typeDeploy ]; then
    if [ ! -f $typeDeploy2 ]; then
        echo "Deploy script $typeDeploy or $typeDeploy2 not found!"
        exit;
    fi
    typeDeploy=$typeDeploy2
fi

#Make sure the script exists
if [ ! -f $typeHost ]; then
    if [ ! -f $typeHost2 ]; then
        typeHost="$1|"
        echo "Host file $typeHost not found, using $typeHost as host"
    else
        typeHost=$typeHost2
    fi
fi

if [ "$typeExec" = "" ] || [ "$typeExec" = "0" ]; then
    typeExec=0
    echo "***Executing sequentially"
else
    echo "***Executing parallely"
fi

#Read the commands
cmd="`cat $typeDeploy`"

COUNTER=0
while read -d "|"  line
do
    COUNTER=$((COUNTER + 1))
    if [ "$typeExec" == "1" ]; then
        source $typeDeploy  < /dev/null &
    else
        source $typeDeploy  < /dev/tty
    fi

done < "$typeHost"
wait

exit

#Print output in order
for i in "${outputArr[@]}"
do
   cat $i
done

printf "\n\nAll done!\n"
