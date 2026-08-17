Dependencies
============

These are the dependencies currently used by KittehCoin2.0 Core. You can find instructions for installing them in the `build-*.md` file for your platform.

| Dependency | Version used | Minimum required | CVEs | Shared | Bundled with Qt |
| --- | --- | --- | --- | --- | --- |
| Berkeley DB | 4.8.30 | 4.8.x | No |  |  |
| Boost | 1.70.0 | 1.58.0 | No |  |  |
| Clang |  | 3.3+ (C++11 support) |  |  |  |
| Expat | 2.2.7 |  | No | Yes |  |
| fontconfig | 2.12.1 |  | No | Yes |  |
| FreeType | 2.7.1 |  | No |  | Yes (Android only) |
| GCC |  | 4.8+ (C++11 support) |  |  |  |
| HarfBuzz-NG |  |  |  |  | Yes |
| libevent | 2.1.11-stable | 2.0.21 | No |  |  |
| libpng |  |  |  |  | Yes |
| librsvg | |  |  |  |  |
| MiniUPnPc | 2.2.2 |  | No |  |  |
| PCRE |  |  |  |  | Yes |
| Python (tests) |  | 3.5 |  |  |  |
| qrencode | 3.4.4 |  | No |  |  |
| Qt | 5.9.8 | 5.5.1 | No |  |  |
| SQLite | 3.32.1 | 3.7.17 |  |  |  |
| XCB |  |  |  |  | Yes (Linux only) |
| xkbcommon |  |  |  |  | Yes (Linux only) |
| ZeroMQ | 4.3.1 | 4.0.0 | No |  |  |
| zlib | 1.2.11 |  |  |  | No |

Controlling dependencies
------------------------
Some dependencies are not needed in all configurations. The following are some factors that affect the dependency list.

#### Options passed to `./configure`
* MiniUPnPc is not needed with  `--with-miniupnpc=no`.
* Berkeley DB is not needed with `--disable-wallet`.
* SQLite is not needed with `--disable-wallet` or `--without-sqlite`.
* Qt is not needed with `--without-gui`.
* If the qrencode dependency is absent, QR support won't be added. To force an error when that happens, pass `--with-qrencode`.
* ZeroMQ is needed only with the `--with-zmq` option.

#### Other
* librsvg is only needed if you need to run `make deploy` on (cross-compilation to) macOS.
