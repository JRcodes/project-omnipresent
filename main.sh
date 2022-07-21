#! /bin/bash

JOB='jobdef.sh'
WEB_DOCS='web_docs'
chmod +x $JOB

echo "# # # # Reading from node server list in $NODE_LIST..."

echo "# # # # Copying local web file(s) to servers"
sshpass -f$PASSFILE scp -r $WEB_DOCS $USER@$line:
echo "# # # # logging into $line..."
sshpass -f$PASSFILE ssh $USER@$line 'bash -s' < $JOB

echo "Main server has have been configured!"