---
weight: 90
title: Changelog
---

# Changelog

Recent changes and additions to the TzStats Data API.

## 2021-04-16 {#2021-04-16}

- API: fix offset argument on contract calls
- API: new contract storage, bigmap, parameters data decoding engine
- API: new JSON-schema powered metadata enpoints `/metadata`
- API: add `confirmations` to operations

### BREAKING CHANGES

New Micheline decoding engine with changes to data types exported on storage, bigmaps and operation parameters.

- API: new data formats for type definitions on contract storage, entrypoints, bigmap key and value types
  - type definitions are arrays instead of objects
  - value keys are without type always
  - more record nesting levels exported from Micheline type annotations
- API: new data formats for bigmap keys and values, deprecated fields `key_binary`, `key_unpacked`, `key_pretty`, `value_unpacked`, `key_type`, `key_encoding`
- API: contract data decoding does no longer unpack bytes to string/timestamp/etc. automatically, use argument `unpack`
- API: deprecated endpoints `/explorer/bigmap/:id/type` (merged into bigmap info),
- API: changed bigmap update URL for single keys from `/explorer/bigmap/:id/:key/updates` to `/explorer/bigmap/:id/updates/:key`
- API: supply metrics: removed `vesting` and `circulating`, added `liquid` (= total - frozen - unclaimed)


## 2021-02-10 {#2021-02-10}

A big deal of behind-the-scenes performance improvements went into this release, so that we are able to deliver the snappy response times you're used to. We've started to **prune irrelevant historic data** from `rights` (unused bolck priorities) and `snapshots` (non-selected baker and delegator balances) to make querying relevant data faster.

We also reworked our smart contract data model, stripping less useful fields available elsewhere and adding new fields like detected interface standard and used Michelson features. When contract code is patched by a protocol upgrade we now add an implicit migration operation and update the stored representation of contract code as well. The previous version of the contract code is still available, either as part of the origination or the most recent migration operation.

This release adds support for Edo, namely Michelson extensions tickets, comb pairs and lazy storage (currently still exposed as bigmap on the API) as well as simple Sapling support (traking total Sapling supply and flows). Please reach out to tzstats@blockwatch.cc if you need additional Sapling or ticket support.

We decided to not remove deprecated operation listing endpoints because many people still use them and we found a way to optimize their performance.

### BREAKING CHANGES
- **api/contract:** simplified and extended contract data model
- **api/contract:** replaced `bigmap_ids` array (numeric only) with `bigmaps` object (mapping name to bigmap id)
- **api/contract:** renamed `/explorer/contract/{hash}/manager` to `/explorer/contract/{hash}/creator`
- **api/block:** removed `endorsers` list and replaced it with an optional more informative but `rights` list (use new query arg `rights=1`)
- **api/account:** renamed `/explorer/account/{hash}/managed` to `/explorer/account/{hash}/contracts`
- **api/account:** removed deprecated fields `is_delegatable`, `is_spendable` and `is_vesting`
- **api/account:** renamed field `manager` to `creator`
- **api/op:** renamed field `manager` to `creator`
- **api/op:** branch info moved behind the `meta` flag

### NEW FEATURES
- **api/metadata:** added structured metadata to accounts, available as optional embedded field `metadata` on all accounts, operations, contracts, and contract calls (use new query arg `meta=1`)
- **api/metadata:** account metadata is also available as list on `/explorer/metadata` and single objects on `/explorer/metadata/{hash}`
- **api/contract:** added new lists `interfaces` and `features` that signal whether a contract implements any well-known interface standard or uses a specific Michelson feature
- **api/block:** added new `rights` list that details owner and status of baking and endorsing rights
- **api/bakers:** added new endpoint `/explorer/bakers` with several filters to list all active public and non-public bakers
- **api/op:** new implicit contract migration operations as event log about changes to deployed contracts on protocol upgrades
- **api/protocols:**: new endpoint `/explorer/protocols` to list all deployed protocols,
- **api/bigmap:** support bigmap pair keys from comma separated url args
- **etl** support Edonet, Edo protocol, new Edo opcodes, comb pairs, tickets and lazy storage
- **etl** detect Sapling enabled accounts, flag them in contract `features`
- **etl/flow** new `is_shielded` and `is_unshielded` flags to indicate flows into and out of Sapling contracts
- **etl/op** new `is_sapling` flag to indicate a transaction interacted with a Sapling contracts


### FIXES
- **etl/account**: fix removing accounts on rollback
- **api/bigmap**: more bigmap value rendering fixes


### DEPRECATION NOTICES
- **api/explorer**: `deployments` list in `/explorer/tip` will be removed in a future version


## 2020-06-24 {#2020-06-24}

To handle the surge in volume we're optimizing a few of the most heavily used API endpoints. Our aim is to improve user experience and stabilty for everybody.

The most important change is that we begin migrating operation listings on explorer endpoints from embedded arrays inside accounts/blocks to stand-alone arrays. Both flavors will be available in parallel for a while. For high-speed high-volume access, consider using the table API endpoints. Table access is much faster since data is streamed and requires less calls due to higher limits.

As we keep adding new fields to tables and time-series the default order of JSON bulk arrays may change over time. To ensure that our API always returns the field order you expect, use the `columns` query argument. The order of columns you specify is exactly the order that's returned.


### DEPRECATION NOTICES
- **api/account:** listing operations with `/explorer/account/{hash}/ops` and the embedded `ops` array will be removed in the next API release
- **api/block:** listing operations with `/explorer/block/{hash}/ops` and the embedded `ops` array will be removed in the next API release

### BREAKING CHANGES
- **api/block:** `nonce` is now returned as hex string
- **api/cycle:** renamed `active_{bakers|endorsers}` to `working_{bakers|endorsers}`, also note the change in meaning of `active_bakers` as described below
- **api/account:** renamed explorer and table field `flow_rank` to `volume_rank`
- **api/account:** moved `call_stats` from account table to contract table
- **api/account:** we're now hiding unused baker fields from non-baker accounts
- **api/account:** changed `/explorer/account/{hash}/ballots` return value from an account object with embedded `ballots` field to a ballots array

### FIXES
- **api/account:** fixed traffic and volume rank sorting
- **api/account:** return origination only when no entrypoint filter is used
- **api/account:** fixed `since` off-by-one bug on contract call and account operation lists
- **api/account:** fixed `until` param not limiting call/operation lists for recently active accounts
- **api/account:** fixed duplicates in account operation list
- **api/operation:** fixed return data from bigmap copy and bigmap delete operations
- **api/cache:** fixed cache expiration time on account, contract, rights
- **etl/income:** don't count unfrozen rewards into end-of-cycle snapshots
- **etl/income:** use max block reward for counting missed rewards on priority zero baker and max endorsement reward for missed endorsement slots
- **etl/statistics:** fixed active delegation counting for foundation bakers
- **etl/statistics:** fixed block volume counting for failed ops
- **etl/account:** fixed pubkey updates on reveal that caused some keys to be scrambled
- **api/deployments:** fixed protocol version lookup and deployment info
- **etl/income:** fixed `total_income` to include all fees and denunciation rewards

### NEW FEATURES
- **api/operation:** `delegation` operations now have `volume` field set to the initial delegated balance
- **api/operation:** new fields `is_batch` and `batch_volume` on first operation in an explorer batch list
- **api/operation:** added new implicit activation and delegation operations from genesis bootstrap
- **api/operation:** `bake` and `unfreeze` implicit operations now contain the baker as sender and receiver to allow listing bake/endorse/unfreeze ops with a single operation table call
- **api/operation:** added implicit baker registrations in protocols v001 (due to a protocol bug) and v002 (at migration)
- **api/series:** new virtual column `count` that contains the number of aggregated entries per bucket
- **api/account:** support query arguments `limit`, `cursor`, `order` on ballot lists
- **api/account:** new explorer fields `avg_luck_64`, `avg_performance_64`, `avg_contribution_64`, `baker_version`, `delegate_until` and `delegate_until_time`
- **api/cycle:** new explorer fields `snapshot_time`, `active_bakers` and `active_delegators` for a total number of all registered bakers and funded delegators at cycle snapshot
- **api/account:** new table fields `next_bake_height`, `next_bake_priority`, `next_bake_time`, `next_endorse_height`, `next_endorse_time` that will be set for active bakers
- **api/ballot:** new table filter modes `ne`, `in`, `nin` for `ballot`
- **api/rights:** new table filter modes `ne`, `in`, `nin` for `type`
- **api/rights:** new flag `is_bond_miss` to differentiate loss events between low bonds and other failures
- **new** explorer endpoints `/explorer/rank/balances` (rich list), `/explorer/rank/traffic` (1D transaction counts), `/explorer/rank/volume` (1D transaction volume)
- **new** explorer endpoint `/explorer/election/:id/:stage/voters` to list all voters
- **new** explorer endpoint `/explorer/election/:id/:stage/ballots` to list all ballots cast during a voting period
- **new** explorer endpoint `/explorer/account/{hash}/operations` (replaces embeds on `../ops`)
- **new** explorer endpoint `/explorer/block/{hash}/operations` (replaces embeds on `../ops`)
- support `filename` argument for CSV downloads from tables and time-series


## 2020-02-24 {#2020-02-24}

### FIXES

- **etl/model:** frozen deposits, rewards and fees were not correctly deducted from delegate balance and total frozen supply
- **etl/model:** fixed spelling of `denunciation` type in flow table
- **chain:** use protocol constants for snapshot block calculations (was a fixed offset value before that only worked on mainnet)
- **chain:** tolerate arbitrary padding after binary address values in contract storage (when manually packed into type bytes inside a contract one can add an optional annotation which now gets stripped to obtain a valid address)
- **etl/index:** fix baker performance on zero rights to avoid edge case in 3rd party reputation algorithms that penalized bakers without rights, no income still yields 100% performance now
- **micheline/entrypoint:** fix detecting named Unit entrypoints
- **etl/index:** fix empty bigmap operation that deletes all keys and allocates a new bigmap, added `is_removed` bool field to explorer/bigmap endpoint
- **micheline/bigmap:** refactor to support pairs as key type
- **micheline/bigmap:** render empty optional values, use inner type in keys when option annotation is missing

### NEW FEATURES

- **etl:** `delegation` operation now stores previous delegate in formerly unused `receiver` field
- **etl:** `seed_nonce_revelation` operation now stores actual seed publisher in formerly unused `receiver` field
- **etl:** internal transaction operations keep original sender of an external transaction in  formerly unused `manager` field
- **etl:** added new operation types for implicit events `bake`, `invoice`, `airdrop`, `unfreeze`, `seed_slash`; op hashes for implicit operations are empty, values for `op_n` are negative (-1 for block header, -2 for protocol upgrade events); available on explorer, table and series endpoints
- **api/block:** block operation listing now supports `order` similar to accounts
- **api/op:** explorer operation lists now support table-style filters on type, e.g. to filter for multiple types use `type.in=bake,endorsement` as query argument
- **api/op:** explorer operation lists now support `prim` and `unpack` query arguments to simplify working with contract calls
- **api/op:** added new field `entrypoint_id` to operations which contains the sequence number (id) of the called entrypoint; filter by entrypoint on table endpoints is also supported
- **api/op:** added new field `call` to embedded operation `parameters` to identify the actual named entrypoint that was called, this is useful if parameters call the default or root entrypoint and specify the real one by branching
- **api/op:** `unpack=1` now recursively unpacks all packed binary data
- **api/contract:** added new field `iface_hash` (first 4 bytes of the SHA256 hash over binary encoded Michelson script parameters)
- **api/contract:** added new field `call_stats` with per-entrypoint call statistics (an array containing running totals)
- **api/contract:** added new fields `op_l`, `op_p` and `op_i` to reference the position of the contract's origination operation in a block.
- **api/contract:** contract calls now support `entrypoint` filters using entrypoint name, branch or id
- **etl/model:** added cycle `start_time` and `end_time` to baker income (estimated when start or end is in the future)
- **api/series:** new time-series endpoints for `chain` and `supply` tables that will return the first value per collapse interval (ie. first value per hour or day)
- **flow table:** added new fields `op` (hash), `op_id` (uint64), `op_n`, `op_l`, `op_p`, `op_c`, `op_i` (int) which contain metadata about the operation the flow relates to
- **operation table:** added new fields `op_l`, `op_p` containing Tezos RPC operation list positions, and `is_implicit` for non-operation events as well as `entrypoint_id`

### BREAKING CHANGES

- **block:** replaced fields `deposits`, `fees`, `rewards` (plural) which included total sums of all baking and endorsing activity in a block with `deposit`, `fee`, `reward` (singular form) to only cover baking activity
- **flow:** replaced  fields `origin_id` and `origin` with `counterparty_id` and `counterparty`; origin used to contain the source of a flow but was too restrictive since on-way only, now counterparty can hold either party (sender or receiver) who has caused or received a flow, on in-flows (amount_in > 0) the counterparty is the sender, on out-flows (amount_out > 0) counterparty it receiver
- **flow:** JSON bulk array list positions shift because of new fields in the inner array
- **operation:** changed data for `denunciation` operations, now losses incured by the offender are kept in `reward`, `fee`, and `deposit` **as negative values**, reward for the accuser is stored in `volume` as positive value
- **operation:** JSON bulk array list positions shift because of new fields in the inner array. Changed `op_n` to contain a unique per-block operation counter across all implicit and regular operations.
- **contract/script:** JSON keys for entrypoint arguments now always follow the convention `<order>@<name>`, ie. they include an integer order number as first argument, followed by an optional `@` symbol and an optional argument name extracted from type annotations. This way argument order is no longer lost when a name is defined.
- **bigmap/type:** JSON keys for bigmap type arguments now always follow the convention `<order>@<name>@<container-type>`, ie. they include an integer order number as first argument, followed by an optional `@` symbol, an optional name extracted from type annotations and in case the type is a container like list, map or set another `@` and the container type. This way type argument order is no longer lost when a name is defined.

## 2020-01-06 {#2020-01-06}

- UPGRADES
    - supports Carthage protocol PsCARTHAGazKbHtnKfLzQg3kms52kSRpgnDY982a9oYsSXRLQEb
    - supports new Carthage reward constants for Emmy+ called `baking_reward_per_endorsement` and `endorsement_reward` in the Tezos RPC
    - updated expected income based on new rewards formula
- NEW EXPLORER FEATURES
    - `/explorer/config/{height}` now returns two additional float arrays `block_rewards_v6` and `endorsement_rewards_v6` containing the new Carthage reward constants; the previous fields `block_reward` and `endorsement_reward` remain unchanged and will contain the first elements from the corresponding v6 arrays
    - add network health estimation based on recent 128 blocks (priority, endorsements, reorgs)
- FIXES
    - block operation list paging with offset/limit now properly counts internal and batch operations
    - voting period start and end heights are no longer off by 1
    - voting quorum, ema and eligible rolls calculations are corrected
    - improved smart contract entrypoint detection so that annotated parent nodes in the parameter primitive tree are no longer shadowing valid entrypoints
- DEPRECATION NOTICES
	- removed deprecated [contract](#contracts) field `ops` and endpoint `/explorer/contract/{addr}/op` (use `/explorer/account/{addr}/op` endpoint instead)
	- removed deprecated [contract](#contracts) fields `delegate`, `manager`, `script` (use new endpoints or related account endpoints instead)

## 2019-12-05 {#2019-12-05}

- FIXES
	- account `is_revealed` is now correctly reset when account balance becomes zero (in this case a Tezos node will remove all account data including a revealed pubkey from storage)
    - eligible voting rolls are now taken after cycle start block is processed
    - counting duplicate proposal votes has been corrected
    - annualized supply calculation has been fixed to use 365 instead of 364 days
    - fixed vote table  `period_start_height` and `period_end_height` field names
    - fixed empty fields in some CSV results
    - numeric filters on tables now fully support range, in and not-in argument lists
    - corrected `income.missed_baking_income` when prio 0 blocks are lost
    - corrected `supply.circulating` to contain all coins that can move next block (= total - unvested)
- NEW EXPLORER FEATURES
	- added [config](#blockchain-config) field `deployment` that contains a serial counter of protocol activations on the chain
	- changed [config](#blockchain-config) field `version` to show the protocol implementation version (ie. 4 for Athens, 5 for Babylon, etc)
	- added [block](#blocks) field `successor`
	- added [op](#operations) fields `branch_id`, `branch_height`, `branch_depth`, `branch`
	- extended op fields `paramaters`, `storage` and `big_map_diff` to include unboxed types and values and made prim tree optional
	- added new [contract](#contracts) endpoints
		- `/explorer/contract/{addr}/calls` to list smart contract calls
		- `/explorer/contract/{addr}/manager` current manager account (originator in v005)
		- `/explorer/contract/{addr}/script` code, storage &  parameter types
		- `/explorer/contract/{addr}/storage` current storage state
	- added [contract](#contracts) field `bigmap_ids` to list ids of bigmaps owned by this contract
	- added [bigmap](#bigmaps) endpoints
		- `/explorer/bigmap/{id}` bigmap metadata
		- `/explorer/bigmap/{id}/type` bigmap type definition
		- `/explorer/bigmap/{id}/keys` list bigmap keys
		- `/explorer/bigmap/{id}/values` list bigmap key/value pairs
		- `/explorer/bigmap/{id}/updates` list bigmap updates
		- `/explorer/bigmap/{id}/{key}` single bigmap value
		- `/explorer/bigmap/{id}/{key}/updates` list updates for a single bigmap value
	- listing account ops supports `order`, `block` and `since` query arguments
- NEW TABLE FEATURES
	- added [op table](#operation-table) fields `branch_id`, `branch_height`, `branch_depth`
	- added [bigmap table](#bigmap-table) `/tables/bigmap` to access raw bigmap updates
	- changed CSV timestamps to RFC3339 (from UNIX milliseconds)
- DEPRECATION NOTICES
	- removed deprecated [income table](#income-table) fields `efficiency_percent`, `slashed_income` and `lost_baking_income`
	- [contract](#contracts) field `ops` and endpoint `/explorer/contract/{addr}/op` will be removed (use `/explorer/account/{addr}/op` endpoint instead)
	- [contract](#contracts) fields `delegate`, `manager`, `script` will be removed (new endpoints or related account)

## 2019-11-01 {#2019-11-01}

- DEPRECATION NOTICE: income field `efficiency_percent` will be removed with the next release
- replaced income field `efficiency_percent` with `performance_percent` (value range `[-Inf,+Inf]`) to avoid confusion with existing benchmarking metrics that define baker efficiency as percentage or rights utilized
- added new income field `contribution_percent` to measure a baker's contribution to consensus in terms of baking/endorsing rights utilized (value range `[0,100]`, baking/endorsing misses will lower contribution, steals will increase it)
- cycle `n_double_baking` and `n_double_endorsement` count events instead of accusation operations now

## 2019-10-26 {#2019-10-26}

- renamed income table field `lost_baking_income` into `missed_baking_income` to align its name with `missed_endorsing_income`
- renamed income table field `slashed_income` into `total_lost` because it includes not only income but also deposits that may be slashed
- added new income fields `lost_accusation_fees`, `lost_accusation_rewards`, `lost_accusation_deposits`, `lost_revelation_fees`, `lost_revelation_rewards` to differentiate losses
- added new supply field `burned_seed_miss` to capture supply burned by missed seed nonce revelations


## 2019-10-24 {#2019-10-24}

- add `n_endorsed_slots` to block table, series and explorer endpoint
- support bigint in smart contract params, code, bigmaps and storage


## 2019-10-20 {#2019-10-20}

- changed some supply fields from `mined_*` to `minted_*`
- add new supply field `minted_airdrop` for invoices and protocol upgrade airdrops
- support Babylon airdrop of 1 mutez to manager accounts


