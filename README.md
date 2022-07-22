### PROJECT OMNIPRESENT: A PUSH BASED CONFIGURATION MANAGEMENT TOOL
#### The architecture:
- This tool uses a host-node relationship where changes made on the host can be propogated to node servers configured within the tool.
- There is an entry point script `almighty.sh` to be run on the host server which pulls in other peripheral scripts to achieve installation, updates and removal of configurations on the node servers provided in a document `nodelist`. This script works in conjunction with the `control.sh` script when any interaction is required with the node servers
- When the host server is configured, changes are not immediately send to the node server. These changes have to be manually triggered in order to appear on the nodes. This allows extensive testing on host before those changes are moved on the the node servers through a push method.

#### Improvements:
The following improvements can be considered for this tooling:
- Implementation of the entry point can be abstracting to act as an agent instead on the node side in order to facilitate a pull method of updating servers. A cron job can be set to periodically check for updates on the host server and pull in changes as need. This was the initial approach but was scratched due to time constraints
- Addition functionality can be added to compare file drift before any updates are made to the server
- Right now, the tool uses a synchronous approach to update the given node servers. It is agreeable that such an approach becomes tedious and time consuming when the list grows in number. A parallel, asynchronous approach can be used to prevent that
- In terms of security, a handshake protocal can be applied between host and node servers; as well as the installation protocol which uses scp now that the tool hasn't been packaged(ssh is used but one cannot be more secure, lol or maybe overkill)
- In the `dependencies.sh` the user passes in an array of dependencies. A good approach will be to declare the dependencies in a config file and pull it into the script

#### Features:
- Configuration
- Updates
- Standalone commands

#### Installation
- Clone <a href="https://github.com/JRcodes/project-omnipresent/tree/main" target="_blank">this repo</a>. You can clone it directly into ythe host server(Make sure you have git properly configured) or download the zip contents and push it to your server via scp and unzip it there

#### Usage
- The entry point for the tool is the script in `almight.sh`. This script takes in command line arguments and the tool performs based on which argument we pass to it
- A secondary point is the `control.sh` script which handles all calls to the node servers
- There are 5 configuration files that are customizable to the desire of the user. For this project, they have been already configured to provision a php web app running on apache2. These files and their purpose are:
    1. `jobdef.sh`: This is where you define your initial server configuration in. In this case, the script installs apache2 and php
    2. `updates.sh`: This is where you define any subsequent updates to your servers. We have an exemplar script that routinely installs MySQL server
    3. `dependencies.sh`: Any non-standard packages that you want to use can be installed in here. The code is written, all the user has to do is pass in an array of dependencies as indicated in the script(Check Improvements for notes on this script)
    4. `nodelist` this config file contains the list of node server ips and is pulled in by  `control.sh` whenever a call is required to be made to the node servers
    5. `.credfile` this file is intentionally made a hidden file and is excluded from the repository. In our use case where a password is required, the user will configure the passoword for the nodes here. This is simplified since in our use case all the nodes share the same password
- As already stated, the entry point of the tool takes in command line arguments. This helps us pinpoint the usage and purpose of the user's configuration requirements. So far, there are 13 distinct arguments that the tool takes. The first 3 should be done in the correct order to correctly configure the user's servers

- The 1 through 3 should be performed in order. After the host and node servers are configured using the first three, 4 through 8 can be used by themselves or in combination with one another to maintain all servers. To save reading time, also know that apart from `update` and it's counterpart `apply-update`, the rest of the commands will have a `remote` prefix to show that the action will be applied to the nodes as well eg. `install` will have `remote-install` as it's counterpart. Special Attention will be given to `remote-view` when we get that argument:
    1. `./almighty.sh init`: This initializes the host server by installing the required dependencies in `bootstrap.sh` and adds the nodes in `nodelist` to the known hosts(well be making ssh calls to them from the host server). Only run this on the host server
    2. `./almight.sh set`: This goes ahead and installs the configuration in `jobdef.sh` onto the host server. Whatever that is defined in `jobdef.sh` will be installed on the host
    3. `./almighty.sh push`: Hope you got that Naruto reference(If that's your thing lol). This calls `control.sh`. The script there will establish an scp connection to move our web documents in this use case to the root of the node servers. It then calls `jobdef.sh` to propogate the configuration to the node servers.
    4. `./almighty.sh install dependency`: This directly installs the dependency specified
    5. `./almighty.sh remove dependency`: This directly removes the dependency specifed
    6. `./almighty.sh upgrade dependency`: This directly upgrades the dependency specified
    7. `./almighty.sh view /path/to/file`: This allows the user to view the metadata of the specified file in the path
    8. `./almighty.sh remote-view X.XX.XXX.XXX /path/to/file`: This allows the user to view the metadata of a file on a specific node by passing in the node ip as `X.XX.XXX.XXX`
    Note that all actions involving propogating changes to node will pass through the `control.sh` script

##                                                                           !!!! ENJOY AND HAVE FUN !!!!
