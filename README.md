# andyl-github-action

Reusable GitHub Actions for ANDYL's projects.

## Example

A minimal Rust library with tests is in the [example/](./example/) directory,
along with an Actions [workflow](.github/workflows/test.yml) that runs coverage
testing.

## Available Actions

### `setup-devenv`

Installs [Nix](https://nixos.org), [Cachix](https://cachix.org), and
[`devenv`](https://devenv.sh).

Example usage:

```yaml
- name: Setup devenv
  uses: andyl-technologies/andyl-github-action/setup-devenv@master
```

No parameters are required.

### `check-skip`

Uses Graphite to detect if CI can be skipped for a pull request or commit.

This action sets an output named `skip` to `true` or `false`, and should usually
be ran as a separate job.

Example usage:

```yaml
jobs:
  check-skip:
    runs-on: ubuntu-latest
    outputs:
      skip: ${{ steps.check-skip.outputs.skip }}
    steps:
      - name: Check if CI can be skipped
        id: check-skip
        uses: andyl-technologies/andyl-github-action/check-skip@master
```

GitHub does not have a way to arbitrarily exit a workflow without marking it as
"skipped" or "failed", both of which send out notifications which may not be
desirable.

As such, taking advantage of this action without such notifications requires
using the `skip` output as a conditional on all subsequent actions using `needs`
and `if`, like so:

```yaml
- uses: andyl-technologies/andyl-github-action/check-skip@master
  needs: check-skip
  if: ${{ needs.check-skip.outputs.skip }} == 'false'
```

### `rust-cache`

Sets up Rust caching mechanisms and dependencies using the following actions:

- [`Swatinem/rust-cache`](https://github.com/Swatinem/rust-cache)
- [`Mozilla-Actions/sccache-action`](https://github.com/Mozilla-Actions/sccache-action)
- [`cargo-llvm-cov`](https://github.com/taiki-e/cargo-llvm-cov)
- [`cargo-binstall`](https://github.com/cargo-bins/cargo-binstall)

Example usage:

```yaml
- name: Setup Rust cache/dependencies
  uses: andyl-technologies/andyl-github-action/setup-rust@master
  with:
    # Condition in which the cache is saved
    save-condition: ${{ github.ref == 'refs/heads/main' }}
    # Whether to cache all crates or only the current workspace
    cache-all-crates: 'false'
    # List of workspaces to cache, separated by commas
    workspaces: .
    # Whether to use sccache for caching build artifacts
    use-sccache: 'false'
```

If `use-sccache` is set, then two additional variables will need to be set for
any consuming action, since GitHub Actions does not allow setting environment
variables for consuming actions from a composite action like this one.

```yaml
jobs:
  env:
    SCCACHE_GHA_ENABLED: 'true'
    RUSTC_WRAPPER: 'sccache'
```
