This is a setup of the graph for token bounds ERC6551 registry contract. With this you can track accounts made across the tokenbound implementation on any chain that the graph and tokenbound supports.

## Setup
1.) make a hosted service subgraph on [thegraph](https://thegraph.com/hosted-service), once you make a graph the name will be *your-username*/*subgraph-name*.

2a.) (optional if on mac/linux) make a copy of deployScript.sh and put in usr/local/bin. then do nano ~/.zshrc, followed by putting at the bottom of the zshrc file alias deploy="usr/local/bin/deploy.sh".

After doing this, if you do source ~/.zshrc in your terminal, deploy *subgraph-name*  *chain* should make a graph for you automatically. [here](https://thegraph.com/docs/en/developing/supported-networks/) is where you can get the list of chains available (look under CLI name)

2b.) (if you did 2a ignore) make a file subgraph-*chain*.yml, copy the following into the file, replace *chain* with what chain you want to deploy on.
```
specVersion: 0.0.5
schema:
  file: ./schema.graphql
dataSources:
  - kind: ethereum
    name: Registry
    network: *chain*
    source:
      abi: Registry
      address: "0x02101dfB77FDE026414827Fdc604ddAF224F0921"
      startBlock: 105590673
    mapping:
      kind: ethereum/events
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
```
after doing this, graph deploy --product hosted-service *subgraph-name* --network *chain* subgraph-*chain*.yml should deploy the subgraph.
