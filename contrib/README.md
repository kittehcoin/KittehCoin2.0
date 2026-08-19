Repository Tools
---------------------

### [Developer tools](/contrib/devtools) ###
Tools for people working in this tree. Bitcoin Core still publishes extra
maintainer scripts at [bitcoin-core/bitcoin-maintainer-tools](https://github.com/bitcoin-core/bitcoin-maintainer-tools)
if you need `github-merge.py` and friends.

### [Verify-Commits](/contrib/verify-commits) ###
Tool to verify that every merge commit was signed by a developer using the `github-merge.py` script.

### [Linearize](/contrib/linearize) ###
Construct a linear, no-fork, best version of the blockchain.

### [Qos](/contrib/qos) ###

A Linux bash script that will set up traffic control (tc) to limit the outgoing bandwidth for connections to the KittehCoin network. This means one can have an always-on kittehcoind instance running, and another local kittehcoind/kittehcoin-qt instance which connects to this node and receives blocks from it.

### [Seeds](/contrib/seeds) ###
Utility to generate the pnSeed[] array that is compiled into the client.

Build Tools and Keys
---------------------

### Packaging ###
The [Debian](/contrib/debian) subfolder contains the copyright file.

### [Gitian-descriptors](/contrib/gitian-descriptors) ###
Files used during the gitian build process.

### [Gitian-keys](/contrib/gitian-keys)
PGP keys used for signing KittehCoin2.0 Core [Gitian release](/doc/release-process.md) results.

### [MacDeploy](/contrib/macdeploy) ###
Scripts and notes for Mac builds.

### [Gitian-build](/contrib/gitian-build.py) ###
Script for running full Gitian builds.

Test and Verify Tools
---------------------

### [TestGen](/contrib/testgen) ###
Utilities to generate test vectors for the data-driven KittehCoin tests.

### [Verify Binaries](/contrib/verifybinaries) ###
This script attempts to download and verify the signature file SHA256SUMS.asc from kittehcoin.ca.
