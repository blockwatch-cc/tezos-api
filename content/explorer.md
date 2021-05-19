---
weight: 30
title: Explorer Endpoints
---

# Explorer Endpoints

Explorer endpoints serve individual large JSON objects and a few related lists. JSON objects use the typical JSON key/value structure and you cannot limit the contents of objects (i.e. they are always sent in full). CSV format is not supported here.

Most explorer endpoints take different kinds of path arguments to define the object to return. This can be:

- a regular `hash` for blocks, operations or accounts
- the string `head` for the most recent on-chain object (e.g. the recent block or cycle)
- a block `height` (a.k.a level in Tezos)
- a sequence `number` for cycles and elections

### Endpoint Overview

Endpoint | Is Paged | Filter | Comment
---------|----------|--------|----------
`GET /explorer/status`                    |   |   | indexer status |
`GET /explorer/config/{id}`               |   |   | blockchain config at `head` or `height` |
`GET /explorer/tip`                       |   |   | blockchain tip info |
`GET /explorer/protocols`                 |   |   | list of deployed protocols |
`GET /explorer/bakers`                    |   |   | baker list |
`GET /explorer/block/{id}`                |   |   | block info at `head`, `hash`, of `height` |
`GET /explorer/block/{id}/operations`     | x | `type` |list block operations at `head`, `hash`, or `height` |
`GET /explorer/op/{hash}`                 |   |   | operation info |
`GET /explorer/account/{hash}`            |   |   | account info |
`GET /explorer/account/{hash}/contracts`  | x |   | list of contracts managed by this account |
`GET /explorer/account/{hash}/operations` | x | `type` | account info with embedded list of related operations |
`GET /explorer/account/{hash}/ballots`    | x |   | list proposals and ballots |
`GET /explorer/contract/{hash}`           |   |   | smart contract metadata |
`GET /explorer/contract/{hash}/calls`     | x | `entrypoint` | list contract calls |
`GET /explorer/contract/{hash}/creator`   |   |   | contract creator (a.k.a. manager) |
`GET /explorer/contract/{hash}/script`    |   |   | smart contract code, storage and parameter spec |
`GET /explorer/contract/{hash}/storage`   |   |   | smart contract storage |
`GET /explorer/bigmap/{id}`               |   |   | bigmap metadata |
`GET /explorer/bigmap/{id}/keys`          | x |   | list of bigmap keys |
`GET /explorer/bigmap/{id}/values`        | x |   | list of bigmap key/value pairs |
`GET /explorer/bigmap/{id}/{key}`         |   |   | single bigmap value |
`GET /explorer/bigmap/{id}/updates`       | x |   | list of bigmap updates |
`GET /explorer/bigmap/{id}/updates/{key}` **CHANGED** | x |   | list of bigmap updates related to a key|
`GET /explorer/cycle/{id}`                |   |   | cycle info for `head` or `cycle`
`GET /explorer/election/{id}`             |   |   | election metadata and results at `head`, `num` or protocol `hash` |
`GET /explorer/election/{id}/{stage}/voters`| x |   | election voter lists |
`GET /explorer/election/{id}/{stage}/ballots`| x |   | election ballots lists |
`GET /explorer/rank/balances`             | x |   | accounts ranked by balance |
`GET /explorer/rank/volume`               | x |   | accounts ranked by 1D transaction volume |
`GET /explorer/rank/traffic`              | x |   | accounts ranked by 1D traffic |
`GET /metadata/{hash}[/{id}]`             |   |   | structured account & token metadata |
`GET /metadata/schemas`                   |   |   | list of supported JSON schema names |
`GET /metadata/schemas/{schema}`          |   |   | JSON schema definition |
`GET /markets`                            |   |   | list of known exchanges and markets |
`GET /markets/tickers`                    |   |   | list of 1D market tickers |
`GET /markets/{exchange}`                 |   |   | exchange status |
`GET /markets/{exchange}/{market}`        |   |   | market status |
`GET /markets/{exchange}/{market}/ticker` |   |   | single market ticker |

## Pagination and Sorting

List endpoints support pagination (e.g. to list historic transactions, contract calls, voters, etc). Two pagination methods are supported:

- `cursor` + `limit` is the preferred method, it uses the `row_id` of the last result as argument to efficiently skips to the next available object
- `offset` + `limit` is similar, but less efficient, it takes the count of objects seen so far and skips them when retrieving more results (as the chain grows, using offset in combination with descending order may return duplicates; we therefore recommend using the cursor method)

Default value for limit is 20 results on explorer endpoints and 500 results on tables, maximum is 500 and 50,000. Results are always sorted by `row_id` of the underlying table. Sort direction can be controlled by `order` (asc, or desc). If you require sorting by a different field, you have to do this client-side.



## Indexer Status

> **Example request.**

```shell
curl "https://api.tzstats.com/explorer/status"
```

```go
import (
  "context"
  "blockwatch.cc/tzstats-go"
)

// use default Mainnet client
client := tzstats.DefaultClient
status, err := client.GetStatus(context.Background())
```

> **Example response.**

```json
{
  "mode": "sync",
  "status": "synced",
  "blocks": 626399,
  "indexed": 626399,
  "progress": 1
}
```

Returns the current indexer status, useful to check of the indexer is in sync with the blockchain.

### HTTP Request

`GET /explorer/status`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`mode` *enum*      | Chain crawling mode (`sync` = live monitoring).
`status` *enum*    | Indexer status (`connecting`, `syncing`, `synced`, `failed`).
`blocks` *int64*   | Most recent block height seen by the connected Tezos node.
`indexed` *int64*  | Most recent block height indexed.
`progress` *float* | Percentage of blocks indexed.


## Blockchain Config

> **Example request.**

```shell
curl "https://api.tzstats.com/explorer/config/head"
```

```go
import (
  "context"
  "blockwatch.cc/tzstats-go"
)

// use default Mainnet client
client := tzstats.DefaultClient
config, err := client.GetConfig(context.Background())
```

> **Example response.**

```json
{
  "name": "Tezos",
  "network": "Mainnet",
  "symbol": "XTZ",
  "chain_id": "NetXdQprcVkpaWU",
  "deployment": 7,
  "version": 7,
  "protocol": "PsDELPH1Kxsxt8f9eWbxQeRxkjfbxoqM52jvs5Y5fBxWWh4ifpo",
  "start_height": 1212417,
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
  "cost_per_byte": 250,
  "endorsement_reward": 1.25,
  "endorsement_security_deposit": 64,
  "endorsers_per_block": 32,
  "hard_gas_limit_per_block": 10400000,
  "hard_gas_limit_per_operation": 1040000,
  "hard_storage_limit_per_operation": 60000,
  "max_operation_data_length": 16384,
  "max_proposals_per_delegate": 20,
  "max_revelations_per_block": 0,
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
  ],
  "max_anon_ops_per_block": 132,
  "num_voting_periods": 4
}
```

Fetches blockchain configuration parameters. This endpoint accepts `head` and a block `height` as path parameters, so you can access configurations of past protocols as well.


### HTTP Request

`GET /explorer/config/head`


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
`max_anon_ops_per_block` *int64*           | (Delphi, v007) Max number of anonymous ops like seed nonces.
`num_voting_periods`*int64*                | (Edo, v008) Number of voting epochs, Edo introduced a 5th adoption period.

## Blockchain Tip

> **Example request.**

```shell
curl "https://api.tzstats.com/explorer/tip"
```

```go
import (
  "context"
  "blockwatch.cc/tzstats-go"
)

// use default Mainnet client
client := tzstats.DefaultClient
tip, err := client.GetTip(context.Background())
```

> **Example response.**

```json
{
  "name": "Tezos",
  "network": "Mainnet",
  "symbol": "XTZ",
  "chain_id": "NetXdQprcVkpaWU",
  "genesis_time": "2018-06-30T16:07:32Z",
  "block_hash": "BLWxEruWC23hx6EvBFxr8SYCE36H2Xq3hFA3kDFEhSjBhQx7QRj",
  "timestamp": "2021-02-13T10:27:55Z",
  "height": 1342864,
  "cycle": 327,
  "total_accounts": 1101579,
  "funded_accounts": 999143,
  "total_ops": 39596837,
  "delegators": 93314,
  "delegates": 426,
  "rolls": 84949,
  "roll_owners": 404,
  "new_accounts_30d": 103666,
  "cleared_accounts_30d": 15709,
  "funded_accounts_30d": 112848,
  "inflation_1y": 40335052.002298,
  "inflation_rate_1y": 4.884188578147172,
  "health": 98,
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
      "end_height": 1212416
    },
    {
      "protocol": "PsDELPH1Kxsxt8f9eWbxQeRxkjfbxoqM52jvs5Y5fBxWWh4ifpo",
      "version": 7,
      "deployment": 7,
      "start_height": 1212417,
      "end_height": -1
    }
  ],
  "supply": {
    "row_id": 1342865,
    "height": 1342864,
    "cycle": 327,
    "time": "2021-02-13T10:27:55Z",
    "total": 866164181.179763,
    "activated": 576359477.929109,
    "unclaimed": 35095400.481071,
    "liquid": 759883213.005411,
    "delegated": 533114195.249729,
    "staking": 684588680.629035,
    "shielded": 0,
    "active_delegated": 530853021.716629,
    "active_staking": 680814744.486729,
    "inactive_delegated": 2261173.5331,
    "inactive_staking": 3773936.142306,
    "minted": 102201165.989543,
    "minted_baking": 32078464.975639,
    "minted_endorsing": 70116902.006583,
    "minted_seeding": 5199,
    "minted_airdrop": 600.007321,
    "burned": 355582.82248,
    "burned_double_baking": 132029.815883,
    "burned_double_endorse": 31838.219485,
    "burned_origination": 9211.19225,
    "burned_implicit": 177021.9575,
    "burned_seed_miss": 5481.637362,
    "frozen": 61860304.599122,
    "frozen_deposits": 60057024,
    "frozen_rewards": 1801805.068634,
    "frozen_fees": 1475.530488
  },
  "status": {
    "mode": "sync",
    "status": "synced",
    "blocks": 1342864,
    "indexed": 1342864,
    "progress": 1
  }
}
```

Returns info about the most recent block, indexer status, protocol deployments and supply statistics.

### HTTP Request

`GET /explorer/tip`


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


## Accounts

> **Example request for baker accounts.**

```shell
curl "https://api.tzstats.com/explorer/account/tz3RDC3Jdn4j15J7bBHZd29EUee9gVB1CxD9"
```

```go
import (
  "context"
  "blockwatch.cc/tzstats-go"
  "blockwatch.cc/tzgo/tezos"
)

// use default Mainnet client
client := tzstats.DefaultClient

// get account data and embed metadata of available
a, err := client.GetAccount(
  context.Background(),
  tezos.MustParseAddress("tz3RDC3Jdn4j15J7bBHZd29EUee9gVB1CxD9"),
  tzstats.NewAccountParams().WithMeta(),
)
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
  "last_in": 1342841,
  "last_out": 1342841,
  "first_seen": 1,
  "last_seen": 1342841,
  "delegate_since": 1,
  "first_in_time": "2018-06-30T18:11:27Z",
  "first_out_time": "2018-07-03T14:17:12Z",
  "last_in_time": "2021-02-13T10:02:55Z",
  "last_out_time": "2021-02-13T10:02:55Z",
  "first_seen_time": "2018-06-30T17:39:57Z",
  "last_seen_time": "2021-02-13T10:02:55Z",
  "delegate_since_time": "2018-06-30T17:39:57Z",
  "total_received": 3199080.326956,
  "total_sent": 3000000,
  "total_burned": 0,
  "total_fees_paid": 0.044374,
  "total_rewards_earned": 3983406.864835,
  "total_fees_earned": 1034.319477,
  "total_lost": 0,
  "frozen_deposits": 2060800,
  "frozen_rewards": 61046.916177,
  "frozen_fees": 47.928321,
  "spendable_balance": 2061626.622397,
  "total_balance": 4122474.550718,
  "delegated_balance": 18921017.973163,
  "total_delegations": 14,
  "active_delegations": 9,
  "is_funded": true,
  "is_activated": true,
  "is_delegated": false,
  "is_revealed": true,
  "is_delegate": true,
  "is_active_delegate": true,
  "is_contract": false,
  "blocks_baked": 54686,
  "blocks_missed": 590,
  "blocks_stolen": 1349,
  "blocks_endorsed": 937695,
  "slots_endorsed": 1660562,
  "slots_missed": 60304,
  "n_ops": 940181,
  "n_ops_failed": 0,
  "n_tx": 69,
  "n_delegation": 0,
  "n_origination": 0,
  "n_proposal": 0,
  "n_ballot": 11,
  "token_gen_min": 1,
  "token_gen_max": 43238,
  "grace_period": 333,
  "staking_balance": 23043492.523881,
  "staking_capacity": 44530768.468665,
  "rolls": 2880,
  "last_bake_height": 1342802,
  "last_bake_block": "BLyPLQZ19VpVrAKfYd7fBfucjUFxbH8cPEKsudyBM1uJByMt315",
  "last_bake_time": "2021-02-13T09:23:55Z",
  "last_endorse_height": 1342841,
  "last_endorse_block": "BLnw18a8buAJFFNtxkizMm4Bg7oRst3eaUebYBAEeUSRRDZdfLg",
  "last_endorse_time": "2021-02-13T10:02:55Z",
  "next_bake_height": 1342857,
  "next_bake_priority": 0,
  "next_bake_time": "2021-02-13T10:18:55Z",
  "next_endorse_height": 1342843,
  "next_endorse_time": "2021-02-13T10:04:55Z",
  "avg_luck_64": 10055,
  "avg_performance_64": 9889,
  "avg_contribution_64": 9970,
  "baker_version": "08c80261"
}
```

> **Example request for non-baker accounts and contracts.**

```shell
curl "https://api.tzstats.com/explorer/account/KT1QuofAgnsWffHzLA7D78rxytJruGHDe7XG"
```

```go
import (
  "context"
  "blockwatch.cc/tzstats-go"
  "blockwatch.cc/tzgo/tezos"
)

// use default Mainnet client
client := tzstats.DefaultClient

// get account data and embed metadata of available
a, err := client.GetAccount(
  context.Background(),
  tezos.MustParseAddress("KT1QuofAgnsWffHzLA7D78rxytJruGHDe7XG"),
  tzstats.NewAccountParams().WithMeta(),
)
```

> **Example response for non-baker accounts and contracts.**

```json
{
  "address": "KT1QuofAgnsWffHzLA7D78rxytJruGHDe7XG",
  "address_type": "contract",
  "delegate": "tz3RDC3Jdn4j15J7bBHZd29EUee9gVB1CxD9",
  "creator": "KT1QuofAgnsWffHzLA7D78rxytJruGHDe7XG",
  "pubkey": "",
  "first_in": 30,
  "first_out": 30,
  "last_in": 984007,
  "last_out": 984007,
  "first_seen": 1,
  "last_seen": 984056,
  "delegated_since": 1,
  "first_in_time": "2018-06-30T18:11:27Z",
  "first_out_time": "2018-06-30T18:11:27Z",
  "last_in_time": "2020-06-05T19:25:32Z",
  "last_out_time": "2020-06-05T19:25:32Z",
  "first_seen_time": "2018-06-30T17:39:57Z",
  "last_seen_time": "2020-06-05T20:14:32Z",
  "delegated_since_time": "2018-06-30T17:39:57Z",
  "total_received": 0,
  "total_sent": 2822843.928521,
  "total_burned": 0,
  "total_fees_paid": 0,
  "unclaimed_balance": 6731138.546637,
  "spendable_balance": 0,
  "total_balance": 0,
  "is_funded": true,
  "is_activated": false,
  "is_delegated": true,
  "is_revealed": false,
  "is_delegate": false,
  "is_active_delegate": false,
  "is_contract": true,
  "n_ops": 31,
  "n_ops_failed": 0,
  "n_tx": 31,
  "n_delegation": 0,
  "n_origination": 0,
  "token_gen_min": 1,
  "token_gen_max": 1
}
```

Provides information about the most recent state of accounts and smart contracts. Baker accounts and delegator accounts contain additional state information. Use `meta` (boolean) to embed optional metadata. See the table below for details.

### HTTP Request

`GET /explorer/account/{hash}`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`address` *hash*              | Account address as base58-check encoded string.
`address_type` *enum*         | Account address type `ed25519` (tz1), `secp256k1` (tz2), `p256` (tz3), `contract` (KT1) or `blinded` (btz1).
`delegate` *hash*             | Current delegate (may be self when registered as delegate).
`creator` *hash*              | Contract creator account.
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
`rich_rank` *int64* **meta-arg**           | Global rank on rich list by total balance. Requires `meta=1` argument.
`traffic_rank` *int64* **meta-arg**        | Global rank on 1D most active accounts by transactions sent/received. Requires `meta=1` argument.
`volume_rank` *int64* **meta-arg**         | Global rank on 1D most active accounts by volume sent/received. Requires `meta=1` argument.
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
`metadata` *object* **meta-arg**              | Embedded account metadata if available. Requires `meta=1` argument.

### List Account Operations

> **Example request for account operation list.**

```shell
curl "https://api.tzstats.com/explorer/account/tz1irJKkXS2DBWkU1NnmFQx1c1L7pbGg4yhk/operations?limit=100&order=desc"
```

```go
import (
  "context"
  "blockwatch.cc/tzstats-go"
  "blockwatch.cc/tzgo/tezos"
)

// use default Mainnet client
client := tzstats.DefaultClient

// list operations sent and received by this account
ops, err := client.GetAccountOps(
  context.Background(),
  tezos.MustParseAddress("tz1irJKkXS2DBWkU1NnmFQx1c1L7pbGg4yhk"),
  tzstats.NewOpParams().
    WithLimit(100).
    WithOrder(tzstats.OrderDesc),
)
```

`GET /explorer/account/{hash}/operations`

Lists operations sent from and to an account (defaults to all types and ascending order). This endpoint supports pagination with `cursor` or `offset` and `limit`. Use `type` to [filter](#query-filters) for a specific operation type (e.g. `transaction`).

To query for updates after a certain block use the optional argument `since` (int64|hash) or simply use `cursor`. Using block hash has teh advantage that the query is reorg-aware, i.e. it throws a 409 error when the specified block has become orphan.

To change the order of returned operations use the optional `order` (asc|desc) parameter. Use `meta` (boolean) to add optional account metadata.

### List Managed and Created Contracts

> **Example request for listing created contracts.**

```shell
curl "https://api.tzstats.com/explorer/account/tz1UBZUkXpKGhYsP5KtzDNqLLchwF4uHrGjw/contracts"
```

```go
import (
  "context"
  "blockwatch.cc/tzstats-go"
  "blockwatch.cc/tzgo/tezos"
)

// use default Mainnet client
client := tzstats.DefaultClient

// list deployed contracts
contracts, err := client.GetAccountContracts(
  context.Background(),
  tezos.MustParseAddress("tz1UBZUkXpKGhYsP5KtzDNqLLchwF4uHrGjw"),
  tzstats.NewAccountParams(),
)
```

`GET /explorer/account/{hash}/contracts`

Lists all contracts this account has originated. This endpoint has been renamed from `../managed`.

### List Account Ballots

```shell
curl "https://api.tzstats.com/explorer/account/tz1aRoaRhSpRYvFdyvgWLL6TGyRoGF51wDjM/ballots"
```

`GET /explorer/account/{hash}/ballots`

Lists all voting ballots the account has sent. This applies to bakers only.




## Operations

> **Example request.**

```shell
curl "https://api.tzstats.com/explorer/op/opSrt7oYHDTZcfGnhNt3BzGrrCQf364VuYmKo5ZQVQRfTnczjnf"
```

```go
import (
  "context"
  "blockwatch.cc/tzstats-go"
  "blockwatch.cc/tzgo/tezos"
)

// use default Mainnet client
client := tzstats.DefaultClient

// get all members of the operation group identified by hash
opGroup, err := client.GetOp(
  context.Background(),
  tezos.MustParseOpHash("opSrt7oYHDTZcfGnhNt3BzGrrCQf364VuYmKo5ZQVQRfTnczjnf"),
  tzstats.NewOpParams(),
)
```


> **Example response.**

```json
[
  {
    "row_id": 28086947,
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
    "branch_height": 1011874,
    "branch_depth": 1,
    "branch": "BKt5Lz42YyZNaSYkqfx3m9cmZ2qRoqw1duHqvygLUrgxCewYXoS",
    "is_implicit": false,
    "entrypoint_id": 0,
    "is_orphan": false,
    "is_batch": true,
    "is_sapling": false,
    "confirmations": 466404
  },
  // ...
]
```

Returns info about a single operation or a list of related operations. Because Tezos supports batch operations (multiple operations sharing the same hash) and internal operations (created by smart contract calls in response to a transaction) this endpoint always returns an array of operation objects. In many cases this array contains one element only. Use the optional `prim` (boolean) parameter to embed Michelson primitive trees with smart contract calls. Use `meta` (boolean) to add optional account metadata.

### HTTP Request

`GET /explorer/op/{hash|id}`

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
`creator` *hash*         | Contains contract creator on `origination`. For internal `transactions`, the original sender of the external transaction is referenced.
`branch_height` *int64*  **meta-arg** | Height of the branch block this op refers to.
`branch_depth` *int64* **meta-arg**  | Count of blocks between branch block and block including this op.
`branch` *hash*  **meta-arg**        | Block hash of the branch this op refers to.
`entrypoint_id` *int64*  | Serial id of the called entrypoint, only relevant if the operation was a transaction, the receiver is a smart contract and call parameters are present.
`is_orphan` *bool*       | Flag indicating whether this operation was orphaned (not included in any block).
`is_batch` *bool*        | Flag indicating if this operation is part of a batch operation list.
`batch_volume` *money*   | Total amount transferred in a batch operation list. Only available of the first operation of a batch list and only when any transfers happened.
`metadata` *object*      | Use `meta=1` to embed optional account metadata for sender, receiver, delegate, creator. May be empty if no account has metadata defined.
`confirmations`          | Number of blocks following the inclusion of this operation. Usually 6 blocks are OK to consider an operation final (not subject to reorg).

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
- `migration` (implict, no hash, protocol upgrade event `op_n = -2`)

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



## Bakers

Get a list of all active bakers, their current status and affiliation metadata. Optionally filter by **status** and **country** or get a random list of **suggestions** for a given account. This endpoint is supposed to be a simple to use listing feature for wallets and other dapps who like to enable delegation.

### Filter Options

You can filter the baker list by the following criteria

Argument           | Description
-------------------|--------------------------------------------------
`status` *enum*    | Filter by baker status `public`, `private`, `closing`, `closed`.
`country` *enum*   | Filter by baker country of operation (use ISO 3166-1 Alpha-2 country codes, that's two uppercase letters like US, DE, FR)
`suggest` *address* | Return a suggested list of bakers for the given address (see below)
`cursor` *int*     | Last baker id after which to continue listing, use for paging.
`limit` *int*      | Max number of results to return (max 100).
`offset` *int*     | Skip first N results, use for paging instead of cursor.

### Baker Metadata

> **Example request.**

```shell
curl "https://api.tzstats.com/explorer/bakers"
```

> **Example response.**

```json
[
  {
    "id": 25,
    "address": "tz3RDC3Jdn4j15J7bBHZd29EUee9gVB1CxD9",
    "baker_since_time": "2018-06-30T17:39:57Z",
    "baker_version": "31e6641d",
    "total_balance": 3480925.146338,
    "spendable_balance": 1397389.603135,
    "frozen_deposits": 2083328,
    "frozen_rewards": 63537.333133,
    "frozen_fees": 207.543203,
    "staking_balance": 12141916.235343,
    "staking_capacity": 37791553.487076,
    "active_delegations": 8,
    "is_full": false,
    "rolls": 1517,
    "share": 0.017767418980803692,
    "avg_luck_64": 9988,
    "avg_performance_64": 9852,
    "avg_contribution_64": 9948,
    "metadata": {
      "address": "tz3RDC3Jdn4j15J7bBHZd29EUee9gVB1CxD9",
      "alias":{
        "name": "Foundation Baker 1",
        "kind": "validator",
        "logo": "tz3RDC3Jdn4j15J7bBHZd29EUee9gVB1CxD9.png"
      },
      "baker": {
        "status": "private",
        "non_delegatable": true
      },
      "location": {
        "country": "CH"
      },
      "social": {
        "twitter": "TezosFoundation"
      }
    }
  },
  // ...
]
```

Returns structured metadata about a baker.

### HTTP Request

`GET /explorer/bakers`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`id` *int64*       | Internal account id, use for cursor-based paging.
`address` *hash*         | Baker account address.
`baker_since_time` *datetime*  | Time when baker registered.
`baker_version` *hex*    | Git hash of mist recently seen baker software.
`total_balance` *money*         | Currently spendable and frozen balances (except frozen rewards).
`spendable_balance` *money*     | Currently spendable balance.
`frozen_deposits` *money*       | Currently frozen deposits
`frozen_rewards` *money*        | Currently frozen rewards.
`frozen_fees` *money*           | Currently frozen fees.
`staking_balance` *money*       | Current delegated and own total balance.
`staking_capacity` *money*      | Available delegation capacity (before overdelegation).
`active_delegations` *int64*    | Currently active and non-zero delegations.
`is_full` *bool*                | Flag indicating the baker cannot accept more delegations, i.e. is overdelegated.
`rolls` *int64*                 | Number of rolls currently owned.
`avg_luck_64` *float*           | Average luck to get random priority zero baking/endorsing rights for the past 64 cycles (182 days, 6 months).
`avg_performance_64` *float*    | Average reward generation performance for the past 64 cycles (182 days, 6 months).
`avg_contribution_64` *float*   | Average utilization of rights to bake/endorse blocks for the past 64 cycles.
`metadata` *object*             | Structured account metadata.


## Bigmaps

Bigmaps are key-value stores where smart contracts keep large amounts of data. Values in bigmaps are accessed by unique keys. The TzStats bigmap index supports different keys, a **hash** (script expression hash) and the **native** typed version of a key. For convenience, both variants are present in responses as `key_hash` and `key`.

**Types** A bigmap is defined by a `key_type` and a `value_type`. While the key type is most often a simple type (int, string, bytes, address, etc) it can also be an object. Values are represented as unfolded (decoded) form and optionally as original Michelson primitives.

**Unfolding** uses Micheline type annotations from the smart contract to decompose native primitives into nested JSON objects. Annotations become JSON property names. To request the original Micheline primitives, add query parameter `prim=1` (bool).

**Packed Data** When data is **packed** using the `PACK` instruction, an unpacked version can be obtained with the `unpack=1` (bool) query argument. In this case both `key` and `value` contain the unpacked version. We also try to recursively unpack all embedded values of type `bytes` so that URLs, names and other packed data becomes easier to access.

**Metadata** Each bigmap entry comes with a set of **metadata** that describes ist latest update time, block hash and height as well as the bigmap id and its owner contract.

**Pagination** The Bigmap API support paginated queries for keys, values and updates using `limit` and `cursor` or `offset`.

**Historic Values** To query a bigmap at a certain point in time add the `block` (int64|hash) query argument. Using block hashes is reorg-aware, ie. in case you execute a query on a block that becomes orphaned, the API returns a 409 Conflict error.

If you like to query for updates that happened after a certain block, add a `since` (int64|hash) argument.

### **SECURITY WARNING**

Unlike other on-chain data where values and ranges are predictable the contents of bigmaps is entirely user-controlled and unpredictable. IT MAY CONTAIN MALICIOUS DATA INTENDED TO ATTACK YOUR APPLICATIONS AND USERS! Be vigilant and sanitize all data before you process or display it.


## Bigmap Info

> **Example request.**

```shell
curl "https://api.tzstats.com/explorer/bigmap/523"
```

```go
import (
  "context"
  "blockwatch.cc/tzstats-go"
)

// use default Mainnet client
client := tzstats.DefaultClient

bigmap, err := client.GetBigmap(
  context.Background(),
  523,
  tzstats.NewContractParams(),
)
```

> **Example response.**

```json
{
  "alloc_block": "BLmmtt7CFJagi9DWTNNjqD1JBBRmknpmcgAcpsJRhw5KQnybBoc",
  "alloc_height": 1365148,
  "alloc_time": "2021-03-01T02:04:41Z",
  "bigmap_id": 523,
  "contract": "KT1Hkg5qeNhfwpKW4fXvq7HGZB9z2EnmCCA9",
  "key_type": {
    "name": "@key",
    "type": "nat"
  },
  "n_keys": 90005,
  "n_updates": 640725,
  "update_block": "BLFiakfUmXoLuN7DGoRkykQjEHr73ShWspXKLEdDC1hwpHiENu6",
  "update_height": 1478163,
  "update_time": "2021-05-19T10:59:14Z",
  "value_type": {
    "args": [
    {
      "name": "issuer",
      "type": "address"
    },
    {
      "name": "objkt_amount",
      "type": "nat"
    },
    {
      "name": "objkt_id",
      "type": "nat"
    },
    {
      "name": "xtz_per_objkt",
      "type": "mutez"
    }
    ],
    "name": "@value",
    "type": "struct"
  }
}
```

Returns information about the identity and type of a bigmap. At access native Micheline type info, add `prim=1` (boolean)

### HTTP Request

`GET /explorer/bigmap/{id}`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`alloc_block` *hash*     | Hash of the block where the bigmap was allocated.
`alloc_height` *int64*   | Height when the bigmap was allocated.
`alloc_time` *datetime*  | Timestamp when the bigmap was allocated.
`bigmap_id` *int64*      | Unique on-chain id of this bigmap.
`contract` *hash*        | Contract that owns the bigmap.
`key_type` *object*      | Typedef describing bigmap keys.
`value_type` *object*    | Typedef describing bigmap values.
`n_keys` *int64*         | Current number of live keys in bigmap.
`n_updates` *int64*      | Total update count.
`update_height` *int64*  | Last update height.
`update_block` *hash*    | Hash of the block containing the latest update.
`update_time` *datetime* | Last update timestamp.
`key_type_prim` *object*   | Native Micheline type for key.
`value_type_prim` *object* | Native Micheline type for value.


## Bigmap Keys

> **Example request.**

```shell
curl "https://api.tzstats.com/explorer/bigmap/523/keys?meta=1&prim=1&unpack=1"
```

```go
import (
  "context"
  "blockwatch.cc/tzstats-go"
)

// use default Mainnet client
client := tzstats.DefaultClient

keys, err := client.GetBigmapKeys(
  context.Background(),
  523,
  tzstats.NewContractParams().
    WithMeta().
    WithPrim().
    WithUnpack(),
)

// access integer key
i, ok := keys[0].GetBig("")

// access pair key element
addr, ok := keys[0].GetAddress("0")
```

> **Example response.**

```json
[
  {
    "key": "29",
    "key_hash": "exprvFW5tJBbcQUhtABJ2ThMb6v5ufBaoanohBBBikEMBJDjEjKdS6",
    "meta": {
      "bigmap_id": 523,
      "block": "BLBx21J2jcSEUpFZyCkCjWf2M4SGsTyPZnQLnZYD3KpKWm7ZpYM",
      "contract": "KT1Hkg5qeNhfwpKW4fXvq7HGZB9z2EnmCCA9",
      "height": 1366105,
      "is_removed": false,
      "is_replaced": false,
      "time": "2021-03-01T18:10:47Z"
    },
    "prim": {
      "int": "29"
    }
  }
  // ...
]
```

Lists bigmap keys with optional metadata, native primitives and unpacking. Supports

- paging with `limit` and `cursor` / `offset`
- historic key listing using `block` (int64|hash)
- native Micheline primitives `prim=1`
- unpacking of packed data withh `unpack=1`

### HTTP Request

`GET /explorer/bigmap/{id}/keys`

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`key` *polymorph*     | The native representation of the key. Integers are bigints wrapped in strings, other types are rendered according to type rules, e.g. addresses, keys and signatures are base58check encoded, timestamps are ISO8601, etc. Can be used for lookup.
`key_hash` *hash*     | The script expression hash for this key. Can be used for lookup.
`meta` *object*        | Metadata for the current bigmap entry (optional, use `meta=1`).
  `meta.bigmap_id` *int64*  | Unique on-chain id of this bigmap.
  `meta.contract` *hash*    | Contract that owns the bigmap.
  `meta.time` *datetime*    | Update timestamp for this key/value pair.
  `meta.height` *int64*     | Update height for this key/value pair.
  `meta.block` *hash*       | Hash of the block containing the latest update.
  `meta.is_replaced` *bool* | Flag indicating if a future update has overwritten the current value. Useful in combination with the `block` parameter that allows to query a value at a point in history.
  `meta.is_removed` *bool* | Flag indicating if a future remove action has deleted the current key. Useful in combination with the `block` parameter that allows to query a value at a point in history.
`prim` *object*        | Native JSON encoded Micheline primitives (optional, use `prim=1`).


## Bigmap Values

> **Example request.**

```shell
curl "https://api.tzstats.com/explorer/bigmap/511/values"
```

```go
import (
  "context"
  "blockwatch.cc/tzstats-go"
)

// use default Mainnet client
client := tzstats.DefaultClient

values, err := client.GetBigmapValues(
  context.Background(),
  511,
  tzstats.NewContractParams().
    WithMeta().
    WithPrim().
    WithUnpack(),
)

// access pair key element
addr, ok := values[0].Key.GetAddress("0")

// access integer value
i, ok := values[0].GetBig("")
```

> **Example response.**

```json
[
  {
    "key": {
      "0": "tz1UBZUkXpKGhYsP5KtzDNqLLchwF4uHrGjw",
      "1": "153"
    },
    "key_hash": "exprvD1v8DxXvrsCqbx7BA2ZqxYuUk9jXE1QrXuL46i3MWG6o1szUq",
    "key_prim": {
      "args": [
        {
          "bytes": "00005db799bf9b0dc319ba1cf21ab01461a9639043ca"
        },
        {
          "int": "153"
        }
      ],
      "prim": "Pair"
    },
    "meta": {
      "bigmap_id": 511,
      "block": "BL9xqjjom8B9wsp6RgMkFjKzNmYKyDqY4nH7Scqvgp9ut4FK1zJ",
      "contract": "KT1RJ6PbjHpwc3M5rw5s2Nbmefwbuwbdxton",
      "height": 1365467,
      "is_removed": false,
      "is_replaced": false,
      "time": "2021-03-01T07:27:27Z"
    },
    "value": "2",
    "value_prim": {
      "int": "2"
    }
  }
  // ...
]
```

Lists key/value pairs in bigmaps with optional metadata, native primitives and unpacking. Supports

- paging with `limit` and `cursor` / `offset`
- historic key listing using `block` (int64|hash)
- native Micheline primitives `prim=1`
- unpacking of packed data withh `unpack=1`


### HTTP Request

`GET /explorer/bigmap/{id}/values`

`GET /explorer/bigmap/{id}/{key}`

The second variant returns a single bigmap value stored at `key` if exists. Key can be a **key hash** (script expr hash) or the **native** key representation (i.e. an address or integer). For pair keys, separate the pair's elements with comma.

### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`key` *polymorph*     | The native representation of the key. Integers are bigints wrapped in strings, other types are rendered according to type rules, e.g. addresses, keys and signatures are base58check encoded, timestamps are ISO8601, etc).
`key_hash` *hash*     | The script expression hash for this key.
`value` *object*       | Unfolded and optionally unpacked value, such as simple string or nested JSON objects/arrays to represent records, lists, sets, and maps.
`meta` *object*        | Metadata for the current bigmap entry (optional, use `meta=1`).
  `meta.contract` *hash*    | Contract that owns the bigmap.
  `meta.bigmap_id` *int64*  | Unique on-chain id of this bigmap.
  `meta.time` *datetime*    | Update timestamp for this key/value pair.
  `meta.height` *int64*     | Update height for this key/value pair.
  `meta.block` *hash*       | Hash of the block containing the latest update.
  `meta.is_replaced` *bool* | Flag indicating if a future update has overwritten the current value. Useful in combination with the `block` parameter that allows to query a value at a fixed block in history.
  `meta.is_removed` *bool* | Flag indicating if a future remove action has deleted the current key. Useful in combination with the `block` parameter that allows to query a value at a fixed block in history.
`key_prim` *object*    | Native Micheline primitive for key (optional, use `prim=1`).
`value_prim` *object*    | Native Micheline primitive for value (optional, use `prim=1`).


## Bigmap Updates

> **Example request.**

```shell
curl "https://api.tzstats.com/explorer/bigmap/511/updates?prim=1&meta=1&unpack=1"
```

```go
import (
  "context"
  "blockwatch.cc/tzstats-go"
)

// use default Mainnet client
client := tzstats.DefaultClient

upd, err := client.GetBigmapUpdates(
  context.Background(),
  511,
  tzstats.NewContractParams().
    WithMeta().
    WithPrim().
    WithUnpack(),
)
```

> **Example response.**

```json
[
  {
    "action": "update",
    "bigmap_id": 511,
    "key": {
      "0": "tz1UBZUkXpKGhYsP5KtzDNqLLchwF4uHrGjw",
      "1": "152"
    },
    "key_hash": "expru3VKqrBfsG3ZbP9eBTTpWrYWth5Ypp8qhn6JyM4BR3pTB3PGu8",
    "key_prim": {
      "args": [
        {
          "bytes": "00005db799bf9b0dc319ba1cf21ab01461a9639043ca"
        },
        {
          "int": "152"
        }
      ],
      "prim": "Pair"
    },
    "meta": {
      "bigmap_id": 511,
      "block": "BMPAfxwn8rgQdhgvHJ479aF5sLPQ3uocSTkeZLDpLapf4Wqp34J",
      "contract": "KT1RJ6PbjHpwc3M5rw5s2Nbmefwbuwbdxton",
      "height": 1365242,
      "is_removed": false,
      "is_replaced": true,
      "time": "2021-03-01T03:39:21Z"
    },
    "value": "1",
    "value_prim": {
      "int": "1"
    }
  }
  // ...
]
```

List historic updates to a bigmap in chronological order, including keys that have been deleted. Supports

- paging with `limit` and `cursor` / `offset`
- native Micheline primitives `prim=1`
- unpacking of packed data withh `unpack=1`

### HTTP Request

`GET /explorer/bigmap/{id}/updates`

`GET /explorer/bigmap/{id}/updates/{key}`

The second variant lists updates for a specific key only.Key can be a **key hash** (script expr hash) or the **native** key representation (i.e. an address or integer). For pair keys, separate the pair's elements with comma.


### HTTP Response

Contains the same fields as the values endpoint above with one addition:


Field              | Description
-------------------|--------------------------------------------------
`action` *enum*    | Update kind, one of `alloc`, `update`, `remove`, `copy`.
`bigmap_id` *int64*  | Unique on-chain id of this bigmap.
`key` *polymorph*     | The native representation of the key. Integers are bigints wrapped in strings, other types are rendered according to type rules, e.g. addresses, keys and signatures are base58check encoded, timestamps are ISO8601, etc).
`key_hash` *hash*     | The script expression hash for this key.
`value` *object*       | Unfolded and optionally unpacked value, such as simple string or nested JSON objects/arrays to represent records, lists, sets, and maps.
`meta` *object*        | Metadata for the current bigmap entry (optional, use `meta=1`).
  `meta.contract` *hash*    | Contract that owns the bigmap.
  `meta.bigmap_id` *int64*  | Unique on-chain id of this bigmap.
  `meta.time` *datetime*    | Update timestamp for this key/value pair.
  `meta.height` *int64*     | Update height for this key/value pair.
  `meta.block` *hash*       | Hash of the block containing the latest update.
  `meta.is_replaced` *bool* | Flag indicating if a future update has overwritten the current value. Useful in combination with the `block` parameter that allows to query a value at a fixed block in history.
  `meta.is_removed` *bool* | Flag indicating if a future remove action has deleted the current key. Useful in combination with the `block` parameter that allows to query a value at a fixed block in history.
`key_prim` *object*    | Native Micheline primitive for key (optional, use `prim=1`).
`value_prim` *object*    | Native Micheline primitive for value (optional, use `prim=1`).
`source_big_map` *int64* | Source bigmap copied (only for action=copy).
`destination_big_map` *int64* | Destination bigmap created (only for action=copy).


## Blocks

> **Example request.**

```shell
curl "https://api.tzstats.com/explorer/block/1342853?meta=1&rights=1"
```

```go
import (
  "context"
  "blockwatch.cc/tzstats-go"
)

// use default Mainnet client
client := tzstats.DefaultClient

block, err := client.GetBlockHeight(
  context.Background(),
  1342853,
  tzstats.NewBlockParams().
    WithMeta().
    WithRights(),
)
```

> **Example response.**

```json
{
  "hash": "BLhRjTFhk37a8vgE2M5DU2cCbtV3qJHaBBPvTboHfyLYV74hM99",
  "predecessor": "BKjZfegUTsCD3eURHPur6L6zRmS6c6D9cdwLKoFDU9DcmJmWnaY",
  "successor": "BMKvd7HhwnhCTSWGG2YkDrsWSugcZefo1V5i9gZ2Khz87S3e98k",
  "baker": "tz1bTpviNnyx2PXsNmGpCQTMQsGoYordkUoA",
  "height": 1342853,
  "cycle": 327,
  "is_cycle_snapshot": false,
  "time": "2021-02-13T10:16:55Z",
  "solvetime": 60,
  "version": 7,
  "validation_pass": 4,
  "fitness": 687493,
  "priority": 0,
  "nonce": "6102c808a62a0100",
  "voting_period_kind": "promotion_vote",
  "endorsed_slots": 4294959103,
  "n_endorsed_slots": 31,
  "n_ops": 28,
  "n_ops_failed": 0,
  "n_ops_contract": 1,
  "n_tx": 7,
  "n_activation": 0,
  "n_seed_nonce_revelations": 0,
  "n_double_baking_evidences": 0,
  "n_double_endorsement_evidences": 0,
  "n_endorsement": 19,
  "n_delegation": 1,
  "n_reveal": 1,
  "n_origination": 0,
  "n_proposal": 0,
  "n_ballot": 0,
  "volume": 98233.072783,
  "fee": 0.019784,
  "reward": 38.75,
  "deposit": 512,
  "unfrozen_fees": 0,
  "unfrozen_rewards": 0,
  "unfrozen_deposits": 0,
  "activated_supply": 0,
  "burned_supply": 0.19275,
  "n_accounts": 31,
  "n_new_accounts": 1,
  "n_new_implicit": 1,
  "n_new_managed": 0,
  "n_new_contracts": 0,
  "n_cleared_accounts": 0,
  "n_funded_accounts": 3,
  "gas_limit": 113904,
  "gas_used": 15466,
  "gas_price": 1.27919,
  "storage_size": 621,
  "days_destroyed": 812.427699,
  "pct_account_reuse": 96.7741935483871,
  "n_ops_implicit": 1,
  "metadata": {
    "tz1KfEsrtDaA1sX7vdM4qmEPWuSytuqCDp5j": {
      "alias": {
        "name": "XTZ Master",
        "kind": "validator",
        "logo": "tz1KfEsrtDaA1sX7vdM4qmEPWuSytuqCDp5j.png"
      },
      "baker": {
        "status": "public",
        "fee": 0.08,
        "payout_delay": true
      },
      "location": {
        "country": "AU"
      },
      "social": {
        "twitter": "Xtzmastercom"
      }
    },
    // ...
  },
  "rights": [
    {
      "type": "baking",
      "priority": 0,
      "account": "tz1bTpviNnyx2PXsNmGpCQTMQsGoYordkUoA",
      "is_used": true
    },
    {
      "type": "endorsing",
      "slot": 0,
      "account": "tz2FCNBrERXtaTtNX6iimR1UJ5JSDxvdHM93",
      "is_used": true
    },
    // ...
  ]
}
```

Fetches information about the specified block. Takes either a block `hash`, a block `height` or the string `head` as argument. Use `meta` (boolean) to embed optional account metadata and `rights` to embed information about baking and endorsing rights as well as their status.

### HTTP Request

`GET /explorer/block/{hash,height,head}`

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
`metadata` *object*            | Optional account metadata for baker and endorsers, missing when no metadata is available. Endorser metadata is only embedded when `rights` arg is also set.
`rights` *array*               | List of endorsing (all slots) and baking rights (all priorities up to block priority) including owner and status.


### List Block Operations

> Example request to list block operations.

```shell
curl "https://api.tzstats.com/explorer/block/head/operations?meta=1"
```

```go
import (
  "context"
  "blockwatch.cc/tzstats-go"
)

// use default Mainnet client
client := tzstats.DefaultClient

ops, err := client.GetBlockOps(
  context.Background(),
  1342853,
  tzstats.NewOpParams().
    WithMeta(),
)
```

> **Example response.**

```json
[
  {
    "row_id": 41092042,
    "hash": "",
    "type": "bake",
    "block": "BMbQcVE5Yf7MnzGwHqFWHxwGgL4o6dBK1NywSSWVDYDFHZJijHE",
    "time": "2021-02-13T10:23:55Z",
    "height": 1342860,
    "cycle": 327,
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
    "fee": 0.001411,
    "reward": 40,
    "deposit": 512,
    "burned": 0,
    "is_internal": false,
    "has_data": false,
    "days_destroyed": 0,
    "sender": "tz1cYufsxHXJcvANhvS55h3aY32a9BAFB494",
    "receiver": "tz1cYufsxHXJcvANhvS55h3aY32a9BAFB494",
    "branch_height": 0,
    "branch_depth": 0,
    "branch": "",
    "is_implicit": true,
    "entrypoint_id": 0,
    "is_orphan": false,
    "is_batch": false,
    "is_sapling": false,
    "confirmations": 1000,
    "metadata": {
      "tz1cYufsxHXJcvANhvS55h3aY32a9BAFB494": {
        "alias": {
          "name": "Bakery IL",
          "kind": "validator",
          "logo": "tz1cYufsxHXJcvANhvS55h3aY32a9BAFB494.png"
        },
        "baker": {
          "status": "public",
          "fee": 0.05,
          "payout_delay": true
        },
        "location": {
          "country": "IL",
          "city": "TLV"
        },
        "social": {
          "twitter": "bakery_il"
        }
      }
    }
  },
  // ...
  ]
}
```

Returns a list of operations in the corresponding block as well as a list of implicit events. Supports

- `limit` and `cursor` / `offset` for paging
- `order` with `asc` or `desc`for ordering (by row_id)
- `type` for filtering operations (see [query filters](#query-filters))
- `meta=1` to embed optional account metadata senders, receivers, delegates


### HTTP Request

#### List Block Operations

`GET /explorer/block/{hash,height,head}/operations`

## Contracts

> **Example request.**

```shell
curl "https://api.tzstats.com/explorer/contract/KT1Puc9St8wdNoGtLiD2WXaHbWU7styaxYhD"
```

```go
import (
  "context"
  "blockwatch.cc/tzgo"
  "blockwatch.cc/tzstats-go"
)

// use default Mainnet client
client := tzstats.DefaultClient

contract, err := client.GetContract(
  context.Background(),
  tezos.MustParseAddress("KT1Puc9St8wdNoGtLiD2WXaHbWU7styaxYhD"),
  tzstats.NewContractParams(),
)
```

> **Example response.**

```json
{
  "address": "KT1Puc9St8wdNoGtLiD2WXaHbWU7styaxYhD",
  "creator": "tz1P7A3YFgeSsGgopKN9vUU86W3psgTMdtcJ",
  "delegate": "tz1WCd2jm4uSt4vntk4vSuUWoZQGhLcDuR9q",
  "storage_size": 34600,
  "storage_paid": 34608,
  "first_seen": 1149672,
  "last_seen": 1342865,
  "first_seen_time": "2020-09-29T16:18:45Z",
  "last_seen_time": "2021-02-13T10:28:55Z",
  "n_ops": 13765,
  "n_ops_failed": 158,
  "bigmaps": {
    "accounts": 124
  },
  "iface_hash": "cf9361e1",
  "code_hash": "666dcc01",
  "call_stats": {
    "addLiquidity": 608,
    "approve": 0,
    "default": 0,
    "removeLiquidity": 230,
    "setBaker": 0,
    "setManager": 0,
    "tokenToToken": 16,
    "tokenToXtz": 2421,
    "updateTokenPool": 0,
    "updateTokenPoolInternal": 0,
    "xtzToToken": 2195
  },
  "features": [
    "set_delegate",
    "transfer_tokens"
  ],
  "interfaces": [
    "DEXTER"
  ]
}
```

Returns information about a Tezos smart contract. For balance details call the [explorer account endpoint](#accounts) using the contract's KT1 address.


### HTTP Request

`GET /explorer/contract/{hash}`


### HTTP Response

Field              | Description
-------------------|--------------------------------------------------
`address` *hash*   | Contract address.
`creator` *hash*   | Creator account (called manager before Babylon.
`delegate` *hash*  | Delegate (may be empty).
`storage_size` *int64*    | Storage size allocated in bytes.
`storage_paid` *int64*    | Storage bytes paid for in bytes.
`first_seen` *int64*                | Block height of account creation.
`last_seen` *int64*                 | Block height of last activity.
`delegated_since` *int64*           | Block height of most recent delegation.
`first_seen_time` *datetime*      | Block time of account creation.
`last_seen_time` *datetime*       | Block time of last activity.
`n_ops` *int64*                  | Lifetime total number of operations sent and received.
`n_ops_failed` *int64*           | Lifetime total number of operations sent that failed.
`bigmaps` *object*               | Named bigmaps owned by this contract, map between annotation used in storage spec and bigmap id.
`iface_hash` *bytes*           | Short hash to uniquely identify the contract interface, first 4 bytes of the SHA256 hash over binary encoded Michelson script parameters.
`code_hash` *bytes*            | Short hash to uniquely identify the contract code, first 4 bytes of the SHA256 hash over binary encoded Michelson script code.
`call_stats` *object*          | Per-entrypoint call statistics, as named key/value pairs.
`features` *array*             | Michelson features used by this contract. Any of `account_factory`, `contract_factory`, `set_delegate`, `lambda`, `transfer_tokens`, `chain_id`, `ticket`, `sapling`.
`interfaces` *array*           | Standard interfaces implemented by this contract. Any of `MANAGER`, `SET_DELEGATE`, `TZIP-005`, `TZIP-007`, `TZIP-012`, `DEXTER` (list will be extended).



## Contract Scripts

> **Example request.**

```shell
curl "https://api.tzstats.com/explorer/contract/KT1Puc9St8wdNoGtLiD2WXaHbWU7styaxYhD/script?prim=1"
```

```go
import (
  "context"
  "blockwatch.cc/tzgo"
  "blockwatch.cc/tzstats-go"
)

// use default Mainnet client
client := tzstats.DefaultClient

script, err := client.GetContractScript(
  context.Background(),
  tezos.MustParseAddress("KT1Puc9St8wdNoGtLiD2WXaHbWU7styaxYhD"),
  tzstats.NewContractParams().WithPrim(),
)
```

> **Example response.**

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
    "name": "storage",
    "type": "struct",
    "args": [{
      // ...
    }]
  },
  "entrypoints": {
    "approve": {
      "id": 0,
      "call": "approve",
      "branch": "/L/L/L",
      "type": [{
        "name": "spender",
        "type": "address"
      },{
        "name": "allowance",
        "type": "nat"
      },{
        "name": "currentAllowance",
        "type": "nat"
      }],
      "prim": {
        // ...
      }
    },
    //...
  }
},
// ...
```

`GET /explorer/contract/{hash}/script`

Returns the native Michelson JSON encoding of the deployed smart contract code as well as type specifications for call parameters, storage and bigmaps. Also contains decoded entrypoints and unfolded storage type.

JSON keys for entrypoint arguments always follow the convention `<order>@<name>`, ie. they include an integer order number as first argument, followed by an optional `@` symbol and an optional argument name extracted from type annotations.



Field              | Description
-------------------|--------------------------------------------------
`script` *object*     | Native Micheline primitives (optional, use `prim=1`).
`storage_type` *object* | Typedef for contract storage.
`entrypoint` *object* | List of named entrypoints.
`entrypoint.$.id` *int64*          | Position of the entrypoint in the Michelson parameter tree.
`entrypoint.$.branch` *string*     | Path of left (L) or right \(R) branches to reach the entrypoint's code in the Michelson code tree.
`entrypoint.$.call` *string*       | Annotated name of the entrypoint.
`entrypoint.$.type` *polymorph*    | Array of typedef for entrypoint arguments.
`entrypoint.$.prim` *object*       | Native Micheline primitives (optional, use `prim=1`).



## Contract Storage

> **Example request.**

```shell
curl "https://api.tzstats.com/explorer/contract/KT1Puc9St8wdNoGtLiD2WXaHbWU7styaxYhD/storage?prim=1"
```

```go
import (
  "context"
  "blockwatch.cc/tzgo"
  "blockwatch.cc/tzstats-go"
)

// use default Mainnet client
client := tzstats.DefaultClient

storage, err := client.GetContractStorage(
  context.Background(),
  tezos.MustParseAddress("KT1Puc9St8wdNoGtLiD2WXaHbWU7styaxYhD"),
  tzstats.NewContractParams().WithPrim(),
)
```

> **Example response.**

```json
{
  "value": {
    "accounts": "124",
    "freezeBaker": false,
    "lqtTotal": "55431856030",
    "manager": "KT1B5VTw8ZSMnrjhy337CEvAm4tnT8Gu8Geu",
    "selfIsUpdatingTokenPool": false,
    "tokenAddress": "KT1LN4LPSqTMS7Sd2CJw4bbDGRkMv2t68Fy9",
    "tokenPool": "1494861",
    "xtzPool": "1191482"
  },
  "prim": {
    // ...
  }
}
```

`GET /explorer/contract/{hash}/storage`

Returns the most recent or a historic version of the contract's storage. Supports

- historic values when using `block` (int64|hash)
- metadata about the contract and most recent update time/block with `meta=1`
- native Micheline primitives `prim=1`
- unpacking of packed data withh `unpack=1`


Field              | Description
-------------------|--------------------------------------------------
`meta` *object*        | Metadata for the current storage entry (optional, use `meta=1`).
  `meta.contract` *hash*    | Owner contract.
  `meta.time` *datetime*    | Update timestamp.
  `meta.height` *int64*     | Update height.
  `meta.block` *hash*       | Block hash of latest update.
`value` *object*       | Unfolded storage using type annotations.
`prim` *object*        | Native Micheline primitives (optional, use `prim=1`).



## Contract Calls

> **Example request.**

```shell
curl "https://api.tzstats.com/explorer/contract/KT1Puc9St8wdNoGtLiD2WXaHbWU7styaxYhD/calls?prim=1"
```

```go
import (
  "context"
  "blockwatch.cc/tzgo"
  "blockwatch.cc/tzstats-go"
)

// use default Mainnet client
client := tzstats.DefaultClient

calls, err := client.GetContractCalls(
  context.Background(),
  tezos.MustParseAddress("KT1Puc9St8wdNoGtLiD2WXaHbWU7styaxYhD"),
  tzstats.NewContractParams().WithPrim(),
)
```

> **Example response.**

```json
// ...
"parameters": {
  "entrypoint": "addLiquidity",
  "call": "addLiquidity",
  "branch": "/L/L/R",
  "id": 1,
  "value": {
    "addLiquidity": {
      "deadline": "2020-09-30T18:30:44.002Z",
      "maxTokensDeposited": "6000000",
      "minLqtMinted": "1",
      "owner": "tz1fSkEwBCgTLas8Y82SYpEGW9aFZPBag8uY"
    }
  },
  "prim": {
    // ...
  },
},
"big_map_diff": {
  // ...
},
"storage": {
  // ...
}
// ...
```

`GET /explorer/contract/{hash}/calls`

Returns contract calls (transactions) sent to the contract with embedded parameters, storage and bigmap updates. Supports

- metadata with `meta=1`
- native Micheline primitives `prim=1`
- unpacking of packed data withh `unpack=1`
- listing of newer updates with `since` (int64|hash)
- ordering of calls with `order` (asc|desc)
- filtering by `entrypoint` (int64|string) using id, name or branch

Call parameters contain the following properties:

Field              | Description
-------------------|--------------------------------------------------
`entrypoint` *string* | Named entrypoint into the smart contract, e.g. 'default' or '__entrypoint_00__.
`branch` *string*     | Path of left (L) or right \(R) branches to reach the entrypoint's code in the Michelson code tree.
`call` *string*       | Name of the actaully called entrypoint. This is useful if parameters contain a call to default or root entrypoints and specify the real entrypoint by branching only.
`id` *int64*          | Position of the entrypoint in the Michelson parameter tree.
`value` *object*      | Call parameters in order of type definition.
`prim` *object*       | Native Micheline primitives (optional, use `prim=1`).



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

`GET /explorer/cycle/{head,number}`

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
  "voting_period": "promotion",
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
  "exploration": {
    "voting_period": 16,
    "voting_period_kind": "exploration",
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
  "cooldown": {
    "voting_period": 17,
    "voting_period_kind": "cooldown",
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
  "promotion": {
    "voting_period": 18,
    "voting_period_kind": "promotion",
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

`GET /explorer/election/{head,hash,number}`

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
`voting_period` *enum*  | Period kind `proposal`, `exploration`, `cooldown`, `promotion`, `adoption`.
`proposal` *object*        | Vote object for the proposal period 1 (see below).
`exploration` *object*     | Vote object for the exploration period 2 (see below).
`cooldown` *object*        | Vote object for the cooldown period 3 (see below).
`promotion` *object*       | Vote object for the promotion vote period 4 (see below).
`adoption` *object*        | Vote object for the adoption vote period 5 (see below).

### Voting Period Object

Field              | Description
-------------------|--------------------------------------------------
`voting_period` *int64*        | Protocol-level voting period counter.
`voting_period_kind` *enum*  | Period kind `proposal`, `exploration`, `cooldown`, `promotion`, `adoption`.
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

`GET /explorer/election/{hash,number,head}/{stage}/voters`

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

`GET /explorer/election/{hash,number,head}/{stage}/ballots`

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

`GET /markets/tickers`

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




