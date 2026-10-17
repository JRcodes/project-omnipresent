#! /bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Nodes are reached over SSH with key-based auth as a sudo-capable (non-root) user.
# Override any of these with environment variables.
USER="${OMNI_USER:-deploy}"
SSH_KEY="${OMNI_SSH_KEY:-}"
NODE_LIST="${OMNI_NODELIST:-$SCRIPT_DIR/nodelist}"
WEB_DOCS="$SCRIPT_DIR/web_docs"
CONFIG=$1

# BatchMode makes ssh fail fast instead of hanging on a password prompt
SSH_OPTS=(-o BatchMode=yes)
if [ -n "$SSH_KEY" ]; then
        SSH_OPTS+=(-i "$SSH_KEY")
fi

# Runs a command on a node. -n stops ssh from reading stdin, which would otherwise
# swallow the rest of the node list inside the while-read loops below
remote() {
        local node=$1
        shift
        ssh -n "${SSH_OPTS[@]}" "$USER@$node" "$@"
}

# Quotes an argument so it reaches the remote shell as a single literal word
q() {
        printf '%q' "$1"
}

echo "           ~~~~~~~~~~~~~~~~~~~~ Establishing Connection with Nodes ~~~~~~~~~~~~~~~~~~~~             "
echo "          "
if [[ $1 = "remote-install" ]]; then
        while read -r line; do
                if [ -n "$line" ]; then
                        echo "                                ***logging into $line***                                 "
                        echo "          "
                        remote "$line" "sudo DEBIAN_FRONTEND=noninteractive apt-get install -y $(q "$2")" || exit
                        echo "                                   ***Testing Server: $line***                                     "
                        curl -sv "http://$line"
                fi
        done < "$NODE_LIST"
elif [[ $1 = "remote-remove" ]]; then
        while read -r line; do
                if [ -n "$line" ]; then
                        echo "                                ***logging into $line***                                 "
                        echo "          "
                        remote "$line" "sudo apt-get remove -y $(q "$2")" || exit
                        echo "                                   ***Testing Server: $line***                                     "
                        curl -sv "http://$line"
                fi
        done < "$NODE_LIST"
elif [[ $1 = "remote-upgrade" ]]; then
        while read -r line; do
                if [ -n "$line" ]; then
                        echo "                                ***logging into $line***                                 "
                        echo "          "
                        remote "$line" "sudo DEBIAN_FRONTEND=noninteractive apt-get install --only-upgrade -y $(q "$2")" || exit
                        echo "                                   ***Testing Server: $line***                                     "
                        curl -sv "http://$line"
                fi
        done < "$NODE_LIST"
elif [[ $1 = "remote-view" ]]; then
        echo "                                ***logging into $2***                                 "
        echo "          "
        remote "$2" "sudo stat $(q "$3")" || exit
else
        while read -r line; do
                if [ -n "$line" ]; then # This will handle accidental empty lines; which I encountered during testing

                        # Nodes are configured one at a time. Running them in parallel would speed up
                        #  large node lists; see Future improvements in the README.

                        echo "                         ***Copying local web file(s) to server: $line***                          "
                        echo "          "
                        scp -r "${SSH_OPTS[@]}" "$WEB_DOCS" "$USER@$line:" < /dev/null || exit
                        echo "                                     ***logging into $line***                                      "
                        echo "          "
                        ssh "${SSH_OPTS[@]}" "$USER@$line" 'bash -s' < "$CONFIG" || exit
                        echo "                                   ***Testing Server: $line***                                     "
                        curl -sv "http://$line"
                fi
        done < "$NODE_LIST"
fi

echo "       ~~~~~~~~~~~~~~~~~~~~ All node server(s) have been configured! ~~~~~~~~~~~~~~~~~~~~           "
