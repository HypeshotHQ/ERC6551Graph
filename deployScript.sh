#!/bin/bash

# Check if at least subgraph and network arguments are provided
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: ./deploy.sh <subgraph-name> <network> [optional-contract-address]"
    exit 1
fi

SUBGRAPH_NAME="$1"
NETWORK="$2"
ADDRESS=${3:-"0x02101dfB77FDE026414827Fdc604ddAF224F0921"}  # Default address if not provided
ABI="Registry"
START_BLOCK="0"
KIND="ethereum"



echo "NETWORK is: $NETWORK"
echo "KIND is: $KIND"

# Generate the subgraph manifest file
cat > subgraph-$NETWORK.yml <<EOL
specVersion: 0.0.5
schema:
  file: ./schema.graphql
dataSources:
  - kind: $KIND
    name: Registry
    network: $NETWORK
    source:
      address: "$ADDRESS"
      abi: $ABI
      startBlock: $START_BLOCK
    mapping:
      kind: $KIND/events
      apiVersion: 0.0.7
      language: wasm/assemblyscript
      entities:
        - AccountCreated
      abis:
        - name: Registry
          file: ./abis/Registry.json
      eventHandlers:
        - event: AccountCreated(address,address,uint256,address,uint256,uint256)
          handler: handleAccountCreated
      file: ./src/registry.ts
EOL

# Deploy the subgraph to the hosted service
graph deploy --product hosted-service $SUBGRAPH_NAME --network $NETWORK subgraph-$NETWORK.yml
