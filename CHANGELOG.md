# Changelog
All notable changes to this project will be documented in this file. See [conventional commits](https://www.conventionalcommits.org/) for commit guidelines.

- - -
## [1.1.2](https://github.com/kleinweb/beams/compare/672828673b5bfa710f45eae3c06061415a39a456..1.1.2) - 2025-08-04
#### Bug Fixes
- **(release)** specify git remote and branch in post-bump hook - ([6728286](https://github.com/kleinweb/beams/commit/672828673b5bfa710f45eae3c06061415a39a456)) - [@montchr](https://github.com/montchr)

- - -

## [1.1.1](https://github.com/kleinweb/beams/compare/eca66ae5b498dae3d2682802dcfad7dd660654b7..1.1.1) - 2025-08-04
#### Bug Fixes
- **(release)** recipes must not cd - ([eca66ae](https://github.com/kleinweb/beams/commit/eca66ae5b498dae3d2682802dcfad7dd660654b7)) - [@montchr](https://github.com/montchr)

- - -

## [1.0.0](https://github.com/kleinweb/beams/compare/1.0.0-rc.1..1.0.0) - 2025-08-04
#### Bug Fixes
- **(meta)** remove non-compliant `just` formatter - ([30c83bf](https://github.com/kleinweb/beams/commit/30c83bf6edd5d4604cfc8ee2d6a50133bfee6b08)) - [@montchr](https://github.com/montchr)
- **(meta:recipes)** remove php checks - ([71504b3](https://github.com/kleinweb/beams/commit/71504b350d758ba5a584ed8f67bb86a6a90feb30)) - [@montchr](https://github.com/montchr)
#### Refactoring
- **(release|recipes)** clean up `bump` recipe - ([692c556](https://github.com/kleinweb/beams/commit/692c55666de26e9354b59f8b1973c14d40d92a5b)) - [@montchr](https://github.com/montchr)

- - -

## [1.0.0-rc.1](https://github.com/kleinweb/beams/compare/65e49d7cbfbf56a941f173b4d7699d43f5e1922d..1.0.0-rc.1) - 2025-08-04
#### Bug Fixes
- **(ddev)** use stable version in `ldflags` - ([323dc80](https://github.com/kleinweb/beams/commit/323dc8056a2e479d4972e44ea983447d9c3d6dad)) - [@montchr](https://github.com/montchr)
- **(meta)** update biome.json for v2 compat - ([f20bea5](https://github.com/kleinweb/beams/commit/f20bea5bd03b34a770c59b05857a98f43b4ac618)) - [@montchr](https://github.com/montchr)
- prevent downstream infinite recursions due to overlay - ([26df801](https://github.com/kleinweb/beams/commit/26df801863f688bf5a47343baa7640efe75cf4d8)) - [@montchr](https://github.com/montchr)
- remove obsolete `treefmt` package override - ([97739ef](https://github.com/kleinweb/beams/commit/97739ef099a32c837fca1c3fd5eee4e2488c8116)) - [@montchr](https://github.com/montchr)
#### Features
- **(shib)** add metadata generator script - ([60741d3](https://github.com/kleinweb/beams/commit/60741d3e579692d3bc119aa4dabbb66b12834134)) - [@montchr](https://github.com/montchr)
- npm monorepo - ([3dce692](https://github.com/kleinweb/beams/commit/3dce6922dca2c731176e9edac69e81ade969e3c4)) - [@montchr](https://github.com/montchr)
- add `shib-keygen` script package - ([5675603](https://github.com/kleinweb/beams/commit/5675603ab8252c6d0c63b595daf1073cc0448bd4)) - [@montchr](https://github.com/montchr)
- provide patched ddev package expression for intellij plugin compat - ([6cf93fc](https://github.com/kleinweb/beams/commit/6cf93fc8d839cd94ae936710701f5b50b6e2c59e)) - [@montchr](https://github.com/montchr)
- add common nix package expressions - ([f627981](https://github.com/kleinweb/beams/commit/f627981e31d547485e05aa918837f2cedb29b6b5)) - [@montchr](https://github.com/montchr)
#### Miscellaneous Chores
- **(meta:reuse)** remove LICENSE file - ([1bc1e07](https://github.com/kleinweb/beams/commit/1bc1e07e1f96096852e06d3948db8167d7101184)) - [@montchr](https://github.com/montchr)
- **(meta:reuse)** update copyright years - ([a7c84d9](https://github.com/kleinweb/beams/commit/a7c84d9be115817049799aa8817b974c24baad1d)) - [@montchr](https://github.com/montchr)
- **(meta:reuse)** compliance - ([56916fd](https://github.com/kleinweb/beams/commit/56916fddc137d5b2f34211ff41e91dee74594ade)) - [@montchr](https://github.com/montchr)
- **(php-stubs-generator)** 0.8.4 -> 0.8.5 - ([53a7e39](https://github.com/kleinweb/beams/commit/53a7e3954de47fa19a1773b6e14b12c1067ea200)) - [@montchr](https://github.com/montchr)
- fmt - ([3d0172f](https://github.com/kleinweb/beams/commit/3d0172f9956db7dc80caf006d4fca74f145cdfa8)) - [@montchr](https://github.com/montchr)
- update flake - ([a8b8d39](https://github.com/kleinweb/beams/commit/a8b8d39c125173f492d8546d5d6608d2cc2129e7)) - [@montchr](https://github.com/montchr)
- remove obsolete shibboleth script - ([b99fb31](https://github.com/kleinweb/beams/commit/b99fb31171336b75d0c6701d0b426fbb5a44f1ba)) - [@montchr](https://github.com/montchr)
- add config files - ([2b8f9a0](https://github.com/kleinweb/beams/commit/2b8f9a03205b9b222f8cec0c43e0813ac4b69fb3)) - [@montchr](https://github.com/montchr)
- initial commit - ([65e49d7](https://github.com/kleinweb/beams/commit/65e49d7cbfbf56a941f173b4d7699d43f5e1922d)) - chris montgomery
#### Refactoring
- **(ddev)** move package to standard location - ([6e4a820](https://github.com/kleinweb/beams/commit/6e4a820503cdfb5c1c9a35e10387db84deb5d64e)) - [@montchr](https://github.com/montchr)
- **(php-lint)** provide real package expressions - ([de7a580](https://github.com/kleinweb/beams/commit/de7a580480ed3a0f6a420708587e0f10ecb9d5bd)) - [@montchr](https://github.com/montchr)
- updates from configs template - ([2944863](https://github.com/kleinweb/beams/commit/29448632e15ff16871b207255a8989f9274beb15)) - [@montchr](https://github.com/montchr)

- - -

Changelog generated by [cocogitto](https://github.com/cocogitto/cocogitto).