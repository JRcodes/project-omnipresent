#! /bin/bash
DEPENDENCIES='dependencies.sh'
NODE_LIST='nodelist' 

# Bootstrap Phase
if [[ $1 = "init" ]]; then
    echo "|--------------------------------------------------------------------------------------------------------|"
    echo "|  B   O   O   T    S   T   R   A   P   P   I   N   G       H   O   S   T       S   E   R   V   E   R    |"
    echo "|________________________________________________________________________________________________________|"
    echo "                ~~~~~~~~~~~~~~~~~~~~ LET THERE BE EXECUTABLES! ~~~~~~~~~~~~~~~~~~~~                       "
    echo "          "
    chmod +x *.sh
    echo "                  ~~~~~~~~~~~~~~~~~~~~ DONE NOW LET'S CREATE! ~~~~~~~~~~~~~~~~~~~~                        "
    echo "          "

    echo "                ~~~~~~~~~~~~~~~~~~~~ BOOTSTRAPPING DEPENDENCIES! ~~~~~~~~~~~~~~~~~~~~                     "
    echo "          "
    ./$DEPENDENCIES
    echo "             ~~~~~~~~~~~~~~~~~~~~ YOUR PACKAGES HAVE BEEN DELIVERED! ~~~~~~~~~~~~~~~~~~~~                 "
    echo "          "

    echo "                ~~~~~~~~~~~~~~~~~~~~ ADDING NODES TO KNOWN HOSTS! ~~~~~~~~~~~~~~~~~~~~                    "
    echo "          "
    
    while read -r line;
    do
            if [ ! -z "$line" ]; then
                echo $line
                ssh-keyscan -H $line >> ~/.ssh/known_hosts -v
            fi
    done < $NODE_LIST
    echo "                -----------------------------------------------------------------------                   "
    echo "          "
    echo " BOOTSTRAPPING IS DONE! MAKE SURE THE FOLLOWING FILES ARE CONFIGURED"
    echo " 1. jobdef.sh: This will contain the initial configuration executions to be run on host and propogated on node servers"
    echo " 2. updates.sh: This will contain any update executions to be run on host and propogated on nodes."
    echo "                This can include installs, updates, and deletes"
    echo " 3. web_docs: This is where all documents for the web server will reside. Please place your source code for your website here"
fi

# Configuring host using our Job definitions config script




