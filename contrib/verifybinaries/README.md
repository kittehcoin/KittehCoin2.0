### Verify Binaries

KittehCoin2.0 Core releases are signed by **Ryan M** (`contact@kittehcoin.ca`).
Import the key from [`contrib/gitian-keys/ryan-m.asc`](../gitian-keys/ryan-m.asc)
and check the fingerprint against a few independent copies:

```
E1E044BE7AC175AA6E935AF8A2770580E4E08451
```

```sh
gpg --import ../gitian-keys/ryan-m.asc
gpg --fingerprint E1E044BE7AC175AA6E935AF8A2770580E4E08451
```

#### Usage

The helper script was written for Bitcoin Core’s old download layout
(`bitcoincore.org` / `bitcoin.org`). Prefer verifying GitHub Release
`SHA256SUMS` (or the hashes posted on [kittehcoin.ca](https://www.kittehcoin.ca))
with that key until the script is pointed at KittehCoin hosts.

```sh
gpg --verify SHA256SUMS.asc SHA256SUMS
sha256sum -c SHA256SUMS
```
