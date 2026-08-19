Sample configuration files for:
```
SystemD: bitcoind.service
Upstart: bitcoind.conf
OpenRC:  bitcoind.openrc
         bitcoind.openrcconf
CentOS:  bitcoind.init
macOS:   org.bitcoin.bitcoind.plist
```

Those filenames are leftover from upstream. Copy and rename them to
`kittehcoind.*` / `org.kittehcoin.kittehcoind.plist` when you package a node.
The units themselves should run `kittehcoind`, not `bitcoind`.

See [doc/init.md](/doc/init.md) for paths, the `kittehcoin` service user, and
install steps.
