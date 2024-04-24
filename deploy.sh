#!/bin/bash

## Author: uwin
## Date: 2024-03-25
## Usage: ./deploy.sh -k <access_key> [-p <project_id>] [challenge]

usage() {
    echo -e "Usage: $0 -k <access_key> [-p <project_id>] [challenge]\n" >&2
    echo -e "    -h                     Show this help" >&2
    echo -e "    -k <access_key>        Your Phalcon Access Key" >&2
    echo -e "    -p <project_id>        Your Phalcon Project ID\n" >&2
    echo "See https://phalcon.blocksec.com/account and https://phalcon.blocksec.com/settings for detailed infos." >&2
}

WORK_DIR=`pwd`
ACCESS_KEY=
PROJECT_ID=
CHALL_NAME=

while getopts ":k:p:h" opt; do
    case "$opt" in
        k )
            ACCESS_KEY=$OPTARG
            ;;
        p )
            PROJECT_ID=$OPTARG
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

# If challenge is specified, check it
challenges=(alienspaceship beef dutch dutch-2 spacebank wombocombo xyz)
if [ $# -ge 1 ]; then
    if [[ "${challenges[*]}" =~ $1 ]]; then
        CHALL_NAME=$1
    else
        echo "No such challenge named $1" >&2
        exit 1
    fi
fi

# If no Project ID is specified, then create new
if [ -z $PROJECT_ID ]; then
    echo "⏳ Creating new phalcon project..."
    result=`curl --location 'https://api.phalcon.blocksec.com/v1/project' \
    --header "Access-Key: $ACCESS_KEY" \
    --header 'Content-Type: application/json' \
    --data '{
        "name":"Ethernaut CTF 2024"
    }'`

    code=`echo $result | python3 -c "import sys, json; print(json.load(sys.stdin)['code'])"`
    if [[ $code -ne 0 ]]; then
        echo -n "Error messgae: " >&2
        echo $result | python3 -c "import sys, json; print(json.load(sys.stdin)['message'], file=sys.stderr)"
        exit 1
    fi

    PROJECT_ID=`echo $result | python3 -c "import sys, json; print(json.load(sys.stdin)['data']['projectId'])"`
    echo "✅ Successfully created new project $PROJECT_ID"
else
    echo "🦅 Using phalcon project $PROJECT_ID"
fi

# Foundry provided signer 0x70997970c51812dc3a010c7d01b50e0d17dc79c8
SIGNER_PRIV_KEY="0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d"

launch() {
    chall=$1
    result=`curl --location "https://api.phalcon.blocksec.com/v1/project/$PROJECT_ID/fork" \
        --header "Access-Key: $ACCESS_KEY" \
        --header 'Content-Type: application/json' \
        --data '{
            "chainId": 1,
            "height": "0x1286d1a",
            "name": "'$chall'",
            "position": 0,
            "antiReplay": false
        }'`
    
    code=`echo $result | python3 -c "import sys, json; print(json.load(sys.stdin)['code'])"`
    if [[ $code -ne 0 ]]; then
        echo -n "Error messgae: " >&2
        echo $result | python3 -c "import sys, json; print(json.load(sys.stdin)['message'], file=sys.stderr)"
        return 1
    fi
    
    echo "🔨 Deploying challenge $chall using foundry..."
    PROJ_DIR="$WORK_DIR/$CHALL_NAME/challenge/project"
    export OUTPUT_FILE=${OUTPUT_FILE:-"$PROJ_DIR/deploy.txt"}
    RPC_ID=`echo $result | python3 -c "import sys, json; print(json.load(sys.stdin)['data']['rpc'].split('/')[-1])"`
    cd $PROJ_DIR
    forge script script/Deploy.s.sol:Deploy --rpc-url "https://rpc.phalcon.blocksec.com/$RPC_ID" \
        --etherscan-api-key $ACCESS_KEY --verifier-url "https://api.phalcon.xyz/api/$RPC_ID" \
        --broadcast --verify --private-key $SIGNER_PRIV_KEY -vvvv --slow
    cd $WORK_DIR
    unset OUTPUT_FILE
}

if [ -z $CHALL_NAME ]; then
    for chall in "${challenges[@]}"; do
        launch $chall
    done
else
    launch $CHALL_NAME
fi

echo "✅ All done"
exit 0