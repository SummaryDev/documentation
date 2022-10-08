# API

While the manual [web console](../../console) is useful to explore
blockchain data with GraphQL queries, how do you build analytics tools
and back end which would consume their results?

You can automate with API calls with the same GraphQL queries as you
tried in the console.

The development process may start with you designing queries in the
GraphQL console, combining and refining them. Once you figured out how
to collect all the data you need, you can incorporate these query calls
into your DApp frontend.

## Synchronous with http

Try this http call with queries for both the decoded and the raw block
100000\. We use `curl` for demo to send this http POST, but any other
http client either in the browser or on the back can do the same.

```bash
curl https://hasura.prod.summary.dev/v1/graphql --data-raw '{"query":"{starknet_goerli_block(where: {block_number: {_eq: 100000}}) { transactions { function entry_point_selector inputs { name type value } events { name transmitter_contract arguments { name type value decimal } } } } starknet_goerli_raw_block_by_pk(block_number: 100000) { raw }}"}'
```

## Asynchronous with WebSocket

To get notified of changes to your query results use GraphQL
[subscriptions](subscriptions.md) feature. It lets you connect via a
WebSocket, pass your query as a *subscription* and your client will get
called back once the results change. Use your favorite WebSocket or
GraphQL client or our sample
[subscriber](https://github.com/SummaryDev/subscriber) as a starting
point to build **web hooks** that react to changes in blockchain data.

This example invocation of our `subscriber` reacts to the latest three
events emitted.
 
```bash
npm start 'subscription {starknet_goerli_event(limit: 3, order_by: {id: desc}) {id, name}}'
```

The subscription query can be of any complexity required to get the data
you're interested in, and deliver changes in an arbitrary collection of
entities.
