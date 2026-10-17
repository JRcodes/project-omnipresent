# Changelog

All notable changes to this project are documented here. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and versions follow [Semantic Versioning](https://semver.org/).

## [2.0.0] - Unreleased

Improvements to the original architecture. The host-node, push-based design is unchanged. Full details are in [PR #1](https://github.com/JRcodes/project-omnipresent/pull/1).

### Breaking
- Nodes are reached with key-based SSH as a non-root, sudo-capable user (`deploy` by default). Password login through `sshpass`, `root` login and the `.credfile` are removed. To upgrade, add the host's public key to the deploy user's `~/.ssh/authorized_keys` on each node.

### Added
- `make demo`, which starts a control host and two Ubuntu nodes in Docker and runs `init`, `set` and `push` against them.
- `OMNI_USER`, `OMNI_SSH_KEY` and `OMNI_NODELIST` environment variables to override the node user, SSH key and node list.
- A usage message when `almighty.sh` is run with no or unknown arguments.

### Fixed
- `remote-install`, `remote-remove` and `remote-upgrade` reached only the first node, because `ssh` consumed the rest of `nodelist`.
- `push` didn't update web documents already on a node; `jobdef.sh` now syncs all of `web_docs` every time.
- Arguments sent to remote shells weren't quoted or escaped, which allowed command injection.
- Scripts depended on the current directory and the home folder; paths now resolve from the repo.
- Package installs could stop for confirmation or configuration prompts.
- Error paths exited with a success status, `remote-view` didn't show the node name, and several messages were wrong or misspelled.

## [1.0.0] - 2022-07-22

The original release: a push-based configuration management tool in Bash, built as a take-home project.

### Added
- `almighty.sh` entry point with `init`, `set`, `push`, `update`, `apply-update`, `install`, `remove`, `upgrade` and `view`, plus `remote-*` versions that also run on the nodes.
- `control.sh` for all calls to the node servers listed in `nodelist`.
- `jobdef.sh`, `updates.sh` and `dependencies.sh` configuration scripts, set up to provision a PHP site on Apache.

[2.0.0]: https://github.com/JRcodes/project-omnipresent/compare/v1.0.0...portfolio-cleanup
[1.0.0]: https://github.com/JRcodes/project-omnipresent/tree/v1.0.0
