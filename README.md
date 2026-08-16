# KittehCoin 2.0 [MEOWS]

Official reboot of **KittehCoin**, originally launched December 2013.

This tree is a fresh relaunch — not a continuation of the legacy chain — built on
[Litecoin Core v0.21.5.6](https://github.com/litecoin-project/litecoin/releases/tag/v0.21.5.6)
with KittehCoin branding, economics, and consensus identity restored.

Legacy reference: [kittehcoin/kittehcoin](https://github.com/kittehcoin/kittehcoin)

## Highlights

| Parameter | Value |
|-----------|-------|
| Ticker | **MEOWS** |
| Proof of Work | Scrypt |
| Difficulty | Kimoto Gravity Well (min 36 / max 1008 blocks) |
| Block time | 60 seconds |
| Address prefix | **K** (version byte `45`) |
| Bech32 HRP | `meows` |
| P2P port | `22566` |
| RPC port | `22565` |
| Max money | 25,000,000,000 MEOWS |
| Network magic | `4D 45 4F 57` (`MEOW`) — distinct from legacy `c0c0c0c0` |

## Mining rewards (from original KittehCoin post-hardfork schedule)

Guaranteed minimum **1,000 MEOWS** per block. Reward is deterministic from the previous block hash.

| Blocks | Reward range |
|--------|----------------|
| 1 – 200,000 | 1,000 – 50,000 MEOWS |
| 200,001 – 400,000 | 1,000 – 25,000 MEOWS |
| 400,001 – 500,000 | 1,000 – 12,500 MEOWS |
| 500,001 – 600,000 | 1,000 – 6,250 MEOWS |
| 600,001 – 700,000 | 1,000 – 3,125 MEOWS |
| 700,001+ | 2,000 MEOWS (flat) |

## Binaries

After building you get:

- `kittehcoind` — full node daemon  
- `kittehcoin-qt` — wallet GUI (uses the KittehCoin 2.0 logo)  
- `kittehcoin-cli` / `kittehcoin-tx` / `kittehcoin-wallet`

Data directory: `~/.kittehcoin` (Linux) / `%APPDATA%\KittehCoin` (Windows)

Config file: `kittehcoin.conf`

## Build

Follow Litecoin/Bitcoin Core docs for your platform:

- [doc/build-unix.md](doc/build-unix.md)
- [doc/build-windows.md](doc/build-windows.md)
- [doc/build-osx.md](doc/build-osx.md)

Typical Unix flow:

```sh
./autogen.sh
./configure
make
make install   # optional
```

## Branding note

This is the **official KittehCoin 2.0** relaunch by the original project lineage.
Impostor forks claiming the KittehCoin name are unrelated to this codebase.

