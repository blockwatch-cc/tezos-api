---
weight: 90
title: Changelog | TzStats Data API
---

# Changelog

Recent changes and additions to the TzStats Data API.

## 2019-12-05

- FIXES
	- account `is_revealed` is now correctly reset when account balance becomes zero (in this case a Tezos node will remove all account data including a revealed pubkey from storage)
    - eligible voting rolls are now taken after cycle start block is processed
    - counting duplicate proposal votes has been corrected
    - annualized supply calculation has been fixed to use 365 instead of 364 days
    - fixed vote table  `period_start_height` and `period_end_height` field names
    - fixed empty fields in some CSV results
    - numeric filters on tables now fully support range, in and not-in argument lists
    - corrected `missed_baking_income` when prio 0 blocks are lost
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
- NEW TABLE FEATURES
	- added [op table](#operation-table) fields `branch_id`, `branch_height`, `branch_depth`
	- added [bigmap table](#bigmap-table) `/tables/bigmap` to access raw bigmap updates
	- changed CSV timestamps to RFC3339 (from UNIX milliseconds)
- DEPRECATION NOTICES
	- removed deprecated [income table](#income-table) fields `efficiency_percent`, `slashed_income` and `lost_baking_income`
	- [contract](#contracts) field `ops` and endpoint `/explorer/contract/{addr}/op` will be removed (use `/explorer/account/{addr}/op` endpoint instead)
	- [contract](#contracts) fields `delegate`, `manager`, `script` will be removed (new endpoints or related account)

## 2019-11-01

- DEPRECATION NOTICE: income field `efficiency_percent` will be removed with the next release
- replaced income field `efficiency_percent` with `performance_percent` (value range `[-Inf,+Inf]`) to avoid confusion with existing benchmarking metrics that define baker efficiency as percentage or rights utilized
- added new income field `contribution_percent` to measure a baker's contribution to consensus in terms of baking/endorsing rights utilized (value range `[0,100]`, baking/endorsing misses will lower contribution, steals will increase it)
- cycle `n_double_baking` and `n_double_endorsement` count events instead of accusation operations now

## 2019-10-26

- renamed income table field `lost_baking_income` into `missed_baking_income` to align its name with `missed_endorsing_income`
- renamed income table field `slashed_income` into `total_lost` because it includes not only income but also deposits that may be slashed
- added new income fields `lost_accusation_fees`, `lost_accusation_rewards`, `lost_accusation_deposits`, `lost_revelation_fees`, `lost_revelation_rewards` to differentiate losses
- added new supply field `burned_seed_miss` to capture supply burned by missed seed nonce revelations


## 2019-10-24

- add `n_endorsed_slots` to block table, series and explorer endpoint
- support bigint in smart contract params, code, bigmaps and storage


## 2019-10-20

- changed some supply fields from `mined_*` to `minted_*`
- add new supply field `minted_airdrop` for invoices and protocol upgrade airdrops
- support Babylon airdrop of 1 mutez to manager accounts


