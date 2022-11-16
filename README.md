# Docker Assistant

## Requirements:
- These script are written with bash, so a linux kernel is required.
- You will need root access to execute these scripts
- A domain name - I use Google domains as it is so easy to manage and works great with my DDclient 
  - (something like '[example.com](http://example.com/)')
- Knowledge of how to install Docker 
  - Linux reference -> https://docs.docker.com/engine/install/ubuntu/
  - Synology reference -> install package Docker: https://www.synology.com/en-global/dsm/packages/Docker
- Knowledge of how to install git -
  - Linux refererenct > https://gist.github.com/derhuerst/1b15ff4652a867391f03
  - I'm using Synology DSM 7.0 ->  so I installed 'Git Server' Package Center
    - https://gist.github.com/walkerjeffd/374750c366605cd5123d
    - http://blog.osdev.org/git/2014/02/13/using-git-on-a-synology-nas.html
- Knowledge of an editor to maintenace/edit your .env files.
  - Pick one of these editors: 'notepad' 'vi .env' 'vim .env' or 'nano .env'
- Knowledge DNS records you need
- Start with the default networks only:
  | NETWORK ID   | NAME           |DRIVER  | SCOPE
  |--------------|----------------|--------|-------|
  | ############ | bridge         |bridge  | local |
  | ############ | host           |host    | local |
  | ############ | none           |null    | local |

### What this will NOT do for you:
- Teach you how to debug any issues you may have

**You CANNOT move scripts between directories (if you do, learn to debug).**

### Your clone directory will contain ( I used:'./docker_assistant/')
```
/voloume1
  └── docker_assistant
       ├── custom_data - misc files used in a container setup
       ├── scripts     - re-usable code base (bash scripts)
       └── templates   - deployment container and scripts
```



### Templates are deployed in two of the three directories off the ./docker_assistant/:
```
/voloume1
  └── docker_assistant
       ├── dev   not a deploy directory, this is where we try things out, or setup a degug environment.
       ├── lan   1 local area network, no intarnet access, only intranet (local lan) via a whitelist (wan access will receive a not authorized)
       └── wan   2 wide area network, accessible from internet and intranet
```


### Each template will have a dedicated folder and deployment script
Naming standard should be {PACKAGE_NAME}-{VERSION}
  - i.e. Template: 'whoami' is deployed using the script 'whoami.sh'

### Every template will contain the below set of scripts (no description as they are self explanatory)
Currently, these do not have any parameters, so no -h option
If the deployment package does not support something, a message will be diplayed when executed
```
/voloume1
  └── docker_assistant
       └── {lan or wan}
            └── {container_name}
                ├── attach.sh
                ├── down.sh
                ├── env.sh
                ├── log.error.sh
                ├── log.standard.sh
                ├── log.tail.sh
                ├── restart.sh
                └──  up.sh
```

You can execute these by doing:
```
sudo ./{script}.sh
sudo ./up.sh
```

## Follow these required steps to get sites/apps working...

### 1 - Clone Docker Assistant
- Clone docker_assistant to your server. (preferable one (1) level from the root directory) i.e. /volume1/docker_assistant/
  - user@server:~/ $ cd /volume1
  - user@server:/volume1/ $> git clone https://github.com/ToolboxAid/docker_assistant
- 'cd' to the directory you use to deploy this software
  - user@server:/volume1/ $ cd ./docker_assistant/

### 2 Setup Docker Assistant environment setup
- Execute script 'user@server:/volume1/docker_assistant/ $ sudo ./env.setup.sh'
  - Please review/update your generated files for correctness
```
/voloume1
  └── docker_assistant
       ├── custom_data
       ├── dev
       ├── lan
       ├── scriptsemplate
       ├── template 
       │   └── .common.env
       ├── wan
       └── setup.env.sh
```

### 3 DD-Client setup
- use 'cd ./template' and 'ls -la' to see the templated directory
- Setup DDclient
  - Execute script 'sudo ./ddclient-v3.9.1-ls100.sh' (as of writting this, the version is 'v3.9.1-ls100')

### 4 Create a dynamic A record for Traefik and DD-Client
Logon to your DNS host and create a Dynamic record forwarding to 'traefik.wan.{YOUR_DOMAIN_NAME}'
  - use command: 'cd /volume1/docker_assistant/lan/ddclient-v3.9.1-ls100/config/'
  - use: 'ls -la' to see directory listing

Update your DD-client config with the new DNS information '/docker_assistant/templates/ddclient-v3.9.1-ls100/config/ddclient.conf' with the below information from your Google domain provider

```
YYYY.MM.DD
protocol=googledomains
login=
password=
traefik.wan.{YOUR_DOMAIN_NAME}
```

If you have a firewall in place (and you should), you will need to enter a rule for outbound traffic.
The ddclient subnet will be display for you
You may need to lookup the CIDR of >  xx.xx.xx.xx/16 for most firewal rules
                                                 /16 subnet is 255.255.0.0
   - you can use something like: https://www.dan.me.uk/ipsubnets

After updating 'ddclient.conf', Execute:
```
- 'sudo ./up.sh' to start DDclient
- 'sudo ./log.tail.sh' and see if it is updating or failing.
```
Once updated, it could take upto 24 hours or more to work, with Google DNS, my works within 15 min
If no errors, you should now be able to:
```
ping traefik.lan.{YOUR_DOMAIN_NAME}  (depending if you allow replies to pings)
nslookup traefik.lan.{YOUR_DOMAIN_NAME}
```
(assuming the DNS gods are with you, if not, upto 24 hours)


### 5  Point your router to you MAC-VLAN IP from step 2 to the MAC-VLAN ip address (Ports 80 and 443)
- as Traefik will be running on a MAC-VLAN, you need to forward ports 80 to 80 and 443 to 443 to your Traefik IP address
- I know, no way to test this until Traefik is running in step 6.


### 6 Traefik will proxy all of it's HTTPS network requests to your services
Only the Traefik container has direct access to the internet.  All other containers flow through Traefik using the docker firewall rules to assist with security issues.

To setup the container (as of writting this, the version is 'v2.8') use:
```
sudo ./traefik-v2.8.sh
cd ./wan/traefik-v2.8/
```

If you are using a synology NAS, you can route it through Traefik
- uncomment sysnology (service and router) section in /volume1/docker_assistant/templates/traefik-v2.8/dynamic.yml
  - in service update {synology_nas_ip}:{no_secure_port}
  - in router update {YOUR_DOMAIN_NAME}
- if you enabled redirect http to https on your Synology NAS.
  - In control panel, under DSM
    - disable Automatically redirect HTTP connection to HTTPS
    - disable HSTS forect brousers to use secured connection
- You can used this as a template to redirect request to non docker continers

Let's start it up:
```
sudo ./up.sh
sudo ./log.tail.sh
```

At this point, you sould be able to browse to traefik.wan.{YOUR_DOMAIN_NAME}


### 7 Test your setup single deployable sites.
Setup whoami - simple test site
  - execute script ./templates/whoami.sh
  - navagate to ./lan/whoami/ and execute ./up.sh
  - launch your browser pointed to whoami.lan.{YOUR_DOMAIN_NAME}


### 8 Now that you see what to do, you can diploy the other containers:
- From directory './template' use the {script_name}.setup.sh to create new continers
- use 'cd ./template' and 'ls -la' to see the templated directory
- From directory './template' use the {script_name}.setup.sh to create new continers
- Point your router to you MAC-VLAN IP (Ports 80 and 443) to the MAC-VLAN ip address

### NOTE: if the script require a parameter, you can deploy multiple instances of it

After each deployment where you see a network created (remember to do this):
- You will need to change directory to the deployment folder (it will be displayed to you)
- Review/edit the '.env' file generated for correctness
- Execute: user@server:/volume1/docker_assistant/(wan|lan)/packege/ $ sudo ./up.sh to start the container


### 9 Deploy a single instance with predefined URLs.
- Setup phpmyadmin - abaility to get to your database when needed.
- Setup portainer - easy way to see details about a container


### 10 Deploy multiplue instances of a container with different URLs
Run wordpress - your first site to manage with a DB
Additional reading: 
- https://wordpress.org/support/article/hardening-wordpress/#file-permissions
- https://plugins.traefik.io/plugins/62947353108ecc83915d778d/simple-cache
- https://plugins.traefik.io/plugins/628c9eadffc0cd18356a9799/docker-compose.local.yml

### 11 backing up sites
Update the BACKUP_PATH in './docker_assistant/scripts/.docker.zip.env'

docker_zip_backup.sh requires one (1) parameter:
 base - backup only custom_data, scripts & templates
 site - backup only wan, lan, dev directories
 full - backup site & base

Run a backup of your work './docker_assistant/scripts/docker_zip_backup.sh {parameter}'
To restore a site, just drag the folder to the correct location and start it.

# Notes:
### More projects at: [ToolboxAid.com](https://toolboxaid.com/).
### Network external access meaning:
   - external: false # prevents talking to other containers (creates new network for exe)
   - external: true  # allows   talking to other containers (used defined network in docker-compose)

