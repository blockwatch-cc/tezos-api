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

Some endpoints support a simple pagination scheme to walk lists of results (i.e. for related operations or accounts). To paginate append `limit` and `offset`, both are positive integers. Limit defaults to 20 and is capped to a maximum value of 100. Results are always sorted by `row_id` of the underlying table. If you require a different sort order, you have to do this client-side.

### List of supported endpoints

Endpoint | Is Paged | Filter | Comment
---------|----------|--------|----------
`GET /explorer/status`                    |   |   | indexer status |
`GET /explorer/config/{head,height}`      |   |   | blockchain config at head or height |
`GET /explorer/tip`                       |   |   | blockchain tip info |
`GET /explorer/block/{head,hash,height}`  |   |   | block info |
`GET /explorer/block/{head,hash,height}/op`| x | `type` | list block operations |
`GET /explorer/op/{hash}`                 |   |   |  operation info |
`GET /explorer/account/{hash}`            |   |   | account info |
`GET /explorer/account/{hash}/managed`    | x |   | list of contracts managed by this account |
`GET /explorer/account/{hash}/op`         | x | `type`, `block`, `since` | account info with embedded list of related operations |
`GET /explorer/account/{hash}/ballots`    | x |   | list proposals and ballots |
`GET /explorer/contract/{hash}`           |   |   | smart contract metadata |
`GET /explorer/contract/{hash}/calls`     | x | `block`, `since` | list contract calls |
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
`GET /explorer/cycle/{head,num}`          |   |   | active cycle or cycle N info
`GET /explorer/election/{head,num,height}`|   |   | election info (num ::= [1,1024] |
`GET /markets`                            |   |   | list of known exchanges and markets |
`GET /markets/tickers`                    |   |   | list of 24h market tickers |
`GET /markets/{exchange}`                 |   |   | exchange status |
`GET /markets/{exchange}/{market}`        |   |   | market status |
`GET /markets/{exchange}/{market}/ticker` |   |   | single market ticker |



## Accounts

> **Example request.**

```shell
curl "https://api.tzstats.com/explorer/account/tz2TSvNTh2epDMhZHrw73nV9piBX7kLZ9K9m"
```

> **Example response.**

```json
{
  "address": "tz2TSvNTh2epDMhZHrw73nV9piBX7kLZ9K9m",
  "address_type": "secp256k1",
  "delegate": "tz2TSvNTh2epDMhZHrw73nV9piBX7kLZ9K9m",
  "manager": "",
  "pubkey": "sppk7bn9MKAWDUFwqowcxA1zJgp12yn2kEnMQJP3WmqSZ4W8WQhLqJN",
  "first_in": 360996,
  "first_out": 360997,
  "last_in": 627433,
  "last_out": 627433,
  "first_seen": 360996,
  "last_seen": 627433,
  "delegated_since": 0,
  "delegate_since": 361000,
  "first_in_time": "2019-03-20T23:10:52Z",
  "first_out_time": "2019-03-20T23:11:52Z",
  "last_in_time": "2019-09-28T14:43:06Z",
  "last_out_time": "2019-09-28T14:43:06Z",
  "first_seen_time": "2019-03-20T23:10:52Z",
  "last_seen_time": "2019-09-28T14:43:06Z",
  "delegated_since_time": "0001-01-01T00:00:00Z",
  "delegate_since_time": "2019-03-20T23:14:52Z",
  "total_received": 4129917.992,
  "total_sent": 1241985.094354,
  "total_burned": 0,
  "total_fees_paid": 0.041097,
  "total_rewards_earned": 463712.421526,
  "total_fees_earned": 51.817584,
  "total_lost": 0,
  "frozen_deposits": 2777472,
  "frozen_rewards": 86384.999996,
  "frozen_fees": 10.252118,
  "unclaimed_balance": 0,
  "spendable_balance": 487829.843545,
  "total_balance": 3265312.095663,
  "delegated_balance": 28092992.436557,
  "total_delegations": 13,
  "active_delegations": 8,
  "is_funded": true,
  "is_activated": false,
  "is_vesting": false,
  "is_spendable": true,
  "is_delegatable": false,
  "is_delegated": false,
  "is_revealed": true,
  "is_delegate": true,
  "is_active_delegate": true,
  "is_contract": false,
  "blocks_baked": 5867,
  "blocks_missed": 40,
  "blocks_stolen": 127,
  "blocks_endorsed": 97968,
  "slots_endorsed": 185547,
  "slots_missed": 332,
  "n_ops": 98177,
  "n_ops_failed": 0,
  "n_tx": 38,
  "n_delegation": 1,
  "n_origination": 0,
  "n_proposal": 1,
  "n_ballot": 1,
  "token_gen_min": 2,
  "token_gen_max": 4875,
  "grace_period": 159,
  "staking_balance": 31358304.53222,
  "rolls": 3919,
  "rich_rank": 25,
  "traffic_rank": 0,
  "flow_rank": 0,
  "last_bake_height": 627422,
  "last_bake_block": "BLeU7pnXhFRKsjvc3XYQ2gByCqwAALpKc7vZSoTeVNeUgHWDZ3V",
  "last_bake_time": "2019-09-28T14:32:01Z",
  "last_endorse_height": 627433,
  "last_endorse_block": "BLapVsFS7DB9H76njHSoFyGTTSfMn7ZJvUzB1KekUvtUk8KeXMy",
  "last_endorse_time": "2019-09-28T14:43:06Z",
  "next_bake_height": 627464,
  "next_bake_priority": 0,
  "next_bake_time": "2019-09-28T15:14:06Z",
  "next_endorse_height": 627434,
  "next_endorse_time": "2019-09-28T14:44:06Z"
}
```

Provides information about the most recent state of implicit and smart contract accounts.

### HTTP Request

`GET https://api.tzstats.com/explorer/account/{hash}`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`address` *hash*              |  Account address as base58-check encoded string.
`address_type` *enum*         |  Account address type `ed25519` (tz1), `secp256k1` (tz2), `p256` (tz3), `contract` (KT1) or `blinded` (btz1).
`delegate` *hash*             |  Current delegate (may be self when registered as delegate).
`manager` *hash*              |  Contract manager account.
`pubkey` *hash*               |  Revealed public key.
`first_in` *int64*            | Block height of first incoming transaction.
`first_out` *int64*           | Block height of first outgoing transaction.
`last_in` *int64*             | Block height of latest incoming transaction.
`last_out` *int64*            | Block height of latest outgoing transaction.
`first_seen` *int64*          | Block height of account creation.
`last_seen` *int64*           | Block height of last activity.
`delegated_since` *int64*     | Block height of most recent delegation.
`delegate_since` *int64*      | Block height of registration as delegate.
`first_in_time` *datetime*    | Block time of first incoming transaction.
`first_out_time` *datetime*   | Block time of first outgoing transaction.
`last_in_time` *datetime*     | Block time of latest incoming transaction.
`last_out_time` *datetime*    | Block time of latest outgoing transaction.
`first_seen_time` *datetime*  | Block time of account creation.
`last_seen_time` *datetime*   | Block time of last activity.
`delegated_since_time` *datetime* | Block time of most recent delegation.
`delegate_since_time` *datetime*  | Block time of registration as delegate.
`total_received` *money*       | Lifetime total tokens received in transactions.
`total_sent` *money*           | Lifetime total tokens sent in transactions.
`total_burned` *money*         | Lifetime total tokens burned in tz.
`total_fees_paid` *money*      | Lifetime fees paid in tz.
`total_rewards_earned` *money* | Lifetime rewards earned in tz.
`total_fees_earned` *money*    | Lifetime fees earned in tz.
`total_lost` *money*           | Lifetime total tokens lost in tz.
`frozen_deposits` *money*      | Currently frozen deposits
`frozen_rewards` *money*       | Currently frozen rewards.
`frozen_fees` *money*          | Currently frozen fees.
`unclaimed_balance` *money*    | Currently unclaimed balance (for vesting contracts and commitments).
`spendable_balance` *money*    | Currently spendable balance.
`total_balance` *money*        | Currently spendable and frozen balances (except frozen rewards).
`delegated_balance` *money*    | (delegate only) Current incoming delegations.
`staking_balance` *money*      | (delegate only) Current delegated and own total balance.
`total_delegations` *int64*    | (delegate only) Lifetime count of delegations.
`active_delegations` *int64*   | (delegate only) Currently active and non-zero delegations.
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
`blocks_baked` *int64*         | Lifetime total blocks baked.
`blocks_missed` *int64*        | Lifetime total block baking missed.
`blocks_stolen` *int64*        | Lifetime total block baked at priority > 0.
`blocks_endorsed` *int64*      | Lifetime total blocks endorsed.
`slots_endorsed` *int64*       | Lifetime total endorsemnt slots endorsed.
`slots_missed` *int64*         | Lifetime total endorsemnt slots missed.
`n_ops` *int64*                | Lifetime total number of operations sent and received.
`n_ops_failed` *int64*         | Lifetime total number of operations sent that failed.
`n_tx` *int64*                 | Lifetime total number of transactions sent and received.
`n_delegation` *int64*         | Lifetime total number of delegations sent.
`n_origination` *int64*        | Lifetime total number of originations sent.
`n_proposal` *int64*           | Lifetime total number of proposals (operations) sent.
`n_ballot` *int64*             | Lifetime total number of ballots sent.
`token_gen_min` *int64*        | Minimum generation number of all tokens owned.
`token_gen_max` *int64*        | Maximum generation number of all tokens owned.
`grace_period` *int64*         | (delegate only) Current grace period before deactivation.
`rolls` *int64*                | (delegate only) Currently owned rolls.
`rich_rank` *int64*            | Global rank on rich list by total balance.
`traffic_rank` *int64*         | Global rank on 24h most active accounts by transactions sent/received.
`flow_rank` *int64*            | Global rank on 24h most active accounts by volume sent/received.
`last_bake_height` *int64*     | Height of most recent block baked.
`last_bake_block` *hash*       | Hash of most recent block baked.
`last_bake_time` *datetime*    | Timestamp of most recent block baked.
`last_endorse_height` *int64*  | Height of most recent block endorsed.
`last_endorse_block` *hash*    | Hash of most recent block endorsed.
`last_endorse_time` *datetime* | Timestamp of most recent block endorsed.
`next_bake_height` *int64*     | Height of next block baking right.
`next_bake_priority` *int64*   | Priority of next baking right (fixed at zero currently).
`next_bake_time` *datetime*    | Approximate time of next block baking right.
`next_endorse_height` *int64*  | Height of next block endorsing right.
`next_endorse_time` *datetime* | Approximate time of next block endorsing right.

### List Account Operations

`GET https://api.tzstats.com/explorer/account/{hash}/op`

Lists operations sent from and to an account (defaults to all types and ascending order). This endpoint supports pagination with `limit` and `offset`. Use `type` to filter for a specific operation type (e.g. transactions), `block` (int64|hash) to lock a call to a specific block height or hash (hash is reorg-aware and throws an error when block has become orphan). To query for updates after a certain block use the optional argument `since` (int64|hash). To change the order of returned calls use the optional `order` (asc|desc) parameter.


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
curl "https://api.tzstats.com/explorer/bigmap/1/type"
```

> **Example response.**

```json
{
  "contract": "KT1R3uoZ6W1ZxEwzqtv75Ro7DhVY6UAcxuK2",
  "bigmap_id": 1,
  "key_type": "address",
  "key_encoding": "bytes",
  "value_type": {
    "0": "string",
    "1@option": "bytes",
    "2": "mutez",
    "3@or": {
      "0": "unit",
      "1@or": {
        "0": "address",
        "1": "unit"
      }
    },
    "4": "timestamp"
  },
  "prim": {
    // ...
  }
}
```

Returns bigmap type description in Michelson JSON format, both for keys and values. Keys are simple scalar types and values can have a simple or complex type. Use `prim` (boolean) to embed original Michelson primitives for key and value type definitions.

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
  "hash": "BLWT4x43zqzbtRzWNShkuU1DaTjU9fX34Qs4V3Hku2ZgYxiEpPW",
  "predecessor": "BKqv8SBNabXEMXV9fsy21yx9BNsqWBKVVp9ca4KTMpGsF2Wi8Uj",
  "successor": "BLFjwCUTebnhw6ZWpQNxa9VjZgGLgnp1Zazb21T1356VFEnxPrZ",
  "baker": "tz1cZfFQpcYhwDp7y1njZXDsZqCrn2NqmVof",
  "height": 627342,
  "cycle": 153,
  "is_cycle_snapshot": false,
  "time": "2019-09-28T13:11:51Z",
  "solvetime": 60,
  "version": 4,
  "validation_pass": 4,
  "fitness": 19846458,
  "priority": 0,
  "nonce": 11996642917503807005,
  "voting_period_kind": "promotion_vote",
  "endorsed_slots": 4294965247,
  "n_endorsed_slots": 31,
  "n_ops": 24,
  "n_ops_failed": 0,
  "n_ops_contract": 0,
  "n_tx": 1,
  "n_activation": 0,
  "n_seed_nonce_revelation": 0,
  "n_double_baking_evidence": 0,
  "n_double_endorsement_evidence": 0,
  "n_endorsement": 23,
  "n_delegation": 0,
  "n_reveal": 0,
  "n_origination": 0,
  "n_proposal": 0,
  "n_ballot": 0,
  "volume": 2.434174,
  "fees": 0.00142,
  "rewards": 80,
  "deposits": 2560,
  "unfrozen_fees": 0,
  "unfrozen_rewards": 0,
  "unfrozen_deposits": 0,
  "activated_supply": 0,
  "burned_supply": 0,
  "n_accounts": 26,
  "n_new_accounts": 0,
  "n_new_implicit": 0,
  "n_new_managed": 0,
  "n_new_contracts": 0,
  "n_cleared_accounts": 0,
  "n_funded_accounts": 0,
  "gas_limit": 10300,
  "gas_used": 10200,
  "gas_price": 0.13922,
  "storage_size": 0,
  "days_destroyed": 0.003381,
  "pct_account_reuse": 100,
  "endorsers": [
    "tz1LLNkQK4UQV6QcFShiXJ2vT2ELw449MzAA",
    "tz1isXamBXpTUgbByQ6gXgZQg4GWNW7r6rKE",
    "tz1gk3TDbU7cJuiBRMhwQXVvgDnjsxuWhcEA",
    "tz2TSvNTh2epDMhZHrw73nV9piBX7kLZ9K9m",
    "tz1MXFrtZoaXckE41bjUCSjAjAap3AFDSr3N",
    "tz1dZhK4HMbGTPUucpKy1rNG1WfYLqdRMs6Z",
    "tz3bvNMQ95vfAYtG8193ymshqjSvmxiCUuR5",
    "tz1KtvGSYU5hdKD288a1koTBURWYuADJGrLE",
    "tz1TaLYBeGZD3yKVHQGBM857CcNnFFNceLYh",
    "tz3RB4aoyjov4KEVRbuhvQ1CKJgBJMWhaeB8",
    "tz3bTdwZinP8U1JmSweNzVKhmwafqWmFWRfk",
    "tz1Ukm38BsGU58drCoJ31u3w6kgPo4oda4gL",
    "tz1TzaNn7wSQSP5gYPXCnNzBCpyMiidCq1PX",
    "tz1UHxJUMWHY4FxK3RxgbSdwMXAhEzmoLVWA",
    "tz3bTdwZinP8U1JmSweNzVKhmwafqWmFWRfk",
    "tz1NPbgLoqoct15RfrGu29DhUw41sVvTmqjP",
    "tz1VQnqCCqX4K5sP3FNkVSNKTdCAMJDd3E1n",
    "tz1T7duV5gZWSTq4YpBGbXNLTfznCLDrFxvs",
    "tz3RB4aoyjov4KEVRbuhvQ1CKJgBJMWhaeB8",
    "tz3NExpXn9aPNZPorRE4SdjJ2RGrfbJgMAaV",
    "tz3bTdwZinP8U1JmSweNzVKhmwafqWmFWRfk",
    "tz3VEZ4k6a4Wx42iyev6i2aVAptTRLEAivNN",
    "tz3VEZ4k6a4Wx42iyev6i2aVAptTRLEAivNN",
    "tz1LmaFsWRkjr7QMCx5PtV6xTUz3AmEpKQiF",
    "tz1VmiY38m3y95HqQLjMwqnMS7sdMfGomzKi",
    "tz1ajgycuHmd2z2JbTSJxKv7x6cok2KuNSk1",
    "tz1bHzftcTKZMTZgLLtnrXydCm6UEqf4ivca",
    "tz3bTdwZinP8U1JmSweNzVKhmwafqWmFWRfk",
    "tz2TSvNTh2epDMhZHrw73nV9piBX7kLZ9K9m",
    "tz1irJKkXS2DBWkU1NnmFQx1c1L7pbGg4yhk",
    "tz1cmvE9SbB63z9GB1h64P3YawsMqiBmQpCG",
    "tz3VEZ4k6a4Wx42iyev6i2aVAptTRLEAivNN"
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
`fees` *money*               | Total fees paid (and frozen) by all operations.
`rewards` *money*            | Total rewards earned (and frozen) by baker and endorsers.
`deposits` *money*           | Total deposits frozen by baker and endorsers.
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
curl "https://api.tzstats.com/explorer/block/head/op"
```

> **Example response.**

```json
{
  "hash": "BLFjwCUTebnhw6ZWpQNxa9VjZgGLgnp1Zazb21T1356VFEnxPrZ",
  "predecessor": "BLWT4x43zqzbtRzWNShkuU1DaTjU9fX34Qs4V3Hku2ZgYxiEpPW",
  "baker": "tz1S1Aew75hMrPUymqenKfHo8FspppXKpW7h",
  "height": 627343,
  "cycle": 153,
  // ...
  "ops": [{
      "hash": "oozRTWSPr2M2rr1EQKaU4uVgu4kP28UnTu1tMS24DoTAZiC3kx3",
      "type": "endorsement",
      "block": "BLFjwCUTebnhw6ZWpQNxa9VjZgGLgnp1Zazb21T1356VFEnxPrZ",
      "time": "2019-09-28T13:12:51Z",
      "height": 627343,
      "cycle": 153,
      "counter": 0,
      "op_n": 0,
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
      "deposit": 64,
      "burned": 0,
      "is_internal": false,
      "has_data": true,
      "days_destroyed": 0,
      "data": "524288",
      "sender": "tz3NExpXn9aPNZPorRE4SdjJ2RGrfbJgMAaV",
      "branch_id": 627343,
      "branch_height": 627342,
      "branch_depth": 1,
      "branch": "BLWT4x43zqzbtRzWNShkuU1DaTjU9fX34Qs4V3Hku2ZgYxiEpPW"
    },
    // ...
  ]
}
```

Block data can be extended with an embedded list of operations. This endpoint is an optimization to fetch both the operation list and the related resource in one call. Use `limit` and `offset` (both integers) to page through operation lists. Operations are sorted by row_id in ascending order.

### HTTP Request

#### List Block Operations

`GET https://api.tzstats.com/explorer/block/{hash,height,head}/op`



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
  "version": 5,
  "deployment": 6,
  "protocol": "PsBabyM1eUXZseaJdmXFApDSBqj8YBfwELoxZHHW77EMcAbbwAS",
  "start_height": -1,
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
  "hard_gas_limit_per_block": 8000000,
  "hard_gas_limit_per_operation": 800000,
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
  "block_reward_v6": [
    1.25,
    0.1875
  ],
  "endorsement_reward_v6": [
    1.25,
    0.833333
  ],
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
  "symbol": "XTZ",
  "network": "Mainnet",
  "chain_id": "NetXdQprcVkpaWU",
  "genesis_time": "2018-06-30T16:07:32Z",
  "block_hash": "BL326wcsdVU2Gp1PqnEgbP26dzM1crnevoTJXDQnPPJ1LAqVwv3",
  "timestamp": "2019-09-27T21:23:47Z",
  "height": 626408,
  "cycle": 152,
  "total_accounts": 333538,
  "funded_accounts": 298038,
  "total_ops": 15059205,
  "delegators": 17007,
  "delegates": 481,
  "rolls": 71897,
  "roll_owners": 459,
  "new_accounts_30d": 9848,
  "cleared_accounts_30d": 2195,
  "funded_accounts_30d": 9326,
  "inflation_1y": 39223088.146111,
  "inflation_rate_1y": 5.098069887192244,
  "health": 100,
  "supply": {
    "height": 626408,
    "cycle": 152,
    "time": "2019-09-27T21:23:47Z",
    "total": 810708076.643151,
    "activated": 526825268.109869,
    "unclaimed": 84629610.300311,
    "vested": 27582743.42817,
    "unvested": 125280976.17435,
    "circulating": 685424731.813075,
    "delegated": 457179960.469034,
    "staking": 580619999.307627,
    "active_delegated": 455871344.805448,
    "active_staking": 576682219.775331,
    "inactive_delegated": 1308615.663586,
    "inactive_staking": 3937779.532296,
    "minted": 46545468.745557,
    "minted_baking": 9685699.106655,
    "minted_endorsing": 36857356.263902,
    "minted_seeding": 2413.375,
    "minted_airdrop": 100,
    "burned": 155990.115106,
    "burned_double_baking": 103509.825621,
    "burned_double_endorse": 31838.219485,
    "burned_origination": 6574.002,
    "burned_implicit": 14068.068,
    "burned_seed_miss": 2576.671187,
    "frozen": 64032839.047756,
    "frozen_deposits": 62097662,
    "frozen_rewards": 1934957.146609,
    "frozen_fees": 219.901147
  },
  "status": {
    "status": "synced",
    "blocks": 626408,
    "indexed": 626408,
    "progress": 1
  }
}
```

Returns info about the most recent block as well as some on-chain and supply statistics.

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
  "bigmap_ids": []
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


### Related HTTP Requests

### Get Contract Script

`GET https://api.tzstats.com/explorer/contract/{hash}/script`

Returns the native Michelson JSON encoding of the deployed smart contract code as well as type specifications for call parameters, storage and bigmaps. Also contains decoded entrypoints and unboxed storage type.

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

Returns the most recent content of the contract's storage or, when using the optional `height` (int64) or block `hash` (hash) argument, a prior state at the specified block. Use the optional `prim` (boolean) argument to embed Michelson JSON primitives.



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

Returns calls (transactions) sent to the contract with embedded parameters, storage and bigmap updates. Use the optional `prim` (boolean) argument to embed Michelson primitive trees in addition to unboxed call data. To query calls until a specific block use the optional query argument `block` (int64|hash). Hash is reorg-aware, ie. in case you execute a query on a block that becomes orphaned, the API returns a 409 Conflict error. To query for updates after a certain block use the optional argument `since` (int64|hash). To change the order of returned calls use the optional `order` (asc|desc) parameter (defaults to ascending).


### Unboxed Call Parameters

> **Example call parameters.**

```json
// ...
"parameters": {
  "entrypoint": "default",
  "branch": "RRR",
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
  "cycle": 153,
  "start_height": 626689,
  "end_height": 630784,
  "start_time": "2019-09-28T02:13:20Z",
  "end_time": "2019-09-30T22:53:57Z",
  "progress": 58.935546875,
  "is_complete": false,
  "is_snapshot": false,
  "is_active": true,
  "snapshot_height": -1,
  "snapshot_index": -1,
  "rolls": 71965,
  "roll_owners": 458,
  "staking_supply": 581115775.293209,
  "staking_percent": 71.66191388216313,
  "active_bakers": 200,
  "active_endorsers": 421,
  "missed_priorities": 22,
  "missed_endorsements": 459,
  "n_double_baking": 0,
  "n_double_endorsement": 0,
  "n_orphans": 0,
  "solvetime_min": 60,
  "solvetime_max": 285,
  "solvetime_mean": 60.72990886495457,
  "priority_min": 0,
  "priority_max": 3,
  "priority_mean": 0.009113504556752305,
  "endorsement_rate": 99.4055636137588,
  "endorsements_min": 25,
  "endorsements_max": 32,
  "endorsements_mean": 31.80978035640282,
  "seed_rate": 168,
  "worst_baked_block": 626689,
  "worst_endorsed_block": 626689,
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
`rolls` *int64*              | Number of rolls at selected snapshot block or most recent snapshot block.
`roll_owners` *int64*        | Number of unique roll owners (delegates) at selected snapshot block or most recent snapshot block.
`staking_supply` *money*     | Total staked supply at selected snapshot block or most recent snapshot block.
`staking_percent` *float*    | Percent of total supply staked at selected snapshot block or most recent snapshot block.
`active_bakers` *int64*        | Number of unique bakers seen.
`active_endorsers` *int64*     | Number of unique endorsers seen.
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

Shows full detail about a past or current election including up to four voting periods and detailed results. Elections represent metadata about each consecutive run of related voting periods. Elections may contain 4, 2 or 1 vote periods. They are called empty when only one empty proposal vote without a proposal exists. Votes represent on-chain voting periods, proposals represent individual proposals that are submitted by a source and upvoted by other bakers, ballots represent the individual ballot operations sent by bakers during votes.

### HTTP Request

`GET https://api.tzstats.com/explorer/election/{head,number}`

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
curl "https://api.tzstats.com/explorer/op/ooxRwXAEM76NyMGyn4hHjS9D2Q8UkWVV6W2Esk2LZaq2tzFBH3p"
```

> **Example response.**

```json
[
  {
    "hash": "ooxRwXAEM76NyMGyn4hHjS9D2Q8UkWVV6W2Esk2LZaq2tzFBH3p",
    "type": "transaction",
    "block": "BKqv8SBNabXEMXV9fsy21yx9BNsqWBKVVp9ca4KTMpGsF2Wi8Uj",
    "time": "2019-09-28T13:10:51Z",
    "height": 627341,
    "cycle": 153,
    "counter": 1946527,
    "op_n": 26,
    "op_c": 0,
    "op_i": 0,
    "status": "applied",
    "is_success": true,
    "is_contract": false,
    "gas_limit": 10300,
    "gas_used": 10200,
    "gas_price": 0.98039,
    "storage_limit": 0,
    "storage_size": 0,
    "storage_paid": 0,
    "volume": 2047.9,
    "fee": 0.01,
    "reward": 0,
    "deposit": 0,
    "burned": 0,
    "is_internal": false,
    "has_data": false,
    "days_destroyed": 203.367847,
    "parameters": null,
    "storage": null,
    "data": null,
    "big_map_diff": null,
    "errors": null,
    "sender": "tz1bnaCyDdJNjD8TcZPLNc2kBfJsYhNe86Lm",
    "receiver": "tz1a6WGHRq16ENkxbJVHbtGX4D6mUkCGo5sA",
    "branch_id": 627341,
    "branch_height": 627340,
    "branch_depth": 1,
    "branch": "BKr3kjkbi5LndjDTDDSPUWubZjrdSBCWLJudmuGYuiVuG2j8fvj"
  }
]
```

Returns info about a single operation or a list of related operations. Because Tezos supports batch operations (multiple operations sharing the same hash) and internal operations (created by smart contract calls in response to a transaction) this endpoint always returns an array of operation objects. In many cases this array contains one element only. Use the optional `prim` (boolean) parameter to embed Michelson primitive trees with smart contract calls.

### HTTP Request

`GET https://api.tzstats.com/explorer/op/{hash}`

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
`op_n` *int64*           | Operation position in block. (Tezos defines 4 arrays used for the different op verification steps. The `op_n` value represents the global operation position across all these arrays.)
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
`volume` *money*         | Amount of tokens transferred in tz.
`fee` *money*            | Fees paid in tz.
`reward` *money*         | Rewards earned in tz.
`deposit` *money*        | Amount of deposited tokens in tz.
`burned` *money*         | Amount of burned tokens in tz.
`is_internal` *bool*     | Flag indicating if this operation was sent be a smart contract.
`has_data` *bool*        | Flag indicating if extra data or parameters are present.
`data` *polymorph*       | Extra type-dependent operation data. See below.
`parameters` *object*    | Call parameters as embedded JSON object, contract-only.
`storage` *object*       | Updated contract storage as embedded JSON object, contract-only.
`big_map_diff` *object*  | Inserted, updated or deleted bigmap entries as embedded JSON object, contract-only.
`errors` *object*        | When failed, contains details about the reason as JSON object.
`days_destroyed` *float* | Token days destroyed by this operation (`tokens transferred * token idle time`).
`parameters` *object*    | Contract call parameters.
`storage` *object*       | Updated version of contract storage after call.
`data` *object*          | Extra operation data (see below for content encoding).
`big_map_diff` *array*   | List of bigmap updates.
`errors` *object*        | Embedded native Tezos RPC error object.
`sender` *hash*          | Operation sender, always set.
`receiver` *hash*        | Transaction receiver, may be empty.
`delegate` *hash*        | New Delegate, only used by `origination` and `delegation`. When empty for a `delegation` the operation was a delegate withdrawal.
`manager` *hash*         | Contract manager, `origination` only.
`branch_id` *uint64*     | Row id of the branch block this op refers to.
`branch_height` *int64*  | Height of the branch block this op refers to.
`branch_depth` *int64*   | Count of blocks between branch block and block including this op.
`branch` *hash*          | Block hash of the branch this op refers to.

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

