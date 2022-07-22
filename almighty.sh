#! /bin/bash
DEPENDENCIES='dependencies.sh'
NODE_LIST='nodelist' 
CONFIG='jobdef.sh'
CONTROLLER='control.sh'
UPDATE_CONFIG='updates.sh'

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
    ./$DEPENDENCIES || exit
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
    done < $NODE_LIST || exit
    echo "                -----------------------------------------------------------------------                   "
    echo "          "
    echo " BOOTSTRAPPING IS DONE! MAKE SURE THE FOLLOWING FILES ARE CONFIGURED"
    echo " 1. jobdef.sh: This will contain the initial configuration executions to be run on host and propogated on node servers"
    echo " 2. updates.sh: This will contain any update executions to be run on host and propogated on nodes."
    echo "                This can include installs, updates, and deletes"
    echo " 3. web_docs: This is where all documents for the web server will reside. Please place your source code for your website here"
fi

# Configuring host using our Job definitions config script
if [[ $1 = "set" ]]; then
    if [ -f $CONFIG ]; then
        echo "|----------------------------------------------------------------------------------------------|"
        echo "|  C  O   N   F   I   G   U   R   I   N   G       H   O   S   T       S   E   R   V   E   R    |"
        echo "|______________________________________________________________________________________________|"
        
        ./$CONFIG || exit
    else
        echo "ERROR!!! Job configuration file, [jobdef.sh] is missing."
        echo "Create one, run <./almight.sh init> to add to config bundle, then run <./almight.sh set> to configure host server"
        exit
    fi
    echo "           ~~~~~~~~~~~~~~~~~~~~ HOST CONFIGURATION COMPLETE! ~~~~~~~~~~~~~~~~~~~~               "
    echo "          "
    echo " You can run <./almight.sh push> to propogate the configurations to node servers now; or later when you're comfortable after testing"
fi

# Configuring node servers using our config script
if [[ $1 = "push" ]]; then
    if [ -f $CONTROLLER ]; then
        echo "|--------------------------------------------------------------------------------------------------|"
        echo "|  C  O   N   F   I   G   U   R   I   N   G       N   O   D   E       S   E   R   V   E   R   S    |"
        echo "|__________________________________________________________________________________________________|"
        
        ./$CONTROLLER $CONFIG || exit
    else
        echo "ERROR!!! Job configuration file, [jobdef.sh] is missing."
        echo "Create one, run <./almight.sh init> to add to config bundle, then run <./almight.sh set> to configure host server"
        exit
    fi
    echo "            ~~~~~~~~~~~~~~~~~~~~ NODE CONFIGURATION COMPLETE! ~~~~~~~~~~~~~~~~~~~~                 "
    echo "          "
fi

# Update host configuration
if [[ $1 = "update" ]]; then
    if [ -f $UPDATE_CONFIG ]; then
        echo "|----------------------------------------------------------------------------------|"
        echo "|  U  P   D   A   T   I   N   G       H   O   S   T       S   E   R   V   E   R    |"
        echo "|__________________________________________________________________________________|"
        
        ./$UPDATE_CONFIG || exit
    else
        echo "ERROR!!! Job configuration file, [updates.sh] is missing."
        echo "Create one, run <./almight.sh init> to add to config bundle,"
        echo "then run <./almight.sh set> to configure host server"
        exit
    fi
        echo "      ~~~~~~~~~~~~~~~~~~~~ HOST CONFIGURATION UPDATED! ~~~~~~~~~~~~~~~~~~~~         "
        echo "          "
        echo " You can run <./almight.sh apply-updates> to propogate the configurations to node servers now;"
        echo "or later when you're comfortable after testing"
fi

# Update host configuration
if [[ $1 = "apply-update" ]]; then
    if [ -f $UPDATE_CONFIG ]; then
        echo "|--------------------------------------------------------------------------------------|"
        echo "|  U  P   D   A   T   I   N   G        N  O   D   E       S   E   R   V   E   R   S    |"
        echo "|______________________________________________________________________________________|"
        
        ./$CONTROLLER $UPDATE_CONFIG || exit
    else
        echo "ERROR!!! Update configuration file, [updates.sh] is missing."
        echo "Create one, run <./almight.sh init> to add to config bundle,"
        echo "then run <./almight.sh set> to configure host server"
        exit
    fi
        echo "      ~~~~~~~~~~~~~~~~~~~~ HOST CONFIGURATION UPDATED! ~~~~~~~~~~~~~~~~~~~~         "
        echo "          "
        echo " You can run <./almight.sh apply-updates> to propogate the configurations to node servers now;"
        echo "or later when you're comfortable after testing"
fi