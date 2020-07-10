---
weight: 30
title: Explorer | TzStats Data API
---

# Explorer Endpoints

Explorer endpoints serve individual large JSON objects and a few related lists. JSON objects use the typical JSON key/value structure and you cannot limit the contents of objects (i.e. they are always sent in full). CSV format is not supported here.

Most explorer endpoints take different kinds of path arguments to define the object to return. This can be:

- a regular `hash` for blocks, operations or accounts
- the string `head` for the most recent object on the blockchain (e.g. the recent block or cycle)
- a block `height` (a.k.a level in Tezos)
- a sequence `number` for cycles and elections

Some endpoints support a simple pagination scheme to walk lists of results (i.e. for related operations or accounts). To paginate append `limit` and `offset`, both are positive integers. Limit defaults to 20 and is capped to a maximum value of 100. Results are always sorted by `row_id` of the underlying table. Sort direction can be controlled by `order` (asc, or desc). If you require sorting by a different field, you have to do this client-side.

### List of supported endpoints

Endpoint | Is Paged | Filter | Comment
---------|----------|--------|----------
`GET /explorer/status`                    |   |   | indexer status |
`GET /explorer/config/{id}`      |   |   | blockchain config at `head` or `height` |
`GET /explorer/tip`                       |   |   | blockchain tip info |
`GET /explorer/block/{id}`  |   |   | block info at `head`, `hash`, of `height` |
`GET /explorer/block/{id}/op` **DEPRECATED** | x | `type` |  list block operations at `head`, `hash`, or `height` |
`GET /explorer/block/{id}/operations` **NEW** | x | `type` |list block operations at `head`, `hash`, or `height` |
`GET /explorer/op/{hash}`                 |   |   | operation info |
`GET /explorer/account/{hash}`            |   |   | account info |
`GET /explorer/account/{hash}/managed`    | x |   | list of contracts managed by this account |
`GET /explorer/account/{hash}/op` **DEPRECATED**         | x | `type`, `block`, `since` | account info with embedded list of related operations |
`GET /explorer/account/{hash}/operations` **NEW** | x | `type`, `block`, `since` | account info with embedded list of related operations |
`GET /explorer/account/{hash}/ballots`    | x |   | list proposals and ballots |
`GET /explorer/contract/{hash}`           |   |   | smart contract metadata |
`GET /explorer/contract/{hash}/calls`     | x | `block`, `since`, `entrypoint` | list contract calls |
`GET /explorer/contract/{hash}/manager`   |   |   | contract manager (pre-babylon) or originator |
`GET /explorer/contract/{hash}/script`    |   |   | smart contract code, storage and parameter spec |
`GET /explorer/contract/{hash}/storage`   |   |   | smart contract storage |
`GET /explorer/bigmap/{id}`               |   |   | bigmap metadata |
`GET /explorer/bigmap/{id}/type`          |   |   | bigmap type specification |
`GET /explorer/bigmap/{id}/keys`          | x |   | list of bigmap keys |
`GET /explorer/bigmap/{id}/values`        | x |   | list of bigmap key/value pairs |
`GET /explorer/bigmap/{id}/updates`       | x |   | list of bigmap updates |
`GET /explorer/bigmap/{id}/{key}`         |   |   | single bigmap value |
`GET /explorer/bigmap/{id}/{key}/updates` | x |   | list of bigmap updates related to a key|
`GET /explorer/cycle/{id}`                |   |   | cycle info for `head` or `cycle`
`GET /explorer/election/{id}`             |   |   | election metadata and results at `head`, `num` or protocol `hash` |
`GET /explorer/election/{id}/{stage}/voters`| x |   | election voter lists |
`GET /explorer/election/{id}/{stage}/ballots`| x |   | election ballots lists |
`GET /explorer/rank/balances` **NEW**     | x |   | accounts ranked by balance |
`GET /explorer/rank/volume` **NEW**       | x |   | accounts ranked by 1D transaction volume |
`GET /explorer/rank/traffic` **NEW**      | x |   | accounts ranked by 1D traffic |
`GET /markets`                            |   |   | list of known exchanges and markets |
`GET /markets/tickers`                    |   |   | list of 1D market tickers |
`GET /markets/{exchange}`                 |   |   | exchange status |
`GET /markets/{exchange}/{market}`        |   |   | market status |
`GET /markets/{exchange}/{market}/ticker` |   |   | single market ticker |



## Accounts

> **Example request for baker accounts.**

```shell
curl "https://api.tzstats.com/explorer/account/tz3RDC3Jdn4j15J7bBHZd29EUee9gVB1CxD9"
```

> **Example response for baker accounts.**

```json
{
  "address": "tz3RDC3Jdn4j15J7bBHZd29EUee9gVB1CxD9",
  "address_type": "p256",
  "delegate": "tz3RDC3Jdn4j15J7bBHZd29EUee9gVB1CxD9",
  "pubkey": "p2pk67wVncLFS1DQDm2gVR45sYCzQSXTtqn3bviNYXVCq6WRoqtxHXL",
  "first_in": 30,
  "first_out": 4097,
  "last_in": 217012,
  "last_out": 217012,
  "first_seen": 1,
  "last_seen": 217012,
  "delegate_since": 1,
  "first_in_time": "2018-06-30T18:11:27Z",
  "first_out_time": "2018-07-03T14:17:12Z",
  "last_in_time": "2018-12-07T00:59:38Z",
  "last_out_time": "2018-12-07T00:59:38Z",
  "first_seen_time": "2018-06-30T17:39:57Z",
  "last_seen_time": "2018-12-07T00:59:38Z",
  "delegate_since_time": "2018-06-30T17:39:57Z",
  "total_received": 3199041.301565,
  "total_sent": 0,
  "total_burned": 0,
  "total_fees_paid": 0,
  "total_rewards_earned": 786850.44285,
  "total_fees_earned": 47.500561,
  "frozen_deposits": 2085185,
  "frozen_rewards": 81375.379532,
  "frozen_fees": 4.363968,
  "spendable_balance": 1819374.501477,
  "total_balance": 3904563.865445,
  "delegated_balance": 15908943.391749,
  "total_delegations": 7,
  "active_delegations": 6,
  "is_funded": true,
  "is_activated": true,
  "is_vesting": false,
  "is_spendable": true,
  "is_delegatable": false,
  "is_delegated": false,
  "is_revealed": true,
  "is_delegate": true,
  "is_active_delegate": true,
  "is_contract": false,
  "blocks_baked": 13503,
  "blocks_missed": 469,
  "blocks_stolen": 424,
  "blocks_endorsed": 166900,
  "slots_endorsed": 377390,
  "slots_missed": 57309,
  "n_ops": 167379,
  "n_ops_failed": 0,
  "n_tx": 3,
  "n_delegation": 0,
  "n_origination": 0,
  "n_proposal": 0,
  "n_ballot": 0,
  "token_gen_min": 1,
  "token_gen_max": 1,
  "grace_period": 58,
  "staking_balance": 19813507.257194,
  "rolls": 1981,
  "rich_rank": 19,
  "traffic_rank": 0,
  "volume_rank": 0,
  "last_bake_height": 216999,
  "last_bake_block": "BLcnJmEyNicviLBdiaCgCrCAmb1NCbvyigUdMtVdcVvRTeCL5Tj",
  "last_bake_time": "2018-12-07T00:42:53Z",
  "last_endorse_height": 217012,
  "last_endorse_block": "BL7CdVSb8NNtm3EVXfZegmYNmp6jdL6oeLcLvZgugVwYhdBSNxt",
  "last_endorse_time": "2018-12-07T00:59:38Z",
  "next_bake_height": 217080,
  "next_bake_priority": 0,
  "next_bake_time": "2018-12-07T02:07:38Z",
  "next_endorse_height": 217013,
  "next_endorse_time": "2018-12-07T01:00:38Z",
  "avg_luck_64": 9953,
  "avg_performance_64": 9861,
  "avg_contribution_64": 9309,
  "baker_version": "00000003"
}
```

> **Example request for non-baker accounts and contracts.**

```shell
curl "https://api.tzstats.com/explorer/account/KT1QuofAgnsWffHzLA7D78rxytJruGHDe7XG"
```

> **Example response for non-baker accounts and contracts.**

```json
{
  "address": "KT1QuofAgnsWffHzLA7D78rxytJruGHDe7XG",
  "address_type": "contract",
  "delegate": "tz3RDC3Jdn4j15J7bBHZd29EUee9gVB1CxD9",
  "pubkey": "",
  "first_in": 30,
  "first_out": 30,
  "last_in": 30,
  "last_out": 30,
  "first_seen": 1,
  "last_seen": 30,
  "delegated_since": 1,
  "first_in_time": "2018-06-30T18:11:27Z",
  "first_out_time": "2018-06-30T18:11:27Z",
  "last_in_time": "2018-06-30T18:11:27Z",
  "last_out_time": "2018-06-30T18:11:27Z",
  "first_seen_time": "2018-06-30T17:39:57Z",
  "last_seen_time": "2018-06-30T18:11:27Z",
  "delegated_since_time": "2018-06-30T17:39:57Z",
  "total_received": 0,
  "total_sent": 199041.301565,
  "total_burned": 0,
  "total_fees_paid": 0,
  "unclaimed_balance": 9354941.173593,
  "spendable_balance": 0,
  "total_balance": 0,
  "is_funded": true,
  "is_activated": false,
  "is_vesting": true,
  "is_spendable": false,
  "is_delegatable": false,
  "is_delegated": true,
  "is_revealed": false,
  "is_delegate": false,
  "is_active_delegate": false,
  "is_contract": true,
  "n_ops": 3,
  "n_ops_failed": 0,
  "n_tx": 3,
  "n_delegation": 0,
  "n_origination": 0,
  "token_gen_min": 0,
  "token_gen_max": 0,
  "rich_rank": 0,
  "traffic_rank": 0,
  "volume_rank": 0
}
```

Provides information about the most recent state of accounts and smart contracts. Baker accounts and delegator accounts contain additional state information. See the table below for details.

### HTTP Request

`GET https://api.tzstats.com/explorer/account/{hash}`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`address` *hash*              | Account address as base58-check encoded string.
`address_type` *enum*         | Account address type `ed25519` (tz1), `secp256k1` (tz2), `p256` (tz3), `contract` (KT1) or `blinded` (btz1).
`delegate` *hash*             | Current delegate (may be self when registered as delegate).
`manager` *hash*              | Contract manager account.
`pubkey` *hash*               | Revealed public key.
`first_in` *int64*            | Block height of first incoming transaction.
`first_out` *int64*           | Block height of first outgoing transaction.
`last_in` *int64*             | Block height of latest incoming transaction.
`last_out` *int64*            | Block height of latest outgoing transaction.
`first_seen` *int64*          | Block height of account creation.
`last_seen` *int64*           | Block height of last activity.
`delegated_since` *int64* **delegator-only** | Block height of most recent delegation.
`delegate_since` *int64* **baker-only**  | Block height of most recent baker registration.
`delegate_until` *int64* **baker-only**  | Block height of most recent baker deactivation.
`first_in_time` *datetime*    | Block time of first incoming transaction.
`first_out_time` *datetime*   | Block time of first outgoing transaction.
`last_in_time` *datetime*     | Block time of latest incoming transaction.
`last_out_time` *datetime*    | Block time of latest outgoing transaction.
`first_seen_time` *datetime*  | Block time of account creation.
`last_seen_time` *datetime*   | Block time of last activity.
`delegated_since_time` *datetime* **delegator-only** | Block time of most recent delegation.
`delegate_since_time` *datetime* **baker-only** | Block time of most recent baker registration.
`delegate_until_time` *datetime* **baker-only** | Block time of most recent baker deactivation.
`total_received` *money*       | Lifetime total tokens received in transactions.
`total_sent` *money*           | Lifetime total tokens sent in transactions.
`total_burned` *money*         | Lifetime total tokens burned in tz.
`total_fees_paid` *money*      | Lifetime fees paid in tz.
`total_rewards_earned` *money* **baker-only** | Lifetime rewards earned in tz.
`total_fees_earned` *money* **baker-only**    | Lifetime fees earned in tz.
`total_lost` *money* **baker-only**           | Lifetime total tokens lost in tz.
`frozen_deposits` *money* **baker-only**      | Currently frozen deposits
`frozen_rewards` *money* **baker-only**       | Currently frozen rewards.
`frozen_fees` *money* **baker-only**          | Currently frozen fees.
`unclaimed_balance` *money*    | Currently unclaimed balance (for vesting contracts and commitments).
`spendable_balance` *money*    | Currently spendable balance.
`total_balance` *money*        | Currently spendable and frozen balances (except frozen rewards).
`delegated_balance` *money* **baker-only**    | (delegate only) Current incoming delegations.
`staking_balance` *money* **baker-only**      | (delegate only) Current delegated and own total balance.
`total_delegations` *int64* **baker-only**    | (delegate only) Lifetime count of delegations.
`active_delegations` *int64* **baker-only**   | (delegate only) Currently active and non-zero delegations.
`is_funded` *bool*             | Flag indicating the account is funded.
`is_activated` *bool*          | Flag indicating the account was activated from a commitment.
`is_vesting` *bool*            | Flag indicating the account is a vesting contract.
`is_spendable` *bool*          | Flag indicating the account balance is spendable.
`is_delegatable` *bool*        | Flag indicating the account is delegatable.
`is_delegated` *bool*          | Flag indicating the account is currently delegated.
`is_revealed` *bool*           | Flag indicating the account has a revealed public key .
`is_delegate` *bool*           | Flag indicating the account is a registered delegate.
`is_active_delegate` *bool*    | Flag indicating the account is a registered and active delegate.
`is_contract` *bool*           | Flag indicating the account is a smart contract.
`blocks_baked` *int64* **baker-only**         | Lifetime total blocks baked.
`blocks_missed` *int64* **baker-only**        | Lifetime total block baking missed.
`blocks_stolen` *int64* **baker-only**        | Lifetime total block baked at priority > 0.
`blocks_endorsed` *int64* **baker-only**      | Lifetime total blocks endorsed.
`slots_endorsed` *int64* **baker-only**       | Lifetime total endorsemnt slots endorsed.
`slots_missed` *int64* **baker-only**         | Lifetime total endorsemnt slots missed.
`n_ops` *int64*                | Lifetime total number of operations sent and received.
`n_ops_failed` *int64*         | Lifetime total number of operations sent that failed.
`n_tx` *int64*                 | Lifetime total number of transactions sent and received.
`n_delegation` *int64*         | Lifetime total number of delegations sent.
`n_origination` *int64*        | Lifetime total number of originations sent.
`n_proposal` *int64* **baker-only**           | Lifetime total number of proposals (operations) sent.
`n_ballot` *int64* **baker-only**             | Lifetime total number of ballots sent.
`token_gen_min` *int64*        | Minimum generation number of all tokens owned.
`token_gen_max` *int64*        | Maximum generation number of all tokens owned.
`grace_period` *int64* **baker-only**         | (delegate only) Current grace period before deactivation.
`rolls` *int64* **baker-only**                | (delegate only) Currently owned rolls.
`rich_rank` *int64*            | Global rank on rich list by total balance.
`traffic_rank` *int64*         | Global rank on 1D most active accounts by transactions sent/received.
`volume_rank` *int64*          | Global rank on 1D most active accounts by volume sent/received.
`last_bake_height` *int64* **baker-only**     | Height of most recent block baked.
`last_bake_block` *hash* **baker-only**       | Hash of most recent block baked.
`last_bake_time` *datetime* **baker-only**    | Timestamp of most recent block baked.
`last_endorse_height` *int64* **baker-only**  | Height of most recent block endorsed.
`last_endorse_block` *hash* **baker-only**    | Hash of most recent block endorsed.
`last_endorse_time` *datetime* **baker-only** | Timestamp of most recent block endorsed.
`next_bake_height` *int64* **baker-only**     | Height of next block baking right.
`next_bake_priority` *int64* **baker-only**   | Priority of next baking right (fixed at zero currently).
`next_bake_time` *datetime* **baker-only**    | Approximate time of next block baking right.
`next_endorse_height` *int64* **baker-only**  | Height of next block endorsing right.
`next_endorse_time` *datetime* **baker-only** | Approximate time of next block endorsing right.
`avg_luck_64` *float* **baker-only**          | Average luck to get random priority zero baking/endorsing rights for the past 64 cycles (182 days, 6 months).
`avg_performance_64` *float* **baker-only**   | Average performance for the past 64 cycles (182 days, 6 months).
`avg_contribution_64` *float* **baker-only**  | Average utilization of rights to bake/endorse blocks for the past 64 cycles. Since block rewards have become dynamic, a baker who fails to contribute to the consensus by utilizing 100% of their rights diminishes the income for other bakers.
`baker_version` *hash* **baker-only**         | Software version run by the baker at the last seen block. This is the first 8 hex digits of the Git repository hash.

### List Account Operations

`GET https://api.tzstats.com/explorer/account/{hash}/operations`

Lists operations sent from and to an account (defaults to all types and ascending order). This endpoint supports pagination with `limit`, `offset` and `cursor`. Use `type` to [filter](#query-filters) for a specific operation type (e.g. transaction), `block` (int64|hash) to lock a call to a specific block height or hash (hash is reorg-aware and throws an error when block has become orphan). To query for updates after a certain block use the optional argument `since` (int64|hash). To change the order of returned calls use the optional `order` (asc|desc) parameter.

### List Managed and Created Contracts

`GET https://api.tzstats.com/explorer/account/{hash}/managed`

Lists all contracts this account has originated.

### List Account Ballots

`GET https://api.tzstats.com/explorer/account/{hash}/ballots`

Lists all voting ballots the account has sent. This applies to bakers only.


## Bigmaps

Bigmaps are key-value stores where smart contracts can store large amounts of data. Values in bigmaps are accessed by unique keys. The TzStats bigmap index supports different key encodings: a **hash** (script expression hash), the **binary** representation of a key and the **native** typed version of a key. For convenience, all three variants are present in responses as `key_hash`, `key_binary` and `key`.

**Types** A bigmap is defined by a `key_type` and a `value_type`. While the key type is most often a simple type (int, string, bytes, address, etc), the value can have a complex type structure. Complex keys (using pairs) are represented as JSON primitive tree and a collapsed stringified version of such keys is returned in the optional `key_pretty` field. Values are represented in unboxed (decoded) form and optionally as original Michelson primitives.

**Unboxing** The API supports a mix of multiple representations for keys and values. Per default only **decoded keys** (as hash, binary, and native) and **unboxed values** are returned. Unboxing uses the types and annotations defined on contract origination to decompose Michelson primitives into nested JSON objects where annotations become JSON property names. Use the optional request parameter `prim` (bool) to include the native Michelson value representation (a tree of primitives).

**Packed Data** When keys or values are **packed** using the `PACK` instruction, an unpacked version can be obtained when using the optional `unpack` (bool) query argument. In this case two additional properties `key_unpacked` and `value_unpacked` are added to the result.

**Metadata** Each bigmap entry comes with a set of **metadata** that describes latest update time, block hash and height as well as the bigmap id and its owner. Bigmap ownership is 1:N, ie. a smart contract can own multiple bigmaps, but each bigmap has only one owner.

**Pagination** The Bigmap API support paginated queries for keys, values and updates using `limit` and `offset`.

**Time-lock** To query a bigmap at a certain point in time (ie. a specific block) use the optional query argument `block` (int64|hash) to specify a height or block hash. Hash is reorg-aware, ie. in case you execute a query on a block that becomes orphaned, the API returns a 409 Conflict error. To query for updates after a certain block use the optional argument `since` (int64|hash).

### **SECURITY WARNING**

Unlike other on-chain data where values and ranges are predictable the contents of bigmaps are entirely user-controlled and unpredictable. IT MAY CONTAIN MALICIOUS DATA INTENDED TO ATTACK YOUR APPLICATIONS AND USERS! Be vigilant and sanitize all data before you process or display it.


### Bigmap Metadata

> **Example request.**

```shell
curl "https://api.tzstats.com/explorer/bigmap/1"
```

> **Example response.**

```json
{
  "contract": "KT1R3uoZ6W1ZxEwzqtv75Ro7DhVY6UAcxuK2",
  "bigmap_id": 1,
  "n_updates": 0,
  "n_keys": 0,
  "alloc_height": 5938,
  "alloc_block": "BLCpcCQhYrqMSgAY9vdnAXPXmswBizTJbVAj9yWSXfbUGhXzd3z",
  "alloc_time": "2018-07-04T20:59:27Z",
  "update_height": 5938,
  "update_block": "BLCpcCQhYrqMSgAY9vdnAXPXmswBizTJbVAj9yWSXfbUGhXzd3z",
  "update_time": "2018-07-04T20:59:27Z"
}
```

Returns metadata about a bigmap.

### HTTP Request

`GET https://api.tzstats.com/explorer/bigmap/{id}`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`contract` *hash*        | Contract that owns the bigmap.
`bigmap_id` *int64*      | Unique on-chain id of this bigmap.
`n_updates` *int64*      | Total update count.
`n_keys` *int64*         | Current number of keys in bigmap.
`alloc_height` *int64*   | Height when the bigmap was allocated.
`alloc_block` *hash*     | Hash of the block where the bigmap was allocated.
`alloc_time` *datetime*  | Timestamp when the bigmap was allocated.
`update_height` *int64*  | Last update height.
`update_block` *hash*    | Hash of the block containing the latest update.
`update_time` *datetime* | Last update timestamp.

### Bigmap Type

> **Example request.**

```shell
curl "https://api.tzstats.com/explorer/bigmap/17/type"
```

> **Example response.**

```json
{
  "contract": "KT1ChNsEFxwyCbJyWGSL3KdjeXE28AY1Kaog",
  "bigmap_id": 17,
  "key_type": "key_hash",
  "key_encoding": "bytes",
  "value_type": {
    "0@data@option": {
      "0@bakerName": "bytes",
      "1@openForDelegation": "bool",
      "2@bakerOffchainRegistryUrl": "bytes",
      "3@split": "nat",
      "4@bakerPaysFromAccounts@list": {
        "0": "address"
      },
      "5@minDelegation": "nat",
      "6@subtractPayoutsLessThanMin": "bool",
      "7@payoutDelay": "int",
      "8@payoutFrequency": "nat",
      "9@minPayout": "int",
      "10@bakerChargesTransactionFee": "bool",
      "11@paymentConfigMask": "nat",
      "12@overDelegationThreshold": "nat",
      "13@subtractRewardsFromUninvitedDelegation": "bool"
    },
    "1@reporterAccount@option": "address",
    "2@last_update": "timestamp"
  },
  "prim": {
    // ...
  }
}
```

Returns bigmap type description in Michelson JSON format, both for keys and values. Keys are simple scalar types and values can have a simple or complex type. JSON keys for bigmap type arguments now always follow the convention `<order>@<name>@<container-type>`, ie. they include an integer order number as first argument (starting at zero), followed by an optional `@` symbol, an optional name extracted from type annotations and in case the type is a container like list, map or set another `@` and the container type. JSON value contains a string with the michelson type name (if scalar) or a JSON object describing the nested type following the same naming conventions. Use `prim` (boolean) to embed original Michelson primitives for key and value type definitions.

### HTTP Request

`GET https://api.tzstats.com/explorer/bigmap/{id}/type`

### HTTP Response


Field              | Description
-------------------|--------------------------------------------------
`contract` *hash*      | Contract that owns the bigmap.
`bigmap_id` *int64*    | Unique on-chain id of this bigmap.
`key_type` *object*    | Michelson type for keys (i.e. any comparable Michelson type) as JSON encoded Michelson primitives.
`key_encoding` *enum*  | Encoding used for keys (e.g. `string`, `bytes`, `int`).
`value_type` *object*  | Unboxed Michelson type for values as JSON encoded Michelson primitives.
`prim` *object*        | Native JSON encoded Michelson primitives (optional, use `prim=true` to enable).


### List Bigmap Keys

> **Example request.**

```shell
curl "https://api.tzstats.com/explorer/bigmap/12/keys"
```

> **Example response.**

```json
[[
  {
    "key": "0501000000044e4c4576",
    "key_hash": "exprtxcQXJiJWzb5PvjHzkf2LKvnvmbvKdNDSvWzegiTMAKsvTgijL",
    "key_binary": "0501000000044e4c4576",
    "key_unpacked": "NLEv",
    "key_pretty": "NLEv",
    "meta": {
      "contract": "KT1NQfJvo9v8hXmEgqos8NP7sS8V4qaEfvRF",
      "bigmap_id": 12,
      "time": "2019-10-25T16:37:56Z",
      "height": 665512,
      "block": "BKucUF1pxUv7JsrmKoLhmoXeoAzBvKUdZA7PVXEEUACyE7PR6qa",
      "is_replaced": false,
      "is_removed": false
    },
    "prim": {
      "prim": "bytes"
    }
  },
  // ...
]
```

Lists bigmap keys only. Supports paging with `limit` and `offset` and locking calls to a specific `block` height (int64) or hash (hash). Use `prim` (boolean) to embed original Michelson primitives and `unpack` (boolean) to unpack packed keys.

### HTTP Request

`GET https://api.tzstats.com/explorer/bigmap/{id}/keys`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`key` *polymorph*     | The native representation of the key. Integers are bigints wrapped in strings, other types are rendered according to type rules, e.g. addresses, keys and signatures are base58check encoded, timestamps are ISO8601, etc. Can be used for lookup.
`key_hash` *hash*     | The script expression hash for this key. Can be used for lookup.
`key_binary` *string* | Hex string containing the binary representation of the key as stored on-chain. Can be used for lookup.
`key_unpacked` *polymorph* | Unpacked version of the key as Michelson primitives (Pair keys only) or scalar type (all other types). Optional, enable with `unpack=true`. Cannot be used for lookup.
`key_pretty` *string*  | Prettified version of complex (Pair) keys where all elements are concatenated using `#`. Same as `key` or `key_unpacked` otherwise. Cannot be used for lookup.
`meta` *object*        | Metadata for the current bigmap entry.
  `meta.contract` *hash*    | Contract that owns the bigmap.
  `meta.bigmap_id` *int64*  | Unique on-chain id of this bigmap.
  `meta.time` *datetime*    | Update timestamp for this key/value pair.
  `meta.height` *int64*     | Update height for this key/value pair.
  `meta.block` *hash*       | Hash of the block containing the latest update.
  `meta.is_replaced` *bool* | Flag indicating if a future update has overwritten the current value. Useful in combination with the `block` parameter that allows to query a value at a fixed block in history.
  `meta.is_removed` *bool* | Flag indicating if a future remove action has deleted the current key. Useful in combination with the `block` parameter that allows to query a value at a fixed block in history.
`prim` *object*        | Native JSON encoded Michelson primitives (optional, use `prim=true` to enable).


### List Bigmap Keys and Values

> **Example request.**

```shell
curl "https://api.tzstats.com/explorer/bigmap/382/values"
```

> **Example response.**

```json
[
  {
    "key": "0501000000044e4c4576",
    "key_hash": "exprtxcQXJiJWzb5PvjHzkf2LKvnvmbvKdNDSvWzegiTMAKsvTgijL",
    "key_binary": "0501000000044e4c4576",
    "key_unpacked": "NLEv",
    "key_pretty": "NLEv",
    "value": {
      "0@bytes": "050000"
    },
    "value_unpacked": "0",
    "meta": {
      "contract": "KT1NQfJvo9v8hXmEgqos8NP7sS8V4qaEfvRF",
      "bigmap_id": 12,
      "time": "2019-10-25T16:37:56Z",
      "height": 665512,
      "block": "BKucUF1pxUv7JsrmKoLhmoXeoAzBvKUdZA7PVXEEUACyE7PR6qa",
      "is_replaced": false,
      "is_removed": false
    },
    "prim": {
      "key": {
        "bytes": "0501000000044e4c4576"
      },
      "value": {
        "bytes": "050000"
      }
    }
  },
  // ...
]
```

Lists key/value pairs contained in bigmap. This endpoint supports paging with `limit` and `offset` and also allows locking paginated calls to a specific `block` height (int64) or hash (hash). Use `prim` (boolean) to embed original Michelson primitives and `unpack` (boolean) to unpack packed keys and values.

### HTTP Request

`GET https://api.tzstats.com/explorer/bigmap/{id}/values`

Lists all values contained in the bigmap at present time, ie. at blockchain head. Can return bigmap contents at a specific block in the past using the optional parameter `block` height (int64) or hash (hash).

`GET https://api.tzstats.com/explorer/bigmap/{id}/{key}`

Returns a single bigmap value stored at `key`. Key can be a **key hash** (script expr hash), the **native** key representation (i.e. an address or integer) or the **encoded** binary version of the key. Use the optional `block` height (int64) or hash (hash) parameter to lookup the key's value at a specific block in the past.

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`key` *polymorph*     | The native representation of the key. Integers are bigints wrapped in strings, other types are rendered according to type rules, e.g. addresses, keys and signatures are base58check encoded, timestamps are ISO8601, etc).
`key_hash` *hash*     | The script expression hash for this key.
`key_binary` *string* | Hex string containing the binary representation of the key as stored on-chain.
`key_unpacked` *polymorph* | Unpacked version of the key as Michelson primitives (Pair keys only) or scalar type (all other types). Optional, enable with `unpack=true`.
`key_pretty` *string*  | Prettified version of complex (Pair) keys where all elements are concatenated using `#`. Same as `key` or `key_unpacked` otherwise.
`value` *object*       | Unboxed version of the bigmap value, either a simple value or complex nested structure using scalar types, lists, sets, maps, and bigmaps.
`value_unpacked` *object*  | An unpacked version of any packed binary data contained in the value. This can be a scalar type or a Michelson primitive tree if the type is complex such as lambda, pair, etc.
`meta` *object*        | Metadata for the current bigmap entry.
  `meta.contract` *hash*    | Contract that owns the bigmap.
  `meta.bigmap_id` *int64*  | Unique on-chain id of this bigmap.
  `meta.time` *datetime*    | Update timestamp for this key/value pair.
  `meta.height` *int64*     | Update height for this key/value pair.
  `meta.block` *hash*       | Hash of the block containing the latest update.
  `meta.is_replaced` *bool* | Flag indicating if a future update has overwritten the current value. Useful in combination with the `block` parameter that allows to query a value at a fixed block in history.
  `meta.is_removed` *bool* | Flag indicating if a future remove action has deleted the current key. Useful in combination with the `block` parameter that allows to query a value at a fixed block in history.
`prim` *object*    | Native Michelson JSON encoded value as prim tree. Optional, use `prim` to enable.


### List Bigmap Updates

> **Example request.**

```shell
curl "https://api.tzstats.com/explorer/bigmap/382/updates"
```

> **Example response.**

```json
[
  {
    "action": "update",
    "key": "0501000000044e4c4576",
    "key_hash": "exprtxcQXJiJWzb5PvjHzkf2LKvnvmbvKdNDSvWzegiTMAKsvTgijL",
    "key_binary": "0501000000044e4c4576",
    "key_unpacked": "NLEv",
    "key_pretty": "NLEv",
    "value": {
      "0@bytes": "050000"
    },
    "value_unpacked": "0",
    "meta": {
      "contract": "KT1NQfJvo9v8hXmEgqos8NP7sS8V4qaEfvRF",
      "bigmap_id": 12,
      "time": "2019-10-25T16:37:56Z",
      "height": 665512,
      "block": "BKucUF1pxUv7JsrmKoLhmoXeoAzBvKUdZA7PVXEEUACyE7PR6qa",
      "is_replaced": false,
      "is_removed": false
    },
    "prim": {
      "key": {
        "bytes": "0501000000044e4c4576"
      },
      "value": {
        "bytes": "050000"
      }
    }
  }
]
```

List historic updates to a bigmap in chronological order, including keys that have been deleted. Returns an array of objects. This endpoint supports paging with `limit` and `offset`. Use the optional `since` (int64|hash) parameter to return updates newer or equal to a specific block. Use `prim` (boolean) to embed original Michelson primitives and `unpack` (boolean) to unpack packed keys and values.

### HTTP Request

`GET https://api.tzstats.com/explorer/bigmap/{id}/updates`

Lists all updates across the entire bigmap.

`GET https://api.tzstats.com/explorer/bigmap/{id}/{key}/updates`

Lists updates for a specific key. Key can be a key hash (script expr hash), the native key representation (i.e. an address or integer) or the encoded binary version.


### HTTP Response

Contains the same fields as the values endpoint above with one addition:


Field              | Description
-------------------|--------------------------------------------------
`action` *enum*    | Update kind, one of `alloc`, `update`, `remove`, `copy`.



## Blocks

> **Example request.**

```shell
curl "https://api.tzstats.com/explorer/block/627341"
```

> **Example response.**

```json
{
  "hash": "BKqv8SBNabXEMXV9fsy21yx9BNsqWBKVVp9ca4KTMpGsF2Wi8Uj",
  "predecessor": "BKr3kjkbi5LndjDTDDSPUWubZjrdSBCWLJudmuGYuiVuG2j8fvj",
  "successor": "BLWT4x43zqzbtRzWNShkuU1DaTjU9fX34Qs4V3Hku2ZgYxiEpPW",
  "baker": "tz1SxEdtfkFChtqioi96hvMfisj4mt744rXi",
  "height": 627341,
  "cycle": 153,
  "is_cycle_snapshot": false,
  "time": "2019-09-28T13:10:51Z",
  "solvetime": 60,
  "version": 4,
  "validation_pass": 4,
  "fitness": 19846425,
  "priority": 0,
  "nonce": 16299522299,
  "voting_period_kind": "promotion_vote",
  "endorsed_slots": 4294967295,
  "n_endorsed_slots": 32,
  "n_ops": 28,
  "n_ops_failed": 0,
  "n_ops_contract": 0,
  "n_tx": 1,
  "n_activation": 0,
  "n_seed_nonce_revelations": 0,
  "n_double_baking_evidences": 0,
  "n_double_endorsement_evidences": 0,
  "n_endorsement": 26,
  "n_delegation": 0,
  "n_reveal": 1,
  "n_origination": 0,
  "n_proposal": 0,
  "n_ballot": 0,
  "volume": 2047.9,
  "fee": 0.01142,
  "reward": 16,
  "deposit": 512,
  "unfrozen_fees": 0,
  "unfrozen_rewards": 0,
  "unfrozen_deposits": 0,
  "activated_supply": 0,
  "burned_supply": 0,
  "n_accounts": 30,
  "n_new_accounts": 0,
  "n_new_implicit": 0,
  "n_new_managed": 0,
  "n_new_contracts": 0,
  "n_cleared_accounts": 0,
  "n_funded_accounts": 0,
  "gas_limit": 20400,
  "gas_used": 20200,
  "gas_price": 0.56535,
  "storage_size": 0,
  "days_destroyed": 203.367847,
  "pct_account_reuse": 100,
  "n_ops_implicit": 1,
  "endorsers": [
    "tz3bvNMQ95vfAYtG8193ymshqjSvmxiCUuR5",
    "tz1PeZx7FXy7QRuMREGXGxeipb24RsMMzUNe",
    "tz3bTdwZinP8U1JmSweNzVKhmwafqWmFWRfk",
    "tz1bLwpPfr3xqy1gWBF4sGvv8bLJyPHR11kx",
    "tz3NExpXn9aPNZPorRE4SdjJ2RGrfbJgMAaV",
    "tz1bHzftcTKZMTZgLLtnrXydCm6UEqf4ivca",
    "tz3RB4aoyjov4KEVRbuhvQ1CKJgBJMWhaeB8",
    "tz3UoffC7FG7zfpmvmjUmUeAaHvzdcUvAj6r",
    "tz1TzaNn7wSQSP5gYPXCnNzBCpyMiidCq1PX",
    "tz1VmiY38m3y95HqQLjMwqnMS7sdMfGomzKi",
    "tz1PesW5khQNhy4revu2ETvMtWPtuVyH2XkZ",
    "tz3NExpXn9aPNZPorRE4SdjJ2RGrfbJgMAaV",
    "tz1Ldzz6k1BHdhuKvAtMRX7h5kJSMHESMHLC",
    "tz1Xek93iSXXckyQ6aYLVS5Rr2tge2en7ZxS",
    "tz1NpWrAyDL9k2Lmnyxcgr9xuJakbBxdq7FB",
    "tz1bHzftcTKZMTZgLLtnrXydCm6UEqf4ivca",
    "tz1TzaNn7wSQSP5gYPXCnNzBCpyMiidCq1PX",
    "tz3WMqdzXqRWXwyvj5Hp2H7QEepaUuS7vd9K",
    "tz1c5vSjZDMsgx7NCQapHjmSM5Wv9bjbwP9B",
    "tz3bvNMQ95vfAYtG8193ymshqjSvmxiCUuR5",
    "tz3WMqdzXqRWXwyvj5Hp2H7QEepaUuS7vd9K",
    "tz1aJS7Pk9uWR3wWyFf1i3RwhYxN84G7stom",
    "tz1TzaNn7wSQSP5gYPXCnNzBCpyMiidCq1PX",
    "tz3WMqdzXqRWXwyvj5Hp2H7QEepaUuS7vd9K",
    "tz1LH4L6XYT2JNPhvWYC4Zq3XEiGgEwzNRvo",
    "tz1NpWrAyDL9k2Lmnyxcgr9xuJakbBxdq7FB",
    "tz1Vd1rXpV8hTHbFXCXN3c3qzCsgcU5BZw1e",
    "tz1NortRftucvAkD1J58L32EhSVrQEWJCEnB",
    "tz1Vd1rXpV8hTHbFXCXN3c3qzCsgcU5BZw1e",
    "tz2TSvNTh2epDMhZHrw73nV9piBX7kLZ9K9m",
    "tz1TaLYBeGZD3yKVHQGBM857CcNnFFNceLYh",
    "tz1abTjX2tjtMdaq5VCzkDtBnMSCFPW2oRPa"
  ]
}
```

Fetches information about the specified block. Takes either a block `hash`, a block `height` or the string `head` as argument.

### HTTP Request

`GET https://api.tzstats.com/explorer/block/{hash,height,head}`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`hash` *hash*                | Block hash.
`predecessor` *hash*         | Parent block on canonical chain or orphan side-chain.
`successor` *hash*           | Child block on canonical chain or orphan side-chain.
`baker` *hash*               | Baker address.
`height` *int64*             | Block height (a.k.a level).
`cycle` *int64*              | Cycle
`is_cycle_snapshot` *bool*   | True if this block has been selected as snapshot.
`time` *datetime*            | Block creation time.
`solvetime` *duration*       | Time since last block in seconds.
`version` *int64*              | Protocol version.
`validation_pass` *int64*      | Block validation pass.
`fitness` *int64*              | Block fitness used to determine longest chain.
`priority` *int64*             | Baking priority.
`nonce` *uint64*               | Block nonce
`voting_period_kind` *enum*    | Current voting period `proposal`, `testing_vote`, `testing`, `promotion_vote`.
`endorsed_slots` *uint64*      | 32bit big-endian bitmask indicating which slots have been endorsed. (Note this field will be set from endorsements published in the subsequent block.)
`n_endorsed_slots` *int64*     | Count of endorsed slots. (Note this field will be set from endorsements published in the subsequent block.)
`n_ops` *int64*                | Count of operations contained in this block.
`n_ops_failed` *int64*         | Count of failed operations.
`n_ops_contract` *int64*       | Count of smart contract operations (transactions sent to contracts and internal operations sent by contracts).
`n_ops_implicit` *int64*       | Count of implicit events, ie. operations and state changes that don't have an operation hash such as `bake`, `unfreeze`, `seed_slash`, `airdrop` and `invoice`.
`n_tx` *int64*                 | Count of `transaction` operations.
`n_activation` *int64*         | Count of `activate_account` operations.
`n_seed_nonce_revelation` *int64*  | Count of `seed_nonce_revelation` operations.
`n_double_baking_evidence` *int64* | Count of `double_baking_evidence` operations.
`n_double_endorsement_evidence` *int64* | Count of `double_endorsement_evidence` operations.
`n_endorsement` *int64*        | Count of `endorsement` operations.
`n_delegation` *int64*         | Count of `delegation` operations.
`n_reveal` *int64*             | Count of `reveal` operations.
`n_origination` *int64*        | Count of `origination` operations.
`n_proposal` *int64*           | Count of `proposals` operations.
`n_ballot` *int64*             | Count of `ballot` operations.
`volume` *money*             | Total amount of tokens moved between accounts.
`fee` *money*                | Total fee paid (and frozen) by all operations.
`reward` *money*             | Reward earned (and frozen) by the block baker.
`deposit` *money*            | Deposit frozen by the block baker.
`unfrozen_fees` *money*      | Total unfrozen fees (at end of a cycle).
`unfrozen_rewards` *money*   | Total unfrozen rewards (at end of a cycle).
`unfrozen_deposits` *money*  | Total unfrozen deposits (at end of a cycle).
`activated_supply` *money*   | Total amount of commitments activated in tz.
`burned_supply` *money*      | Total amount of tokens burned by operations in tz.
`n_accounts` *int64*           | Count of accounts seen in this block (i.e. this includes all operation senders, receivers, delegates and the block's baker).
`n_new_accounts` *int64*       | Count of new accounts created regardless of type.
`n_new_implicit` *int64*       | Count of created implicit accounts (tz1/2/3).
`n_new_managed` *int64*        | Count of created managed accounts (KT1 without code or manager.tz script).
`n_new_contracts` *int64*      | Count of created smart contracts (KT1 with code).
`n_cleared_accounts` *int64*   | Count of accounts that were emptied (final balance = 0).
`n_funded_accounts` *int64*    | Count of accounts that were funded by operations (this includes all new accounts plus previously cleared accounts that were funded again).
`gas_limit` *int64*            | Total gas limit defined by operations.
`gas_used` *int64*             | Total gas consumed by operations.
`gas_price` *float*            | Average price of one gas unit in mutez.
`storage_size` *int64*         | Total sum of new storage allocated by operations.
`days_destroyed` *float*       | Token days destroyed (`tokens transferred * token idle time`).
`pct_account_reuse` *float*    | Portion of seen accounts that existed before.
`endorsers` *array[hash]*      | List of delegates with rights to endorse this block in slot order.


### List Block Operations

> Example request to list block operations.

```shell
curl "https://api.tzstats.com/explorer/block/head/operations"
```

> **Example response.**

```json
[
  {
    "row_id": 4998272,
    "hash": "",
    "type": "bake",
    "block": "BLWyvBDjfUPKdSf4PQYVvNmHqgwNccH3uRnb6CK9Rzyfr5vCwL1",
    "time": "2018-12-15T09:24:47Z",
    "height": 228352,
    "cycle": 55,
    "counter": 0,
    "op_n": 0,
    "op_l": -1,
    "op_p": 0,
    "op_c": 0,
    "op_i": 0,
    "status": "applied",
    "is_success": true,
    "is_contract": false,
    "gas_limit": 0,
    "gas_used": 0,
    "gas_price": 0,
    "storage_limit": 0,
    "storage_size": 0,
    "storage_paid": 0,
    "volume": 0,
    "fee": 0.002,
    "reward": 16,
    "deposit": 440,
    "burned": 0,
    "is_internal": false,
    "has_data": false,
    "days_destroyed": 0,
    "sender": "tz1Vm5cfHncKGBo7YvZfHc4mmudY4qpWzvSB",
    "receiver": "tz1Vm5cfHncKGBo7YvZfHc4mmudY4qpWzvSB",
    "branch_id": 0,
    "branch_height": 0,
    "branch_depth": 0,
    "branch": "",
    "is_implicit": true,
    "entrypoint_id": 0,
    "is_orphan": false,
    "is_batch": false
  },
  {
    "row_id": 4998273,
    "hash": "ooUeBLdSuEpdVxUKSNo8hVjjRa2eTVDPTbFYSaUFae8h6vBcHMV",
    "type": "endorsement",
    "block": "BLWyvBDjfUPKdSf4PQYVvNmHqgwNccH3uRnb6CK9Rzyfr5vCwL1",
    "time": "2018-12-15T09:24:47Z",
    "height": 228352,
    "cycle": 55,
    "counter": 0,
    "op_n": 1,
    "op_l": 0,
    "op_p": 0,
    "op_c": 0,
    "op_i": 0,
    "status": "applied",
    "is_success": true,
    "is_contract": false,
    "gas_limit": 0,
    "gas_used": 0,
    "gas_price": 0,
    "storage_limit": 0,
    "storage_size": 0,
    "storage_paid": 0,
    "volume": 0,
    "fee": 0,
    "reward": 2,
    "deposit": 55,
    "burned": 0,
    "is_internal": false,
    "has_data": true,
    "days_destroyed": 0,
    "data": "64",
    "sender": "tz1abTjX2tjtMdaq5VCzkDtBnMSCFPW2oRPa",
    "branch_id": 228352,
    "branch_height": 228351,
    "branch_depth": 1,
    "branch": "BLDpbGZpTefKV1eripBKuyVdDjHofXpyZE2amkHxt7dc6JPtMwJ",
    "is_implicit": false,
    "entrypoint_id": 0,
    "is_orphan": false,
    "is_batch": false
  },
  // ...
  ]
}
```

Returns a list of operations in the corresponding block. Use `limit`, `offset` and/or `cursor` (all integers) to page through operation lists. Operations are sorted by row_id in ascending order. Cursor is the last row_id in sort order you have seen. Use `order` to switch between `asc` or `desc` order. Allows filtering operations by `type` using [query filters](#query-filters).

The result contains information about all events that happen on-chain. Some of these events are signed operations with a proper operation hash, others are implicit events that have no corresponding representation, but are still required to correctly reconcile account balances and on-chain state/relationships. Important examples for implicit events are `bake` and `unfreeze` which change balances of bakers on their sub-accounts.

### HTTP Request

#### List Block Operations

`GET https://api.tzstats.com/explorer/block/{hash,height,head}/operations`



## Blockchain Config

> **Example request.**

```shell
curl "https://api.tzstats.com/explorer/config/head"
```

> **Example response.**

```json
{
  "name": "Tezos",
  "network": "Mainnet",
  "symbol": "XTZ",
  "chain_id": "NetXdQprcVkpaWU",
  "deployment": 6,
  "version": 6,
  "protocol": "PsCARTHAGazKbHtnKfLzQg3kms52kSRpgnDY982a9oYsSXRLQEb",
  "start_height": 851969,
  "end_height": -1,
  "no_reward_cycles": 0,
  "security_deposit_ramp_up_cycles": 0,
  "decimals": 6,
  "units": 1000000,
  "block_reward": 40,
  "block_security_deposit": 512,
  "blocks_per_commitment": 32,
  "blocks_per_cycle": 4096,
  "blocks_per_roll_snapshot": 256,
  "blocks_per_voting_period": 32768,
  "cost_per_byte": 1000,
  "endorsement_reward": 1.25,
  "endorsement_security_deposit": 64,
  "endorsers_per_block": 32,
  "hard_gas_limit_per_block": 10400000,
  "hard_gas_limit_per_operation": 1040000,
  "hard_storage_limit_per_operation": 60000,
  "max_operation_data_length": 16384,
  "max_proposals_per_delegate": 20,
  "max_revelations_per_block": 32,
  "michelson_maximum_type_size": 1000,
  "nonce_length": 32,
  "origination_burn": 0,
  "origination_size": 257,
  "preserved_cycles": 5,
  "proof_of_work_nonce_size": 8,
  "proof_of_work_threshold": 70368744177663,
  "seed_nonce_revelation_tip": 0.125,
  "time_between_blocks": [
    60,
    40
  ],
  "tokens_per_roll": 8000,
  "test_chain_duration": 1966080,
  "min_proposal_quorum": 500,
  "quorum_min": 2000,
  "quorum_max": 7000,
  "block_rewards_v6": [
    1.25,
    0.1875
  ],
  "endorsement_rewards_v6": [
    1.25,
    0.833333
  ]
}
```

Fetches blockchain configuration parameters. This endpoint accepts `head` and a block `height` as path parameters, so you can access configurations of past protocols as well.


### HTTP Request

`GET https://api.tzstats.com/explorer/config/head`


### HTTP Response

The response contains most of the configuration fields of a regular Tezos blockchain node, enriched with some additional contextual data.

Field                        | Description
-----------------------------|--------------------------------------------------
`name` *string*              | Blockchain name (`Tezos`).
`symbol` *string*            | Ticker symbol (`XTZ`).
`network` *string*           | Network name (e.g. `Mainnet`, `Zeronet`, `Babylonnet`, `Labnet`, `Sandbox`).
`chain_id` *hash*            | Chain hash.
`version` *int64*            | Protocol version number.
`deployment` *int64*         | Number of deployed protocols on this network.
`protocol` *hash*            | Protool hash.
`start_height` *int64*         | Activation height of the protocol.
`end_height` *int64*               | Deactivation height of the protocol (0 if undefined).
`no_reward_cycles` *int64*            | Number of initial cycles that pay no block rewards.
`security_deposit_ramp_up_cycles` *int64*  | Number of initial cycles before full deposits are required.
`decimals` *int64*                         | Decimal points of one coin unit.
`units` *int64*                            | Number of atomic units in one coin (i.e. mutez).
`block_reward` *money*                     | Block baking reward in tz.
`block_security_deposit` *money*           | Baker security deposit in tz.
`blocks_per_commitment` *int64*            | Number of blocks between seed nonce commitments.
`blocks_per_cycle` *int64*                 | Number of blocks per consensus cycle.
`blocks_per_roll_snapshot` *int64*         | Number of blocks between roll snapshots.
`blocks_per_voting_period` *int64*         | Number of blocks per voting period.
`cost_per_byte` *int64*                    | Gas costs per data byte.
`endorsement_reward` *money*               | Block endorsing reward per slot in tz.
`endorsement_security_deposit` *money*     | Endorser security deposit per slot in tz.
`endorsers_per_block` *int64*              | Max number of endorsing slots.
`hard_gas_limit_per_block` *int64*         | Max gas limit per block.
`hard_gas_limit_per_operation` *int64*     | Max gas limit per single operation.
`hard_storage_limit_per_operation` *int64* | Max gas limit for storage spent be an operation.
`max_operation_data_length` *int64*        | Max data bytes per operation.
`max_proposals_per_delegate` *int64*       | Max proposals per single delegate and proposals operation.
`max_revelations_per_block` *int64*        | Maximum number of seed nonce revelation operations per block.
`michelson_maximum_type_size` *int64*      | Maximum type size michelson type definition.
`nonce_length` *int64*                     | Nonce length
`origination_burn` *money*                 | Amount of Tezos burned per origination.
`origination_size` *int64*                 | Origination storage requirement in bytes.
`preserved_cycles` *int64*                 | Number of cycles for freezing security deposits and rewards.
`proof_of_work_nonce_size` *int64*         | Nonce size for P2P messages.
`proof_of_work_threshold` *int64*          | Threshold for message nonce complexity.
`seed_nonce_revelation_tip` *money*        | Rewards for publishing a seed nonce.
`time_between_blocks` *array[int64]*       | Target time between blocks in seconds.
`tokens_per_roll` *int64*                  | Amount of Tezos per roll.
`test_chain_duration` *int64*              | Test chain lifetime in seconds.
`min_proposal_quorum` *int64*              | (Babylon, v005) Minimum quorum to accept proposals in centile (i.e. 5% = 500).
`quorum_min` *int64*                       | (Babylon, v005) Minimum threshold for voting period quorum in centile.
`quorum_max` *int64*                       | (Babylon, v005) Maximum threshold for voting period quorum in centile.
`block_reward_v6` *[2]money*               | (Carthage, v006) Block reward per included endorsement for prio 0 blocks [0] or >prio 0 blocks [1].
`endorsement_reward_v6` *[2]money*         | (Carthage, v006) Reward per endorsement for a prio 0 block [0] or >prio 0 block [1].


## Blockchain Tip

> **Example request.**

```shell
curl "https://api.tzstats.com/explorer/tip"
```

> **Example response.**

```json
{
  "name": "Tezos",
  "network": "Mainnet",
  "symbol": "XTZ",
  "chain_id": "NetXdQprcVkpaWU",
  "genesis_time": "2018-06-30T16:07:32Z",
  "block_hash": "BLatWAoqAdnrVGg84P5JjmBd94mhJTP2EH1RcKwvU4NY9oc18Ud",
  "timestamp": "2020-06-25T12:01:04Z",
  "height": 1012215,
  "cycle": 247,
  "deployments": [
    {
      "protocol": "PrihK96nBAFSxVL1GLJTVhu9YnzkMFiBeuJRPA8NwuZVZCE1L6i",
      "version": -1,
      "deployment": -1,
      "start_height": 0,
      "end_height": 0
    },
    {
      "protocol": "Ps9mPmXaRzmzk35gbAYNCAw6UXdE2qoABTHbN2oEEc1qM7CwT9P",
      "version": 0,
      "deployment": 0,
      "start_height": 1,
      "end_height": 1
    },
    {
      "protocol": "PtCJ7pwoxe8JasnHY8YonnLYjcVHmhiARPJvqcC6VfHT5s8k8sY",
      "version": 1,
      "deployment": 1,
      "start_height": 2,
      "end_height": 28082
    },
    {
      "protocol": "PsYLVpVvgbLhAhoqAkMFUo6gudkJ9weNXhUYCiLDzcUpFpkk8Wt",
      "version": 2,
      "deployment": 2,
      "start_height": 28083,
      "end_height": 204761
    },
    {
      "protocol": "PsddFKi32cMJ2qPjf43Qv5GDWLDPZb3T3bF6fLKiF5HtvHNU7aP",
      "version": 3,
      "deployment": 3,
      "start_height": 204762,
      "end_height": 458752
    },
    {
      "protocol": "Pt24m4xiPbLDhVgVfABUjirbmda3yohdN82Sp9FeuAXJ4eV9otd",
      "version": 4,
      "deployment": 4,
      "start_height": 458753,
      "end_height": 655360
    },
    {
      "protocol": "PsBabyM1eUXZseaJdmXFApDSBqj8YBfwELoxZHHW77EMcAbbwAS",
      "version": 5,
      "deployment": 5,
      "start_height": 655361,
      "end_height": 851968
    },
    {
      "protocol": "PsCARTHAGazKbHtnKfLzQg3kms52kSRpgnDY982a9oYsSXRLQEb",
      "version": 6,
      "deployment": 6,
      "start_height": 851969,
      "end_height": -1
    }
  ],
  "total_accounts": 637981,
  "funded_accounts": 581073,
  "total_ops": 26968187,
  "delegators": 54432,
  "delegates": 447,
  "rolls": 84176,
  "roll_owners": 423,
  "new_accounts_30d": 55305,
  "cleared_accounts_30d": 7591,
  "funded_accounts_30d": 58011,
  "inflation_1y": 40008551.634743,
  "inflation_rate_1y": 4.998041680321219,
  "health": 99,
  "supply": {
    "row_id": 1012216,
    "height": 1012215,
    "cycle": 247,
    "time": "2020-06-25T12:01:04Z",
    "total": 840493105.260388,
    "activated": 562049955.565323,
    "unclaimed": 49404922.844857,
    "vested": 46582751.428168,
    "unvested": 106280968.174352,
    "circulating": 734212137.086036,
    "delegated": 538761123.695065,
    "staking": 683877151.19962,
    "active_delegated": 533927971.023448,
    "active_staking": 674670384.951156,
    "inactive_delegated": 4833152.671617,
    "inactive_staking": 9206766.248464,
    "minted": 76426268.580089,
    "minted_baking": 19259188.538139,
    "minted_endorsing": 57162555.40963,
    "minted_seeding": 3924.625,
    "minted_airdrop": 600.00732,
    "burned": 251761.332401,
    "burned_double_baking": 114197.267834,
    "burned_double_endorse": 31838.219485,
    "burned_origination": 7715.422,
    "burned_implicit": 94244.588,
    "burned_seed_miss": 3765.835082,
    "frozen": 55126202.081035,
    "frozen_deposits": 53462976,
    "frozen_rewards": 1662378.415212,
    "frozen_fees": 847.665823
  },
  "status": {
    "status": "synced",
    "blocks": 1012215,
    "indexed": 1012215,
    "progress": 1
  }
}
```

Returns info about the most recent block, indexer status, protocol deployments and supply statistics.

### HTTP Request

`GET https://api.tzstats.com/explorer/tip`


### HTTP Response

Field                        | Description
-----------------------------|--------------------------------------------------
`name` *string*              | Blockchain name (`Tezos`).
`symbol` *string*            | Ticker symbol (`XTZ`).
`network` *string*           | Network name (e.g. `Mainnet`, `Zeronet`, `Babylonnet`, `Carthagenet`, `Sandbox`).
`chain_id` *hash*            | Chain hash.
`genesis_time` *datetime*    | Genesis block timestamp.
`block_hash` *hash*          | Current block hash.
`timestamp` *datetime*       | Current block timestamp.
`height` *int64*               | Current block height (level).
`cycle` *int64*                | Current cycle.
`total_accounts` *int64*       | Total number of on-chain accounts in existence.
`funded_accounts` *int64*      | Total number on funded (non-zero) accounts.
`total_ops` *int64*            | Total number of on-chain operations.
`delegators` *int64*           | Current number of delegators (updated each block).
`delegates` *int64*            | Current number of active delegates (updated each block).
`rolls` *int64*                | Current number of network-wide rolls (updated each block).
`roll_owners` *int64*          | Current number of network-wide roll owners (updated each block).
`new_accounts_30d` *int64*     | Accounts created during the past 30 days.
`cleared_accounts_30d` *int64* | Accounts emptied during the past 30 days.
`funded_accounts_30d` *int64*  | Accounts (re)funded (new and previously empty) during the past 30 days.
`inflation_1y` *money*       | Absolute inflation in tz.
`inflation_rate_1y` *float*  | Relative annualized inflation in percent.
`health` *int64*             | Blockchain and consensus health indicator with range [0..100] based on recent 128 blocks (priority, endorsements, reorgs).
`supply` *object*            | Coin supply statistics at current block height.
`status` *object*            | Indexer status, embedded for efficiency.
`deployments` *object*       | Protocol deployment information such as protocol hash, protocol version id, deployment order, start and end blocks. The most recent protocol deployment has -1 as end height.


## Contracts

> **Example request.**

```shell
curl "https://api.tzstats.com/explorer/contract/KT1QuofAgnsWffHzLA7D78rxytJruGHDe7XG"
```

> **Example response.**

```json
{
  "address": "KT1QuofAgnsWffHzLA7D78rxytJruGHDe7XG",
  "manager": "",
  "delegate": "tz3RDC3Jdn4j15J7bBHZd29EUee9gVB1CxD9",
  "height": 1,
  "op_l": 3,
  "op_p": 2,
  "op_i": 0,
  "fee": 0,
  "gas_limit": 0,
  "gas_used": 0,
  "gas_price": 0,
  "storage_limit": 0,
  "storage_size": 0,
  "storage_paid": 0,
  "is_funded": true,
  "is_vesting": true,
  "is_spendable": false,
  "is_delegatable": false,
  "is_delegated": true,
  "first_in": 30,
  "first_out": 30,
  "last_in": 30,
  "last_out": 30,
  "first_seen": 1,
  "last_seen": 30,
  "delegated_since": 1,
  "first_in_time": "2018-06-30T18:11:27Z",
  "first_out_time": "2018-06-30T18:11:27Z",
  "last_in_time": "2018-06-30T18:11:27Z",
  "last_out_time": "2018-06-30T18:11:27Z",
  "first_seen_time": "2018-06-30T17:39:57Z",
  "last_seen_time": "2018-06-30T18:11:27Z",
  "delegated_since_time": "2018-06-30T17:39:57Z",
  "n_ops": 3,
  "n_ops_failed": 0,
  "n_tx": 3,
  "n_delegation": 0,
  "n_origination": 0,
  "token_gen_min": 0,
  "token_gen_max": 0,
  "bigmap_ids": [],
  "iface_hash": "4ff4b751",
  "call_stats": [
    0,
    2
  ]
}
```

Returns metadata about the smart contract. For more details call the [explorer account endpoint](#accounts) using the contract's KT1 address. Separate calls support querying contract code, storage type and entrypoint specifications, storage contents and calls.


### **SECURITY WARNING**

Unlike other on-chain data where values and ranges are predictable the contents of **call parameters**, **storage keys/values** and **code/type annotations** is entirely user-controlled and unpredictable. IT MAY CONTAIN MALICIOUS DATA INTENDED TO ATTACK YOUR APPLICATIONS AND USERS! Be vigilant and sanitize all data before you process or display it.


### HTTP Request

`GET https://api.tzstats.com/explorer/contract/{hash}`


### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`address` *hash*   | Contract address.
`manager` *hash*   | Manager account (deprecated in v005 Babylon).
`delegate` *hash*  | Delegate (may be empty).
`height` *int64*     | Origination block height.
`op_l` *int64*           | Origination block operation list number (0..3).
`op_p` *int64*           | Origination block operation list position.
`op_i` *int64*           | Internal origination operation list position.
`fee` *money*           | Fee paid on contract origination.
`gas_limit` *int64*       | Gas limit on contract origination.
`gas_used` *int64*        | Gas used on contract origination.
`gas_price` *float*     | Gas price on contract origination.
`storage_limit` *int64*   | Storage limit defined on contract origination op.
`storage_size` *int64*    | Storage size allocated in bytes.
`storage_paid` *int64*    | Storage bytes paid for in bytes.
`is_funded` *bool*             | Flag indicating the contract is funded.
`is_vesting` *bool*            | Flag indicating the contract is a vesting contract.
`is_spendable` *bool*          | Flag indicating the contract balance is spendable.
`is_delegatable` *bool*        | Flag indicating the contract is delegatable.
`is_delegated` *bool*          | Flag indicating the contract is currently delegated.
`first_in` *int64*                  | Block height of first incoming transaction.
`first_out` *int64*                 | Block height of first outgoing transaction.
`last_in` *int64*                   | Block height of latest incoming transaction.
`last_out` *int64*                  | Block height of latest outgoing transaction.
`first_seen` *int64*                | Block height of account creation.
`last_seen` *int64*                 | Block height of last activity.
`delegated_since` *int64*           | Block height of most recent delegation.
`first_in_time` *datetime*        | Block time of first incoming transaction.
`first_out_time` *datetime*       | Block time of first outgoing transaction.
`last_in_time` *datetime*         | Block time of latest incoming transaction.
`last_out_time` *datetime*        | Block time of latest outgoing transaction.
`first_seen_time` *datetime*      | Block time of account creation.
`last_seen_time` *datetime*       | Block time of last activity.
`delegated_since_time` *datetime* | Block time of most recent delegation.
`n_ops` *int64*                  | Lifetime total number of operations sent and received.
`n_ops_failed` *int64*           | Lifetime total number of operations sent that failed.
`n_tx` *int64*                   | Lifetime total number of transactions sent and received.
`n_delegation` *int64*           | Lifetime total number of delegations sent.
`n_origination` *int64*          | Lifetime total number of originations sent.
`token_gen_min` *int64*        | Minimum generation number of all tokens owned.
`token_gen_max` *int64*        | Maximum generation number of all tokens owned.
`bigmap_ids` *[]int64*         | Array of bigmap ids owned by this contract.
`iface_hash` *bytes*           | Short hash to uniquely identify the contract interface, first 4 bytes of the SHA256 hash over binary encoded Michelson script parameters.
`call_stats` *array*           | Per-entrypoint call statistics, an integer array containing running totals for each entrypoint in id order.

### Related HTTP Requests

### Get Contract Script

`GET https://api.tzstats.com/explorer/contract/{hash}/script`

Returns the native Michelson JSON encoding of the deployed smart contract code as well as type specifications for call parameters, storage and bigmaps. Also contains decoded entrypoints and unboxed storage type.

JSON keys for entrypoint arguments always follow the convention `<order>@<name>`, ie. they include an integer order number as first argument, followed by an optional `@` symbol and an optional argument name extracted from type annotations.

### Unboxed Contract Script

> **Example script.**

```json
// ...
{
  "script": {
    "code": [
      //...
    ],
    "storage": {
      // ...
    },
  },
  "storage_type": {
    "0@big_map": {
      "0": "bytes",
      "1": "bytes"
    },
    "1": "address",
    "2": "nat"
  },
  "entrypoints": {
    "__entry_00__": {
      "id": 0,
      "branch": "LLR",
      "type": {
        "0": "string",
        "1": "bytes"
      },
      "prim": {
        // ...
      }
    },
    //...
  }
},
// ...
```

Field              | Description
-------------------|--------------------------------------------------
`script` *object*     | Native Michelson primitives from contract origination containing `code` with sub-primitives for parameter/entrypoint spec, storage spec and code as well as the initial `storage` content (hidden by default, enable with `prim=true`).
`storage_type` *object* | Unboxed storage spec using order and nesting defined in script. Uses type annotations for JSON property keys if available and a position number otherwise. Complex types like maps, lists, sets, lambda use keys of form `{number}@{type}`.
`entrypoint` *object* | List of named entrypoints using names from constructor/type annotations if present or `__entry_{number}__` otherwise.
`entrypoint.$.id` *int64*          | Position of the entrypoint in the Michelson parameter tree.
`entrypoint.$.branch` *string*     | Path of left (L) or right \(R) branches to reach the entrypoint's code in the Michelson code tree.
`entrypoint.$.type` *polymorph*    | List of unboxed scalar or complex types expected as function call parameters for this entrypoint.
`entrypoint.$.prim` *object*       | Native Michelson primitives defining the parameter types for this entrypoint (hidden by default, enable with `prim=true`).



### Get Contract Storage

`GET https://api.tzstats.com/explorer/contract/{hash}/storage`

Returns the most recent content of the contract's storage or, when using the optional `block` (int64|hash) argument, a prior state at the specified block. Use the optional `prim` (boolean) argument to embed Michelson JSON primitives.



### Unboxed Contract Storage

> **Example storage update.**

```json
{
  "meta": {
    "contract": "KT1NQfJvo9v8hXmEgqos8NP7sS8V4qaEfvRF",
    "time": "2019-10-25T16:41:56Z",
    "height": 665516,
    "block": "BLrmdRNxyY5me3UCUhf4bdbys6RbwGuNJj9jkZG6587tZVdroJi"
  },
  "value": {
    "0@big_map": "12",
    "1@lambda": [
      // ...
    ],
    "2@address": "tz1TUQZtFFZ4Eh7TsYzrL7qFVvabTM63qAqY",
    "3@nat": "1",
    "4@bool": false
  }
}
```

Field              | Description
-------------------|--------------------------------------------------
`meta` *object*        | Metadata for the current bigmap entry.
  `meta.contract` *hash*    | Contract that owns the bigmap.
  `meta.time` *datetime*    | Update timestamp for this key/value pair.
  `meta.height` *int64*     | Update height for this key/value pair.
  `meta.block` *hash*       | Hash of the block containing the latest update.
`value` *object*       | Unboxed contract storage using keys derived from type annotations or of form `number@type` and unboxed JSON representations for content.
`prim` *object*        | Native JSON encoded Michelson primitives of storaged values (hidden by default, enable with `prim=true`).



### List Contract Calls

`GET https://api.tzstats.com/explorer/contract/{hash}/calls`

Returns calls (transactions) sent to the contract with embedded parameters, storage and bigmap updates. Use the optional `prim` (boolean) argument to embed Michelson primitive trees in addition to unboxed call data. To query calls until a specific block use the optional query argument `block` (int64|hash). Hash is reorg-aware, ie. in case you execute a query on a block that becomes orphaned, the API returns a 409 Conflict error. To query for updates after a certain block use the optional argument `since` (int64|hash). To change the order of returned calls use the optional `order` (asc|desc) parameter (defaults to ascending). Use the optional `entrypoint` (int64|string) argument to filter calls by entrypoint. This argument takes either an id value (eg. 7), a name (eg. "mint") or the branch (eg. "RRR").


### Unboxed Call Parameters

> **Example call parameters.**

```json
// ...
"parameters": {
  "entrypoint": "default",
  "branch": "RRR",
  "call": "mint",
  "id": 7,
  "value": {
    //...
  },
  "prim": {
    // ...
  },
},
// ...
```

Call parameters are part of the call (operation) structure and contain the following properties:

Field              | Description
-------------------|--------------------------------------------------
`entrypoint` *string* | Named entrypoint into the smart contract, e.g. 'default' or '__entry_00__.
`branch` *string*     | Path of left (L) or right \(R) branches to reach the entrypoint's code in the Michelson code tree.
`call` *string*       | Name of the actaully called entrypoint. This is useful if parameters contain a call to default or root entrypoints and specify the real entrypoint by branching only.
`id` *int64*          | Position of the entrypoint in the Michelson parameter tree.
`value` *object*      | Call parameters in order of type definition.
`prim` *object*       | Michelson JSON encoded representation of call parameters (hidden by default, enable with `prim=true`).


### Unboxed BigMap Updates

> **Example storage update.**

```json
// ...
"big_map_diff": [{
  "action": "update",
  "key": "0501000000044e4c4576",
  "key_hash": "exprtxcQXJiJWzb5PvjHzkf2LKvnvmbvKdNDSvWzegiTMAKsvTgijL",
  "key_binary": "0501000000044e4c4576",
  "key_unpacked": "NLEv",
  "key_pretty": "NLEv",
  "value": {
    "0@bytes": "050000"
  },
  "value_unpacked": "0",
  "meta": {
    "contract": "KT1NQfJvo9v8hXmEgqos8NP7sS8V4qaEfvRF",
    "bigmap_id": 12,
    "time": "2019-10-25T16:37:56Z",
    "height": 665512,
    "block": "BKucUF1pxUv7JsrmKoLhmoXeoAzBvKUdZA7PVXEEUACyE7PR6qa",
    "is_replaced": false,
    "is_removed": false
  },
  "prim": {
    "key": {
      "bytes": "0501000000044e4c4576"
    },
    "value": {
      "bytes": "050000"
    }
  }
}]
// ...
```


Field              | Description
-------------------|--------------------------------------------------
`action` *enum*    | Update kind, one of `alloc`, `update`, `remove`, `copy`.
`key` *polymorph*     | The native representation of the key. Integers are bigints wrapped in strings, other types are rendered according to type rules, e.g. addresses, keys and signatures are base58check encoded, timestamps are ISO8601, etc). Only present on `update` and `remove`.
`key_hash` *hash*     | The script expression hash for this key. Only present on `update` and `remove`.
`key_binary` *string* | Hex string containing the binary representation of the key as stored on-chain. Only present on `update` and `remove`.
`key_unpacked` *polymorph* | Unpacked version of the key as Michelson primitives (Pair keys only) or scalar type (all other types). Optional, enable with `unpack=true`. Only present on `update` and `remove`.
`key_pretty` *string*  | Prettified version of complex (Pair) keys where all elements are concatenated using `#`. Same as `key` or `key_unpacked` otherwise. Only present on `update` and `remove`.
`value` *object*       | Unboxed version of the bigmap value, either a simple value or complex nested structure using scalar types, lists, sets, maps, and bigmaps. Only present on `update`.
`value_unpacked` *object*  | An unpacked version of any packed binary data contained in the value. This can be a scalar type or a Michelson primitive tree if the type is complex such as lambda, pair, etc. Only present on `update`.
`key_type` *object*   | Michelson JSON encoded representation of bigmap key type. Only present on `alloc` and `copy`.
`value_type` *object*   | Michelson JSON encoded representation of bigmap value type. Only present on `alloc` and `copy`.
`source_big_map` *int64*   | Source bigmap id. Only present on `copy`.
`destination_big_map` *int64*   | Source bigmap id. Only present on `copy`.
`meta` *object*        | Metadata for the current bigmap entry.
  `contract` *hash*    | Contract that owns the bigmap.
  `bigmap_id` *int64*  | Unique on-chain id of this bigmap.
  `time` *datetime*    | Update timestamp for this key/value pair.
  `height` *int64*     | Update height for this key/value pair.
  `block` *hash*       | Hash of the block containing the latest update.
  `is_replaced` *bool* | Flag indicating if a future update has overwritten the current value. Useful in combination with the `block` parameter that allows to query a value at a fixed block in history.
  `is_removed` *bool* | Flag indicating if a future remove action has deleted the current key. Useful in combination with the `block` parameter that allows to query a value at a fixed block in history.
`prim` *object*    | Native Michelson JSON encoded `key` and `value` as primitive tree. Optional, use `prim` to enable.



### Get Contract Manager

`GET https://api.tzstats.com/explorer/contract/{hash}/manager`

Returns the manager of the contract (before Babylon) or the originator account (Babylon and later).



## Cycles

> **Example request.**

```shell
curl "https://api.tzstats.com/explorer/cycle/head"
```

> **Example response.**

```json
{
  "cycle": 247,
  "start_height": 1011713,
  "end_height": 1015808,
  "start_time": "2020-06-25T03:36:14Z",
  "end_time": "2020-06-27T23:54:04Z",
  "progress": 13.2568359375,
  "is_complete": false,
  "is_snapshot": false,
  "is_active": true,
  "snapshot_height": -1,
  "snapshot_index": -1,
  "snapshot_time": "0001-01-01T00:00:00Z",
  "rolls": 84176,
  "roll_owners": 423,
  "active_delegators": 54434,
  "active_bakers": 447,
  "staking_supply": 674670196.013393,
  "staking_percent": 80.2706912175752,
  "working_bakers": 117,
  "working_endorsers": 300,
  "missed_priorities": 4,
  "missed_endorsements": 115,
  "n_double_baking": 0,
  "n_double_endorsement": 0,
  "n_orphans": 0,
  "solvetime_min": 60,
  "solvetime_max": 100,
  "solvetime_mean": 60.327808471454915,
  "priority_min": 0,
  "priority_max": 1,
  "priority_mean": 0.007366482504604053,
  "endorsement_rate": 99.33694649446494,
  "endorsements_min": 25,
  "endorsements_max": 32,
  "endorsements_mean": 31.78782287822878,
  "seed_rate": 100,
  "worst_baked_block": 1011950,
  "worst_endorsed_block": 1011819,
  "snapshot_cycle": {
    // ... same data as cycle
  },
  "follower_cycle": {
    // ... same data as cycle
  }
}
```

Provides information about a consensus cycle, the past roll snapshot cycle and the future cycle whose rights are determined by the current cycle. This endpoint accepts `head` and a cycle `number` as path parameters.

### HTTP Request

`GET https://api.tzstats.com/explorer/cycle/{head,number}`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`cycle` *int64*              | The cycle number.
`start_height` *int64*       | First block height (level) in this cycle.
`end_height` *int64*         | Last block height (level) in this cycle.
`start_time` *datetime*      | Start time (estimate for future cycles).
`end_time` *datetime*        | End time (estimate for open and future cycles).
`progress` *float*           | Cycle completion in percent.
`is_complete` *bool*         | Flag indicating the cycle is complete.
`is_snapshot` *bool*         | Flag indicating a roll snapshot has been selected.
`is_active` *bool*           | Flag indicating the cycle is currently active.
`snapshot_height` *int64*    | Height of the snapshot block.
`snapshot_index` *int64*     | Index of the snapshot block.
`snapshot_time` *datetime*   | Time the snapshot block was taken.
`rolls` *int64*              | Number of rolls at selected snapshot block or most recent snapshot block.
`roll_owners` *int64*        | Number of unique roll owners (delegates) at selected snapshot block or most recent snapshot block.
`staking_supply` *money*     | Total staked supply at selected snapshot block or most recent snapshot block.
`staking_percent` *float*    | Percent of total supply staked at selected snapshot block or most recent snapshot block.
`active_bakers` *int64*        | Number of actively registered bakers.
`active_delegators` *int64*    | Number of non-zero accounts delegating to active bakers.
`working_bakers` *int64*       | Number of bakers seen during this cycle. Its expected for this number to be lower than `active_bakers` because some may have no rolls, others may not contribute.
`working_endorsers` *int64*    | Number of unique endorsers seen during this cycle. Its expected for this number to be lower than `active_bakers` because some may have no rolls, others may not contribute.
`missed_priorities` *int64*    | Total count of missed block priorities.
`missed_endorsements` *int64*  | Total count of missed endorsement slots.
`n_double_baking` *int64*      | Count of `double_baking_evidence` events.
`n_double_endorsement` *int64* | Count of `double_endorsement_evidence` events.
`n_orphans` *int64*            | Number of orphan blocks in this cycle.
`solvetime_min` *int64*        | Minimum time between blocks.
`solvetime_max` *int64*        | Maximum time between blocks.
`solvetime_mean` *float*     | Mean time between blocks.
`priority_min` *int64*         | Minimum block priority.
`priority_max` *int64*         | Maximum block priority.
`priority_mean` *float*      | Mean block priority.
`endorsement_rate` *float*   | Percentage of seen endorsements vs expected endorsements.
`endorsements_min` *int64*     | Minimum count of endorsements across all blocks.
`endorsements_max` *int64*     | Maximum count of endorsements across all blocks.
`endorsements_mean` *float*  | Mean count of endorsements across all blocks.
`seed_rate` *int64*            | Percentage of published vs expectd `seed_nonce_revelations`.
`worst_baked_block` *int64*    | Height of the block with lowest priority.
`worst_endorsed_block` *int64* | Height of the block with least endorsed slots.
`snapshot_cycle` *object*    | Embedded cycle data for the cycle that provided the roll snapshot for the current cycle.
`follower_cycle` *object*    | Embedded cycle data for the future cycle that will get its rights assigned from a snapshot in the current cycle.




## Elections

> **Example request.**

```shell
curl "https://api.tzstats.com/explorer/election/head"
```

> **Example response.**

```json
{
  "election_id": 13,
  "num_periods": 4,
  "num_proposals": 2,
  "start_time": "2019-07-16T19:02:34Z",
  "end_time": "2019-10-18T00:29:57Z",
  "start_height": 524288,
  "end_height": 655359,
  "is_empty": false,
  "is_open": true,
  "is_failed": false,
  "no_quorum": false,
  "no_majority": false,
  "no_proposal": false,
  "voting_period": "promotion_vote",
  "proposal": {
    "voting_period": 15,
    "voting_period_kind": "proposal",
    "period_start_time": "2019-07-16T19:02:34Z",
    "period_end_time": "2019-08-09T06:46:57Z",
    "period_start_block": 524288,
    "period_end_block": 557055,
    "eligible_rolls": 70159,
    "eligible_voters": 461,
    "quorum_pct": 0,
    "quorum_rolls": 0,
    "turnout_rolls": 43133,
    "turnout_voters": 225,
    "turnout_pct": 6147,
    "turnout_ema": 0,
    "yay_rolls": 0,
    "yay_voters": 0,
    "nay_rolls": 0,
    "nay_voters": 0,
    "pass_rolls": 0,
    "pass_voters": 0,
    "is_open": false,
    "is_failed": false,
    "is_draw": false,
    "no_proposal": false,
    "no_quorum": false,
    "no_majority": false,
    "proposals": [
      {
        "hash": "PsBABY5nk4JhdEv1N1pZbt6m6ccB9BfNqa23iKZcHBh23jmRS9f",
        "source": "tz1eEnQhbwf6trb8Q8mPb2RaPkNk2rN7BKi8",
        "block_hash": "BLkbt55K5YZMPtjrSfo3ericxRaeXcwEwawfE5BkT9H5ZbZnLQV",
        "op_hash": "op4mZHRe1xTmYG34xYRwpGaGMAfTp6S82eeebgNZmdtNW6szeeX",
        "height": 537802,
        "time": "2019-07-26T13:20:04Z",
        "rolls": 19964,
        "voters": 146
      },
      {
        "hash": "PsBABY5HQTSkA4297zNHfsZNKtxULfL18y95qb3m53QJiXGmrbU",
        "source": "tz1eEnQhbwf6trb8Q8mPb2RaPkNk2rN7BKi8",
        "block_hash": "BLzSKKWp9NyrNrZrZgWin3m2zjPVUJfxNn1QkCzt9aZy7ZLWgJJ",
        "op_hash": "ooDAtGzFBeRUJcEK3QRBHU3kzk31CAp2RARYE3kmU3qsrvgs8JN",
        "height": 547386,
        "time": "2019-08-02T09:42:56Z",
        "rolls": 66302,
        "voters": 304
      }
    ]
  },
  "testing_vote": {
    "voting_period": 16,
    "voting_period_kind": "testing_vote",
    "period_start_time": "2019-08-09T06:48:02Z",
    "period_end_time": "2019-09-01T17:52:51Z",
    "period_start_block": 557056,
    "period_end_block": 589823,
    "eligible_rolls": 70585,
    "eligible_voters": 464,
    "quorum_pct": 7291,
    "quorum_rolls": 51463,
    "turnout_rolls": 57818,
    "turnout_voters": 179,
    "turnout_pct": 8191,
    "turnout_ema": 0,
    "yay_rolls": 37144,
    "yay_voters": 171,
    "nay_rolls": 0,
    "nay_voters": 0,
    "pass_rolls": 20674,
    "pass_voters": 8,
    "is_open": false,
    "is_failed": false,
    "is_draw": false,
    "no_proposal": false,
    "no_quorum": false,
    "no_majority": false,
    "proposals": [
      {
        "hash": "PsBABY5HQTSkA4297zNHfsZNKtxULfL18y95qb3m53QJiXGmrbU",
        "source": "tz1eEnQhbwf6trb8Q8mPb2RaPkNk2rN7BKi8",
        "block_hash": "BLzSKKWp9NyrNrZrZgWin3m2zjPVUJfxNn1QkCzt9aZy7ZLWgJJ",
        "op_hash": "ooDAtGzFBeRUJcEK3QRBHU3kzk31CAp2RARYE3kmU3qsrvgs8JN",
        "height": 547386,
        "time": "2019-08-02T09:42:56Z",
        "rolls": 0,
        "voters": 0
      }
    ]
  },
  "testing": {
    "voting_period": 17,
    "voting_period_kind": "testing",
    "period_start_time": "2019-09-01T17:53:51Z",
    "period_end_time": "2019-09-25T04:30:36Z",
    "period_start_block": 589824,
    "period_end_block": 622591,
    "eligible_rolls": 71053,
    "eligible_voters": 469,
    "quorum_pct": 0,
    "quorum_rolls": 0,
    "turnout_rolls": 0,
    "turnout_voters": 0,
    "turnout_pct": 0,
    "turnout_ema": 0,
    "yay_rolls": 0,
    "yay_voters": 0,
    "nay_rolls": 0,
    "nay_voters": 0,
    "pass_rolls": 0,
    "pass_voters": 0,
    "is_open": false,
    "is_failed": false,
    "is_draw": false,
    "no_proposal": false,
    "no_quorum": false,
    "no_majority": false,
    "proposals": [
      {
        "hash": "PsBABY5HQTSkA4297zNHfsZNKtxULfL18y95qb3m53QJiXGmrbU",
        "source": "tz1eEnQhbwf6trb8Q8mPb2RaPkNk2rN7BKi8",
        "block_hash": "BLzSKKWp9NyrNrZrZgWin3m2zjPVUJfxNn1QkCzt9aZy7ZLWgJJ",
        "op_hash": "ooDAtGzFBeRUJcEK3QRBHU3kzk31CAp2RARYE3kmU3qsrvgs8JN",
        "height": 547386,
        "time": "2019-08-02T09:42:56Z",
        "rolls": 0,
        "voters": 0
      }
    ]
  },
  "promotion_vote": {
    "voting_period": 18,
    "voting_period_kind": "promotion_vote",
    "period_start_time": "2019-09-25T04:32:51Z",
    "period_end_time": "2019-10-18T00:28:57Z",
    "period_start_block": 622592,
    "period_end_block": 655359,
    "eligible_rolls": 71840,
    "eligible_voters": 463,
    "quorum_pct": 7471,
    "quorum_rolls": 53671,
    "turnout_rolls": 11895,
    "turnout_voters": 79,
    "turnout_pct": 1655,
    "turnout_ema": 0,
    "yay_rolls": 11044,
    "yay_voters": 71,
    "nay_rolls": 844,
    "nay_voters": 6,
    "pass_rolls": 7,
    "pass_voters": 2,
    "is_open": true,
    "is_failed": false,
    "is_draw": false,
    "no_proposal": false,
    "no_quorum": false,
    "no_majority": false,
    "proposals": [
      {
        "hash": "PsBABY5HQTSkA4297zNHfsZNKtxULfL18y95qb3m53QJiXGmrbU",
        "source": "tz1eEnQhbwf6trb8Q8mPb2RaPkNk2rN7BKi8",
        "block_hash": "BLzSKKWp9NyrNrZrZgWin3m2zjPVUJfxNn1QkCzt9aZy7ZLWgJJ",
        "op_hash": "ooDAtGzFBeRUJcEK3QRBHU3kzk31CAp2RARYE3kmU3qsrvgs8JN",
        "height": 547386,
        "time": "2019-08-02T09:42:56Z",
        "rolls": 0,
        "voters": 0
      }
    ]
  }
}
```

On-chain elections can be queried by proposal `hash` or sequence `number`. An election contains a complete set of data on a past or the currently ongoing (`head`) on-chain voting process, including up to four voting periods. Voting periods may be empty when no proposal has been published. Only the last voting period of the last election is open at eny point in time. Ballots represent the individual ballot operations sent by bakers during votes or the upvotes to a proposal during the first voting period.

### HTTP Request

`GET https://api.tzstats.com/explorer/election/{head,hash,number}`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`election_id` *int64*     | Sequence number of the election.
`num_periods` *int64*     | Number of voting periods activated during this election (min 1, max 4)
`num_proposals` *int64*   | Total number of submitted proposals.
`start_time` *int64*      | Time of the first block in the election.
`end_time` *int64*        | Time of the last block in the election (when open this is an approximation of the latest possible end assuming all voting periods are used and all remaining blocks are produced at priority zero).
`start_height` *int64*    | First block of the election period.
`end_height` *bool*      | Last block of the election (when open this is an approximation of the full duration assuming all voting periods are used).
`is_empty` *bool*        | Flag indicating the election has not seen and proposal being submitted.
`is_open` *bool*         | Flag indicating the election is ongoing.
`is_failed` *bool*       | Flag indicating the election has failed to select or activate a new protocol.
`no_quorum` *bool*       | Flag indicating the election has failed because no quorum could be reached.
`no_majority` *bool*     | Flag indicating the election has failed because no majority could be reached.
`no_proposal` *bool*     | Flag indicating the election has failed because no proposal has been submitted.
`voting_period` *enum*  | Period kind `proposal`, `testing_vote`, `testing`, `promotion_vote`.
`proposal` *object*        | Vote object for the proposal period 1 (see below).
`testing_vote` *object*    | Vote object for the testing vote period 2 (see below).
`testing` *object*         | Vote object for the testing period 3 (see below).
`promotion_vote` *object*  | Vote object for the promotion vote period 4 (see below).

### Voting Period Object

Field              | Description
-------------------|--------------------------------------------------
`voting_period` *int64*        | Protocol-level voting period counter.
`voting_period_kind` *enum*  | Period kind `proposal`, `testing_vote`, `testing`, `promotion_vote`.
`period_start_time` *datetime*   | Time of the first block in the voting period.
`period_end_time` *datetime*     | Time of the last block in the voting period (when open this is an approximation of the latest possible end assuming all remaining blocks are produced at priority zero).
`period_start_block` *int64*  | First block of the voting period.
`period_end_block` *int64*    | Last block of the voting period.
`eligible_rolls` *int64*      | Number of rolls eligible to vote snapshot at start of the voting period.
`eligible_voters` *int64*     | Number of eligible voters (delegates) snapshot at start of the voting period.
`quorum_pct` *float*          | Required quorum in percent.
`quorum_rolls` *int64*        | Required rolls to reach quorum.
`turnout_rolls` *int64*       | Actual rolls who voted.
`turnout_voters` *int64*      | Actual voters who voted.
`turnout_pct` *float*         | Actual participation in percent.
`turnout_ema` *float*         | Moving average for Babylon v005 quorum algorithm.
`yay_rolls` *int64*           | Number of Yay rolls.
`yay_voters` *int64*          | Number of Yay voters.
`nay_rolls` *int64*           | Number of Nay rolls.
`nay_voters` *int64*          | Number of Nay voters.
`pass_rolls` *int64*          | Number of Pass rolls.
`pass_voters` *int64*         | Number of Pass voters.
`is_open` *bool*             | Flag indicating the voting period is currently open.
`is_failed` *bool*           | Flag indicating the voting period has failed to select or activate a new protocol.
`is_draw` *bool*             | Flag indication the reason for failure was a draw between two proposals in the proposal period.
`no_proposal` *bool*         | Flag indication the reason for failure was no submitted proposal in the proposal period.
`no_quorum` *bool*           | Flag indication the reason for failure was participation below the required quorum.
`no_majority` *bool*         | Flag indication the reason for failure was acceptance below the required supermajority.
`proposals` *array*         | List of submitted proposals (in proposal period) or the selected proposal.

### Proposal Object

Field              | Description
-------------------|--------------------------------------------------
`hash` *hash*       | Protocol hash.
`source` *hash*     | Sender account.
`block_hash` *hash* | Proposal operation block hash.
`op_hash` *hash*    | Proposal operation hash.
`height` *int64*      | Proposal operation submission height.
`time` *datetime*   | Proposal operation submission time.
`rolls` *int64*       | Count of rolls voting for this proposal during the proposal period.
`voters` *int64*      | Count of voters voting for this proposal during the proposal period.

### List Voters

`GET https://api.tzstats.com/explorer/election/{hash,number,head}/{stage}/voters`

Lists all eligible voters for the current voting period where `stage` is the sequence number of the voting period `[1..4]`. The voter list supports pagination with `limit`, `offset` and `cursor`. To change the order of returned calls use the optional `order` (asc|desc) parameter.

#### Voter Object

Field              | Description
-------------------|--------------------------------------------------
`row_id` *int64*   | Internal account id for use with `cursor`.
`address` *hash*   | Voter address.
`rolls` *int64*    | Count of rolls the voter has during this voting period.
`stake` *money*    | Staking balance the voter had at the beginning of this voting period.
`has_voted` *bool* | Flag indicating if the account has already voted.
`ballot` *enum*    | Ballot cast by the voter, either `yay`, `nay` or `pass`.
`proposals` *array* | List of proposals (as hashes) the voter voted for.

### List Ballots

`GET https://api.tzstats.com/explorer/election/{hash,number,head}/{stage}/ballots`

Lists all ballots cast during the current voting periodwhere `stage` is the sequence number of the voting period `[1..4]`. The voter list supports pagination with `limit`, `offset` and `cursor`. To change the order of returned calls use the optional `order` (asc|desc) parameter.

### Ballot Object

Field              | Description
-------------------|--------------------------------------------------
`row_id` *int64*   | Internal account id for use with `cursor`.
`sender` *hash*    | Voter address.
`height` *int64*   | Operation submission height.
`time` *datetime*  | Operation submission time.
`election_id` *int64*        | Sequence number of the election.
`voting_period` *int64*      | Protocol-level voting period counter.
`voting_period_kind` *enum*  | Period kind `proposal`, `testing_vote`, `testing`, `promotion_vote`.
`proposal` *hash*  | Hash of the proposal the voter voted for. If the vote happend during the proposal period and the voter used to vote for multiple proposals either in a single `proposals` operation or with multiple `proposals` operations, multiple ballots exist.
`op` *hash*        | Operation hash.
`ballot` *enum*    | Ballot cast by the voter, either `yay`, `nay` or `pass`. During proposal period the ballot is always `yay` to decribe the only choice.
`rolls` *int64*    | Count of rolls the voter has during this voting period.

## Indexer Status

> **Example request.**

```shell
curl "https://api.tzstats.com/explorer/status"
```

> **Example response.**

```json
{
  "status": "synced",
  "blocks": 626399,
  "indexed": 626399,
  "progress": 1
}
```

Returns the current indexer status, useful to check of the indexer is in sync with the blockchain.

### HTTP Request

`GET https://api.tzstats.com/explorer/status`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`status` *enum*    | Indexer status (`connecting`, `syncing`, `synced`, `failed`).
`blocks` *int64*   | Most recent block height seen by the connected Tezos node.
`indexed` *int64*  | Most recent block height indexed.
`progress` *float* | Percentage of blocks indexed.



## Market Tickers

> **Example request.**

```shell
curl "https://api.tzstats.com/markets/tickers"
```

> **Example response.**

```json
[
  {
    "pair": "XTZ_BNB",
    "base": "XTZ",
    "quote": "BNB",
    "exchange": "binance",
    "open": 0.05813000,
    "high": 0.06058000,
    "low": 0.05583000,
    "last": 0.05741000,
    "change": -1.23860313,
    "vwap": 0.05787292,
    "n_trades": 176,
    "volume_base": 17373.80000000,
    "volume_quote": 1005.47257300,
    "timestamp": "2019-09-29T20:14:00.001014458Z"
  },
  {
    "pair": "XTZ_BTC",
    "base": "XTZ",
    "quote": "BTC",
    "exchange": "kraken",
    "open": 0.00011090,
    "high": 0.00011300,
    "low": 0.00010710,
    "last": 0.00010970,
    "change": -1.08205591,
    "vwap": 0.00011036,
    "n_trades": 808,
    "volume_base": 219356.80514484,
    "volume_quote": 24.20907256,
    "timestamp": "2019-09-29T20:14:00.000755843Z"
  }
]
```

Fetches a list of market price tickers with 24h OHLCV data.

### HTTP Request

`GET https://api.tzstats.com/markets/tickers`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`pair` *string*         | Trading pair in format `{base}_{quote}`.
`base` *string*         | Base currency (always `XTZ`).
`quote` *string*        | Quote currency.
`exchange` *string*     | Exchange code.
`open` *money*          | 24h open price in quote currency.
`high` *money*          | 24h highest price in quote currency.
`low` *money*           | 24h lowest price in quote currency.
`last` *money*          | Last price in quote curreny.
`change` *float*        | 24h price change in percent.
`vwap` *money*          | 24h volume weighted average price in quote currency.
`n_trades` *int64*      | 24h number of trades.
`volume_base` *money*   | 24h traded volume in base currency.
`volume_quote` *money*  | 24h traded volume in quote currency.
`timestamp` *datetime*  | Timestamp of the ticker result.






## Operations

> **Example request.**

```shell
curl "https://api.tzstats.com/explorer/op/opSrt7oYHDTZcfGnhNt3BzGrrCQf364VuYmKo5ZQVQRfTnczjnf"
```

> **Example response.**

```json
[
  {
    "row_id": 28059456,
    "hash": "opSrt7oYHDTZcfGnhNt3BzGrrCQf364VuYmKo5ZQVQRfTnczjnf",
    "type": "transaction",
    "block": "BL1PGezBat3BX1N2rnk1qycTJbCXdWJwYoGBChyeFyYJABGLyZ9",
    "time": "2020-06-25T06:18:19Z",
    "height": 1011875,
    "cycle": 247,
    "counter": 2187104,
    "op_n": 22,
    "op_l": 3,
    "op_p": 3,
    "op_c": 0,
    "op_i": 0,
    "status": "applied",
    "is_success": true,
    "is_contract": false,
    "gas_limit": 15385,
    "gas_used": 10207,
    "gas_price": 0.17557,
    "storage_limit": 257,
    "storage_size": 0,
    "storage_paid": 0,
    "volume": 0.040128,
    "fee": 0.001792,
    "reward": 0,
    "deposit": 0,
    "burned": 0,
    "is_internal": false,
    "has_data": false,
    "days_destroyed": 0.016302,
    "sender": "tz1Ywgcavxq9D6hL32Q2AQWHAux9MrWqGoZC",
    "receiver": "tz1ijyJy2QncvgDKZJARDgPqEYVRk6yTE5d7",
    "branch_id": 1011875,
    "branch_height": 1011874,
    "branch_depth": 1,
    "branch": "BKt5Lz42YyZNaSYkqfx3m9cmZ2qRoqw1duHqvygLUrgxCewYXoS",
    "is_implicit": false,
    "entrypoint_id": 0,
    "is_orphan": false,
    "is_batch": true,
    "batch_volume": 261.785412
  },
  // ...
]
```

Returns info about a single operation or a list of related operations. Because Tezos supports batch operations (multiple operations sharing the same hash), internal operations (created by smart contract calls in response to a transaction) and implicit events (state changes that do not have an operation hash) this endpoint always returns an array of operation objects. In many cases this array contains one element only. Use the optional `prim` (boolean) parameter to embed Michelson primitive trees with smart contract calls.

### HTTP Request

`GET https://api.tzstats.com/explorer/op/{hash|id}`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`hash` *hash*            | Operation hash.
`type` *enum*            | Operation type.
`block` *hash*           | Block hash at which the operation was included on-chain.
`time` *datetime*        | Block time at which the operation was included on-chain.
`height` *int64*         | Block height at which the operation was included on-chain.
`cycle` *int64*          | Cycle in which the operation was included on-chain.
`counter` *int64*        | Unique sender account 'nonce' value.
`op_n` *int64*           | In block operation counter.
`op_l` *int64*           | Tezos RPC operation list number (0..3).
`op_p` *int64*           | Tezos RPC operation list position.
`op_c` *int64*           | Bulk operation list position.
`op_i` *int64*           | Internal operation list position.
`status` *enum*          | Operation status `applied`, `failed`, `backtracked`, `skipped`.
`is_success` *bool*      | Flag indicating operation was successfully applied.
`is_contract` *bool*     | Flag indicating smart-contract calls.
`gas_limit` *int64*      | Caller-defined gas limit.
`gas_used` *int64*       | Gas used by the operation.
`gas_price` *float*      | Effective price per gas unit in mutez.
`storage_limit` *int64*  | Caller-defined storage limit.
`storage_size` *int64*   | Actual storage size allocated.
`storage_paid` *int64*   | Part of the storage the operation paid for.
`volume` *money*         | Amount of tokens transferred in tz. In denunciation operations, this field contains the accuser reward, in delegation operations this field contains the initially delegated balance.
`fee` *money*            | Fees paid in tz. In denunciation operations, this field contains the offender loss as negative value.
`reward` *money*         | Rewards earned in tz. In denunciation operations, this field contains the offender loss as negative value.
`deposit` *money*        | Amount of deposited tokens in tz. In denunciation operations, this field contains the offender loss as negative value.
`burned` *money*         | Amount of burned tokens in tz.
`is_internal` *bool*     | Flag indicating if this operation was sent be a smart contract.
`is_implicit` *bool*     | Flag indicating implicit on-chain events, ie. state changes that don't have an operation hash such as `bake`, `unfreeze`, `seed_slash`, `airdrop` and `invoice`.
`has_data` *bool*        | Flag indicating if extra data or parameters are present.
`data` *polymorph*       | Extra type-dependent operation data. See below.
`parameters` *object*    | Call parameters as embedded JSON object, contract-only.
`storage` *object*       | Updated contract storage as embedded JSON object, contract-only.
`big_map_diff` *object*  | Inserted, updated or deleted bigmap entries as embedded JSON object, contract-only.
`days_destroyed` *float* | Token days destroyed by this operation (`tokens transferred * token idle time`).
`parameters` *object*    | Contract call parameters.
`storage` *object*       | Updated version of contract storage after call.
`data` *object*          | Extra operation data (see below for content encoding).
`big_map_diff` *array*   | List of bigmap updates.
`errors` *array*         | Native Tezos RPC errors.
`sender` *hash*          | Operation sender.
`receiver` *hash*        | Transaction receiver, may be empty. For `activate_account` the source account is referenced when the activation merged coins from a second blinded account (ie. when a fundraiser signed up twice). For `delegation` the previous delegate is referenced. For `seed_nonce_revelation` the actual seed publisher is referenced.
`delegate` *hash*        | New Delegate, only used by `origination` and `delegation`. When empty for a `delegation` the operation was a delegate withdrawal.
`manager` *hash*         | Contains contract manager (Athens) or creator (Babylon+) on `origination`. For internal `transactions`, the original sender of the external transaction is referenced.
`branch_id` *uint64*     | Row id of the branch block this op refers to.
`branch_height` *int64*  | Height of the branch block this op refers to.
`branch_depth` *int64*   | Count of blocks between branch block and block including this op.
`branch` *hash*          | Block hash of the branch this op refers to.
`entrypoint_id` *int64*  | Serial id of the called entrypoint, only relevant if the operation was a transaction, the receiver is a smart contract and call parameters are present.
`is_orphan` *bool*       | Flag indicating whether this operation was orphaned (not included in any block).
`is_batch` *bool*        | Flag indicating if this operation is part of a batch operation list.
`batch_volume` *money*   | Total amount transferred in a batch operation list. Only available of the first operation of a batch list and only when any transfers happened.

### List of supported operation types

- `activate_account`
- `double_baking_evidence`
- `double_endorsement_evidence`
- `seed_nonce_revelation`
- `transaction`
- `origination`
- `delegation`
- `reveal`
- `endorsement`
- `proposals`
- `ballot`
- `bake` (implict, no hash, block header event `op_n = -1`)
- `unfreeze` (implict, no hash, block header event `op_n = -1`)
- `seed_slash` (implict, no hash, block header event `op_n = -1`)
- `airdrop` (implict, no hash, protocol upgrade event `op_n = -2`)
- `invoice` (implict, no hash, protocol upgrade event `op_n = -2`)

### Decoding Operation Data

Some operations contain extra data in the polymorphic `data` field. This field exists when the `has_data` flag is true. Decoding the data depends on the operation `type`.

Operation | Data Type | Specification
----------|-----------|--------------------
`activate_account` | string | `hex(secret),blinded-address`
`endorsement` | uint | 32bit big-endian bitmask identifying endorsed slots
`ballot` | string | `proposal-hash,ballot` (yay, nay, pass)
`proposals` | string | comma-separated list or proposal hashes
`reveal` | string | public key hash
`seed_nonce_revelation` | string | `level,hex(nonce)`
`double_baking_evidence` | object | JSON array of double signed block headers
`double_endorsemnt_evidence` | object | JSON array of double signed endorsements
`transaction` | - | unused, see `parameters`, `storage` and `big_map_diff`

