# Docker Assistant


Requirements:
- These script are written with bash, so a linux kernel is required.
- You will need root access to execute these scripts
- A domain name - I use Google domains as it is so easy to manage and works great with my DDclient 
  - (something like 'i-love-this-stuff.com')
- Knowledge of how to install Docker 
  - Linux reference -> https://docs.docker.com/engine/install/ubuntu/
  - Synology reference -> install package Docker: https://www.synology.com/en-global/dsm/packages/Docker
- Teach you how to install git -
  - Linux refererenct > https://gist.github.com/derhuerst/1b15ff4652a867391f03
  - I'm using Synology DSM 7.0 ->  so I install 'Git Server' Package Center
    - https://gist.github.com/walkerjeffd/374750c366605cd5123d
- Knowledge of an editor to maintenace/edit your .env files.
  - Pick one of these editors: 'notepad' 'vi .env' 'vim .env' or 'nano .env'
- Knowledge DNS records you need
- Start with the default networks only:
  | NETWORK ID   | NAME           |DRIVER  | SCOPE
  |--------------|----------------|--------|-------|
  | ############ | bridge         |bridge  | local |
  | ############ | host           |host    | local |
  | ############ | none           |null    | local |


What this will NOT do for you:
- Teach you how to debug any issues you may have


Templates are deployed in two of the three directories off the ./docker_assistant/:
- lan 1 local area network, no intarnet access, only intranet (local lan) via a whitelist (wan access will receive a not authorized)
- wan 2 wide area network, accessible from internet and intranet
- dev X this is where we try things out, or setup a degug environment. (hard code new things to dev regardless of ENV)


Your clone directory will contain ( I used:'./docker_assistant/')
- custom_data - misc files used in a container setup
- scripts     - re-usable code base (bash scripts)
- templates   - deployment container and scripts './docker_assistant/templates/'


Each template will have a dedicated folder and deployment script
Naming standard should be {PACKAGE_NAME}-{VERSION}
  - i.e. Template: 'whoami' is deployed using the script 'whoami.sh'


Every template will contain the below set of scripts (no description as they are self explanatory)
Currently, these do not have any parameters, so no -h option
If the deployment package does not support something, a message will be diplayed when executed
- attach.sh
- down.sh
- log.error.sh
- log.standard.sh
- log.tail.sh
- restart.sh
- up.sh
You can execute these by doing:
i.e. sudo ./{script}.sh
     sudo ./up.sh


You cannot move scripts between directories (if you do, learn to debug).


After each deployment:
- You will need to change directory to the deployment folder (it will be displayed to you)
- Review the '.env' file generated for correctness
- Execute: sudo ./up.sh to start the container


# 1 - Steps required to get sites/apps working...
- Clone the docker environment to your server. (preferable one (1) level from the root directory) i.e. /volume1/docker_assistant/
  - user@server:~/ $ cd /volume1
  - user@server:/volume1/ $> git clone https://github.com/ToolboxAid/docker_assistant
- 'cd' to the directory you use to deploy this software
  - user@server:/volume1/ $ cd ./docker_assistant/



# 2 Setup environment
- Execute script 'user@server:/volume1/docker_assistant/ $ sudo ./env.setup.sh'
  - Please review/update your generated files for correctness :
    - './templates/.common.env' file
    - './scripts/.port_number' (the value will change over time)
    - './scripts/.docker.zip.env'

# 3 Create a dynamic A record for your {DOMAIN_NAME}.com

4  Point your router to you MAC-VLAN IP (Ports 80 and 443) to the MAC-VLAN ip address
- as Traefik will be running on a MAC-VLAN, you can forward port 80 to 80 & 443 to 443
- I know, no way to test this until Traefik is running.

# 5 DD-Client
- use 'cd ./template' and 'ls -la' to see the templated directory
- Run DDclient setup - this will point a url to your dynamic external IP
-   (once updated, it could take upto 24 hours to work, my works within 15 min with google DNS)
- Execute script 'sudo ./ddclient-v3.9.1-ls100.sh' (as of writting this, the version is 'v3.9.1-ls100')

- Logon to your domain and create a Dynamic record forwarding to traefik.wan.{DOMAIN_NAME}
- update your DDclient with the new DNS information, and restart
    use command: 'cd ./templates'  if not already there
    use: 'ls -la' to see directory listing
    cd to '../wan/ddclient-v3.9.1-ls100'

    If you have a firewall in place, you will need to enter a rule for outbound traffic.
    The ddclient web subnet will be display
    You will need to lookup the CIDR of >  xx.xx.xx.xx/16 for most firewal rules
                                                      /16 subnet is 255.255.0.0
   you can use something like: https://www.dan.me.uk/ipsubnets

    use: 'sudo ./up.sh' to start the container

    run ./log.tail.sh and see if is updating or failing.

) Update /docker_assistant/templates/ddclient-v3.9.1-ls100/config/ddclient.conf with the below information from your domain provider
# - - - - - - - - - - YYYY.MM.DD
protocol=googledomains
login=
password=
{DOMAIN_NAME}.com
)

    Execute: 'sudo ./up.sh' to start DDclient

    Execute: './log.tail.sh' and see if is updating or failing.

If no errors, you should now be able to ping your DOMAIN_NAME and get your external IP
(assuming the DNS gods are with you, if not, upto 24 hours)


# 6 Traefik proxies network traffic to all of your services over SSL
Only the Traefik container has direct access to the internet.  All other containers flow through Traefick having the docker firewall rules in place to assist with security issues.

- Logon to your domain and create another Dynamic record forwarding to traefik.wan.{DOMAIN_NAME}
- update your DDclient with the new DNS information, wait 15 min or ./restart.sh
    use command: 'cd ./templates'  if not already there
    use: 'ls -la' to see directory listing
    use: 'sudo ./traefik-v2.8.sh' to setup the container (as of writting this, the version is 'v2.8')

- at this point, you sould be able to browse to traefik.wan.{DOMAIN_NAMER}

# 7
- From directory './template' use the {script_name}.setup.sh to create new continers
- use 'cd ./template' and 'ls -la' to see the templated directory
- From directory './template' use the {script_name}.setup.sh to create new continers
- Point your router to you MAC-VLAN IP (Ports 80 and 443) to the MAC-VLAN ip address


8 Test your setup
- Run whoami - test your first site
- Run wordpress - your first site to manage
- run phpmyadmin - abaility to get to your database when needed.


#### not a setup script to create .docker_zip.env
) run a backup of your work './docker_assistant/scripts/docker_zip_backup.sh'


# Notes
- external: false     #### prevents talking to other containers (creates new network for exe)
- external: true      #### allows   talking to other containers (used defined network in docker-compose)
