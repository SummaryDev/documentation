# How it works 

## Approach: write once 

We aim to solve the problem most DApp developers face: the data their
smart contracts produce is buried in transaction inputs and events
scattered in blocks. These data need to be gathered, parsed and
interpreted for analysis (think an up-to-date TVL) and, finally,
presented to the end users.

This problem is often solved by an **indexer**, a service that listens
to blockchain events, decodes and persists the emitted data. The code to
interpret events is usually written by the DApp developers themselves
and run by third parties, sometimes in a decentralized manner.

While this multi-step approach gets the job done, it requires
development effort better spent on the DApp itself, and creates friction
between the many parts of the process.

Our approach is a centralised service offering already **decoded and
normalized data** ready for consumption and interpretation. We run one
process to gather data from blockchains, decode it and persist in a
relational database; there is no other secondary indexing or parsing.
Once in the database, the data are already indexed and available for
querying with SQL and GraphQL. Developers can use the up-to-date data 
right away without the need to write extra code, run multiple processes
or involve third party indexers.
