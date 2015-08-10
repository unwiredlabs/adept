
      █████╗ ██████╗ ███████╗██████╗ ████████╗
      ██╔══██╗██╔══██╗██╔════╝██╔══██╗╚══██╔══╝
      ███████║██║  ██║█████╗  ██████╔╝   ██║   
      ██╔══██║██║  ██║██╔══╝  ██╔═══╝    ██║   
      ██║  ██║██████╔╝███████╗██║        ██║   
      ╚═╝  ╚═╝╚═════╝ ╚══════╝╚═╝        ╚═╝   

Adept
-----

_Adept_ is a *very* simple way to run commands & deploy apps on multiple servers. It runs on `Shell` (Linux, Mac, etc), over SSH and without any agents. Adept was created by non-DevOps folks at @UnwiredLabs to quickly manage ~ 25 servers without learning `ansible` or `chef`.

###How it works

Adept uses `SSH` to login to one or more servers and execute a series of `sh/bash` commands. This can be done sequentially or parallely. Commands are executed from the entry script - `deploy.sh` and the structure of a typical command is as follows:

```
$ ./deploy.sh <Host-group file / SSH identity> <Task file> [Parallel or Sequential; default sequential]
```

Host group & Task files are stored in the `./hosts` and `./tasks` folders respectively. Hosts are read from the local SSH config file, usually located at `~/.ssh/config`. These hosts need to be configured with SSH keys.

###Things you could do on multiple systems with Adept
* Install a new stack
* Add / remove users
* Copy config files to multiple servers while also executing commands (using sFTP)
* Deploy a script (git pulls, etc)
* Deploy a new system by installing default tools
* Just about anything else you do in Shell / Bash, but want replicated :-)

###Examples
*These examples are included in `/tasks` folder of the project*

####Show current system date on all servers parallely:
```
$ ./deploy.sh all date 1
```

####Show available disk space on all servers sequentially:
```
$ ./deploy.sh all disk 0
```

####Deploy LAMP-server on a group of hosts:
```
$ ./deploy.sh webservers deploy-lamp
```
Adept can also use `sFTP` to copy files, such as config files, to servers. In-order to deploy the configuration files, we recommend you place them under `./configs` folder

####Deploy a PHPMyAdmin instance on a single host:
```
$ ./deploy.sh host1 deploy-pma
```

###Adding servers / host-groups

####Create a host-group
* Create a new `<host-group-name>.txt` file in `./hosts` folder
* Enter host names (as configured in your local `~/.ssh/config` file) separated by `|`
* The last host name should be followed by `|` for the file to work

####For a single server
* You don't have to create a `host` file. Directly enter the SSH identity name in place of the hostgroup.

###Writing Adept scripts

####Create a task
* Create a new `<task-name>.sh` file in `./tasks` folder
* A simple task file looks like this:
````
ssh -t -t "$line" \
'hostname &&
exit;'
````
* This task can execute both parallely or in sequentially
* If it's a parallel task, you should use the following style of code to ensure output for each host comes together:
````
out=$(printf "\n*SSH to $line*\n\n"
ssh -t -t "$line" \
  'hostname;
  echo -ne "Git pull \t";
  cd /var/www/ &&
  git pull -q && echo "Done";
  exit;
')

printf "%s\n\n" "$out"
````
* To prevent parallel execution, use this snippet inside your task file:
````
if [ "$typeExec" = "1" ]; then
    echo "Cannot run parallely, please set parallel to 0"
    exit
fi
````
* _Error handling_: Use `&&` at the end of a line to exit if there's an error and `;` to continue even if there are errors.

####Create a local-only task
To create a task or host-group that's only accessible on your local machine and not visible to GIT, add `@` to the task or host group and save it in the /local/ sub-directory.


####Road-map for new features
* Conditions before deploying, like running the tests locally before deploying a project
* Show only error output instead of everything, so it's easier to manage deployments for more servers
* Auto-predict list of hosts & tasks
* Stay simple :-)
* Any other ideas, folks?

Logo credit: `http://patorjk.com/software/taag/`