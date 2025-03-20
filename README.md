![This is an image](./assets/ToolboxAid3.png)

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

## Follow this [Set Me Up](https://github.com/ToolboxAid/Docker-Assistant/blob/main/SETMEUP.md) page to get going

# Notes:
### More projects at: [ToolboxAid.com](https://toolboxaid.com/).
### Docker external network access meaning:
   - external: false # prevents talking to other containers (creates new network for exe)
   - external: true  # allows   talking to other containers (used defined network in docker-compose)

