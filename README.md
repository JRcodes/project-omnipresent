## PROJECT OMNIPRESENT: A PUSH BASED CONFIGURATION MANAGEMENT TOOL
### The architecture:
- This tool uses a host-node relationship where changes made on the host can be propogated to node servers configured within the tool.
- There is an entry point script `almighty.sh` to be run on the host server which pulls in other peripheral scripts to achieve installation, updates and removal of configurations on the node servers provided in a document `nodelist`.
- When the host server is configured, changes are not immediately send to the node server. These changes have to be manually triggered in order to appear on the nodes. This allows extensive testing on host before those changes are moved on the the node servers through a push method.

### Improvements:
The following improvements can be considered for this tooling:
- Implementation of the entry point can be abstracting to act as an agent instead on the node side in order to facilitate a pull method of updating servers. A cron job can be set to periodically check for updates on the host server and pull in changes as need. This was the initial approach but was scratched due to time constraints
- Addition functionality can be added to compare file drift before any updates are made to the server
- Right now, the tool uses a synchronous approach to update the given node servers. It is agreeable that such an approach becomes tedious and time consuming when the list grows in number. A parallel, asynchronous approach can be used to prevent that
- In terms of security, a handshake protocal can be applied between host and node servers; as well as the installation protocol which uses scp now that the tool hasn't been packaged(ssh is used but one cannot be more secure, lol or maybe overkill)

### Features:
- Configuration
- Updates
- Standalone commands

