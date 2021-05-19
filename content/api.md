---
weight: 20
title: Tezos API
---

# Tezos API

> **API Endpoints**

```
Mainnet: https://api.tzstats.com
Mainnet Staging: https://api.staging.tzstats.com
Edonet: https://api.edo.tzstats.com
Florencenet: https://api.florence.tzstats.com
```

> **RPC Endpoints**

```
Mainnet: https://rpc.tzstats.com
Edonet: https://rpc.edo.tzstats.com
Florencenet: https://rpc.florence.tzstats.com
```

TzStats provides a powerful Tezos API to access fully indexed raw data and statistics collected from the Tezos blockchain. Made and supported by [Blockwatch Data](https://blockwatch.cc). You may use this API free of charge and without limits for non-commercial projects. To inquire about commercial use send an email to license@blockwatch.cc.

This API reference provides information on all public API endpoints and how to call them. Access is not authenticated and we do not enforce rate limits right now, but we monitor usage and may apply limits to guarantee fair usage for everybody.

The TzStats Tezos API supports different kinds of endpoints:

- **explorer** for individual on-chain data like blocks, accounts and operations
- **table** for direct listing of large quantities of rows
- **series** for aggregate counters and statistics as time-series
- **metadata** for off-chain and on-chain metadata
- **markets** for off-chain and on-chain asset prices

## TzStats SDKs

Official client libraries for TzStats are currently available for

- [https://github.com/blockwatch-cc/tzstats-go](Golang)

## Calling the API

Our Tezos API is read-only at the moment, i.e. the only supported HTTP methods are `GET`, `HEAD` and `OPTIONS`. Query parameters must be properly URL encoded and appended as query arguments.

For high-speed high-volume access, always use the table API endpoints. Table and time-series endpoints stream data and have higher limits, that is, they immediately return response headers after accepting and validating a request and then stream rows or aggregated data points as they are fetched from the underlying database.

### Transport Security

> All our certificates are signed by [LetsEncrypt Authority X3 certificate](https://letsencrypt.org/certificates/).

> **Available ciphers are**

    ECDHE-ECDSA-AES256-GCM-SHA384
    ECDHE-ECDSA-CHACHA20-POLY1305
    ECDHE-ECDSA-AES128-GCM-SHA256
    ECDHE-ECDSA-AES256-SHA384
    ECDHE-ECDSA-AES128-SHA256
    ECDHE-RSA-AES256-GCM-SHA384
    ECDHE-RSA-CHACHA20-POLY1305
    ECDHE-RSA-AES128-GCM-SHA256
    ECDHE-RSA-AES256-SHA384
    ECDHE-RSA-AES128-SHA256

The API supports secure connections via **TLS v1.3**, **v1.2** and **v1.1** with Perfect Forward Secrecy based on Elliptic Curves and Diffie Helman key exchange. Insecure HTTP requests to port 80 are automatically redirected to HTTPS on port 443.

### Tezos API Response Headers

All our API responses are tagged with an API version that's included in the `X-Api-Version` HTTP header field as well as the Tezos network id and protocol.

> **Current TzStats Mainnet Response Headers**

    # API version
    X-Api-Version:   v009-2021-04-16

    # Tezos Network (chain id)
    X-Network-Id:    NetXdQprcVkpaWU

    # Tezos Protocol (protocol hash)
    X-Protocol-Hash: PsFLorenaUUuikDWvMDr6fGBRG8kt3e3D3fHoXK1j1BFRxeSH4i


### CORS

TzStats Data API supports cross-origin HTTP requests, commonly referred as [CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS). This means that you can call the API using Javascript from any browser. Right now CORS support is limited to localhost and the tzstats.com domain. Send a request to tzstats@blockwatch.cc if you have an interesting use case and like to get whitelisted.

### Rate Limits

We do not enforce limits on the number of calls or the amount of data you can query from the API. We do, however, use SPAM protection measures that limit the number of connection attempts and HTTP calls over short time-frames. Try to slow down your call rate if you start seeing 429 status codes. Be responsible with calls and retries, this API is a shared resource for everybody.

## Data Formats

> **Regular JSON Objects**

```json
{
  "hash": "BLPUNqkikFAbNDekUhiqJrCaao86o6sPNq5YrcGobHMzSPi4XWr",
  "predecessor": "BM6xrDirVQLYf5KkU7ZFbTdhzxe8Hn9k2K1rR7bmByfcv75dzcu",
  "baker": "tz1XfAjZyaLdceHnZxbMYop7g7kWKPut4PR7",
  "height": 626158,
  "cycle": 152
}
```

> **JSON Bulk Arrays**

```json
[
  [
    "BMRdcMqU63QiXmU8vLE7a2qBES1kRX46mTDEGYEUsFV8uL4PDkd",
    "tz1isXamBXpTUgbByQ6gXgZQg4GWNW7r6rKE",
    626160,
    152
  ],[
    "BLhhgCSR8Avhbc7hrqQ9uSsB9Adfts2NwqZbzrGS5VCjxQdLX5N",
    "tz1coHzgoQYRu1Ezn5QChfFEjwTrBzGNQT6U",
    626159,
    152
  ],[
    "BLPUNqkikFAbNDekUhiqJrCaao86o6sPNq5YrcGobHMzSPi4XWr",
    "tz1XfAjZyaLdceHnZxbMYop7g7kWKPut4PR7",
    626158,
    152
  ]
]
```

Results are returned as `Content-Type` JSON ([RFC 7159](https://tools.ietf.org/html/rfc7159)) or CSV ([RFC 4180](https://tools.ietf.org/html/rfc4180)). Select either format by appending `.json` or `.csv` to the query path.

CSV files always include a header containing the requested column names in the requested order. Columns are separated by comma (ASCII 44, UTF-8 0x2C).

When downloading a CSV file you may add an optional `filename` query argument (ASCII only, 128 characters max, no path separators) which will be used in the Content-Disposition header. Suffix `.csv` isautomatically appended if missing.

### JSON Bulk Arrays

Large JSON results such as lists and time-series use a more optimized (less verbose) formatting. Instead of regular JSON objects with named key/value pairs we use **bulk arrays**, i.e. two levels of nested JSON arrays without keys. An outer array contains result rows or datapoints. The inner arrays contain lists of columns. To control which columns are returned and their order use the `columns` query parameter.

Note: As we keep adding new fields to tables and time-series the default order of JSON bulk arrays may change over time. To ensure that our API always returns the field order you expect, use the `columns` query argument. The order of columns you specify is exactly the order that's returned.

### JSON Data Types

We use the following data types and encoding conventions throughout the API:

| | |
|----|----|
| **string** | unstructured ASCII/UTF-8 text |
| **bytes** | binary data encoded  |
| **datetime** | UTC timestamps as UNIX milliseconds, e.g. `1536246000000` or ISO 8601/RFC3339 strings `2018-09-06T15:00:00Z` |
| **duration**  | signed 64bit integers with second precision |
| **boolean** | a binary value, either as string or number `true` (1) or `false` (0) |
| **float64** | an IEEE-754 64-bit floating-point number |
| **int64** | a signed 64-bit integer (Range: -9,223,372,036,854,775,807 through 9,223,372,036,854,775,807) |
| **uint64** | an unsigned 64-bit integer (Range: 0 through 18,446,744,073,709,551,615) |
| **enum** | enumerable values expressed as strings, usually used for types |
| **hash** | on-chain hashes encoded as base58-check strings |
| **money** | monetary quantities are expressed as `float64` with 6 decimal points (the Tezos coin unit precision); market endpoints use 5 or more decimal points depending on the fiat or crypto pairs |

For efficiency reasons, timestamps in JSON bulk arrays are encoded as UNIX time at millisecond resolution. That is, value `0` represents `Jan 1, 1970 00:00:00 UTC`. Timestamps in explorer responses and CSV output are encoded according to [RFC 3339](https://tools.ietf.org/html/rfc3339) (`2018-09-06T08:07:38Z`) for convenience and human readability.

Timestamps in queries can be expressed in multiple ways:

- as RFC3339 string with any timezone
- as UNIX timestamp in seconds or milliseconds, so `1536246000` and `1536246000000` are equal
- as date without time, i.e. `2018`, `2018-09`, `2018-09-06` represents midnight at the first day of month and/or month of year
- as static string such as `now`, `today`, or `yesterday` to reference a relative point in time
- as static string expression with truncation and offset arguments against `now`, eg. `now/d` for start of today or `now/d-30d` for start of day 30 days ago (expressions support `s`, `m`, `h`, `d`)


## Status Codes

The TzStats Data API responds with regular HTTP status codes in the `2xx` range to indicate success, in the `4xx` range to indicate client-side errors and in the `5xx` range to indicate backend errors. The response body contains additional information encoded as JSON object.

- `200 OK` Success
- `400 Bad Request` Missing required fields of malformed request data, your fault
- `404 Not Found` No such object
- `405 Method Not Allowed` Unsupported request method
- `409 Conflict` Resource state conflict
- `429 Too Many Requests` Request limit exceeded
- `500 Internal Server` Something went wrong, not your fault
- `502 Bad Gateway` Your request has reached a timeout and was cancelled, try to reduce the range of data in your request
- `504 Gateway Timeout` Our backend is overloaded or down for maintenance, wait a while before retry

### Error Responses

> **API Error Response**

```json
{
  "errors": [
    {
      "code": 1007,
      "status": 400,
      "message": "incorrect request syntax",
      "scope": "StreamTable",
      "detail": "unknown column 'cycles'",
      "request_id": "BW-a935b7fedf6beefcedc94e539cfe320cc551c5b3",
    }
  ]
}
```

All error messages are JSON encoded. They contain fields numeric and human readable fields to help developers easily debug and map errors.

Fields       | Description
-------------|--------------------------------------------------
`status` *int*    | The HTTP status code, duplicated for convenience.
`message` *string*   | A textual representation of the error status.
`scope` *string*     | The name of the API call that has failed.
`detail` *string*    | A detailed text description of the error.
`code` *int*      | An internal error code.
`request_id` *string* | Unique call id that helps us trace failed requests.
