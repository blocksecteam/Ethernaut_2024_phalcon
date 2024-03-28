#!/bin/bash

## Author: uwin
## Date: 2024-03-25
## Usage: ./solve.sh -u <rpc_url> <challenge>

usage() {
    echo -e "Usage: $0 -f <rpc_url> <challenge>\n" >&2
    echo -e "    -h                     Show this help"
    echo -e "    -f <rpc_url>           Your Phalcon Fork RPC\n" >&2
    echo -e "See https://phalcon.blocksec.com/fork for detailed infos." >&2
}

WORK_DIR=`pwd`
RPC_URL=
CHALL_NAME=

while getopts ":f:h" opt; do
    case "$opt" in
        f )
            RPC_URL=$OPTARG
            ;;
        h )
            usage
            exit 0
            ;;
        \? )
            echo "Invalid option: -$OPTARG" >&2
            usage
            exit 1
            ;;
        : )
            echo "Missing option argument for -$OPTARG" >&2
            usage
            exit 1
            ;;
    esac
done
shift $((OPTIND -1))

if [ $# -lt 1 ]; then
    usage
    exit 1
fi

challenges=(alienspaceship beef dutch dutch-2 spacebank wombocombo xyz)
if [[ "${challenges[*]}" =~ $1 ]]; then
    CHALL_NAME=$1
else
    echo "No such challenge named $1" >&2
    exit 1
fi

# Foundry provided signer 0x70997970c51812dc3a010c7d01b50e0d17dc79c8
SIGNER_PRIV_KEY="0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d"

echo "🎮 Solving challenge $CHALL_NAME using foundry..."
PROJ_DIR="$WORK_DIR/$CHALL_NAME/challenge/project"
DEPLOY_FILE=${DEPLOY_FILE:-"$PROJ_DIR/deploy.txt"}
if [ ! -f $DEPLOY_FILE ]; then
    echo "Deployment file with challenge address not found" >&2
    exit 1
fi

# Set player private key if given
export PLAYER=${PRIV_KEY}
export CHALLENGE=$(cat $DEPLOY_FILE | tr -d '\n')
forge script $PROJ_DIR/script/Solve.s.sol:Solve --root "$PROJ_DIR" --rpc-url "$RPC_URL" \
    --broadcast --private-key $SIGNER_PRIV_KEY -vvvv --slow
unset CHALLENGE
unset PLAYER

echo "✅ Finished"
exit 0