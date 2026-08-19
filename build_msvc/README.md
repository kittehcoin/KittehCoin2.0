Building KittehCoin2.0 Core with Visual Studio
==============================================

Introduction
---------------------
Solution and project files to build KittehCoin2.0 Core with `msbuild` or Visual Studio live in `build_msvc`. The build has been tested with Visual Studio 2017 and 2019.

This is an alternative to the Linux [Mingw cross-compile](../doc/build-windows.md). The `.sln` filename is still `bitcoin.sln` from upstream.

Quick Start
---------------------

```
cd build_msvc
py -3 msvc-autogen.py
msbuild /m bitcoin.sln /p:Platform=x64 /p:Configuration=Release /t:build
```

Dependencies
---------------------
Libraries needed to build are listed in [doc/dependencies.md](/doc/dependencies.md) and `build_msvc/vcpkg.json`.

Options for installing them in a Visual Studio compatible manner:

- Use Microsoft's [vcpkg](https://docs.microsoft.com/en-us/cpp/vcpkg) to download the source packages and build locally. This is the recommended approach.
- Download the source code, build each dependency, add the required include paths, link libraries and binary tools to the Visual Studio project files.
- Use [nuget](https://www.nuget.org/) packages with the understanding that any binary files have been compiled by an untrusted third party.

The `msbuild` project files are configured to automatically install the `vcpkg` dependencies.

Qt
---------------------
A static Qt build is required for `kittehcoin-qt`. Runtime library version (e.g. v141, v142) and platform type (x86 or x64) must match.

Some prebuilt x64 Qt zips exist [here](https://github.com/sipsorcery/qt_win_binary/releases). Those are **not** KittehCoin releases. Do not use them for wallets that will hold real MEOWS.

To determine which Qt prebuilt version to download open the `.appveyor.yml` file and note the `QT_DOWNLOAD_URL`. When extracting the zip file the destination path must be set to `C:\`. This is due to the way that Qt includes, libraries and tools use internal paths.

To build without Qt, unload or disable the `bitcoin-qt`, `libbitcoin_qt` and `test_bitcoin-qt` projects (upstream project names).

Building
---------------------
The instructions below use `vcpkg` to install the dependencies.

- Install [`vcpkg`](https://github.com/Microsoft/vcpkg).

- Use Python to generate `*.vcxproj` from Makefile

```
PS >py -3 msvc-autogen.py
```

- An optional step is to adjust the settings in the `build_msvc` directory and the `common.init.vcxproj` file. This project file contains settings that are common to all projects such as the runtime library version and target Windows SDK version. The Qt directories can also be set.

- To build from the command line with the Visual Studio 2017 toolchain use:

```
msbuild /m bitcoin.sln /p:Platform=x64 /p:Configuration=Release /p:PlatformToolset=v141 /t:build
```

- To build from the command line with the Visual Studio 2019 toolchain use:

```
msbuild /m bitcoin.sln /p:Platform=x64 /p:Configuration=Release /t:build
```

- Alternatively open the `build_msvc/bitcoin.sln` file in Visual Studio.

AppVeyor
---------------------
The `.appveyor.yml` in the repo root can drive AppVeyor builds. Point AppVeyor at your fork of [kittehcoin/KittehCoin2.0](https://github.com/kittehcoin/KittehCoin2.0).

Artifact upload is disabled by default. To enable it on a fork, uncomment:

```
    #- 7z a bitcoin-%APPVEYOR_BUILD_VERSION%.zip %APPVEYOR_BUILD_FOLDER%\build_msvc\%platform%\%configuration%\*.exe
    #- path: bitcoin-%APPVEYOR_BUILD_VERSION%.zip
```
