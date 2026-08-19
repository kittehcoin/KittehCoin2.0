Contributing to KittehCoin2.0 Core
=================================

Anyone is welcome to help — review, testing, and patches all count. This tree is
the official **KittehCoin 2.0 (MEOWS)** node and wallet, rebuilt from Litecoin
Core. Hang out on [Discord](https://discord.gg/UxEcfrz6) if you want a human
before you open a PR.

There is no inner circle of “Core developers.” Maintainers merge pull requests
and cut releases. Trust is earned by showing up and doing careful work.

Getting started
---------------

New people are needed. The most useful first contribution is **review and
testing**, not a giant refactor.

Build the tree and run the tests before you start changing things:

- [Unix](doc/build-unix.md) · [Windows](doc/build-windows.md) · [macOS](doc/build-osx.md)
- Tests: [test/README.md](test/README.md) and [test/functional/README.md](test/functional/README.md)

Looking for a place to start? Check
[open issues](https://github.com/kittehcoin/KittehCoin2.0/issues)
and anything labeled `good first issue`. Leave a comment if you pick one up so
we do not duplicate work.

GUI, wallet, and node all live in **this** repository
([kittehcoin/KittehCoin2.0](https://github.com/kittehcoin/KittehCoin2.0)).
Do not open KittehCoin bugs against bitcoin/bitcoin or bitcoin-core/gui.

Communication
-------------

- **Discord:** [discord.gg/UxEcfrz6](https://discord.gg/UxEcfrz6)
- **GitHub:** issues and pull requests
- **Mailing list:** [kittehcoin-dev](https://groups.google.com/forum/#!forum/kittehcoin-dev)
  for messy consensus / P2P protocol ideas *before* a big patch set

Please do not file public issues for undisclosed security bugs. See [SECURITY.md](SECURITY.md).

Contributor workflow
--------------------

Everyone, including maintainers, sends patches as pull requests.

1. [Fork](https://docs.github.com/en/get-started/quickstart/fork-a-repo) (first time)
2. Create a topic branch
3. Commit patches
4. Push to your fork and open a PR against `main`

Commits should be atomic and easy to read. Do not mix formatting nits with real
changes. Each commit should build and pass tests on its own.

Commit messages: short subject (about 50 chars), blank line, then *why* if it is
not obvious. Never put `@mentions` in commit messages. Use `fixes #1234` when a
commit actually closes an issue.

### Pull request titles

Prefix with the area:

- `consensus` · `doc` · `qt` / `gui` · `log` · `mining` · `net` / `p2p`
- `refactor` · `rpc` / `rest` / `zmq` · `script` · `test` / `ci`
- `util` / `lib` · `wallet` · `build`

Examples:

    consensus: Clamp subsidy at the 25B mint cap
    net: Add seed3 and seed4 DNS seeds
    qt: Show MEOWS instead of a leftover BTC label
    doc: Point CONTRIBUTING at this repo, not Bitcoin Core

The PR body should explain **what** and **why**. No `@mentions` in the opening
description (they get replayed every time someone cherry-picks the merge).
Mention people in a later comment.

### Translations

Do not open PRs that only touch generated locale files. If you want to help
translate the GUI, say so on Discord first.

### WIP and review

Prefix unfinished work with `[WIP]` or use a task list. Squash fixup commits
when asked. Rebase onto current `main` rather than merging it in — we want a
history of signed, non-merge commits that [contrib/verify-commits](contrib/verify-commits)
can check.

Please keep working in the existing PR instead of opening a second one for the
same change.

Pull request philosophy
-----------------------

Keep patchsets focused. A feature, a bug fix, *or* a refactor — not all three.

New features need a maintainer. If nobody will own it later, it may get dropped.

Refactoring PRs should not change behavior (including bugs). New contributors
should not lead with “cleanup the whole tree” PRs; those are hard to review and
easy to get wrong.

Decision making
---------------

Merging into KittehCoin2.0 Core is up to the maintainers. Consensus-rule changes
are a much higher bar than a wallet nits PR: talk on Discord / the mailing list
first, and be ready for more review than usual.

PRs should:

- Do something real (fix a bug, add a needed feature, or a justified refactor)
- Be peer-reviewed
- Include tests where they make sense
- Not break the existing suite
- Update comments and docs when behavior changes

### Peer review

Anyone can review. Typical language:

- `Concept ACK` / `Concept NACK` — I (do not) agree with the goal
- `Approach ACK` / `Approach NACK` — goal is fine, this design is (not)
- `ACK <commit>` — I reviewed this exact tip
- A NACK needs a reason or it can be ignored
- A “nit” is small and usually non-blocking

Please say whether you actually ran the tests / tried the change.

Finding reviewers
-----------------

If a PR sits: it may be a feature freeze, the change may be too big, or the
right people have not seen it. Git blame on the files you touched is a polite
way to find who last cared. Ask on Discord. While you wait, review someone
else’s PR.

Backporting
-----------

Security and bug fixes can move from `main` onto release branches after the
original PR is merged. Non-trivial backports get their own PR.

Commit body metadata:

```
Github-Pull: #<PR number>
Rebased-From: <commit hash of the original commit>
```

Release policy
--------------

The project lead is the release manager for each KittehCoin2.0 Core release.
Signed binaries: [GitHub Releases](https://github.com/kittehcoin/KittehCoin2.0/releases)
and [kittehcoin.ca](https://www.kittehcoin.ca).

Copyright
---------

By contributing, you license your work under the MIT license unless a file
says otherwise. If you are not the original author, keep the original license
header and attribution.
