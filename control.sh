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
        echo "# # # # Adding server to known_hosts"
        ssh-keyscan -H $line >> ~/.ssh/known_hosts # Abstract to initial bootstrap
        echo "# # # # Copying local web file(s) to server: $line"
        sshpass -f$PASSFILE scp -r $WEB_DOCS $USER@$line:
        echo "# # # # logging into $line..."
        sshpass -f$PASSFILE ssh $USER@$line 'bash -s' < $JOB
done < $NODE_LIST

echo "All node server(s) have been configured!"