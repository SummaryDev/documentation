# Query blockchain data with SQL

## Complex queries from database views

What if filters and aggregation queries still don't give you the desired
data? Then you can use the full power and flexibility of **SQL**: create
custom database views and functions and query them with GraphQL.

Let's say you want to calculate daily `Mint` volumes of your contract,
which requires summing over your events each day. The date can be
derived from `timestamp` column in the block containing the event. This
is not an easy thing to do by a GraphQL query yet trivial in a SQL
query. You can create a database **view** with the SQL `select`
statement returning the results desired. This view automatically becomes
available as a GraphQL query. Just like you can query database tables
`block`, `event` etc. with GraphQL, you can query the database views you
created.

This query calls a custom database view `daily_mint`.
```graphql
{
  daily_mint(limit: 3) {
    dt
    mint_amount0
  }
}
```

Returns sums of `amount0` arguments of `Mint` events per day:
```json
{
  "data": {
    "daily_mint": [
      {
        "dt": "2022-06-08",
        "mint_amount0": "1079024791522862986420035"
      },
      {
        "dt": "2022-06-07",
        "mint_amount0": "1406494987101656904988874"
      },
      {
        "dt": "2022-06-06",
        "mint_amount0": "1994302239023862329983776"
      }
    ]
  }
}
```

GraphQL query `daily_mint` was created from a database view with the
same name that sums over `Mint` event arguments grouped by day.
```sql
create view daily_mint(amount0, dt) as
select sum(a.decimal) as sum, (to_timestamp((b."timestamp")))::date AS dt
from argument a left join event e on a.event_id = e.id left join transaction t on e.transaction_hash = t.transaction_hash left join block b on t.block_number = b.block_number
where e.transmitter_contract = '0x4b05cce270364e2e4bf65bde3e9429b50c97ea3443b133442f838045f41e733' and e.name = 'Mint' and a.name = 'amount0'
group by dt order by dt desc;
```

Here's another example query that calculates total transactions per day.
```graphql
{
  daily_transactions(limit: 3) {
    count
    date
  }
}
```

We limited its output to the three last days:
```json
{
  "data": {
    "daily_transactions": [
      {
        "count": "13370",
        "date": "2022-06-08"
      },
      {
        "count": "22068",
        "date": "2022-06-07"
      },
      {
        "count": "47647",
        "date": "2022-06-06"
      }
    ]
  }
}
```

GraphQL query `daily_transactions` selects data from this database view:
```sql
create view daily_transactions (count, date) as
select count(t.transaction_hash), to_timestamp(b.timestamp)::date as dt from transaction as t
left join block b on t.block_number = b.block_number
group by dt order by dt desc;
```

These queries are available like all the others via http calls. Request
all daily transaction counts to date:
```bash
curl https://starknet-archive.hasura.app/v1/graphql --data-raw '{"query":"query {daily_transactions {count date}}"}'
```

Such statistical queries are useful for constructing charts and
dashboards. More on this later.

Try this GraphQL query selecting from `top_functions` database view.
```graphql
{
  top_functions(limit: 4) {
    count
    name
  }
}
```

Returns four functions called the most.
```json
{
  "data": {
    "top_functions": [
      {
        "count": "2388068",
        "name": "__execute__"
      },
      {
        "count": "1414978",
        "name": "execute"
      },
      {
        "count": "536120",
        "name": "constructor"
      },
      {
        "count": "322249",
        "name": "initialize"
      }
    ]
  }
}
```

The view was created with this SQL select statement:
```sql
create view top_functions (function, ct) as
select t.function, count(t.function) ct from transaction t group by t.function order by ct desc;
```

The above examples show that you can use SQL queries which
can be rather complex, to aggregate and calculate over any data you're
interested in.

In most cases no separate indexer process is needed to interpret your
data. If however you want to do something that SQL, even with custom
views and functions cannot, you can query for specific data with GraphQL
and consume the results by a your own software and deal with it.