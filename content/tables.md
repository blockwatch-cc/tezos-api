---
weight: 40
title: Tables | TzStats Data API
---

# Table Endpoints

> **Generic Table Query**

```
https://api.tzstats.com/tables/{table_code}.{format}?{args}
```


Tables store data in tabular form as a set of columns. Each column has a specified type and each row has a unique uint64 `row_id`. Empty values are represented as JSON `null` or empty strings.  Tables can grow extremely large, so its good practice to use filters and the `columns` query argument to limit the result size. Table responses are automatically sorted by `row_id`. Use client-side sorting if a different sorting order is required.

### List of supported tables

Endpoint | Table Content
---------|---------------
`GET /tables/chain`    | running blockchain totals
`GET /tables/supply`   | running supply totals
`GET /tables/block`    | blocks (including orphans)
`GET /tables/op`       | operations (only final)
`GET /tables/account`  | most recent account balances and state
`GET /tables/contract` | smart contracts state at creation
`GET /tables/flow`     | balance, freezer and delegation flows
`GET /tables/rights`   | baking and endorsing rights
`GET /tables/snapshot` | balances of active delegates & delegators at all snapshot blocks
`GET /tables/income`   | per-cycle statistics on baker income, efficiency, etc
`GET /tables/election` | election metadata (i.e. entire governance cycles)
`GET /tables/proposal` | individual proposals
`GET /tables/vote`     | voting period metadata
`GET /tables/ballot`   | ballots and proposal operations


## Query Arguments

Tables support the following general query parameters.

Argument  | Description
----------|-----------------
`columns` *optional*| Comma separated list of column names to return. Bulk array results will be ordered accordingly. Default is all defined columns for a table.
`limit` *optional* | Maximum number of rows to return. Limited to 50,000, default 500.
`cursor` *optional* | Id (`row_id`) of the latest result row returned by a previous call.
`order` *optional* | Result order either `asc` (default) or `desc`, sorted by `row_id`.

To paginate result sets larger than the maximum limit, include `row_id` into the list of columns and use the last value of row_id as cursor in your next call. This will automatically apply an extra filter `row_id.gt=cursor` for ascending and `row_id.lt=cursor` for descending order. You can of course also apply the relevant row_id filter directly, without using cursor.


## Query Filters

> **Filter Example**

> The example below filters blocks by time range from `time.gte=2019-08-01` (inclusive) to `time.lte=2019-08-31` (inclusive) and returns columns `time` and `height`. The same effect can be achieved with the range operator `time.rg=2019-08-01,2019-08-31`.


```shell
curl "https://api.tzstats.com/tables/block.json?columns=time,height&time.gte=2018-08-01&time.lte=2018-08-31&limit=50000"
```

> **JSON result**

```json
[
  [1533081657000,42672],
  [1533081717000,42673],
  [1533081777000,42674],
  [1533081837000,42675],
  [1533081897000,42676],
  [1533081957000,42677],
  [1533082017000,42678],
  [1533082152000,42679],
  [1533082287000,42680],
  [1533082347000,42681],
  [1533082407000,42682],
  // ...
]
```

To filter tables use filter expressions of the form `<column>.<operator>=<arg>`. Filters work on any combination of columns regardless of type. For arguments, type encoding rules of the column type apply. Filtering by multiple columns is similar to a logical AND between expressions. For simplicity and performance there are currently no OR expressions or more complex operators available. Comparison order for strings and binary is the lexicographical order over UTF8 (string) or ASCII (binary) alphabets.

|Operator | Semantics |
|---------|-----------|
| `=`, `.eq=` | **Equal.** Matches rows where column values match exactly the filter value. |
| `.ne=`  | **Not equal.** Matches rows where column values do not match the filter value. |
| `.gt=`  | **Greater than.** matches columns whose value is strictly greater than the filter value. |
| `.gte=` | **Greater than or equal.** matches columns whose value is greater than or equal to the filter value. |
| `.lt=`  | **Less than.** matches columns whose value is strictly smaller than the filter value. |
| `.lte=` | **Less than or equal.** matches columns whose value is strictly smaller than or equal to the filter value. |
| `.in=` | **Inclusion in list.** matches columns whose value is equal to one of the filter values. Multiple values must be separated by comma. |
| `.nin=` | **Not included in list.** matches columns whose value is not equal to one of the filter values. Multiple values may be separated by comma. |
| `.rg=` | **Range.** matches columns whose value is between the provided filter values, boundary inclusive. Requires exactly two values separated by comma. (This is similar to, but faster than using `.gte=` and `.lte=` in combination.) |
| `.re=` | **Regexp.** matches columns whose value matches the regular expression. Can only be used on string-type columns (not enum or hash). Non-URL-safe characters must be properly escaped. |





## Account Table

> **Example request.**

```shell
curl "https://api.tzstats.com/tables/account?address=tz2TSvNTh2epDMhZHrw73nV9piBX7kLZ9K9m"
```

> **Example response (comments added for explanation).**

```json
[
  [
    278469,             // row_id
    278469,             // delegate_id
    0,                  // manager_id
    "secp256k1",        // address_type
    360996,             // first_in
    360997,             // first_out
    633203,             // last_in
    633203,             // last_out
    360996,             // first_seen
    633203,             // last_seen
    0,                  // delegated_since
    361000,             // delegate_since
    4129917.992000,     // total_received
    1241985.094354,     // total_sent
    0.000000,           // total_burned
    0.041097,           // total_fees_paid
    488373.754858,      // total_rewards_earned
    53.292001,          // total_fees_earned
    0.000000,           // total_lost
    3029056.000000,     // frozen_deposits
    94254.999996,       // frozen_rewards
    10.405040,          // frozen_fees
    0.000000,           // unclaimed_balance
    253038.498372,      // spendable_balance
    28092993.766577,    // delegated_balance
    13,                 // total_delegations
    8,                  // active_delegations
    1,                  // is_funded
    0,                  // is_activated
    0,                  // is_vesting
    1,                  // is_spendable
    0,                  // is_delegatable
    0,                  // is_delegated
    1,                  // is_revealed
    1,                  // is_delegate
    1,                  // is_active_delegate
    0,                  // is_contract
    6165,               // blocks_baked
    41,                 // blocks_missed
    129,                // blocks_stolen
    102793,             // blocks_endorsed
    195539,             // slots_endorsed
    332,                // slots_missed
    103002,             // n_ops
    0,                  // n_ops_failed
    38,                 // n_tx
    1,                  // n_delegation
    0,                  // n_origination
    1,                  // n_proposal
    1,                  // n_ballot
    2,                  // token_gen_min
    4875,               // token_gen_max
    160,                // grace_period
    "tz2TSvNTh2epDMhZHrw73nV9piBX7kLZ9K9m", // address
    "tz2TSvNTh2epDMhZHrw73nV9piBX7kLZ9K9m", // delegate
    null,               // manager
    "sppk7bn9MKAWDUFwqowcxA1zJgp12yn2kEnMQJP3WmqSZ4W8WQhLqJN", // pubkey
    1553123452000,      // first_seen_time
    1570032391000,      // last_seen_time
    1553123452000,      // first_in_time
    1570032391000,      // last_in_time
    1553123512000,      // first_out_time
    0,                  // delegated_since_time
    1553123692000,      // delegate_since_time
    0,                  // rich_rank
    0,                  // flow_rank
    0,                  // traffic_rank
    "000000"            // call_stats
  ]
]
```

List information about the most recent state of implicit and smart contract accounts.

### HTTP Request

`GET https://api.tzstats.com/tables/account?args`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`row_id` *uint64*                   | Unique row identifier.
`delegate_id` *uint64*              | Account delegate unique row_id.
`manager_id` *uint64*               | Account manager unique row_id.
`address_type` *enum*               | Account address type `ed25519` (tz1), `secp256k1` (tz2), `p256` (tz3), `contract` (KT1) or `blinded` (btz1)
`first_in` *int64*                  | Block height of first incoming transaction.
`first_out` *int64*                 | Block height of first outgoing transaction.
`last_in` *int64*                   | Block height of latest incoming transaction.
`last_out` *int64*                  | Block height of latest outgoing transaction.
`first_seen` *int64*                | Block height of account creation.
`last_seen` *int64*                 | Block height of last activity.
`delegated_since` *int64*           | Block height of most recent delegation.
`delegate_since` *int64*            | Block height of registration as delegate.
`total_received` *money*          | Lifetime total tokens received in transactions.
`total_sent` *money*              | Lifetime total tokens sent in transactions.
`total_burned` *money*            | Lifetime total tokens burned in tz.
`total_fees_paid` *money*         | Lifetime fees paid in tz.
`total_rewards_earned` *money*    | Lifetime rewards earned in tz.
`total_fees_earned` *money*       | Lifetime fees earned in tz.
`total_lost` *money*              | Lifetime total tokens lost in tz.
`frozen_deposits` *money*         | Currently frozen deposits
`frozen_rewards` *money*          | Currently frozen rewards.
`frozen_fees` *money*             | Currently frozen fees.
`unclaimed_balance` *money*       | Currently unclaimed balance (for vesting contracts and commitments).
`spendable_balance` *money*       | Currently spendable balance.
`delegated_balance` *money*       | (baker only) Current incoming delegations.
`total_delegations` *int64*       | (baker only) Lifetime count of delegations.
`active_delegations` *int64*      | (baker only) Currently active and non-zero delegations.
`is_funded` *bool*                | Flag indicating the account is funded.
`is_activated` *bool*             | Flag indicating the account was activated from a commitment.
`is_vesting` *bool*               | Flag indicating the account is a vesting contract.
`is_spendable` *bool*             | Flag indicating the account balance is spendable.
`is_delegatable` *bool*           | Flag indicating the account is delegatable.
`is_delegated` *bool*             | Flag indicating the account is currently delegated.
`is_revealed` *bool*              | Flag indicating the account has a revealed public key .
`is_delegate` *bool*              | Flag indicating the account is a registered delegate.
`is_active_delegate` *bool*       | Flag indicating the account is a registered and active delegate.
`is_contract` *bool*              | Flag indicating the account is a smart contract.
`blocks_baked` *int64*            | Lifetime total blocks baked.
`blocks_missed` *int64*           | Lifetime total block baking missed.
`blocks_stolen` *int64*           | Lifetime total block baked at priority > 0.
`blocks_endorsed` *int64*         | Lifetime total blocks endorsed.
`slots_endorsed` *int64*          | Lifetime total endorsemnt slots endorsed.
`slots_missed` *int64*            | Lifetime total endorsemnt slots missed.
`n_ops` *int64*                   | Lifetime total number of operations sent and received.
`n_ops_failed` *int64*            | Lifetime total number of operations sent that failed.
`n_tx` *int64*                    | Lifetime total number of transactions sent and received.
`n_delegation` *int64*            | Lifetime total number of delegations sent.
`n_origination` *int64*           | Lifetime total number of originations sent.
`n_proposal` *int64*              | Lifetime total number of proposals (operations) sent.
`n_ballot` *int64*                | Lifetime total number of ballots sent.
`token_gen_min` *int64*           | Minimum generation number of all tokens owned.
`token_gen_max` *int64*           | Maximum generation number of all tokens owned.
`grace_period` *int64*            | (baker only) Current grace period before deactivation.
`address` *hash*                  | Account address base58check encoded.
`delegate` *hash*                 | Account delegate address base58check encoded.
`manager` *hash*                  | Account manager address base58check encoded.
`pubkey` *hash*                   | Revealed public key base58check encoded.
`first_seen_time` *datetime*      | Block time of account creation.
`last_seen_time` *datetime*       | Block time of last activity.
`first_in_time` *datetime*        | Block time of first incoming transaction.
`last_in_time` *datetime*         | Block time of latest incoming transaction.
`first_out_time` *datetime*       | Block time of first outgoing transaction.
`last_out_time` *datetime*        | Block time of latest outgoing transaction.
`delegated_since_time` *datetime* | Block time of most recent delegation.
`delegate_since_time` *datetime*  | Block time of registration as delegate.
`rich_rank` *int64*               | Global rank on rich list by total balance.
`flow_rank` *int64*               | Global rank on 24h most active accounts by transactions sent/received.
`traffic_rank` *int64*            | Global rank on 24h most active accounts by volume sent/received.
`call_stats` *bytes*              | Big-endian uint32 call statistic counters per entrypoint. Only used on smart contracts.

## Ballot Table

> **Example request.**

```shell
curl "https://api.tzstats.com/tables/ballot?voting_period=16&limit=1"
```

> **Example response (comments added for explanation).**

```json
[
  [
    856,            // row_id
    13,             // election_id
    5,              // proposal_id
    16,             // voting_period
    "testing_vote", // voting_period_kind
    557061,         // height
    1565333732000,  // time
    63795,          // source_id
    13150288,       // op_id
    6,              // rolls
    "yay",          // ballot
    "tz1abmz7jiCV2GH2u81LRrGgAFFgvQgiDiaf",  // source
    "onw6yGKFPucybjz5ysTRoohdnZMt9UFkTo6RdUFe7vcMp5aGv4s",  // op
    "PsBABY5HQTSkA4297zNHfsZNKtxULfL18y95qb3m53QJiXGmrbU"   // proposal
  ]
]
```

List individual ballot operations sent by bakers during votes.

### HTTP Request

`GET https://api.tzstats.com/tables/ballot?args`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`row_id` *uint64*              | Unique row identifier.
`election_id` *uint64*         | Unique row_id of the election this proposal was submitted in.
`proposal_id` *uint64*         | Unique row_id of the proposal that is voted for.
`voting_period` *int64*        | On-chain sequence number of the voting period this ballot was cast at.
`voting_period_kind` *enum*    | Type of the voting period `proposal`, `testing_vote`, `testing`, `promotion_vote`.
`height` *int64*               | Block height where the ballot was included
`time` *datetime*              | Block time where the ballot was included.
`source_id` *uint64*           | Unique row_id if the ballot sender account.
`op_id` *uint64*               | Unique row_id if the ballot operation.
`rolls` *int64*                | Number of rolls owned by source.
`ballot` *enum*                | The actual ballot `yay`, `nay`, `pass`.
`source` *hash*                | Address of the ballot sender account, base58check encoded.
`op` *hash*                    | Hash of the ballot operation, base58check encoded.
`proposal` *hash*              | Hash of the proposal that is voted on, if any.




## Bigmap Table

> **Example request.**

```shell
curl "https://api.tzstats.com/tables/bigmap?action=alloc&limit=1&order=desc"
```

> **Example response (comments added for explanation).**

```json
[
    [
        861,            // row_id
        0,              // prev_id
        343647,         // account_id
        117,            // contract_id
        16616273,       // op_id
        682374,         // height
        1573054617000,  // time
        15,             // bigmap_id
        "alloc",        // action
        "",             // key_hash
        "bytes",        // key_encoding
        "address",      // key_type
        "",             // key
        "036a",         // value
        0,              // is_replaced
        0,              // is_deleted
        0,              // is_copied
        "KT1AajLnzG5EyJSZfpSsn44iaHhwdm5AK85b", // address
        "oor9UypoAjKYei6miVWhxKVeBhkJV1WH3k1VvzdEBnQFmpPUMaK" // op
    ]
]
```

Lists individual bigmap update operations found in smart contract call results. Use this table to search of filter updates or efficiently access updated data. You can also use the results to reconstruct bigmap state at the client from a sequence of updates. For convenience, the current or past state of a bigmap is available as a set of [explorer endpoints](#bigmaps).


### HTTP Request

`GET https://api.tzstats.com/tables/bigmap?args`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`row_id` *uint64*      | Unique row identifier.
`prev_id` *uint64*     | Unique row identifier of previous value that has been replaced by this row.
`account_id` *uint64*  | Unique row_id of the account that owns the updated bigmap.
`contract_id` *uint64* | Unique row_id of the contract that owns the updated bigmap.
`op_id` *uint64*       | Unique row_id of the operation that contains this update.
`height` *int64*       | Height at which the update was included on-chain.
`time` *datetime*      | Timestamp at which the update was included on-chain.
`bigmap_id` *int64*    | Unique on-chain id of the bigmap.
`action` *enum*        | Update action, one of `alloc`, `update`, `remove`, `copy`.
`key_hash` *string*    | Script expression hash of the key that was updated. Empty on alloc and copy.
`key_encoding` *enum*  | Michelson encoding of the key (`string`, `bytes`, `int`).
`key_type` *enum*      | Michelson type of the key.
`key` *string*         | Native representation of the key. Integers are bigints wrapped in strings, other types are rendered according to type rules, e.g. addresses, keys and signatures are base58check encoded).
`value` *string*       | Binary encoding of the Micheline primitives in Babylon format. Wrapped into a hex string.
`is_replaced` *bool*   | Flag indicating this entry has been replaced by a newer entry.
`is_deleted` *bool*    | Flag indicating this key has been deleted by this update.
`is_copied` *bool*     | Flag indicating this key has been copied by this update.
`address` *hash*       | Address of the bigmap owner.
`op` *hash*            | Operation hash where this updated appeared on-chain.





## Block Table

> **Example request.**

```shell
curl https://api.tzstats.com/tables/block?time.gte=today&limit=1
```

> **Example response (comments added for explanation).**

```json
[
  [
    632250,             // row_id
    632249,             // parent_id
    "BMapnMicyiqFsWU9NdqXvfQJQcpFfzWHMicRRjALEMNngkefd7B", // hash
    0,                  // is_orphan
    632249,             // height
    154,                // cycle
    0,                  // is_cycle_snapshot
    1569974422000,      // time
    60,                 // solvetime
    4,                  // version
    4,                  // validation_pass
    20007610,           // fitness
    0,                  // priority
    14737939769,        // nonce
    "promotion_vote",   // voting_period_kind
    35034,              // baker_id
    4294967295,         // endorsed_slots
    32,                 // n_endorsed_slots
    30,                 // n_ops
    0,                  // n_ops_failed
    0,                  // n_ops_contract
    2,                  // n_tx
    0,                  // n_activation
    0,                  // n_seed_nonce_revelation
    0,                  // n_double_baking_evidence
    0,                  // n_double_endorsement_evidence
    27,                 // n_endorsement
    0,                  // n_delegation
    1,                  // n_reveal
    0,                  // n_origination
    0,                  // n_proposal
    0,                  // n_ballot
    10529.635160,       // volume
    0.004140,           // fee
    80.000000,          // reward
    2560.000000,        // deposit
    0.000000,           // unfrozen_fees
    0.000000,           // unfrozen_rewards
    0.000000,           // unfrozen_deposits
    0.000000,           // activated_supply
    0.000000,           // burned_supply
    31,                 // n_accounts
    0,                  // n_new_accounts
    0,                  // n_new_implicit
    0,                  // n_new_managed
    0,                  // n_new_contracts
    0,                  // n_cleared_accounts
    0,                  // n_funded_accounts
    32100,              // gas_limit
    30414,              // gas_used
    0.136,              // gas_price
    0,                  // storage_size
    58.567415,          // days_destroyed
    100,                // pct_account_reuse
    "tz1hThMBD8jQjFt78heuCnKxJnJtQo9Ao25X" // baker
  ]
]
```

List detailed information about each block, including orphans.

### HTTP Request

`GET https://api.tzstats.com/tables/block?args`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`row_id` *uint64*               | Unique row identifier.
`parent_id` *uint64*            | Unique row id of parent block.
`hash` *hash*                   | Block hash.
`is_orphan` *bool*              | Flag indicating the block is an orphan, i.e. not on main chain.
`height` *int64*                | Block height.
`cycle` *int64*                 | Consensus cycle this block is part of.
`is_cycle_snapshot` *bool*      | Flag indicating this block is a cycle snapshot.
`time` *datetime*               | Block timestamp.
`solvetime` *int64*             | Duration between the parent block's timestamp and this block.
`version` *int64*               | Block protocol version (note, this is a serial version that depends on how many protocols have been activated on the current chain so far).
`validation_pass` *int64*       | Block validation pass.
`fitness` *int64*               | Block fitness used to determine longest chain.
`priority` *int64*              | Baking priority.
`nonce` *uint64*                | Block nonce.
`voting_period_kind` *enum*     | Current voting period `proposal`, `testing_vote`, `testing`, `promotion_vote`.
`baker_id` *uint64*             | Unique row id of the block's baker account.
`endorsed_slots` *uint64*       | 32bit big-endian bitmask indicating which slots have been endorsed. (Note this field will be set from endorsements published in the subsequent block.)
`n_endorsed_slots` *int64*      | Count of endorsed slots. (Note this field will be set from endorsements published in the subsequent block.)
`n_ops` *int64*                 | Count of operations contained in this block.
`n_ops_failed` *int64*          | Count of failed operations.
`n_ops_contract` *int64*        | Count of smart contract operations (transactions sent to contracts and internal operations sent by contracts).
`n_tx` *int64*                  | Count of `transaction` operations.
`n_activation` *int64*          | Count of `activate_account` operations.
`n_seed_nonce_revelation` *int64*  | Count of `seed_nonce_revelation` operations.
`n_double_baking_evidence` *int64* | Count of `double_baking_evidence` operations.
`n_double_endorsement_evidence` *int64*  | Count of `double_endorsement_evidence` operations.
`n_endorsement` *int64*         | Count of `endorsement` operations.
`n_delegation` *int64*          | Count of `delegation` operations.
`n_reveal` *int64*              | Count of `reveal` operations.
`n_origination` *int64*         | Count of `origination` operations.
`n_proposal` *int64*            | Count of `proposals` operations.
`n_ballot` *int64*              | Count of `ballot` operations.
`volume` *money*              | Total amount of tokens moved between accounts.
`fee` *money*                 | Total fees paid (and frozen) by all operations.
`reward` *money*              | Reward earned (and frozen) by baker.
`deposit` *money*             | Deposit frozen by baker.
`unfrozen_fees` *money*       | Total unfrozen fees (at end of a cycle).
`unfrozen_rewards` *money*    | Total unfrozen rewards (at end of a cycle).
`unfrozen_deposits` *money*   | Total unfrozen deposits (at end of a cycle).
`activated_supply` *money*    | Total amount of commitments activated in tz.
`burned_supply` *money*       | Total amount of tokens burned by operations in tz.
`n_accounts` *int64*            | Count of accounts seen in this block (i.e. this includes all operation senders, receivers, delegates and the block's baker).
`n_new_accounts` *int64*        | Count of new accounts created regardless of type.
`n_new_implicit` *int64*        | Count of created implicit accounts (tz1/2/3).
`n_new_managed` *int64*         | Count of created managed accounts (KT1 without code or manager.tz script).
`n_new_contracts` *int64*       | Count of created smart contracts (KT1 with code).
`n_cleared_accounts` *int64*    | Count of accounts that were emptied (final balance = 0).
`n_funded_accounts` *int64*     | Count of accounts that were funded by operations (this includes all new accounts plus previously cleared accounts that were funded again).
`gas_limit` *int64*             | Total gas limit defined by operations.
`gas_used` *int64*              | Total gas consumed by operations.
`gas_price` *float*           | Average price of one gas unit in mutez.
`storage_size` *int64*          | Total sum of new storage allocated by operations.
`days_destroyed` *float*      | Token days destroyed (`tokens transferred * token idle time`).
`n_ops_implicit` *int64*      | Count of implicit protocol events.
`pct_account_reuse` *float*   | Portion of seen accounts that existed before.
`baker` *hash*                | Address of the block baker account, base58check encoded.



## Chain Table

> **Example request.**

```shell
curl "https://api.tzstats.com/tables/chain?time.gte=today&limit=1"
```

> **Example response (comments added for explanation)**.

```json
[
  [
    632250,         // row_id
    632249,         // height
    154,            // cycle
    1569974422000,  // time
    334414,         // total_accounts
    309308,         // total_implicit
    25074,          // total_managed
    108,            // total_contracts
    15227175,       // total_ops
    7139,           // total_contract_ops
    20774,          // total_activations
    19559,          // total_seed_nonce_revelations
    13113009,       // total_endorsements
    127,            // total_double_baking_evidences
    24,             // total_double_endorsement_evidences
    29354,          // total_delegations
    223262,         // total_reveals
    26863,          // total_originations
    1793082,        // total_transactions
    404,            // total_proposals
    725,            // total_ballots
    8747841,        // total_storage_bytes
    167308,         // total_paid_bytes
    0,              // total_used_bytes
    0,              // total_orphans
    298796,         // funded_accounts
    10751,          // unclaimed_accounts
    17567,          // total_delegators
    17105,          // active_delegators
    462,            // inactive_delegators
    3889,           // total_delegates
    483,            // active_delegates
    3406,           // inactive_delegates
    3,              // zero_delegates
    135,            // self_delegates
    78,             // single_delegates
    270,            // multi_delegates
    72059,          // rolls
    462             // roll_owners
  ]
]
```

List running totals of network-wide statistics. This table is updated at each block.

### HTTP Request

`GET https://api.tzstats.com/tables/chain?args`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`row_id` *uint64*              | Unique row identifier.
`height` *int64*               | Block height the current row refers to.
`cycle` *int64*                | Cycle the current row refers to.
`time` *datetime*              | Block time in UNIX milliseconds the current row refers to.
`total_accounts` *int64*       | Total count of existing funded & non-funded accounts.
`total_implicit` *int64*       | Total count of implicit (tz1/2/3) accounts.
`total_managed` *int64*        | Total count of managed accounts (KT1) used for delegation (without code / using manager.tz script).
`total_contracts` *int64*      | Total count of deployed smart contracts.
`total_ops` *int64*            | Total count of on-chain operations.
`total_contract_ops` *int64*   | Total count of smart contract calls (sent to or originated from contracts).
`total_activations` *int64*    | Total count of `activate_account` operations.
`total_seed_nonce_revelations` *int64*    | Total count of `seed_nonce_revelation` operations.
`total_double_endorsement_evidences` *int64*   | Total count of `endorsement` operations.
`total_double_baking_evidences` *int64*    | Total count of `double_baking_evidence` operations.
`total_double_endorse` *int64* | Total count of `double_endorsement_evidence` operations.
`total_delegations` *int64*    | Total count of `delegation` operations.
`total_reveals` *int64*        | Total count of `reveal` operations.
`total_originations` *int64*   | Total count of `origination` operations.
`total_transactions` *int64*   | Total count of `transaction` operations.
`total_proposals` *int64*      | Total count of `proposals` operations.
`total_ballots` *int64*        | Total count of `ballot` operations.
`total_storage_bytes` *int64*  | Total count of storage bytes allocated.
`total_paid_bytes` *int64*     | Total count of storage bytes paid.
`total_used_bytes` *int64*     | Total count of storage used.
`total_orphans` *int64*        | Total count of orphaned blocks.
`funded_accounts` *int64*      | Current number of funded accounts.
`unclaimed_accounts` *int64*   | Current number of unclaimed fundraiser accounts.
`total_delegators` *int64*     | Current number of non-zero delegators.
`active_delegators` *int64*    | Current number of non-zero delegators who delegate to an active delegate.
`inactive_delegators` *int64*  | Total count of non-zero delegators who delegate to an inactive delegate.
`total_delegates` *int64*      | Current number of registered bakers (active and inactive).
`active_delegates` *int64*     | Current number of active bakers.
`inactive_delegates` *int64*   | Current number of inactive bakers (note: inactive bakers can still have future rights, but won't get any new rights).
`zero_delegates` *int64*       | Current number of active bakers with zero staking balance.
`self_delegates` *int64*       | Current number of active bakers who self-bake only and have no incoming delegations.
`single_delegates` *int64*     | Current number of active bakers who potentially self-bake and have only a single incoming delegation.
`multi_delegates` *int64*      | Current number of bakers (potentially staking services) who have more than 1 incoming delegation.
`rolls` *int64*                | Current number of network-wide rolls.
`roll_owners` *int64*          | Current number of network-wide roll owners.





## Contract Table

> **Example | request.**

```shell
curl "https://api.tzstats.com/tables/contract?address=KT1REHQ183LzfoVoqiDR87mCrt7CLUH1MbcV"
```

> **Example response (comments added for explanation).**

```json
[
  [
    80,          // row_id
    289810,      // account_id
    289790,      // manager_id
    438378,      // height
    0.013587,    // fee
    96082,       // gas_limit
    95982,       // gas_used
    0.142,       // gas_price
    4082,        // storage_limit
    3805,        // storage_size
    3805,        // storage_paid
    "00000eb30200000eae...",  // script
    1,           // is_spendable
    0,           // is_delegatable
    3,           // op_l
    5,           // op_p
    0,           // op_i
    "5f89baed",  // iface_hash
    "KT1REHQ183LzfoVoqiDR87mCrt7CLUH1MbcV", // address
    "tz1N74dH3VSeRTeKobbXUbyU82G8pqT2YYEM" // manager
  ]
]
```

List creation-time information about smart contracts with embedded code and initial storage.

### HTTP Request

`GET https://api.tzstats.com/tables/contract?args`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`row_id` *uint64*           | Unique row identifier.
`account_id` *uint64*       | Unique row_id of related account entry.
`manager_id` *uint64*       | Manager account row_id (deprecated in v005 Babylon).
`height` *int64*            | Origination block height.
`fee` *money*               | Fee paid on contract origination.
`gas_limit` *int64*         | Gas limit on contract origination.
`gas_used` *int64*          | Gas used on contract origination.
`gas_price` *float*         | Gas price on contract origination.
`storage_limit` *int64*     | Storage limit defined on contract origination op.
`storage_size` *int64*      | Storage size allocated in bytes.
`storage_paid` *int64*      | Storage bytes paid for in bytes.
`script` *bytes*            | Binary encoded Michelson script and initial contract storage.
`is_spendable` *bool*       | Flag indicating the contract balance is spendable (deprecated in v005 Babylon).
`is_delegatable` *bool*     | Flag indicating the contract is delegatable (deprecated in v005 Babylon).
`op_l` *int64*              | Origination block operation list number (0..3).
`op_p` *int64*              | Origination block operation list position.
`op_i` *int64*              | Internal origination operation list position.
`iface_hash` *bytes*        | Short hash to uniquely identify the contract interface, first 4 bytes of the SHA256 hash over binary encoded Michelson script parameters.
`address` *hash*            | Contract address base58check encoded.
`manager` *hash*            | Contract manager address base58check encoded.


## Election Table

> **Example request.**

```shell
curl "https://api.tzstats.com/tables/election?proposal=PsBABY5HQTSkA4297zNHfsZNKtxULfL18y95qb3m53QJiXGmrbU"
```

> **Example response (comments added for explanation).**

```json
[
  [
    13,              // row_id
    5,               // proposal_id
    4,               // num_periods
    2,               // num_proposals
    15,              // voting_perid
    1563303754000,   // start_time
    0,               // end_time
    524288,          // start_height
    0,               // end_height
    0,               // is_empty
    1,               // is_open
    0,               // is_failed
    0,               // no_quorum
    0,               // no_majority
    "PsBABY5HQTSkA4297zNHfsZNKtxULfL18y95qb3m53QJiXGmrbU", // proposal
    "promotion_vote" // last_voting_period
  ]
]
```

List full details about past and current elections. Elections represent metadata about each consecutive run of related voting periods. Elections may contain 4, 2 or 1 vote periods. They are called empty when only one empty proposal vote without a proposal exists.


### HTTP Request

`GET https://api.tzstats.com/tables/election?args`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`row_id` *uint64*            | Unique row identifier.
`proposal_id` *uint64*       | Unqiue row_id of the winning proposal, if any.
`num_periods` *int64*        | Election duration in number of voting periods.
`num_proposals` *int64*      | Total number of submitted proposals.
`voting_perid` *int64*       | On-chain voting period number.
`start_time` *datetime*      | Block time of election start block.
`end_time` *datetime*        | Block time of election end block.
`start_height` *int64*       | Block height of election start block.
`end_height` *int64*         | Block height of election end block.
`is_empty` *bool*            | Flag indicating no proposal was submitted.
`is_open` *bool*             | Flag indicating the election is in progress.
`is_failed` *bool*           | Flag indicating the election has failed to select or activate a new protocol.
`no_quorum` *bool*           | Flag indicating the election has failed because no quorum could be reached.
`no_majority` *bool*         | Flag indicating the election has failed because no majority could be reached.
`proposal` *hash*            | Hash of the proposal that is voted on, if any.
`last_voting_period` *enum*  | Type of the last period at which this election ended `proposal`, `testing_vote`, `testing`, `promotion_vote`.



## Flow Table

> **Example request.**

```shell
curl "https://api.tzstats.com/tables/flow?address=tz2TSvNTh2epDMhZHrw73nV9piBX7kLZ9K9m&limit=1"
```

> **Example response (comments added for explanation).**

```json
[
  [
    24807689,      // row_id
    360996,        // height
    88,            // cycle
    1553123452000, // time
    8361752,       // op_id
    24,            // op_n
    0,             // op_l
    0,             // op_p
    0,             // op_c
    0,             // op_i
    278469,        // account_id
    31922,         // counterparty_id
    "secp256k1",   // address_type
    "balance",     // category
    "transaction", // operation
    2.000000,      // amount_in
    0.000000,      // amount_out
    0,             // is_fee
    0,             // is_burned
    0,             // is_frozen
    0,             // is_unfrozen
    1,             // token_gen_min
    1194,          // token_gen_max
    60,            // token_age
    "tz2TSvNTh2epDMhZHrw73nV9piBX7kLZ9K9m", // address
    "tz1Yju7jmmsaUiG9qQLoYv35v5pHgnWoLWbt", // counterparty
    "opPdGCS8cgW5j1id7WH485NuwjGnD4rVsJTaTZo4ftaT9jatFKJ" // op
  ]
]
```

List balance updates on all sub-accounts and different categories. Our categories go beyond on-chain types and include baking, denunciations, vesting contracts and the invoicing feature of protocol upgrades.

### HTTP Request

`GET https://api.tzstats.com/tables/flow?args`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`row_id` *uint64*        | Unique row identifier.
`height` *int64*         | Block height at which this flow was created.
`cycle` *int64*          | Cycle at which this flow was created.
`time` *datetime*        | Block time at which this flow was created.
`op_n` *int64*           | Related operation position in block.
`op_l` *int64*           | Tezos RPC operation list (0..3).
`op_p` *int64*           | Tezos RPC operation list position.
`op_c` *int64*           | Related bulk operation list position.
`op_i` *int64*           | Related internal operation list position.
`account_id` *uint64*    | Unique row_id of the account this flow relates to.
`counterparty_id` *uint64*  | Unique row_id of the counterparty that initiated/received the flow.
`address_type` *enum*  | Account address type `ed25519` (tz1), `secp256k1` (tz2), `p256` (tz3), `contract` (KT1) or `blinded` (btz1).
`category` *enum*      | Flow category (i.e. sub-account) `rewards`, `deposits`, `fees`, `balance`, `delegation`.
`operation` *enum*     | Operation creating this flow `activation`, `denunciation`, `transaction`, `origination`, `delegation`, `reveal`, `endorsement`, `baking`, `noncerevelation`, `internal`, `vest`, `pour`, `invoice`, `airdrop`.
`amount_in` *money*    | Incoming amount in tz.
`amount_out` *money*   | Outgoing amount in tz.
`is_fee` *bool*        | Flag indicating this flow is a fee payment.
`is_burned` *bool*     | Flag indicating this flow burns coins.
`is_frozen` *bool*     | Flag indicating this flow goes towards a freezer sub-account.
`is_unfrozen` *bool*   | Flag indicating this flow comes from a freezer sub-account.
`token_gen_min` *int64*  | Minimum generation number of tokens moved.
`token_gen_max` *int64*  | Maximum generation number of tokens moved.
`token_age` *float*    | Age of tokens moved in days.
`address` *hash*       | Address of the related account.
`counterparty` *hash*  | Address of the counterparty of this flow.


## Income Table

> **Example request.**

```shell
curl "https://api.tzstats.com/tables/income?address=tz2TSvNTh2epDMhZHrw73nV9piBX7kLZ9K9m&cycle=150"
```

> **Example response (comments added for explanation).**

```json
[
  [
    64698,            // row_id
    150,              // cycle
    278469,           // account_id
    3576,             // rolls
    3183854.077395,   // balance
    25426700.898205,  // delegated
    4,                // n_delegations
    199,              // n_baking_rights
    6507,             // n_endorsing_rights
    -292.000000,      // luck
    98.230000,        // luck_percent
    99.87,            // performance_percent
    100.00,           // contribution_percent
    201,              // n_blocks_baked
    0,                // n_blocks_lost
    2,                // n_blocks_stolen
    6507,             // n_slots_endorsed
    0,                // n_slots_missed
    15,               // n_seeds_revealed
    16198.000000,     // expected_income
    518336.000000,    // expected_bonds
    16176.875000,     // total_income
    519360.000000,    // total_bonds
    3216.000000,      // baking_income
    12959.000000,     // endorsing_income
    0.000000,         // double_baking_income
    0.000000,         // double_endorsing_income
    1.875000,         // seed_income
    1.680381,         // fees_income
    0.000000,         // missed_baking_income
    0.000000,         // missed_endorsing_income
    32.000000,        // stolen_baking_income
    0.000000,         // total_lost
    0.000000,         // lost_accusation_fees
    0.000000,         // lost_accusation_rewards
    0.000000,         // lost_accusation_deposits
    0.000000,         // lost_revelation_fees
    0.000000,         // lost_revelation_rewards
    "tz2TSvNTh2epDMhZHrw73nV9piBX7kLZ9K9m",  // address
    1568887343000,    // start_time
    1569136305000     // end_time
  ]
]
```

List detailed baker income and income statistics. This table is extended for all active bakers at each cycle and updated at every block until a cycle is complete. That way, rows for open cycles will always contain live data up to the most recent block in the chain.

### HTTP Request

`GET https://api.tzstats.com/tables/income?args`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`row_id` *uint64*                 | Unique row identifier.
`cycle` *int64*                   | Cycle this income relates to.
`account_id` *uint64*             | Unique row_id of the baker account this income relates to.
`rolls` *int64*                   | Number of rolls (at snapshot block).
`balance` *money*                 | A baker's own balance, composed of spendable balance and frozen deposits plus frozen fees (at snapshot block). Note that frozen rewards do not contribute towards rolls, hence they are not part of balance here.
`delegated` *money*               | Delegated balance (at snapshot block).
`n_delegations` *int64*           | Count of incoming non-zero delegations (at snapshot block).
`n_baking_rights` *int64*         | Count of baking rights in this cycle.
`n_endorsing_rights` *int64*      | Count of endorsing rights in this cycle.
`luck` *money*                    | Absolute luck in coins, i.e. the amount of extra coins that can be earned because randomization allocated more rights than the fair share of rolls.
`luck_percent` *float*            | Relation between actual random rights allocated vs. ideal rights gainable by rolls. Neutral luck is 100%, lower values indicated less rights than fair share, higher values indicate more rights.
`performance_percent` *float*      | Effectiveness of a baker in generating expected rewards. Optimal performance is 100%. The value is lower when blocks or endorsements are missed, low value blocks/endorsements are published or the baker is slashed and higher when extra income was generated from stolen blocks or denunciations. NOTE: This value is not ratio scale nor interval scale. CANNOT be used as benchmark between bakers.
`contribution_percent` *float*    | Effectiveness of a baker in utilizing all rights assigned and contribute to consensus. Optimal contribution is 100%. The value is lower when blocks or endorsements are missed and higher when blocks are stolen. NOTE: This value is ratio scale. It can be used as benchmark for baker availability or participation in consensus. It is strongly correlated to generated income, but does not capture low priority blocks, endorsements or slashing.
`n_blocks_baked` *int64*            | Number of blocks baked in this cycle.
`n_blocks_lost` *int64*             | Number of blocks lost in this cycle.
`n_blocks_stolen` *int64*           | Number of blocks stolen in this cycle.
`n_slots_endorsed` *int64*          | Number of slots endorsed in this cycle.
`n_slots_missed` *int64*            | Number of endorsement slots missed in this cycle.
`n_seeds_revealed` *int64*          | Number of seed nonces revealed in this cycle.
`expected_income` *money*         | Total income expected based on endorsing and priority 0 baking rights.
`expected_bonds` *money*          | Total expected deposits based on endorsing and priority 0 baking rights.
`total_income` *money*            | Total sum of all income (note: due to losses, the actual true income may be smaller which is not reflected by this field alone).
`total_bonds` *money*             | Actual deposits (note: due to losses, the actual bonds that will later be unfrozen may be smaller).
`baking_income` *money*           | Total income from baking blocks.
`endorsing_income` *money*        | Total income from endorsing blocks.
`double_baking_income` *money*    | Total income from denouncing double baking.
`double_endorsing_income` *money* | Total income from denouncing double endorsing.
`seed_income` *money*             | Total income from publishing seed nonces.
`fees_income` *money*             | Total income from fees.
`missed_baking_income` *money*    | Missed income from lost blocks.
`missed_endorsing_income` *money* | Missed income due to missed endorsements.
`stolen_baking_income` *money*    | Extra income from stolen blocks.
`total_lost` *money*              | Total lost income due to denunciations or unpublished seed nonces. NOTE: This does not automatically reduce `total_income` above.
`lost_accusation_fees` *money*     | Lost fees due to a denunciation.
`lost_accusation_rewards` *money*  | Lost rewards due to a denunciation.
`lost_accusation_deposits` *money* | Lost income due to a denunciation.
`lost_revelation_fees` *money*     | Lost fees due to an unpublished seed nonce.
`lost_revelation_rewards` *money*  | Lost block rewards due to an unpublished seed nonce.
`address` *hash*                   | Account address base58check encoded.
`start_time` *datetime*            | Income cycle start time.
`end_time` *datetime*              | Income cycle end time.



## Operation Table

> **Example request.**

```shell
curl "https://api.tzstats.com/tables/op?time.gte=today&limit=1"
```

> **Example response (comments added for explanation).**

```json
[
  [
    16848289,         // row_id
    1573516812000,    // time
    689942,           // height
    168,              // cycle
    "opGz2Sg1QiXchJMyz9v1rV9VN7mQadmkL81KVwteANQWZpgV5ew", // hash
    0,                // counter
    0,                // op_n
    0,                // op_l
    0,                // op_p
    0,                // op_c
    0,                // op_i
    "endorsement",    // type
    "applied",        // status
    1,                // is_success
    0,                // is_contract
    0,                // gas_limit
    0,                // gas_used
    0.000,            // gas_price
    0,                // storage_limit
    0,                // storage_size
    0,                // storage_paid
    0.000000,         // volume
    0.000000,         // fee
    2.000000,         // reward
    64.000000,        // deposit
    0.000000,         // burned
    18957,            // sender_id
    0,                // receiver_id
    0,                // manager_id
    0,                // delegate_id
    0,                // is_internal
    1,                // has_data
    "128",            // data
    null,             // parameters
    null,             // storage
    null,             // big_map_diff
    null,             // errors
    0,                // days_destroyed
    689942,           // branch_id
    689941,           // branch_height
    1,                // branch_depth
    0,                // is_implicit
    0,                // entrypoint_id
    "tz1Z2jXfEXL7dXhs6bsLmyLFLfmAkXBzA9WE",  // sender
    null,             // receiver
    null,             // manager
    null              // delegate
  ]
]
```

List detailed information about operations. Note that Tezos supports **batch operations** and **internal operations** created by smart contract calls in response to a transaction. On both types multiple ops share the same hash.

### HTTP Request

`GET https://api.tzstats.com/tables/op?args`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`row_id` *uint64*           | Unique row identifier.
`time` *datetime*           | Block time at which the operation was included on-chain.
`height` *int64*            | Block height.
`cycle` *int64*             | Cycle in which the operation was included on-chain.
`hash` *hash*               | Operation hash.
`counter` *int64*           | Unique sender account 'nonce' value.
`op_n` *int64*              | Operation position in block.
`op_c` *int64*              | Bulk operation list position.
`op_i` *int64*              | Internal operation list position.
`op_l` *int64*              | Tezos RPC operation list (0..3).
`op_p` *int64*              | Tezos RPC operation list position.
`type` *enum*               | Operation type, one of `activate_account`, `double_baking_evidence`, `double_endorsement_evidence`, `seed_nonce_revelation`, `transaction`, `origination`, `delegation`, `reveal`, `endorsement`, `proposals`, `ballot` or implicit event type `bake`, `seed_slash`, `unfreeze`, `airdrop`, `invoice`.
`status` *enum*             | Operation execution status `applied`, `failed`, `backtracked`, `skipped`.
`is_success` *int64*        | Flag indicating operation was successfully applied.
`is_contract` *bool*        | Flag indicating smart-contract calls.
`gas_limit` *int64*         | Caller-defined gas limit.
`gas_used` *int64*          | Gas used by the operation.
`gas_price` *float*         | Effective price per gas unit in mutez.
`storage_limit` *int64*     | Caller-defined storage limit.
`storage_size` *int64*      | Actual storage size allocated.
`storage_paid` *int64*      | Part of the storage the operation paid for.
`volume` *money*            | Amount of tokens transferred in tz.
`fee` *money*               | Fees paid in tz.
`reward` *money*            | Rewards earned in tz.
`deposit` *money*           | Amount of deposited tokens in tz.
`burned` *money*            | Amount of burned tokens in tz.
`sender_id` *uint64*        | Unique row id of the operation sender account.
`receiver_id` *uint64*      | Unique row id of the transaction receiver, may be zero.
`manager_id` *uint64*       | Unique row id of the new manager account, may be zero.
`delegate_id` *uint64*      | Unique row id of the new delegate account, may be zero.
`is_internal` *bool*        | Flag indicating if this operation was sent be a smart contract.
`has_data` *bool*           | Flag indicating if extra data or parameters are present.
`data` *bytes*              | Extra operation-specific data, see [decoding operation data](#decoding-operation-data).
`parameters` *bytes*      | Call parameters as hex-encoded binary data serialized according to Micheline serialization for protocol v005 Babylon.
`storage` *bytes*         | Updated contract storage as hex-encoded binary data serialized according to Micheline serialization for protocol v005 Babylon, contract-only.
`big_map_diff` *bytes*    | Inserted, updated or deleted bigmap entries as hex-encoded binary data serialized according to Micheline serialization for protocol v005 Babylon, contract-only.
`errors` *bytes*          | When failed, contains details about the reason as escaped JSON string.
`days_destroyed` *float*  | Token days destroyed by this operation (`tokens transferred * token idle time`).
`branch_id` *uint64*      | Row id of the branch block this op refers to.
`branch_height` *int64*   | Height of the branch block this op refers to.
`branch_depth` *int64*    | Count of blocks between branch block and block including this op.
`is_implicit` *bool*      | Flag indicating implicit on-chain events, ie. state changes that don't have an operation hash such as `bake`, `unfreeze`, `seed_slash`, `airdrop` and `invoice`.
`entrypoint_id` *int64*  | Serial id of the called entrypoint, only relevant if the operation was a transaction, the receiver is a smart contract and call parameters are present.
`sender` *hash*           | Address of the operation sender, always set.
`receiver` *hash*         | Address of the receiver of a transaction, may be empty.
`manager` *hash*          | Address of the new contract manager account, may be empty.
`delegate` *hash*         | Address of the new delegate account, may be empty.




## Proposal Table

> **Example request.**

```shell
curl "https://api.tzstats.com/tables/proposal"
```

> **Example response (comments added for explanation).**

```json
[
  [
    5,             // row_id
    "PsBABY5HQTSkA4297zNHfsZNKtxULfL18y95qb3m53QJiXGmrbU",  // hash
    547386,        // height
    1564738976000, // time
    38263,         // source_id
    12880576,      // op_id
    13,            // election_id
    15,            // voting_period
    66302,         // rolls
    304,           // voters
    "tz1eEnQhbwf6trb8Q8mPb2RaPkNk2rN7BKi8", // source
    "ooDAtGzFBeRUJcEK3QRBHU3kzk31CAp2RARYE3kmU3qsrvgs8JN" // op
  ]
]
```
List full details about every submitted proposal

### HTTP Request

`GET https://api.tzstats.com/tables/proposal?args`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`row_id` *uint64*        | Unique row identifier.
`hash` *hash*            | Protocol hash.
`height` *int64*         | Proposal operation block height.
`time` *datetime*        | Proposal operation block time.
`source_id` *uint64*     | Unique row_id of the proposal sender account.
`op_id` *uint64*         | Unique row_id of the proposal operation.
`election_id` *uint64*   | Unique row_id of the election this proposal was submitted in.
`voting_period` *int64*  | On-chain sequence number of the voting period this proposal was submitted in.
`rolls` *int64*          | Number of rolls that voted for this proposal in the proposal period.
`voters` *int64*         | Number of voters who voted for this proposal in the proposal period.
`source` *hash*          | Address of the sender account, base58check encoded.
`op` *hash*              | Hash of the proposal operation, base58check encoded.



## Rights Table

> **Example request.**

```shell
curl "https://api.tzstats.com/tables/rights?address=tz2TSvNTh2epDMhZHrw73nV9piBX7kLZ9K9m&cycle=154&limit=1"
```

> **Example response (comments added for explanation).**

```json
[
  [
    60555268,     // row_id
    "baking",     // type
    630785,       // height
    154,          // cycle
    3,            // priority
    278469,       // account_id
    0,            // is_lost
    0,            // is_stolen
    0,            // is_missed
    0,            // is_seed_required
    0,            // is_seed_revealed
    "tz2TSvNTh2epDMhZHrw73nV9piBX7kLZ9K9m", // address
    1569885537000 // time
  ]
]
```

List detailed rights for baking (all priorities 0..63) and endorsing. This table is extended with future data from cycle n+5 at the start of a new cycle N. During a cycle, rights for each block are updated according to actual baker, priority and endorsers.

### HTTP Request

`GET https://api.tzstats.com/tables/rights?args`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`row_id` *uint64*           | Unique row identifier.
`type` *enum*               | Right type, either `baking` or `endorsing`.
`height` *int64*            | Block height this right relates to.
`cycle` *int64*             | Cycle this right relates to.
`priority` *int64*          | Baking priority of this right.
`account_id` *uint64*       | Unique row_id of the baker who owns this right.
`is_lost` *bool*            | Flag indicating a baking right was lost to another baker. This flag appears when a baker fails to produce a block at the designated priority and another baker bakes the block at higher priority.
`is_stolen` *bool*          | Flag indicating a baking right was stolen from another baker. This flag appears on the right relating to the actual baking priority.
`is_missed` *bool*          | Flag indicating an endorser missed endorsing a slot.
`is_seed_required` *bool*   | Flag indicating a baker is required to publish a seed_nonce_revelation in the next cycle.
`is_seed_revealed` *bool*   | Flag indicating whether the baker actually revealed the required seed nonce.
`address` *hash*            | Address of the baker who owns this right.
`time` *datetime*           | Past or estimated future block time for this right.



## Snapshot Table

> **Example request.**

```shell
curl "https://api.tzstats.com/tables/snapshot?address=tz2TSvNTh2epDMhZHrw73nV9piBX7kLZ9K9m&cycle=150&is_selected=1&limit=1"
```

> **Example response (comments added for explanation).**

```json
[
  [
    25384634,         // row_id
    616960,           // height
    150,              // cycle
    1,                // is_selected
    1569042994000,    // time
    9,                // index
    3915,             // rolls
    278469,           // account_id
    278469,           // delegate_id
    1,                // is_delegate
    1,                // is_active
    3216395.662038,   // balance
    28104896.167331,  // delegated
    7,                // n_delegations
    361000,           // since
    "tz2TSvNTh2epDMhZHrw73nV9piBX7kLZ9K9m", // address
    "tz2TSvNTh2epDMhZHrw73nV9piBX7kLZ9K9m", // delegate
    1553123692000     // since_time
  ]
]
```

List network-wide staking status across all bakers and delegators at snapshot blocks. this table contains all snapshots regardless of them being later chosen as cycle snapshot or not.

### HTTP Request

`GET https://api.tzstats.com/tables/snaphsot?args`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`row_id` *uint64*       | Unique row identifier.
`height` *int64*        | Block height of this snapshot.
`cycle` *int64*         | Cycle of this snapshot.
`is_selected` *bool*    | Flag indicating this snapshot was randomly selected as cycle snapshot.
`time` *datetime*       | Block time of this snapshot.
`index` *int64*         | Snapshot index in the cycle [0..15].
`rolls` *int64*         | (baker only) Number of rolls owned by the delegate.
`account_id` *uint64*   | Unique row_id of the account this snapshot relates to.
`delegate_id` *uint64*  | Unique row_id of the baker this account delegates to.
`is_delegate` *bool*    | Flag indicating the current account is a baker.
`is_active` *bool*      | Flag indicating the current account is an active baker.
`balance` *money*       | Account staking balance (for bakers) or spendable balance (for delegators).
`delegated` *money*     | (baker-only) Incoming delegated amount in tz.
`n_delegations` *int64* | (baker-only) Incoming number of non-zero delegations.
`since` *int64*         | (delegator-only) Block height at which this delegation was created.
`address` *hash*        | Account address.
`delegate` *hash*       | Account delegate address.
`since_time` *datetime* | (delegator-only) Timestamp when this delegation was created.





## Supply Table

> **Example request.**

```shell
curl "https://api.tzstats.com/tables/supply?time.gte=today&limit=1"
```

> **Example response (comments added for explanation).**

```json
[
  [
    632250,             // row_id
    632249,             // height
    154,                // cycle
    1569974422000,      // time
    811171614.329775,   // total
    527007757.439372,   // activated
    84447120.970808,    // unclaimed
    27582743.428170,    // vested
    125280976.174350,   // unvested
    685888221.499699,   // circulating
    457526565.844116,   // delegated
    581437025.036545,   // staking
    456454601.645863,   // active_delegated
    578069662.395001,   // active_staking
    1071964.198253,     // inactive_delegated
    3367362.641544,     // inactive_staking
    47009247.412181,    // minted
    9779155.106655,     // minted_baking
    37227647.430526,    // minted_endorsing
    2444.875000,        // minted_seeding
    100,                // minted_airdrop
    156231.095106,      // burned
    103509.825621,      // burned_double_baking
    31838.219485,       // burned_double_endorse
    6599.299000,        // burned_origination
    14283.751000,       // burned_implicit
    0,                  // burned_seed_miss
    57902196.296935,    // frozen
    56149246.000000,    // frozen_deposits
    1752733.604963,     // frozen_rewards
    216.691972          // frozen_fees
  ]
]
```

List running supply totals at each block.

### HTTP Request

`GET https://api.tzstats.com/tables/supply?args`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`row_id` *uint64*                   | Unique row identifier.
`height` *int64*                    | Block height the current row refers to.
`cycle` *int64*                     | Cycle the current row refers to.
`time` *int64*                      | Block time the current row refers to.
`total` *float64*                 | Total supply, i.e. all coins in existence.
`activated` *money*             | Activated fundraiser supply.
`unclaimed` *money*             | Unclaimed fundraiser supply.
`vested` *money*                | Vested genesis supply, i.e. spendable supply owned by vesting contracts.
`unvested` *money*              | Unvested genesis supply, i.e. supply that is still locked in vesting contracts.
`circulating` *money*           | Circulating supply, i.e. all immediately spendable supply (anything but unvested coins).
`delegated` *money*             | Delegated supply, i.e. all spendable supply owned by delegators.
`staking` *money*               | Staking supply, i.e. delegated supply and supply owned by bakers in form of spendable balances, frozen deposits and frozen fees. Frozen rewards are explicitly excluded because they can be slashed.
`active_delegated` *money*      | Portion of delegated supply that is delegated to active delegates.
`active_staking` *money*        | Portion of staking supply available to active delegates and used for securing consensus.
`inactive_delegated` *money*    | Portion of delegated supply that is delegated to inactive delegates.
`inactive_staking` *money*      | Portion of staking supply on inactive delegates that is not used for securing consensus.
`minted` *money*                | Total issued supply in the form of block rewards.
`minted_baking` *money*         | Issued supply as rewards for block baking.
`minted_endorsing` *money*      | Issued supply as rewards for block endorsement.
`minted_seeding` *money*        | Issued supply as rewards for seed nonce revelations.
`minted_airdrop` *money*        | Issued supply as rewards for developers and protocol-upgrade airdrops (i.e. in Babylon).
`burned` *money*                | Total burned supply.
`burned_double_baking` *money*  | Total supply burned due to double baking.
`burned_double_endorse` *money* | Total supply burned due to double endorsement.
`burned_origination` *money*    | Total supply burned due to contract originations.
`burned_implicit` *money*       | Total supply burned due to implicit account creation.
`burned_seed_miss` *money*      | Total supply burned due to implicit account creation.
`frozen` *money*                | Currently frozen supply.
`frozen_deposits` *money*       | Currently frozen bonds.
`frozen_rewards` *money*        | Currently frozen rewards.
`frozen_fees` *money*           | Currently frozen fees.





## Vote Table

> **Example request.**

```shell
curl "https://api.tzstats.com/tables/vote?voting_period=16"
```

> **Example response (comments added for explanation).**

```json
[
  [
    18,                // row_id
    13,                // election_id
    5,                 // proposal_id
    16,                // voting_period
    "testing_vote",    // voting_period_kind
    1565333282000,     // period_start_time
    1565333282000,     // period_end_time
    557056,            // period_start_height
    589823,            // period_end_height
    70585,             // eligible_rolls
    464,               // eligible_voters
    7291,              // quorum_pct
    51463,             // quorum_rolls
    57818,             // turnout_rolls
    179,               // turnout_voters
    8191,              // turnout_pct
    0,                 // turnout_ema
    37144,             // yay_rolls
    171,               // yay_voters
    0,                 // nay_rolls
    0,                 // nay_voters
    20674,             // pass_rolls
    8,                 // pass_voters
    0,                 // is_open
    0,                 // is_failed
    0,                 // is_draw
    0,                 // no_proposal
    0,                 // no_quorum
    0,                 // no_majority
    "PsBABY5HQTSkA4297zNHfsZNKtxULfL18y95qb3m53QJiXGmrbU" // proposal
  ]
]
```

List full details about every on-chain voting period.


### HTTP Request

`GET https://api.tzstats.com/tables/vote?args`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`row_id` *uint64*                 | Unique row identifier.
`election_id` *uint64*            | Unique row_id of the election this proposal was submitted in.
`proposal_id` *uint64*            | Unique row_id of the proposal that is voted for (or the winning proposal, if any, from the proposal period).
`voting_period` *int64*           | On-chain sequence number of the voting period.
`voting_period_kind` *enum*       | Type of the voting period `proposal`, `testing_vote`, `testing`, `promotion_vote`.
`period_start_time` *datetime*    | Block time of vote start block.
`period_end_time` *datetime*      | Block time of vote end block.
`period_start_height` *int64*     | Block height of vote start block.
`period_end_height` *int64*       | Block height of vote end block.
`eligible_rolls` *int64*          | Number of eligible rolls for this vote.
`eligible_voters` *int64*         | Number of eligible voters for this vote.
`quorum_pct` *int64*              | Required quorum for this vote in percent.
`quorum_rolls` *int64*            | Required quorum for this vote in rolls.
`turnout_rolls` *int64*           | Actual vote participation in rolls.
`turnout_voters` *int64*          | Actual vote participation in voters.
`turnout_pct` *int64*             | Actual vote participation in percent.
`turnout_ema` *int64*             | Actual vote participation as moving average.
`yay_rolls` *int64*               | Count of yay voting rolls.
`yay_voters` *int64*              | Count of yay voting voters.
`nay_rolls` *int64*               | Count of nay voting rolls.
`nay_voters` *int64*              | Count of nay voting voters.
`pass_rolls` *int64*              | Count of pass voting rolls.
`pass_voters` *int64*             | Count of pass voting voters.
`is_open` *bool*                  | Flag indicating the vote is in progress.
`is_failed` *bool*                | Flag indicating the vote has failed to select or activate a new protocol.
`is_draw` *bool*                  | Flag indication the reason for failure was a draw between two proposals in the proposal period.
`no_proposal` *bool*              | Flag indication the reason for failure was no submitted proposal in the proposal period.
`no_quorum` *bool*                | Flag indication the reason for failure was participation below the required quorum.
`no_majority` *bool*              | Flag indication the reason for failure was acceptance below the required supermajority.
`proposal` *int64*                | Hash of the proposal that is voted on, if any.




