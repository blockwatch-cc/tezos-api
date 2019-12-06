---
weight: 50
title: Time-Series | TzStats Data API
---

# Time-Series Endpoints

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
    2.223532,           // fees
    79822.000000,       // rewards
    2565504.000000,     // deposits
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
`fees` *float*                 | Total fees paid (and frozen) by all operations.
`rewards` *float*              | Total rewards earned (and frozen) by baker and endorsers.
`deposits` *float*             | Total deposits frozen by baker and endorsers.
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

