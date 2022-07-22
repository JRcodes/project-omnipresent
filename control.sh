#! /bin/bash
USER=root
PASSFILE='.credfile'
NODE_LIST='nodelist' 
JOB='jobdef.sh'
WEB_DOCS='web_docs'
chmod +x $JOB

echo "# # # # Reading from node server list in $NODE_LIST..."
while read -r line;
do
        if [ ! -z "$line" ]; then # This will handle accidental empty lines; which I encountered during testing

                # It may be asked if any sort of asyncronous application of the following 
                #  executions can be used in the case where we have to configure a large server list.  
                #  The answer is YES. That approach was considered and required the usage of third party tools 
                #  that were outside the scope of this assignment. 
                #  This obviously will raise concern for performance issues but for the scope of this exercise, it will be overlooked.
                       
                echo "# # # # Adding server to known_hosts"
                ssh-keyscan -H $line >> ~/.ssh/known_hosts # Abstract to initial bootstrap
                echo "# # # # Copying local web file(s) to server: $line" # Obviously, we will change this code to accomodate where we have our webdocs in a more practical env
                sshpass -f$PASSFILE scp -r $WEB_DOCS $USER@$line:
                echo "# # # # logging into $line..."
                sshpass -f$PASSFILE ssh $USER@$line 'bash -s' < $JOB
        fi
done < $NODE_LIST

echo "All node server(s) have been configured!"