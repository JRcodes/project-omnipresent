#! /bin/bash
USER=root
PASSFILE='.credfile'
NODE_LIST='nodelist' 
CONFIG=$1
WEB_DOCS='web_docs'

echo "           ~~~~~~~~~~~~~~~~~~~~ Establishing Connection with Nodes ~~~~~~~~~~~~~~~~~~~~             "
echo "          "
echo "                         ***Reading from node server list in $NODE_LIST***                          "
echo "          "
while read -r line;
do
        if [ ! -z "$line" ]; then # This will handle accidental empty lines; which I encountered during testing

                # It may be asked if any sort of asyncronous application of the following 
                #  executions can be used in the case where we have to configure a large server list.  
                #  The answer is YES. That approach was considered and required the usage of third party tools 
                #  that were outside the scope of this assignment. 
                #  This obviously will raise concern for performance issues but for the scope of this exercise, it will be overlooked.
                        
                # Obviously, we will change this code to accomodate where we have our webdocs in a more practical env
                echo "                         ***Copying local web file(s) to server: $line***                          "
                echo "          "
                sshpass -f$PASSFILE scp -r $WEB_DOCS $USER@$line: || exit
                echo "                                     ***logging into $line***                                      "
                echo "          "
                sshpass -f$PASSFILE ssh $USER@$line 'bash -s' < $CONFIG || exit
                echo "                                   ***Testing Server: $line***                                     "
                curl -sv "http://$line" || exit
        fi
done < $NODE_LIST

echo "       ~~~~~~~~~~~~~~~~~~~~ All node server(s) have been configured! ~~~~~~~~~~~~~~~~~~~~           "