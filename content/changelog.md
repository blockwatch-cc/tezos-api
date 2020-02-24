---
weight: 90
title: Changelog | TzStats Data API
---

# Changelog

Recent changes and additions to the TzStats Data API.

## 2020-02-24 {#2020-02-24}

### FIXES

- **etl/model:** frozen deposits, rewards and fees were not correctly deducted from delegate balance and total frozen supply
- **etl/model:** fixed spelling of `denunciation` type in flow table
- **chain:** use protocol constants for snapshot block calculations (was a fixed offset value before that only worked on mainnet)
- **chain:** tolerate arbitrary padding after binary address values in contract storage (when manually packed into type bytes inside a contract one can add an optional annotation which now gets stripped to obtain a valid address)
- **etl/index:** fix performance on zero rights to avoid edge case in 3rd party reputation algorithms that penalized bakers without rights, no income still yields 100% performance now
- **micheline/entrypoint:** fix detecting named Unit entrypoints
- **etl/index:** fix empty bigmap operation that deletes all keys and allocates a new bigmap, added `is_removed` bool field to explorer/bigmap endpoint
- **micheline/bigmap:** refactor to support pairs as key type

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
- **api/contract:** added new field `iface_hash` (first 4 bytes of the SHA256 hash over binary encoded Michelson script parameters)
- **api/contract:** added new field `call_stats` with per-entrypoint call statistics (an array containing running totals)
- **api/contract:** added new fields `op_l`, `op_p` and `op_i` to reference the position of the contract's origination operation in a block.
- **api/contract:** contract calls now support `entrypoint` filters using entrypoint name, branch or id
- **etl/model:** added cycle `start_time` and `end_time` to baker income (estimated when start or end is in the future)
- **api/series:** new time-series endpoints for `chain` and `supply` tables that will return the first value per collapse interval (ie. first value per hour or day)

### BREAKING CHANGES

- **block:** replaced fields `deposits`, `fees`, `rewards` (plural) which included total sums of all baking and endorsing activity in a block with `deposit`, `fee`, `reward` (singular form) to only cover baking activity
- **flow:** replaced  fields `origin_id` and `origin` with `counterparty_id` and `counterparty`; origin used to contain the source of a flow but was too restrictive since on-way only, now counterparty can hold either party (sender or receiver) who has caused or received a flow, on in-flows (amount_in > 0) the counterparty is the sender, on out-flows (amount_out > 0) counterparty it receiver
- **flow:** changed data for `denunciation` operations, now losses incured by the offender are kept in `reward`, `fee`, and `deposit` **as negative values**, reward for the accuser is stored in `volume` as positive value
- **contract/script:** JSON keys for entrypoint arguments now always follow the convention `<order>@<name>`, ie. they include an integer order number as first argument, followed by an optional `@` symbol and an optional argument name extracted from type annotations. This way argument order is no longer lost when a name is defined.
- **bigmap/type:** JSON keys for bigmap type arguments now always follow the convention `<order>@<name>@<container-type>`, ie. they include an integer order number as first argument, followed by an optional `@` symbol, an optional name extracted from type annotations and in case the type is a container like list, map or set another `@` and the container type. This way type argument order is no longer lost when a name is defined.
- **flow table:** added new fields `op` (hash), `op_id` (uint64), `op_n`, `op_l`, `op_p`, `op_c`, `op_i` (int) which contain metadata about the operation the flow relates to (Note: JSON bulk array list positions shift because these fields are not added to the end of the inner array)
- **operation table:** added new fields `op_l`, `op_p` containing Tezos RPC operation list positions, and `is_implicit` for non-operation events as well as `entrypoint_id` (Note: JSON bulk array list positions shift because this field is not added to the end of the inner array). Changed `op_n` to contain a unique per-block operation counter for all events and regular operations.

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


