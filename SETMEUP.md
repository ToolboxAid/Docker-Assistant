![This is an image](./assets/ToolboxAid3.png)

# Docker Assistant (Set Me Up)

## Follow these required steps to get sites/apps working...

### 1 - Clone Docker Assistant
- Clone docker_assistant to your server. (preferable one (1) level from the root directory) i.e. /volume1/docker_assistant/
```
user@server:~/ $ cd /volume1
user@server:/volume1/ $ sudo git clone https://github.com/ToolboxAid/docker_assistant
```
- Directory and file needs to be owned by you
```
user@server:/volume1/ $ sudo chown -R {user:group} ./docker_assistant/
user@server:/volume1/ $ chmod 775 -R ./docker_assistant/
```
- 'cd' to docker_assistant
```
user@server:/volume1/ $ cd ./docker_assistant/
```
  
### 2 - Setup Docker Assistant environment setup
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

### 3 - DD-Client setup
- use 'cd ./template' and 'ls -la' to see the templated directory
- Setup DDclient
  - Execute script 'sudo ./ddclient-v3.9.1-ls100.sh' (as of writting this, the version is 'v3.9.1-ls100')

#### If for some reason your cache is bad in the future when you add a new site
```
sudo ./attach.sh
cd /var/cache/ddclient/
cp ddclient.cache ddclient.cache_bkup
touch  ddclient.cache
```

### 4 - Create a dynamic A record for Traefik and DD-Client
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
- sudo ./up.sh
- sudo ./log.tail.sh
```
Review the logs to see if it is updating or failing.

Once updated, it could take upto 24 hours or more to work, with Google DNS, my works within 15 min
If no errors, you should now be able to:
```
ping traefik.lan.{YOUR_DOMAIN_NAME}  (depending if you allow replies to pings)
nslookup traefik.lan.{YOUR_DOMAIN_NAME}
```
(assuming the DNS gods are with you, if not, upto 24 hours)

Additional reading:
- https://plugins.traefik.io/plugins/62947353108ecc83915d778d/simple-cache
- https://plugins.traefik.io/plugins/628c9eadffc0cd18356a9799/docker-compose.local.yml


### 5 - Point your router to you MAC-VLAN IP from step 2 to the MAC-VLAN ip address (Ports 80 and 443)
- as Traefik will be running on a MAC-VLAN, you need to forward ports 80 to 80 and 443 to 443 to your Traefik IP address
- I know, no way to test this until Traefik is running in step 6.


### 6 - Traefik will proxy all of it's HTTPS network requests to your services
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


### 7 - Test your setup single deployable sites.
Setup whoami - simple test site
```
cd ./templates
./whoami.sh
./lan/whoami/ and execute ./up.sh
```
Launch your browser pointed to whoami.lan.{YOUR_DOMAIN_NAME}


### 8 - Now that you see what to do, you can diploy the other containers:
- From directory './template' use the {script_name}.setup.sh to create new continers
- use 'cd ./template' and 'ls -la' to see the templated directory
- From directory './template' use the {script_name}.setup.sh to create new continers
- Point your router to you MAC-VLAN IP (Ports 80 and 443) to the MAC-VLAN ip address

#### NOTE: if the script require the parameter {SITE}, you can deploy multiple instances of it

After each deployment where you see a network created (remember to do this):
- You will need to change directory to the deployment folder (it will be displayed to you)
- Review/edit the '.env' file generated for correctness
- Execute: user@server:/volume1/docker_assistant/(wan|lan)/packege/ $ sudo ./up.sh to start the container


### 9 - Deploy a single instance with predefined URLs.
- Setup phpmyadmin - abaility to get to your database when needed.
- Setup portainer - easy way to see details about a container


### 10 - Deploy multiplue instances of a container with different URLs
Run wordpress - your first site to manage with a DB
Additional reading: 
- https://wordpress.org/support/article/hardening-wordpress/#file-permissions

### 11 - backing up sites
Update the BACKUP_PATH in './docker_assistant/scripts/.docker.zip.env'

docker_zip_backup.sh requires one (1) parameter:
 base - backup only custom_data, scripts & templates
 site - backup only wan, lan, dev directories
 full - backup site & base

Run a backup of your work './docker_assistant/scripts/docker_zip_backup.sh {parameter}'
To restore a site, just drag the folder to the correct location and start it.

