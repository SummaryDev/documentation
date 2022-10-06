## Quick start 

A [GraphQL console](http://starknetindex.com/console) is open to
developers to query blockchain data for events, transactions and their
inputs, as well as to filter, aggregate and sum up values. 

![Screenshot-graphiql](https://github.com/olegabu/starknet-archive-docs/blob/main/Screenshot-graphiql.png?raw=true "GraphQL console")

Use the Explorer pane on the left to put together a GraphQL query by
selecting fields and filter parameters, or write queries directly into
the middle pane. Read the results in json in the left pane.

You can combine queries to return all the data you're looking for in one
shot. This example query requests three `Mint` events and all `DEPLOY`
transactions together with their inputs in block 100000.
```graphql
query mint_and_deploy_100000 {
  event(where: {name: {_eq: "Mint"}, transmitter_contract: {_eq: "0x4b05cce270364e2e4bf65bde3e9429b50c97ea3443b133442f838045f41e733"}}, limit: 3) {
    name
    arguments {
      name
      type
      value
      decimal
    }
    transaction_hash
  }
  block(where: {block_number: {_eq: 100000}}) {
    transactions(where: {type: {_eq: "DEPLOY"}}) {
      function
      entry_point_selector
      inputs {
        name
        type
        value
      }
    }
  }
}
```

You can get results directly from our http endpoint. Send the query above
with `curl`:
```bash
curl https://starknet-archive.hasura.app/v1/graphql --data-raw '{"query":"query mint_and_deploy_100000 { event(where: {name: {_eq: \"Mint\"}, transmitter_contract: {_eq: \"0x4b05cce270364e2e4bf65bde3e9429b50c97ea3443b133442f838045f41e733\"}}, limit: 3) { name arguments { name type value decimal } transaction_hash } block(where: {block_number: {_eq: 100000}}) { transactions(where: {type: {_eq: \"DEPLOY\"}}) { function entry_point_selector inputs { name type value } } }}"}'
```  