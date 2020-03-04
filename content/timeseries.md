---
weight: 50
title: Time-Series | TzStats Data API
---

# Time-Series Endpoints {#time-series-endpoints}

>  **Generic Time-Series Query**

```
https://api.tzstats.com/series/{table_code}.{format}?{args}
```

The time-series API is an abstraction over tables which allows for server-side aggregation of multiple result rows over time. Time-series are meant to be displayed as graphs with time on the x-axis and some aggregate value on the y-axis. Since the underlying data is still in tabular form all table filters work on time-series as well.

Note that this time-series API does not fill gaps. That means when the underlying table contains no data for a particular time interval, the corresponding time-series row will be missing. Clients should be prepared for this case and fill gaps if required.

Intervals between timestamps are equally spaced and can be controlled by the `collapse` query parameter, i.e. `1d` means each interval contains 24 hours of aggregated data. Time-series data can contain fields of all supported numeric data types (e.g. no strings or binary data). The aggregation function is fixed by the semantics of the data type. This may either be a sum, a count, first, last, min, max or mean value.


### List of supported time-series

Endpoint | Time-Series Content
---------|-----------------------
`GET /series/block`                     | aggregated block data
`GET /series/flow`                      | aggregated balances, freezer and delegation flows
`GET /series/op`                        | aggregated operations data
`GET /series/chain`                     | running total counters for on-chain operations, accounts and rolls
`GET /series/supply`                    | running supply totals
`GET /series/{exchange}/{market}/ohlcv` | OHLCV candles

## Query Arguments

Time-series datasets support the following query parameters.

Argument | Description
----------|-----------------
`columns` *optional*   | Comma separated list of columns you like to fetch. Bulk array results will be ordered accordingly. Default is all defined columns for a series.
`collapse` *optional*  | Aggregate numeric data over different sampling intervals. Supported values are `1m` (default), `5m`, `15m`, `30m`, `1h`, `2h`, `3h`, `4h`, `6h`, `12h`, `1d`, `1w`, `1M`, `3M`and `1y`.
`order` *optional*    | Return data in `asc` (ascending) or `desc` (descending) order. Default is `asc`.
`limit` *optional*    | Maximum number of aggregated results returned. Limited to 50,000, default 500.
`start_date` *optional* | Start of the time range to query. See [timestamps](#json-data-types) for syntax.
`end_date` *optional* | End of the time range to query. See [timestamps](#json-data-types) for syntax.

When only start or end date are provided, the other end of the range is deducted from collapse and limit. I.e. with collapse of `1d` and limit of `30` you'll get 30 days of data after start_date or before end_date. Called without any optional parameters a query defaults to the most recent 500 minutes (`end_date=now`, `limit=500` and `collapse=1m`).


## Query Filters

Time-series support the same filters [used on tables](#query-filters) with the same filter expressions of form `<column>.<operator>=<arg>`. Filters can be used on all table fields, including fields that are not part of the aggregated result such as addresses and type enums.


## Block Series

> **Example request.**

```shell
curl "https://api.tzstats.com/series/block.json?start_date=today&collapse=1d"
```

> **Example response.**

```json
[
  [
    1570060800000,      // time
    25002,              // n_ops
    6,                  // n_ops_failed
    2,                  // n_ops_contract
    674,                // n_tx
    2,                  // n_activation
    0,                  // n_seed_nonce_revelation
    0,                  // n_double_baking_evidence
    0,                  // n_double_endorsement_evidence
    24188,              // n_endorsement
    19,                 // n_delegation
    95,                 // n_reveal
    18,                 // n_origination
    0,                  // n_proposal
    6,                  // n_ballot
    1489819.569887,     // volume
    2.223532,           // fee
    79822.000000,       // reward
    2565504.000000,     // deposit
    0.000000,           // unfrozen_fees
    0.000000,           // unfrozen_rewards
    0.000000,           // unfrozen_deposits
    8522.749680,        // activated_supply
    42.148000,          // burned_supply
    152,                // n_new_accounts
    134,                // n_new_implicit
    18,                 // n_new_managed
    0,                  // n_new_contracts
    46,                 // n_cleared_accounts
    164,                // n_funded_accounts
    8167612,            // gas_used
    214,                // storage_size
    17867256.383035008  // days_destroyed
  ]
]
```

Lists aggregate data about blocks. Filters are the same as on the [block table](#block-table), but response fields are limited to numeric data that can be aggregated over time. Aggregation function for all fields is **sum**.

### HTTP Request

`GET https://api.tzstats.com/series/block?args`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`time` *datetime*              | Timestamp, start of interval.
`n_ops` *int*                  | Count of all operations.
`n_ops_failed` *int*           | Count of failed operations.
`n_ops_contract` *int*         | Count of smart-contract operations.
`n_tx` *int*                   | Count of `transaction` operations.
`n_activation` *int*           | Count of `activate_account` operations.
`n_seed_nonce_revelation` *int*   | Count of `seed_nonce_revelation` operations.
`n_double_baking_evidence` *int*  | Count of `double_baking_evidence` operations.
`n_double_endorsement_evidence` *int*   | Count of `double_endorsement_evidence` operations.
`n_endorsement` *int*          | Count of `endorsement` operations.
`n_delegation` *int*           | Count of `delegation` operations.
`n_reveal` *int*               | Count of `reveal` operations.
`n_origination` *int*          | Count of `origination` operations.
`n_proposal` *int*             | Count of `proposals` operations.
`n_ballot` *int*               | Count of `ballot` operations.
`volume` *int*                 | Count of amount of tokens moved between accounts.
`fee` *float*                  | Total fee paid (and frozen) by all operations.
`reward` *float*               | Reward earned (and frozen) by baker.
`deposit` *float*              | Deposit frozen by baker.
`unfrozen_fees` *float*        | Total unfrozen fees (at end of a cycle).
`unfrozen_rewards` *float*     | Total unfrozen rewards (at end of a cycle).
`unfrozen_deposits` *float*    | Total unfrozen deposits (at end of a cycle).
`activated_supply` *float*     | Total amount of commitments activated in tz.
`burned_supply` *float*        | Total amount of tokens burned by operations in tz.
`n_new_accounts` *int*         | Count of new accounts created regardless of type.
`n_new_implicit` *int*         | Count of created implicit accounts (tz1/2/3).
`n_new_managed` *int*          | Count of created managed accounts (KT1 without code or manager.tz script).
`n_new_contracts` *int*        | Count of created smart contracts (KT1 with code).
`n_cleared_accounts` *int*     | Count of accounts that were emptied (final balance = 0).
`n_funded_accounts` *int*      | Count of accounts that were funded by operations (this includes all new accounts plus previously cleared accounts that were funded again).
`gas_used` *int*               | Total gas consumed by operations.
`storage_size` *int*           | Total sum of new storage allocated by operations.
`days_destroyed` *float*       | Token days destroyed.



## Flow Series

> **Example request (network-wide re-delegation flows).**

```shell
curl "https://api.tzstats.com/series/flow?start_date=today&collapse=1d&category=delegation"
```

> **Example response.**

```json
[
  [
    1570060800000, // time
    200650.535155, // amount_in
    246036.709877  // amount_out
  ]
]
```

Lists aggregate data about flows. Filters are the same as on the [flow table](#flow-table), but response fields are limited to numeric data that can be aggregated over time. Aggregation function for all fields is **sum**.

An interesting feature of flow series is that you can reconstruct the entire balance and delegation history of an account. You can either start at account creation time assuming zero balances or start at the current account state and work your way backwards through flows.

### HTTP Request

`GET https://api.tzstats.com/series/flow?args`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`time` *datetime*    | Timestamp, start of interval.
`amount_in` *float*  | Incoming amount during interval in tz.
`amount_out` *float* | Outgoing amount during interval in tz.


## Operation Series

> **Example request.**

```shell
curl "https://api.tzstats.com/series/op?start_date=today&collapse=1d"
```

> **Example response.**

```json
[
  [
    1570060800000,      // time
    8187812,            // gas_used
    214,                // storage_size
    0,                  // storage_paid
    1493221.154887,     // volume
    2.228532,           // fee
    63790.000000,       // reward
    2052480.000000,     // deposit
    42.148000,          // burned
    17867317.80054702   // days_destroyed
  ]
]
```

Lists aggregate data about operations. Filters are the same as on the [operation table](#op-table), but response fields are limited to numeric data that can be aggregated over time. Aggregation function for all fields is **sum**.


### HTTP Request

`GET https://api.tzstats.com/series/op?args`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`time` *datetime*        | Timestamp, start of interval.
`gas_used` *int*         | Total gas used by all operations.
`storage_size` *int*     | Total storage size allocated by all operations.
`storage_paid` *int*     | Total storage paid by all operations.
`volume` *float*         | Total amount of tokens transferred by all operations in tz.
`fee` *float*            | Fees paid by all operation in tz.
`reward` *float*         | Rewards earned in by all operation tz.
`deposit` *float*        | Amount of deposited tokens by all operation in tz.
`burned` *float*         | Amount of burned tokens by all operation in tz.
`days_destroyed` *float* | Total token days destroyed by all operation.






## Chain Series

> **Example request.**

```shell
curl "https://api.tzstats.com/series/chain?start_date=today&collapse=1d"
```

> **Example response.**

```json
[
  [
    815464,        // height
    199,           // cycle
    1581160828000, // time
    425778,        // total_accounts
    398643,        // total_implicit
    26819,         // total_managed
    316,           // total_contracts
    20554157,      // total_ops
    104074,        // total_contract_ops
    22179,         // total_activations
    25277,         // total_seed_nonce_revelations
    17393631,      // total_endorsements
    131,           // total_double_baking_evidences
    24,            // total_double_endorsement_evidences
    54288,         // total_delegations
    272080,        // total_reveals
    29052,         // total_originations
    2755973,       // total_transactions
    494,           // total_proposals
    1036,          // total_ballots
    122042155,     // total_storage_bytes
    470269,        // total_paid_bytes
    0,             // total_used_bytes
    0,             // total_orphans
    387718,        // funded_accounts
    9346,          // unclaimed_accounts
    29352,         // total_delegators
    28005,         // active_delegators
    1347,          // inactive_delegators
    4031,          // total_delegates
    461,           // active_delegates
    3570,          // inactive_delegates
    8,             // zero_delegates
    138,           // self_delegates
    68,            // single_delegates
    255,           // multi_delegates
    81005,         // rolls
    433            // roll_owners
  ]
]
```

Lists running totals and counters at each block. Collapse selects data from the **first** block in a time window.

### HTTP Request

`GET https://api.tzstats.com/series/op?args`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`height` *int64*                             | block height
`cycle` *int64*                              | block cycle
`time` *int64*                               | block creation time
`total_accounts` *int64*                     | total number of accounts (all types, all states)
`total_implicit` *int64*                     | total number of implicit accounts (tz1/2/3)
`total_managed` *int64*                      | total number of managed delegation contracts (KT1, formerly without code)
`total_contracts` *int64*                    | total number of deployed smart contracts (KT1 with code)
`total_ops` *int64*                          | total number of on-chain operations (external and internal, but not implicit events)
`total_contract_ops` *int64*                 | total number of on-chain calls to KT1 contracts
`total_activations` *int64*                  | total number of on-chain fundraiser account activations
`total_seed_nonce_revelations` *int64*       | total number of on-chain seed nonce revelations
`total_endorsements` *int64*                 | total number of on-chain endorsement operations (not slots)
`total_double_baking_evidences` *int64*      | total number of on-chain double-baking denunciations
`total_double_endorsement_evidences` *int64* | total number of on-chain double-endorsing denunciations
`total_delegations` *int64*                  | total number of on-chain delegations (including delegation withdrawals)
`total_reveals` *int64*                      | total number of on-chain pubkey revelations
`total_originations` *int64*                 | total number of on-chain contract originations (contains pre-Babylon delegation contracts)
`total_transactions` *int64*                 | total number of on-chain transactions (contains internal transactions)
`total_proposals` *int64*                    | total number of on-chain voting proposals operations
`total_ballots` *int64*                      | total number of on-chain voting ballots
`total_storage_bytes` *int64*                | total number of allocated storage in bytes
`total_paid_bytes` *int64*                   | total number of paid bytes
`total_used_bytes` *int64*                   | total number of used bytes (TODO: does not work as expected yet)
`total_orphans` *int64*                      | total number of alternative blocks
`funded_accounts` *int64*                    | current number of funded accounts (non-zero balance)
`unclaimed_accounts` *int64*                 | current number of unclaimed fundraiser accounts
`total_delegators` *int64*                   | current number on non-zero balance delegators
`active_delegators` *int64*                  | current number of non-zero balance delegators delegating to active delegates
`inactive_delegators` *int64*                | current number of non-zero balance delegators delegating to inactive delegates
`total_delegates` *int64*                    | current number of registered delegates (active and inactive)
`active_delegates` *int64*                   | current number of active delegates
`inactive_delegates` *int64*                 | current number of inactive delegates
`zero_delegates` *int64*                     | current number of active delegates with zero staking balance
`self_delegates` *int64*                     | current number of active delegates with no incoming delegation
`single_delegates` *int64*                   | current number of active delegates with 1 incoming delegation
`multi_delegates` *int64*                    | current number of active delegates with >1 incoming delegations (delegation services)
`rolls` *int64*                              | current number of rolls
`roll_owners` *int64*                        | current number of distinct active delegates with rolls

## Supply Series

> **Example request.**

```shell
curl "https://api.tzstats.com/series/supply?start_date=today&collapse=1d"
```

> **Example response.**

```json
[
  [
    815478,           // height
    199,              // cycle
    1581161668000,    // time
    825170161.728791, // total
    548313102.872648, // activated
    63141775.537532,  // unclaimed
    27582743.428170,  // vested
    125280976.174350, // unvested
    699889185.554441, // circulating
    516489777.211404, // delegated
    660867550.008684, // staking
    514264193.700025, // active_delegated
    649473768.198626, // active_staking
    2225583.511379,   // inactive_delegated
    11393781.810058,  // inactive_staking
    61045504.551923,  // minted
    12446481.404808,  // minted_baking
    48595263.514794,  // minted_endorsing
    3159.625000,      // minted_seeding
    600.007321,       // minted_airdrop
    193940.835832,    // burned
    114197.267834,    // burned_double_baking
    31838.219485,     // burned_double_endorse
    7221.767000,      // burned_origination
    37584.857000,     // burned_implicit
    3098.724513,      // burned_seed_miss
    54639772.184175,  // frozen
    52997504.000000,  // frozen_deposits
    1641852.516645,   // frozen_rewards
    415.667530        // frozen_fees
  ]
]
```

Lists running supply totals at each block. Collapse selects data from the **first** block in a time window.


### HTTP Request

`GET https://api.tzstats.com/series/supply?args`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`height` *int64*                | block height
`cycle` *int64*                 | block cycle
`time` *datetime*               | block creation time
`total` *money*                 | total available supply (including unclaimed)
`activated` *money*             | total activated fundraiser supply
`unclaimed` *money*             | total non-activated fundraiser supply
`vested` *money*                | total genesis vesting-contract supply that has already vested
`unvested` *money*              | total genesis vesting-contract supply that has not vested yet
`circulating` *money*           | current circulating supply (by unanimous consent this is total - unvested even though frozen supply cannot move next block but still counts against total network value)
`delegated` *money*             | current delegated supply (balances of all delegators)
`staking` *money*               | current staking supply (balances of delegators and all bakers even if inactive, see below)
`active_delegated` *money*      | current active delegated supply (balances of all delegators delegating to active bakers)
`active_staking` *money*        | current active staking supply (balances of all active bakers and their delegators)
`inactive_delegated` *money*    | current inactive delegated supply (balances of all delegators delegating to inactive bakers)
`inactive_staking` *money*      | current inactive staking supply (balances of all inactive bakers and their delegators)
`minted` *money*                | total supply minted so far
`minted_baking` *money*         | total supply minted as baking rewards
`minted_endorsing` *money*      | total supply minted as endorsing rewards
`minted_seeding` *money*        | total supply minted as seed nonce revelation rewards
`minted_airdrop` *money*        | total supply minted in airdrops
`burned` *money*                | total supply burned so far
`burned_double_baking` *money*  | total supply burned by double baking denunciations
`burned_double_endorse` *money* | total supply burned by double endorsing denunciations
`burned_origination` *money*    | total supply burned by contract originations
`burned_implicit` *money*       | total supply burned by implicit account allocations
`burned_seed_miss` *money*      | total supply burned by seed nonce revelation misses
`frozen` *money*                | current frozen supply
`frozen_deposits` *money*       | current frozen deposits
`frozen_rewards` *money*        | current frozen rewards
`frozen_fees` *money*           | current frozen fees



## OHLCV Series

> **Example request for the 24 most recent hourly candles.**

```shell
curl "https://api.tzstats.com/series/kraken/XTZ_USD/ohlcv?start_date=now-24h&collapse=1h"
```

> **Example response.**

```json
[
  [
    1570032000000,  // time
    0.94000,        // open
    0.94460,        // high
    0.90890,        // low
    0.92180,        // close
    0.92183,        // vwap
    36,             // n_trades
    3,              // n_buy
    33,             // n_sell
    7878.17322,     // vol_base
    7262.35661,     // vol_quote
    162.09115,      // vol_buy_base
    150.18552,      // vol_buy_quote
    7716.08207,     // vol_sell_base
    7112.17109      // vol_sell_quote
  ],
  // ...
]
```

List aggregated OHLCV market data.

### HTTP Request

`GET https://api.tzstats.com/series/{exchange}/{market}/ohlcv`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`time` *datetime*        | Timestamp, start of interval.
`open` *float*           | Opening price.
`high` *float*           | Highest price.
`low` *float*            | Lowest price.
`close` *float*          | Closing price.
`vwap` *float*           | Volume weighted average price from smallest increment (1 min).
`n_trades` *int*         | Count of trades in the time-frame.
`n_buy` *int*            | Count of trades where the market maker was buyer.
`n_sell` *int*           | Count of trades where the market maker was seller.
`vol_base` *float*       | Total trading volume in base currency (i.e. always XTZ).
`vol_quote` *float*      | Total trading volume in quote currency.
`vol_buy_base` *float*   | Buy-side volume in base currency.
`vol_buy_quote` *float*  | Buy-side volume in quote currency.
`vol_sell_base` *float*  | Sell-side volume in base currency.
`vol_sell_quote` *float* | Sell-side volume in quote currency.

