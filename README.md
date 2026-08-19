<p align="center">
  <img src="https://pool.kittehcoin.ca/static/logo.png" alt="KittehCoin 2.0" width="160">
</p>

<h1 align="center">KittehCoin 2.0</h1>
<p align="center"><b>Kitteh sez MEOW.</b> Ticker <code>MEOWS</code>. Own chain. No premine. Not a token.</p>

<p align="center">
  <a href="https://www.kittehcoin.ca">Website</a> ·
  <a href="https://www.kittehcoin.ca/start">Get started</a> ·
  <a href="https://explorer.kittehcoin.ca">Explorer</a> ·
  <a href="https://pool.kittehcoin.ca">Pool</a> ·
  <a href="https://faucet.kittehcoin.ca">Faucet</a> ·
  <a href="https://wallet.kittehcoin.ca">Browser wallet</a> ·
  <a href="https://github.com/kittehcoin/KittehCoin2.0/releases">Releases</a> ·
  <a href="https://discord.gg/UxEcfrz6">Discord</a>
</p>

---

The original [KittehCoin](https://github.com/kittehcoin/kittehcoin) showed up in December 2013. This is the reboot — a **fresh genesis**, not a continuation of the old ledger. Same spirit (Scrypt, K-addresses, lottery-style rewards), modern code from [Litecoin Core v0.21.5.6](https://github.com/litecoin-project/litecoin/releases/tag/v0.21.5.6).

If it is not linked from [kittehcoin.ca](https://www.kittehcoin.ca), it is not this coin. Ticker is **MEOWS**, not MEOW, not MEWC, and not a Base / ETH / BSC token.

## Come on in

| | |
|---|---|
| Grab a wallet | [kittehcoin.ca](https://www.kittehcoin.ca) — Core is the real thing. [Browser wallet](https://wallet.kittehcoin.ca) if you just need a K-address. |
| First hour | [Start here](https://www.kittehcoin.ca/start) |
| Watch the chain | [explorer.kittehcoin.ca](https://explorer.kittehcoin.ca) |
| Mine | [pool.kittehcoin.ca](https://pool.kittehcoin.ca) · [how to point a miner](https://www.kittehcoin.ca/mine) |
| A sip of coins | [faucet.kittehcoin.ca](https://faucet.kittehcoin.ca) |
| Hang out | [discord.gg/UxEcfrz6](https://discord.gg/UxEcfrz6) |

Receive and mine to a **K…** address. That is the one official services pay.

GPU / CPU pool: `stratum+tcp://stratum.kittehcoin.ca:3333`  
ASIC: `stratum+tcp://stratum.kittehcoin.ca:3433`  
Username = your K-address. Password = `x`.

## The useful bits

| | |
|---|---|
| Ticker | **MEOWS** |
| Algo | Scrypt |
| Block time | 60 seconds |
| Difficulty | Kimoto Gravity Well (min 4 / max 1008) |
| Addresses | **K** (version byte `45`) · bech32 `meows1…` |
| Max money | 25,000,000,000 MEOWS |
| P2P / RPC | `22566` / `22565` |
| Magic | `4D 45 4F 57` (`MEOW`) — not the old `c0c0c0c0` |
| Seeds | `seed1.kittehcoin.ca`, `seed2.kittehcoin.ca`, `seed3.kittehcoin.ca`, `seed4.kittehcoin.ca` |

Rewards are the original post-hardfork lottery: at least **1,000 MEOWS** a block, rolled from the previous block hash.

| Blocks | Reward |
|--------|--------|
| 1 – 200,000 | 1,000 – 50,000 |
| 200,001 – 400,000 | 1,000 – 25,000 |
| 400,001 – 500,000 | 1,000 – 12,500 |
| 500,001 – 600,000 | 1,000 – 6,250 |
| 600,001 – 700,000 | 1,000 – 3,125 |
| 700,001+ | 2,000 flat |

## Building from this tree

You get `kittehcoind`, `kittehcoin-qt`, `kittehcoin-cli`, `kittehcoin-tx`, and `kittehcoin-wallet`.

Data dir: `~/.kittehcoin` (Linux) · `~/Library/Application Support/KittehCoin` (macOS) · `%APPDATA%\KittehCoin` (Windows)  
Config file: `kittehcoin.conf`

```sh
./autogen.sh
./configure
make
```

Platform notes: [Unix](doc/build-unix.md) · [Windows](doc/build-windows.md) · [macOS](doc/build-osx.md). Prebuilt wallets live on [Releases](https://github.com/kittehcoin/KittehCoin2.0/releases).

## Right chain?

Genesis hash should be:

`4f2f309ba49ca94f1a0ad98186845fe85a0b3de2ce5cc5b541057348cc6ea72a`

If it is not, stop. You are somewhere else. Compare the tip with [the explorer](https://explorer.kittehcoin.ca). Do not import an old 2013 `wallet.dat`.

## License

MIT — see [COPYING](COPYING). Bitcoin Core, Litecoin Core, and KittehCoin folks (2013–2026).

This is the official KittehCoin 2.0 relaunch. Impostor forks using the name are unrelated to this tree.

In Kitteh We Trust.
