# Change Log

## Unreleased

* Docs: rewrite README for new users and split contributor docs ([#533](https://github.com/test-kitchen/kitchen-vagrant/pull/533)) ([731ee73](https://github.com/test-kitchen/kitchen-vagrant/commit/731ee73))
* Drop CHEF_LICENSE env vars from integration CI; add Cinc gem canary ([#534](https://github.com/test-kitchen/kitchen-vagrant/pull/534)) ([3d164d0](https://github.com/test-kitchen/kitchen-vagrant/commit/3d164d0))
* Remove dependabot config in favor of renovate ([#535](https://github.com/test-kitchen/kitchen-vagrant/pull/535)) ([0a402cb](https://github.com/test-kitchen/kitchen-vagrant/commit/0a402cb))

## [2.4.1](https://github.com/test-kitchen/kitchen-vagrant/compare/v2.4.0...v2.4.1) (2026-08-30)


### Bug Fixes

* avoid colliding libvirt domain names across concurrent runs ([#547](https://github.com/test-kitchen/kitchen-vagrant/issues/547)) ([14af4bb](https://github.com/test-kitchen/kitchen-vagrant/commit/14af4bbdab0764e2e30922cf0f81e8317c24154b))
* read the WSL home path when the instance needs it, not at load time ([#544](https://github.com/test-kitchen/kitchen-vagrant/issues/544)) ([9ac3ee9](https://github.com/test-kitchen/kitchen-vagrant/commit/9ac3ee95690e6ab76a483f4cb8f021a2d7c8ba73))

## [2.4.0](https://github.com/test-kitchen/kitchen-vagrant/compare/v2.3.0...v2.4.0) (2026-08-24)


### Features

* implement the driver doctor hook ([#541](https://github.com/test-kitchen/kitchen-vagrant/issues/541)) ([ec8ad65](https://github.com/test-kitchen/kitchen-vagrant/commit/ec8ad65f97c1b0a9892100da67d161c6fbe3d975))
* implement the driver status hook ([#540](https://github.com/test-kitchen/kitchen-vagrant/issues/540)) ([a080cf6](https://github.com/test-kitchen/kitchen-vagrant/commit/a080cf6110cfee900fb947fbdb5c83691f6e0d6d))


### Bug Fixes

* require test-kitchen 3.0 or newer ([#538](https://github.com/test-kitchen/kitchen-vagrant/issues/538)) ([206621b](https://github.com/test-kitchen/kitchen-vagrant/commit/206621bb355ca331d83834dc3d776e5709b09be8))

## [2.3.0](https://github.com/test-kitchen/kitchen-vagrant/compare/v2.2.1...v2.3.0) (2026-08-22)

### Features

* **tart provider:** Consolidate VM name logic and add vendor to .gitignore ([#523](https://github.com/test-kitchen/kitchen-vagrant/issues/523)) ([c1c5ccf](https://github.com/test-kitchen/kitchen-vagrant/commit/c1c5ccf36d468364bee2dfc0ede709f63182a63e))

### Other Changes

* Fix typos ([#528](https://github.com/test-kitchen/kitchen-vagrant/pull/528)) ([b6cc51f](https://github.com/test-kitchen/kitchen-vagrant/commit/b6cc51f))
* chore(deps): update actions/checkout action to v7 ([#527](https://github.com/test-kitchen/kitchen-vagrant/pull/527)) ([4de49c5](https://github.com/test-kitchen/kitchen-vagrant/commit/4de49c5))
* chore(deps): update googleapis/release-please-action action to v5 ([#526](https://github.com/test-kitchen/kitchen-vagrant/pull/526)) ([6f78e21](https://github.com/test-kitchen/kitchen-vagrant/commit/6f78e21))
* Require Ruby 3.1+ and modernize CI ([#529](https://github.com/test-kitchen/kitchen-vagrant/pull/529)) ([7d9b6ef](https://github.com/test-kitchen/kitchen-vagrant/commit/7d9b6ef))
* Modernize the unit test suite, fix 4 bugs it surfaced, and document every method ([#531](https://github.com/test-kitchen/kitchen-vagrant/pull/531)) ([7b17cc3](https://github.com/test-kitchen/kitchen-vagrant/commit/7b17cc3))

## [2.2.1](https://github.com/test-kitchen/kitchen-vagrant/compare/v2.2.0...v2.2.1) (2026-01-22)

### Bug Fixes

* Add Hash-based synced folder options for SMB authentication with Hyper-V ([#520](https://github.com/test-kitchen/kitchen-vagrant/issues/520)) ([bd6b815](https://github.com/test-kitchen/kitchen-vagrant/commit/bd6b8157211ce287323c151bb59be5de0d1d10fc))
* bump tk dep to &lt;5 ([#525](https://github.com/test-kitchen/kitchen-vagrant/issues/525)) ([9753a44](https://github.com/test-kitchen/kitchen-vagrant/commit/9753a445167957839e89bf3b8941a72117727bb3))
* **credentials:** Fix AWS credentials not passing to Vagrant box ([#521](https://github.com/test-kitchen/kitchen-vagrant/issues/521)) ([b6da5d9](https://github.com/test-kitchen/kitchen-vagrant/commit/b6da5d94a9ca129fcd7a7e8f9eae4c8c7f3521cc))

### Other Changes

* chore(docs): Document custom SSH port specification for VMs ([#519](https://github.com/test-kitchen/kitchen-vagrant/pull/519)) ([f74fcf2](https://github.com/test-kitchen/kitchen-vagrant/commit/f74fcf2))
* chore(deps): update actions/checkout action to v6 ([#524](https://github.com/test-kitchen/kitchen-vagrant/pull/524)) ([e6ba1c0](https://github.com/test-kitchen/kitchen-vagrant/commit/e6ba1c0))

## [2.2.0](https://github.com/test-kitchen/kitchen-vagrant/compare/v2.1.3...v2.2.0) (2025-11-09)

### Features

* Warn users when new Vagrant box version is available ([#517](https://github.com/test-kitchen/kitchen-vagrant/issues/517)) ([8c05a0e](https://github.com/test-kitchen/kitchen-vagrant/commit/8c05a0ebd35b8570ce25e9578804c99ea14dd4dc))


### Bug Fixes

* SSH key path resolution in WSL2 environments ([#516](https://github.com/test-kitchen/kitchen-vagrant/issues/516)) ([69b942c](https://github.com/test-kitchen/kitchen-vagrant/commit/69b942c2579e8996f8faee143e84e82c2bed0786))

### Other Changes

* fix: Fix RSA key acceptance issue in Test Kitchen with OpenSSH 8.8 ([#515](https://github.com/test-kitchen/kitchen-vagrant/pull/515)) ([25be1b1](https://github.com/test-kitchen/kitchen-vagrant/commit/25be1b1))

## [2.1.3](https://github.com/test-kitchen/kitchen-vagrant/compare/v2.1.2...v2.1.3) (2025-09-29)

### Bug Fixes

* add oracle linux to bento box list ([#513](https://github.com/test-kitchen/kitchen-vagrant/issues/513)) ([9b466ae](https://github.com/test-kitchen/kitchen-vagrant/commit/9b466ae759c5932b6515d2632adea59ba7ee6521))

### Other Changes

* Revert "fix: add oracle linux to bento box list" ([#512](https://github.com/test-kitchen/kitchen-vagrant/pull/512)) ([b560c60](https://github.com/test-kitchen/kitchen-vagrant/commit/b560c60))

## [2.1.2](https://github.com/test-kitchen/kitchen-vagrant/compare/v2.1.1...v2.1.2) (2025-09-22)

### Bug Fixes

* update test-kitchen dependency to support test-kitchen and chef-test-kitchen-enterprise ([#502](https://github.com/test-kitchen/kitchen-vagrant/issues/502)) ([55be0e9](https://github.com/test-kitchen/kitchen-vagrant/commit/55be0e90f6d53d13a5c401726e9f61c734372af7))

## [2.1.1](https://github.com/test-kitchen/kitchen-vagrant/compare/v2.1.0...v2.1.1) (2025-09-22)

### Bug Fixes

* update hash syntax for Ruby 3.4 compatibility ([#508](https://github.com/test-kitchen/kitchen-vagrant/issues/508)) ([091cdb7](https://github.com/test-kitchen/kitchen-vagrant/commit/091cdb766d1b0ac89d5d5460d05452b46d383e38))

## [2.1.0](https://github.com/test-kitchen/kitchen-vagrant/compare/v2.0.2...v2.1.0) (2025-09-02)

### Features

* support setting extra data for VirtualBox ([#493](https://github.com/test-kitchen/kitchen-vagrant/issues/493)) ([46c9606](https://github.com/test-kitchen/kitchen-vagrant/commit/46c9606a8b08d738953e1e6c08bca848ad2b1e04))

## [2.0.2](https://github.com/test-kitchen/kitchen-vagrant/compare/v2.0.1...v2.0.2) (2025-09-02)

### Bug Fixes

* Add utm provider to list of not safe providers for omnibus cache ([#505](https://github.com/test-kitchen/kitchen-vagrant/issues/505)) ([b8b3c44](https://github.com/test-kitchen/kitchen-vagrant/commit/b8b3c44de7e9b803c0edc7fc26832d4d048f115e))

### Other Changes

* fix action name ([#500](https://github.com/test-kitchen/kitchen-vagrant/pull/500)) ([bcc11c6](https://github.com/test-kitchen/kitchen-vagrant/commit/bcc11c6))
* chore(deps): update actions/checkout action to v5 ([#504](https://github.com/test-kitchen/kitchen-vagrant/pull/504)) ([978a618](https://github.com/test-kitchen/kitchen-vagrant/commit/978a618))

## [2.0.1](https://github.com/test-kitchen/kitchen-vagrant/compare/v2.0.0...v2.0.1) (2024-06-19)

* fix: update release please configs ([#498](https://github.com/test-kitchen/kitchen-vagrant/pull/498)) ([823b495](https://github.com/test-kitchen/kitchen-vagrant/commit/823b495))

## [2.0.0](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.14.2...v2.0.0) (2024-02-14)

- Require Vagrant 2.4 or later
- Drop support for EOL Ruby 2.7 release
- Add a new `box_arch` configuration option for defining the architecture to use
- Eliminate the need for the vagrant-winrm plugin on Windows boxes

* chore(deps): update google-github-actions/release-please-action action to v4 ([#490](https://github.com/test-kitchen/kitchen-vagrant/pull/490)) ([3b7c4b5](https://github.com/test-kitchen/kitchen-vagrant/commit/3b7c4b5))
* add vagrant architecture support ([#491](https://github.com/test-kitchen/kitchen-vagrant/pull/491)) ([cdd8999](https://github.com/test-kitchen/kitchen-vagrant/commit/cdd8999))

* update release please configs ([#498](https://github.com/test-kitchen/kitchen-vagrant/issues/498)) ([823b495](https://github.com/test-kitchen/kitchen-vagrant/commit/823b49527ee8ddb69cdd52ca77a4cb3dc7946382))

## [1.14.2](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.14.1...v1.14.2) (2023-11-27)

### Bug Fixes

* Add New lint and publish workflows ([#488](https://github.com/test-kitchen/kitchen-vagrant/issues/488)) ([744fdc9](https://github.com/test-kitchen/kitchen-vagrant/commit/744fdc93d006ad32f80994b371c198e5a2a9deb6))

### Other Changes

* Update chefstyle requirement from 2.2.2 to 2.2.3 ([#486](https://github.com/test-kitchen/kitchen-vagrant/pull/486)) ([a3707d6](https://github.com/test-kitchen/kitchen-vagrant/commit/a3707d6))
* Configure renovate ([00be941](https://github.com/test-kitchen/kitchen-vagrant/commit/00be941))

## [1.14.1](https://github.com/test-kitchen/kitchen-vagrant/tree/1.14.1) (2023-02-21)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.14.0...v1.14.1)

- Fix failures auto pruning box images that are in use elsewhere [#485](https://github.com/test-kitchen/kitchen-vagrant/pull/485) ([@Stromweld](https://github.com/Stromweld))

## [1.14.0](https://github.com/test-kitchen/kitchen-vagrant/tree/1.14.0) (2023-02-09)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.13.0...v1.14.0)

- Add arm64 to bento box name [#483](https://github.com/test-kitchen/kitchen-vagrant/pull/483) ([@Stromweld](https://github.com/Stromweld))

## [1.13.0](https://github.com/test-kitchen/kitchen-vagrant/tree/1.13.0) (2022-12-13)

- Drop support for EOL Ruby 2.6 ([@tas50](https://github.com/tas50))
- Avoid failures when the system has the same boxes for multiple providers on disk [#481](https://github.com/test-kitchen/kitchen-vagrant/pull/481) ([@Stromweld](https://github.com/Stromweld))

* Update rubocop config for Ruby 2.7 ([8738880](https://github.com/test-kitchen/kitchen-vagrant/commit/8738880))

## [1.12.1](https://github.com/test-kitchen/kitchen-vagrant/tree/1.12.1) (2022-07-11)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.12.0...v1.12.1)

- Fix for Ruby 3.0 compatibility when specifying Vagrantfile network configuration [#477](https://github.com/test-kitchen/kitchen-vagrant/pull/477) ([@PowerKiki](https://github.com/PowerKiKi))

* Prep to release 1.12.1 ([#479](https://github.com/test-kitchen/kitchen-vagrant/pull/479)) ([192c5c8](https://github.com/test-kitchen/kitchen-vagrant/commit/192c5c8))

## [1.12.0](https://github.com/test-kitchen/kitchen-vagrant/tree/1.12.0) (2022-06-09)

- Support for Ruby 3.1
- Using chefstyle linting

* Update chefstyle requirement from 2.1.3 to 2.2.0 ([#469](https://github.com/test-kitchen/kitchen-vagrant/pull/469)) ([cfd1366](https://github.com/test-kitchen/kitchen-vagrant/commit/cfd1366))
* Update README.md ([e4ddd0d](https://github.com/test-kitchen/kitchen-vagrant/commit/e4ddd0d))
* Update chefstyle requirement from 2.2.0 to 2.2.1 ([#470](https://github.com/test-kitchen/kitchen-vagrant/pull/470)) ([9de383c](https://github.com/test-kitchen/kitchen-vagrant/commit/9de383c))
* Use chefstyle linting ([#471](https://github.com/test-kitchen/kitchen-vagrant/pull/471)) ([e99ccae](https://github.com/test-kitchen/kitchen-vagrant/commit/e99ccae))
* Update chefstyle requirement from 2.2.1 to 2.2.2 ([#472](https://github.com/test-kitchen/kitchen-vagrant/pull/472)) ([a975676](https://github.com/test-kitchen/kitchen-vagrant/commit/a975676))
* run specs on ruby 3.1 and remove 2.5 support ([#473](https://github.com/test-kitchen/kitchen-vagrant/pull/473)) ([e33961f](https://github.com/test-kitchen/kitchen-vagrant/commit/e33961f))

## [1.11.0]

- Adds `use_cached_chef_client` option to enable using the cached Chef Infra Client installers on non-Bento Vagrant boxes that have `Guest Additions` installed.

* Update chefstyle requirement from 2.0.8 to 2.0.9 ([#463](https://github.com/test-kitchen/kitchen-vagrant/pull/463)) ([b8f07cd](https://github.com/test-kitchen/kitchen-vagrant/commit/b8f07cd))
* Update chefstyle requirement from 2.0.9 to 2.1.0 ([#464](https://github.com/test-kitchen/kitchen-vagrant/pull/464)) ([94e0ddb](https://github.com/test-kitchen/kitchen-vagrant/commit/94e0ddb))
* Updated use_cached_chef_client PR ([#468](https://github.com/test-kitchen/kitchen-vagrant/pull/468)) ([3a407b7](https://github.com/test-kitchen/kitchen-vagrant/commit/3a407b7))
* Update chefstyle requirement from 2.1.0 to 2.1.3 ([#467](https://github.com/test-kitchen/kitchen-vagrant/pull/467)) ([912ef94](https://github.com/test-kitchen/kitchen-vagrant/commit/912ef94))

## [1.10.0](https://github.com/test-kitchen/kitchen-vagrant/tree/1.10.0) (2021-08-25)

- Only create the virtual drive if it doesn't already exist locally

* Update chefstyle requirement from 2.0.5 to 2.0.6 ([#456](https://github.com/test-kitchen/kitchen-vagrant/pull/456)) ([9334227](https://github.com/test-kitchen/kitchen-vagrant/commit/9334227))
* Support rockylinux and springdalelinux bento boxes ([#457](https://github.com/test-kitchen/kitchen-vagrant/pull/457)) ([c846532](https://github.com/test-kitchen/kitchen-vagrant/commit/c846532))
* Update chefstyle requirement from 2.0.6 to 2.0.7 ([#460](https://github.com/test-kitchen/kitchen-vagrant/pull/460)) ([e3fae39](https://github.com/test-kitchen/kitchen-vagrant/commit/e3fae39))
* Update chefstyle requirement from 2.0.7 to 2.0.8 ([#462](https://github.com/test-kitchen/kitchen-vagrant/pull/462)) ([3514aa5](https://github.com/test-kitchen/kitchen-vagrant/commit/3514aa5))
* VagrantFile: check if virtual drives already exist ([#461](https://github.com/test-kitchen/kitchen-vagrant/pull/461)) ([bbbbb31](https://github.com/test-kitchen/kitchen-vagrant/commit/bbbbb31))

## [1.9.0](https://github.com/test-kitchen/kitchen-vagrant/tree/1.9.0) (2021-07-02)

- Support Test Kitchen 3.0

* Update chefstyle requirement from 1.6.1 to 1.6.2 ([#445](https://github.com/test-kitchen/kitchen-vagrant/pull/445)) ([c937ef4](https://github.com/test-kitchen/kitchen-vagrant/commit/c937ef4))
* Update chefstyle requirement from 1.6.2 to 1.7.1 ([#446](https://github.com/test-kitchen/kitchen-vagrant/pull/446)) ([6370768](https://github.com/test-kitchen/kitchen-vagrant/commit/6370768))
* Update chefstyle requirement from 1.7.1 to 1.7.2 ([#447](https://github.com/test-kitchen/kitchen-vagrant/pull/447)) ([e36963e](https://github.com/test-kitchen/kitchen-vagrant/commit/e36963e))
* Update chefstyle requirement from 1.7.2 to 1.7.4 ([#448](https://github.com/test-kitchen/kitchen-vagrant/pull/448)) ([7c74493](https://github.com/test-kitchen/kitchen-vagrant/commit/7c74493))
* Update chefstyle requirement from 1.7.4 to 1.7.5 ([#449](https://github.com/test-kitchen/kitchen-vagrant/pull/449)) ([28645ed](https://github.com/test-kitchen/kitchen-vagrant/commit/28645ed))
* Upgrade to GitHub-native Dependabot ([#450](https://github.com/test-kitchen/kitchen-vagrant/pull/450)) ([f6492dd](https://github.com/test-kitchen/kitchen-vagrant/commit/f6492dd))
* Update chefstyle requirement from 1.7.5 to 2.0.4 ([#452](https://github.com/test-kitchen/kitchen-vagrant/pull/452)) ([dd712c1](https://github.com/test-kitchen/kitchen-vagrant/commit/dd712c1))
* Update chefstyle requirement from 2.0.4 to 2.0.5 ([#454](https://github.com/test-kitchen/kitchen-vagrant/pull/454)) ([e37dfc5](https://github.com/test-kitchen/kitchen-vagrant/commit/e37dfc5))

## [1.8.0](https://github.com/test-kitchen/kitchen-vagrant/tree/1.8.0) (2021-02-02)

- Require Ruby 2.5 or later (2.3/2.4 are EOL) ([@tas50](https://github.com/tas50))
- Add support for our new Bento `almalinux` boxes [#444](https://github.com/test-kitchen/kitchen-vagrant/pull/444) ([@tas50](https://github.com/tas50))
- Switch all testing to GitHub Actions [#430](https://github.com/test-kitchen/kitchen-vagrant/pull/430) ([@tas50](https://github.com/tas50))
- Remove github changelog generator & countloc development dependencies [#431](https://github.com/test-kitchen/kitchen-vagrant/pull/431) ([@tas50](https://github.com/tas50))
- Remove the Guardfile [#432](https://github.com/test-kitchen/kitchen-vagrant/pull/432) ([@tas50](https://github.com/tas50))
- Add Ruby 3.0 testing [#440](https://github.com/test-kitchen/kitchen-vagrant/pull/440) ([@tas50](https://github.com/tas50))
- Remove guard dev deps / move dev deps to the gemfile [#441](https://github.com/test-kitchen/kitchen-vagrant/pull/441) ([@tas50](https://github.com/tas50))
- Add a Code of Conduct file + misc testing updates [#442](https://github.com/test-kitchen/kitchen-vagrant/pull/442) ([@tas50](https://github.com/tas50))

* Update README.md ([ebf8e8f](https://github.com/test-kitchen/kitchen-vagrant/commit/ebf8e8f))
* Remove code climate test gem ([2c0d9a9](https://github.com/test-kitchen/kitchen-vagrant/commit/2c0d9a9))
* Fix tests ([#434](https://github.com/test-kitchen/kitchen-vagrant/pull/434)) ([acdd2b6](https://github.com/test-kitchen/kitchen-vagrant/commit/acdd2b6))
* Update chefstyle requirement from = 1.5.1 to = 1.5.2 ([#433](https://github.com/test-kitchen/kitchen-vagrant/pull/433)) ([09dfcd9](https://github.com/test-kitchen/kitchen-vagrant/commit/09dfcd9))
* Update chefstyle requirement from = 1.5.2 to = 1.5.7 ([5a2103f](https://github.com/test-kitchen/kitchen-vagrant/commit/5a2103f))
* Update chefstyle requirement from = 1.5.7 to = 1.5.8 ([#438](https://github.com/test-kitchen/kitchen-vagrant/pull/438)) ([61fcf05](https://github.com/test-kitchen/kitchen-vagrant/commit/61fcf05))
* Update chefstyle requirement from = 1.5.8 to = 1.5.9 ([#439](https://github.com/test-kitchen/kitchen-vagrant/pull/439)) ([914e15f](https://github.com/test-kitchen/kitchen-vagrant/commit/914e15f))
* Update chefstyle requirement from =1.5.9 to 1.6.1 ([#443](https://github.com/test-kitchen/kitchen-vagrant/pull/443)) ([836173c](https://github.com/test-kitchen/kitchen-vagrant/commit/836173c))

## [1.7.2](https://github.com/test-kitchen/kitchen-vagrant/tree/1.7.2) (2020-11-10)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.7.1...v1.7.2)

- Ignore error if box not found when updating [#428](https://github.com/test-kitchen/kitchen-vagrant/pull/428) ([@clintoncwolfe](https://github.com/clintoncwolfe))

## [1.7.1](https://github.com/test-kitchen/kitchen-vagrant/tree/1.7.1) (2020-11-03)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.7.0...v1.7.1)

- Don't fail if active boxes can't be pruned [#427](https://github.com/test-kitchen/kitchen-vagrant/pull/427) ([@tas50](https://github.com/tas50))
- Remove redundant encoding comments [#426](https://github.com/test-kitchen/kitchen-vagrant/pull/426) ([@tas50](https://github.com/tas50))
- Use match? when we don't need the match data [#424](https://github.com/test-kitchen/kitchen-vagrant/pull/424) ([@tas50](https://github.com/tas50))
- Optimize our requires to improve performance [#423](https://github.com/test-kitchen/kitchen-vagrant/pull/423) ([@tas50](https://github.com/tas50))

* Fix spelling mistakes ([44a03c7](https://github.com/test-kitchen/kitchen-vagrant/commit/44a03c7))
* Update the example kitchen.yml file for the latest vagrant ([c9be9ed](https://github.com/test-kitchen/kitchen-vagrant/commit/c9be9ed))

## [1.7.0](https://github.com/test-kitchen/kitchen-vagrant/tree/1.7.0) (2020-07-04)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.6.1...v1.7.0)

- Add new `box_auto_update` and `box_auto_prune` options to pull newer Vagrant base boxes [#421](https://github.com/test-kitchen/kitchen-vagrant/pull/421) ([@Stromweld](https://github.com/Stromweld))

* Update github_changelog_generator requirement from 1.15.0 to 1.15.2 ([#416](https://github.com/test-kitchen/kitchen-vagrant/pull/416)) ([c44be79](https://github.com/test-kitchen/kitchen-vagrant/commit/c44be79))

## [1.6.1](https://github.com/test-kitchen/kitchen-vagrant/tree/1.6.1) (2020-01-14)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.6.0...v1.6.1)

- \[README\] fix openstack link [#409](https://github.com/test-kitchen/kitchen-vagrant/pull/409) ([@arthurlogilab](https://github.com/arthurlogilab))
- Use require_relative instead of require [#414](https://github.com/test-kitchen/kitchen-vagrant/pull/414) ([@tas50](https://github.com/tas50))

* Update github_changelog_generator requirement from 1.11.3 to 1.14.3 ([#408](https://github.com/test-kitchen/kitchen-vagrant/pull/408)) ([987f118](https://github.com/test-kitchen/kitchen-vagrant/commit/987f118))
* Update github_changelog_generator requirement from 1.14.3 to 1.15.0 ([#412](https://github.com/test-kitchen/kitchen-vagrant/pull/412)) ([b233509](https://github.com/test-kitchen/kitchen-vagrant/commit/b233509))

## [1.6.0](https://github.com/test-kitchen/kitchen-vagrant/tree/1.6.0) (2019-08-05)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.5.2...v1.6.0)

- Don't fail when instance names become too long for Hyper-V [#404](https://github.com/test-kitchen/kitchen-vagrant/pull/404) ([@Xorima](https://github.com/Xorima))
- Require Ruby 2.3 or later (Ruby < 2.3 are no longer supported Ruby releases)

* Allows for windows hostnames up to 15 characters ([#402](https://github.com/test-kitchen/kitchen-vagrant/pull/402)) ([d263d66](https://github.com/test-kitchen/kitchen-vagrant/commit/d263d66))

## [1.5.2](https://github.com/test-kitchen/kitchen-vagrant/tree/1.5.2) (2019-05-02)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.5.1...v1.5.2)

- Restores vm name uniqueness [#399](https://github.com/test-kitchen/kitchen-vagrant/pull/399) ([@fretb](https://github.com/fretb))

## [1.5.1](https://github.com/test-kitchen/kitchen-vagrant/tree/1.5.1) (2019-03-19)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.5.0...v1.5.1)

- Loosen the Test Kitchen dep to allow 2.0 [#398](https://github.com/test-kitchen/kitchen-vagrant/pull/398) ([@tas50](https://github.com/tas50))

## [1.5.0](https://github.com/test-kitchen/kitchen-vagrant/tree/1.5.0) (2019-03-14)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.4.0...v1.5.0)

- Support using bento/amazonlinux-2 when specifying just amazonlinux-2 platform [#397](https://github.com/test-kitchen/kitchen-vagrant/pull/397) ([@tas50](https://github.com/tas50))

## [1.4.0](https://github.com/test-kitchen/kitchen-vagrant/tree/1.4.0) (2019-01-28)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.3.6...v1.4.0)

- Add usage of vm_hostname to Readme.md [#386](https://github.com/test-kitchen/kitchen-vagrant/pull/386) ([@f9n](https://github.com/f9n))
- Disable audio in virtualbox by default to prevent interupting host Bluetooth audio [#392](https://github.com/test-kitchen/kitchen-vagrant/pull/392) ([@robbkidd](https://github.com/robbkidd))
- Added WSL support [#384](https://github.com/test-kitchen/kitchen-vagrant/pull/384) ([@BCarley](https://github.com/BCarley))

* add documentation for enabling sound ([#393](https://github.com/test-kitchen/kitchen-vagrant/pull/393)) ([7adedca](https://github.com/test-kitchen/kitchen-vagrant/commit/7adedca))

## [1.3.6](https://github.com/test-kitchen/kitchen-vagrant/tree/1.3.6) (2018-10-26)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.3.5...v1.3.6)

**Merged pull requests:**

- Updating for new Chefstyle rules [\#382](https://github.com/test-kitchen/kitchen-vagrant/pull/382) ([tyler-ball](https://github.com/tyler-ball))
- Newest vagrant no long requires vagrant-winrm plugin [\#379](https://github.com/test-kitchen/kitchen-vagrant/pull/379) ([tyler-ball](https://github.com/tyler-ball))

* Preparing 1.3.6 release ([70b35f2](https://github.com/test-kitchen/kitchen-vagrant/commit/70b35f2))

## [1.3.5](https://github.com/test-kitchen/kitchen-vagrant/tree/v1.3.5) (2018-10-23)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.3.4...v1.3.5)

**Merged pull requests:**

- Slim the size of the gem by removing spec files [\#377](https://github.com/test-kitchen/kitchen-vagrant/pull/377) ([tas50](https://github.com/tas50))

## [1.3.4](https://github.com/test-kitchen/kitchen-vagrant/tree/v1.3.4) (2018-09-15)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.3.3...v1.3.4)

**Merged pull requests:**

- Fix \#371, change require =\> load [\#373](https://github.com/test-kitchen/kitchen-vagrant/pull/373) ([cheeseplus](https://github.com/cheeseplus))
- Vagrantfile Template: Hyper-v Differencing\_disk deprecation [\#370](https://github.com/test-kitchen/kitchen-vagrant/pull/370) ([cocazoulou](https://github.com/cocazoulou))

## [1.3.3](https://github.com/test-kitchen/kitchen-vagrant/tree/v1.3.3) (2018-08-13)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.3.2...v1.3.3)

**Merged pull requests:**

- Adding a per-instance generated vmname for Hyper-V [\#368](https://github.com/test-kitchen/kitchen-vagrant/pull/368) ([stuartpreston](https://github.com/stuartpreston))
- Fix \#365 - add name for virtualbox instances [\#366](https://github.com/test-kitchen/kitchen-vagrant/pull/366) ([cheeseplus](https://github.com/cheeseplus))
- Adding the lifecycle hooks stub to fix tests [\#364](https://github.com/test-kitchen/kitchen-vagrant/pull/364) ([cheeseplus](https://github.com/cheeseplus))
- Add an example for vagrantfile\_erb [\#363](https://github.com/test-kitchen/kitchen-vagrant/pull/363) ([jkugler](https://github.com/jkugler))
- Move github changelog generator to the gemfile and skip install in testing [\#362](https://github.com/test-kitchen/kitchen-vagrant/pull/362) ([tas50](https://github.com/tas50))
- Fix disk examples [\#360](https://github.com/test-kitchen/kitchen-vagrant/pull/360) ([espoelstra](https://github.com/espoelstra))

* Adding an example configuration file ([5b7e27a](https://github.com/test-kitchen/kitchen-vagrant/commit/5b7e27a))

## [1.3.2](https://github.com/test-kitchen/kitchen-vagrant/tree/v1.3.2) (2018-04-23)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.3.1...v1.3.2)

**Merged pull requests:**

- Fixing \#349 - allow bento/hardenedbsd [\#355](https://github.com/test-kitchen/kitchen-vagrant/pull/355) ([cheeseplus](https://github.com/cheeseplus))
- Updating travis config [\#354](https://github.com/test-kitchen/kitchen-vagrant/pull/354) ([cheeseplus](https://github.com/cheeseplus))
- Hyper-V: Ensure default switch name is always wrapped in quotes [\#345](https://github.com/test-kitchen/kitchen-vagrant/pull/345) ([stuartpreston](https://github.com/stuartpreston))

## [1.3.1](https://github.com/test-kitchen/kitchen-vagrant/tree/v1.3.1) (2018-02-20)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.3.0...v1.3.1)

**Merged pull requests:**

- Adding support for HyperV Differencing\_disk [\#342](https://github.com/test-kitchen/kitchen-vagrant/pull/342) ([cocazoulou](https://github.com/cocazoulou))

## [1.3.0](https://github.com/test-kitchen/kitchen-vagrant/tree/1.3.0) (2018-01-17)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.2.2...1.3.0)

- Improve Hyper-V defaults and support [\#338](https://github.com/test-kitchen/kitchen-vagrant/pull/338)

* Point people the the https vagrantup.com URL ([#328](https://github.com/test-kitchen/kitchen-vagrant/pull/328)) ([4885193](https://github.com/test-kitchen/kitchen-vagrant/commit/4885193))
* For WinRM options, only treat strings as strings. ([#330](https://github.com/test-kitchen/kitchen-vagrant/pull/330)) ([cdebe04](https://github.com/test-kitchen/kitchen-vagrant/commit/cdebe04))
* Prepping 1.2.2 release ([#335](https://github.com/test-kitchen/kitchen-vagrant/pull/335)) ([0302c07](https://github.com/test-kitchen/kitchen-vagrant/commit/0302c07))
* virtualbox: Allow to use storagectl in customize section ([#334](https://github.com/test-kitchen/kitchen-vagrant/pull/334)) ([bbb36bc](https://github.com/test-kitchen/kitchen-vagrant/commit/bbb36bc))

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.2.1...1.2.2)
- For WinRM options, only treat strings as strings. [\#330](https://github.com/test-kitchen/kitchen-vagrant/pull/330)

## [1.2.1](https://github.com/test-kitchen/kitchen-vagrant/tree/1.2.1) (2017-08-22)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.2.0...1.2.1)

- Revert parallel virtualbox [\#325](https://github.com/test-kitchen/kitchen-vagrant/pull/325)
- Shorten directory name for `vagrant_root` [\#323](https://github.com/test-kitchen/kitchen-vagrant/pull/323)

* turn off parallel vbox when run on Windows hosts ([#324](https://github.com/test-kitchen/kitchen-vagrant/pull/324)) ([0c15ed6](https://github.com/test-kitchen/kitchen-vagrant/commit/0c15ed6))

## [1.2.0](https://github.com/test-kitchen/kitchen-vagrant/tree/1.2.0) (2017-08-11)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.1.1...1.2.0)

**Implemented enhancements:**

- Support to create/attach multiple additional VirtualBox disks [\#312](https://github.com/test-kitchen/kitchen-vagrant/pull/312) ([stissot](https://github.com/stissot))
- Parallel virtualbox [\#202](https://github.com/test-kitchen/kitchen-vagrant/pull/202) ([rveznaver](https://github.com/rveznaver))

## [1.1.1](https://github.com/test-kitchen/kitchen-vagrant/tree/v1.1.1) (2017-07-26)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.1.0...v1.1.1)

### Fixed Bugs

- Fix detection of vagrant-winrm plugin. [\#309](https://github.com/test-kitchen/kitchen-vagrant/pull/309) ([silverl](https://github.com/silverl))
- Fix bug in Vagrantfile template related to WinRM options. [\#306](https://github.com/test-kitchen/kitchen-vagrant/pull/306) ([aleksey-hariton](https://github.com/aleksey-hariton))
- Disable caching, even for bento boxes. [\#313](https://github.com/test-kitchen/kitchen-vagrant/pull/313) ([robbkidd](https://github.com/robbkidd))

### Other Changes

* remove cane testing, chefstyle will handle ([#315](https://github.com/test-kitchen/kitchen-vagrant/pull/315)) ([992b0a8](https://github.com/test-kitchen/kitchen-vagrant/commit/992b0a8))
* Add list of unmaintained Vagrant providers ([#316](https://github.com/test-kitchen/kitchen-vagrant/pull/316)) ([756be28](https://github.com/test-kitchen/kitchen-vagrant/commit/756be28))

## [1.1.0](https://github.com/test-kitchen/kitchen-vagrant/tree/v1.1.0) (2017-03-31)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.0.2...v1.1.0)

**New Features:**

- Make kitchen package work [\#275](https://github.com/test-kitchen/kitchen-vagrant/pull/275) ([ccope](https://github.com/ccope))

**Improvements:**

- Only enable the cache when using known bento boxes. Fix \#296 [\#303](https://github.com/test-kitchen/kitchen-vagrant/pull/303) ([cheeseplus](https://github.com/cheeseplus))
- README: add info about cache\_directory disabling [\#299](https://github.com/test-kitchen/kitchen-vagrant/pull/299) ([jugatsu](https://github.com/jugatsu))
- Add ability to override Kitchen cache directory [\#292](https://github.com/test-kitchen/kitchen-vagrant/pull/292) ([Jakauppila](https://github.com/Jakauppila))
- Add support for all misc vagrant providers [\#290](https://github.com/test-kitchen/kitchen-vagrant/pull/290) ([myoung34](https://github.com/myoung34))

## [1.0.2](https://github.com/test-kitchen/kitchen-vagrant/tree/v1.0.2) (2017-02-13)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.0.1...v1.0.2)

**Fixed bugs:**

- Fixed a bug that can occur when `instance` returns `nil` [\#285](https://github.com/test-kitchen/kitchen-vagrant/pull/285) ([Kuniwak](https://github.com/Kuniwak))

## [1.0.1](https://github.com/test-kitchen/kitchen-vagrant/tree/v1.0.1) (2017-02-10)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.0.0...v1.0.1)

**Fixed bugs:**

- Fixed cache folder disable for FreeBSD and MacOS/OSX [\#281](https://github.com/test-kitchen/kitchen-vagrant/pull/281) ([brentm5](https://github.com/brentm5)) [\#283](https://github.com/test-kitchen/kitchen-vagrant/pull/283) ([cheeseplus](https://github.com/cheeseplus))

* added -- to make it a command line param ([#279](https://github.com/test-kitchen/kitchen-vagrant/pull/279)) ([212a309](https://github.com/test-kitchen/kitchen-vagrant/commit/212a309))
* Add notes for adding vBox disks ([d4e456c](https://github.com/test-kitchen/kitchen-vagrant/commit/d4e456c))

## [1.0.0](https://github.com/test-kitchen/kitchen-vagrant/tree/1.0.0) (2017-01-10)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v0.21.1...v1.0.0)

**Implemented enhancements:**

- Add vagrant-cachier support to default Vagrantfile.erb [\#186](https://github.com/test-kitchen/kitchen-vagrant/issues/186)
- Allow customization of cpuidset for VirtualBox VMs  [\#175](https://github.com/test-kitchen/kitchen-vagrant/issues/175)
- Add KVM/libvirt storage support to Vagrantfile.erb [\#271](https://github.com/test-kitchen/kitchen-vagrant/pull/271) ([dprts](https://github.com/dprts))
- Move to chefstyle [\#264](https://github.com/test-kitchen/kitchen-vagrant/pull/264) ([shortdudey123](https://github.com/shortdudey123))
- Allow multiple "include" statements in LXC configuration [\#230](https://github.com/test-kitchen/kitchen-vagrant/pull/230) ([alexmv](https://github.com/alexmv))
- Set FQDN to include vagrantup.com again for non-windows operating sys… [\#168](https://github.com/test-kitchen/kitchen-vagrant/pull/168) ([spion06](https://github.com/spion06))
- Virtualbox storage via createhd and storageattach [\#246](https://github.com/test-kitchen/kitchen-vagrant/pull/246) ([shortdudey123](https://github.com/shortdudey123))
- Add support for box\_download\_ca\_cert [\#274](https://github.com/test-kitchen/kitchen-vagrant/pull/274) ([cheeseplus](https://github.com/cheeseplus))

**Fixed bugs:**

- Bug in box\_check\_update code [\#237](https://github.com/test-kitchen/kitchen-vagrant/issues/237)
- Fix quoting for cloud providers \(redux \#179\) [\#268](https://github.com/test-kitchen/kitchen-vagrant/pull/268) ([cheeseplus](https://github.com/cheeseplus))

* Updating readme examples for accuracy ([#266](https://github.com/test-kitchen/kitchen-vagrant/pull/266)) ([f609781](https://github.com/test-kitchen/kitchen-vagrant/commit/f609781))
* Fix Readme links for real ([21cee5c](https://github.com/test-kitchen/kitchen-vagrant/commit/21cee5c))
* Fix #186 (mostly) and make it easy to use vagrant-cachier ([#269](https://github.com/test-kitchen/kitchen-vagrant/pull/269)) ([be4a245](https://github.com/test-kitchen/kitchen-vagrant/commit/be4a245))
* Fix #175. Ability to set cpuidset for vbox ([#272](https://github.com/test-kitchen/kitchen-vagrant/pull/272)) ([0231526](https://github.com/test-kitchen/kitchen-vagrant/commit/0231526))
* Fix #237 - fix `false` for box_check_update ([#273](https://github.com/test-kitchen/kitchen-vagrant/pull/273)) ([f9748a6](https://github.com/test-kitchen/kitchen-vagrant/commit/f9748a6))

## [0.21.1](https://github.com/test-kitchen/kitchen-vagrant/tree/0.21.1) (2016-12-05)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v0.21.0...v0.21.1)

**Implemented enhancements:**

- add oracle as supported bento-box type [\#258](https://github.com/test-kitchen/kitchen-vagrant/pull/258) ([lamont-granquist](https://github.com/lamont-granquist))

**Fixed bugs:**

- Change default cache dir for Windows [\#259](https://github.com/test-kitchen/kitchen-vagrant/pull/259) ([afiune](https://github.com/afiune))
- Vagrant requires also to scape slashes [\#253](https://github.com/test-kitchen/kitchen-vagrant/pull/253) ([afiune](https://github.com/afiune))
- Fix cache directory on windows [\#251](https://github.com/test-kitchen/kitchen-vagrant/pull/251) ([afiune](https://github.com/afiune))
- Exclude freebsd and ability to disable cache dir [\#262](https://github.com/test-kitchen/kitchen-vagrant/pull/262) ([afiune](https://github.com/afiune))
- Don't alter the path during the bundler cleanup on windows [\#241](https://github.com/test-kitchen/kitchen-vagrant/pull/241) ([mwrock](https://github.com/mwrock))
- do not map the extra cache drive on non virtualbox windows [\#255](https://github.com/test-kitchen/kitchen-vagrant/pull/255) ([mwrock](https://github.com/mwrock))

* Preparing 0.21.0 release ([#249](https://github.com/test-kitchen/kitchen-vagrant/pull/249)) ([46e32fa](https://github.com/test-kitchen/kitchen-vagrant/commit/46e32fa))
* Release version 0.21.1 ([#261](https://github.com/test-kitchen/kitchen-vagrant/pull/261)) ([358148c](https://github.com/test-kitchen/kitchen-vagrant/commit/358148c))

## [0.21.0](https://github.com/test-kitchen/kitchen-vagrant/tree/0.21.0) (2016-11-29)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v0.20.0...v0.21.0)

**Fixed bugs:**

- Generated Vagrantfile has type issues [\#236](https://github.com/test-kitchen/kitchen-vagrant/issues/236)
- Fix ssh boolean values in Vagrantfile template [\#231](https://github.com/test-kitchen/kitchen-vagrant/pull/231) ([zuazo](https://github.com/zuazo))

**Merged pull requests:**

- Add a synced folder to persist chef omnibus packages [\#248](https://github.com/test-kitchen/kitchen-vagrant/pull/248) ([afiune](https://github.com/afiune))
- Fix generated Vagrantfile type issues [\#243](https://github.com/test-kitchen/kitchen-vagrant/pull/243) ([OBrienCommaJosh](https://github.com/OBrienCommaJosh))
- Bump travis rubies to the modern age [\#242](https://github.com/test-kitchen/kitchen-vagrant/pull/242) ([mwrock](https://github.com/mwrock))
- Fix the name of "Parallels Desktop for Mac" [\#233](https://github.com/test-kitchen/kitchen-vagrant/pull/233) ([legal90](https://github.com/legal90))
- Add support for ovirt3 vagrant provider [\#223](https://github.com/test-kitchen/kitchen-vagrant/pull/223) ([xiboy](https://github.com/xiboy))

## [0.20.0](https://github.com/test-kitchen/kitchen-vagrant/tree/v0.20.0) (2016-04-07)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v0.19.0...v0.20.0)

**Implemented enhancements:**

- Make Vagrant binary a parameter [\#218](https://github.com/test-kitchen/kitchen-vagrant/issues/218)
- WARN: Child with name 'dna.json' found in multiple directories: /tmp/kitchen/dna.json and /tmp/kitchen/dna.json [\#198](https://github.com/test-kitchen/kitchen-vagrant/issues/198)
- Default bento boxes should be pulled from Atlas [\#193](https://github.com/test-kitchen/kitchen-vagrant/issues/193)
- Easily override instance name [\#169](https://github.com/test-kitchen/kitchen-vagrant/issues/169)
- Make vagrant binary a parameter [\#219](https://github.com/test-kitchen/kitchen-vagrant/pull/219) ([bheuvel](https://github.com/bheuvel))
- HyperV acts as OpenStack, CloudStack [\#217](https://github.com/test-kitchen/kitchen-vagrant/pull/217) ([bheuvel](https://github.com/bheuvel))
- Add support for hyperv customize [\#212](https://github.com/test-kitchen/kitchen-vagrant/pull/212) ([giseongeom](https://github.com/giseongeom))
- Add option for box\_download\_insecure to be passed to Vagrantfile [\#208](https://github.com/test-kitchen/kitchen-vagrant/pull/208) ([drrk](https://github.com/drrk))
- fix libvirt customize [\#204](https://github.com/test-kitchen/kitchen-vagrant/pull/204) ([akissa](https://github.com/akissa))
- Add linked\_clone config option [\#203](https://github.com/test-kitchen/kitchen-vagrant/pull/203) ([bborysenko](https://github.com/bborysenko))
- Use Bento's Atlas boxes by default if detected [\#195](https://github.com/test-kitchen/kitchen-vagrant/pull/195) ([andytson](https://github.com/andytson))
- Parallels: Use "memory" and "cpus" customization shortcuts [\#194](https://github.com/test-kitchen/kitchen-vagrant/pull/194) ([legal90](https://github.com/legal90))
- Add support for boot\_timeout driver setting [\#184](https://github.com/test-kitchen/kitchen-vagrant/pull/184) ([gh2k](https://github.com/gh2k))
- Fixes box check update bug [\#182](https://github.com/test-kitchen/kitchen-vagrant/pull/182) ([roderickrandolph](https://github.com/roderickrandolph))
- Add cloudstack support [\#167](https://github.com/test-kitchen/kitchen-vagrant/pull/167) ([miguelaferreira](https://github.com/miguelaferreira))

**Fixed bugs:**

- setting box\_check\_update to false does not disable box update checking [\#181](https://github.com/test-kitchen/kitchen-vagrant/issues/181)

**Merged pull requests:**

- Updating readme for Parallels [\#221](https://github.com/test-kitchen/kitchen-vagrant/pull/221) ([cheeseplus](https://github.com/cheeseplus))
- Adding changelog generator [\#220](https://github.com/test-kitchen/kitchen-vagrant/pull/220) ([cheeseplus](https://github.com/cheeseplus))
- Updating Readme to reflect changes to default boxes [\#215](https://github.com/test-kitchen/kitchen-vagrant/pull/215) ([cheeseplus](https://github.com/cheeseplus))
- Ruby 1.9.3 is no longer supported [\#209](https://github.com/test-kitchen/kitchen-vagrant/pull/209) ([drrk](https://github.com/drrk))

* Up version for development. ([4af0b54](https://github.com/test-kitchen/kitchen-vagrant/commit/4af0b54))
* Preparing 0.20.0 release ([#222](https://github.com/test-kitchen/kitchen-vagrant/pull/222)) ([67a5248](https://github.com/test-kitchen/kitchen-vagrant/commit/67a5248))

## 0.19.0 / 2015-09-18

### Bug fixes

* Pull request [#163][]: Properly quote `config[:ssh]` values. ([@zuazo][])
* Pull request [#191][], pull request [#197][], issue [#190][]: Escape Bundler environment when shelling out to `vagrant` command. ([@ksubrama][], [@tknerr][])

### New features

* Pull request 172, issue [#171][]: Add support for OpenStack provider. ([@xmik][])

### Improvements

* Pull request [#174][]: Correct grammar error in README. ([@albsOps][])
* Support running unit test suite on Windows ([@ksubrama][])

### Other Changes

* Up version for development. ([537162e](https://github.com/test-kitchen/kitchen-vagrant/commit/537162e))
* Customize supports other vagrant providers, fixes #171 ([#172](https://github.com/test-kitchen/kitchen-vagrant/pull/172)) ([3d8d9f0](https://github.com/test-kitchen/kitchen-vagrant/commit/3d8d9f0))

## 0.18.0 / 2015-05-07

### Bug fixes

* Pull request [#161][]: Add handling for winrm communicator in username & password handling. ([@atiniir][])

### Improvements

* Pull request [#166][]: Allow a fuzzier match for known Bento box names. ([@fnichol][])

## 0.17.0 / 2015-04-28

(*A selected roll-up of 0.17.0 pre-release changelogs*)

### Bug fixes

* Pull request [#156][]: Use RDPPort value from `vagrant winrm-config` for WinRM Transports. ([@fnichol][])

### New features

* Pull request [#154][]: Support for WinRM Transport and Windows-based instances. ([@fnichol][])

### Improvements

* Pull request [#152][]: Translate CPU count for VMWare provider. ([@whiteley][])
* Pull request [#157][]: Close Transport connection in #destroy. ([@fnichol][])
* Pull request [#158][]: Add plugin metadata to the Driver. ([@fnichol][])

### Other Changes

* Up version for development. ([92fbf70](https://github.com/test-kitchen/kitchen-vagrant/commit/92fbf70))

## 0.17.0.rc.1 / 2015-03-29

### Improvements

* Pull request [#157][]: Close Transport connection in #destroy. ([@fnichol][])
* Pull request [#158][]: Add plugin metadata to the Driver. ([@fnichol][])

### Other Changes

* Up version for development. ([e7eef87](https://github.com/test-kitchen/kitchen-vagrant/commit/e7eef87))

## 0.17.0.beta.4 / 2015-03-26

### Bug fixes

* Pull request [#156][]: Use RDPPort value from `vagrant winrm-config` for WinRM Transports. ([@fnichol][])

### Improvements

* Pull request [#152][]: Translate CPU count for VMWare provider. ([@whiteley][])

### Other Changes

* Up version for development. ([d89a0b2](https://github.com/test-kitchen/kitchen-vagrant/commit/d89a0b2))

## 0.17.0.beta.3 / 2015-03-25

### Bug fixes

* Pull request [#155][]: Use the vagrant-winrm Vagrant plugin to resolve VM IP address. See PR for details. ([@fnichol][])

### Other Changes

* Up version for development. ([cfa9e83](https://github.com/test-kitchen/kitchen-vagrant/commit/cfa9e83))

## 0.17.0.beta.2 / 2015-03-25

* Relax version constraint on Test Kitchen. ([@fnichol][])

* Up version for development. ([461b310](https://github.com/test-kitchen/kitchen-vagrant/commit/461b310))

## 0.17.0.beta.1 / 2015-03-24

* Pull request [#154][]: Support for WinRM Transport and Windows-based instances. ([@fnichol][])

* Up version for development. ([eaaa6f1](https://github.com/test-kitchen/kitchen-vagrant/commit/eaaa6f1))

## 0.16.0 / 2015-03-23

### Bug fixes

* Pull request [#122][], pull request [#151][]: Only set custom `:box` & `:box_url` values for known Bento boxes. ([@ashb][], [@fnichol][])

### New features

* Pull request [#84][]: Add support for Parallels provider. ([@jhx][])
* Pull request [#107][]: Add support for libvirt provider. ([@bradleyd][])
* Pull request [#128][]: Add support for LXC provider. ([@tknerr][])
* Pull request [#142][]: Add support for managed-servers provider. ([@kbruner][])
* Add `:gui` configuration attribute to override default GUI mode with VirtualBox and VMware-based providers. ([@fnichol][])
* Pull request [#137][]: Support SoftLayer `:disk_capacity` configuration. ([@hugespoon][])
* Pull request [#102][]: Add `:box_version` & `:box_check_update` configuration options to support box versioning. ([@mconigliaro][])
* Pull request [#129][]: Add `:provision` configuration option. ([@gouketsu][])
* Pull request [#112][]: Add configuration option for user Vagrantfiles with `:vagrantfiles` configuration option. ([@byggztryng][])
* Pull request [#95][]: Add SSH ProxyCommand to state if present. ([@bdclark][])
* Pull request [#121][]: Add `:ssh` configuration hash. ([@Igorshp][])
* Pull request [#104][]: Add `:communicator` configuration option to support overriding underlying base box's communicator setting. ([@RobertRehberg][])
* Pull request [#118][]: Vagrant config password (Not Vagrant recommended). ([@philcallister][])

### Improvements

* Pull request [#148][]: Add full test coverage to the codebase. ([@fnichol][])
* Pull request [#126][]: Disable vagrant-berkshelf plugin by default (this Driver does not need it and can cause confusing errors). ([@tknerr][])
* Pull request [#101][]: Qualify VM names with project name. ([@petere][])
* Pull request [#117][]: Change default hostname to be shorter and friendlier for Windows hosts. ([@Annih][])
* Pull request [#106][], Use correct URLs to download vagrant in README. ([@alex-slynko-wonga][])
* Pull request [#146][]: Freshen project quality (TravisCI, Tailor-for-Rubocop, Guard support, etc). ([@fnichol][])
* Pull request [#147][]: Tidy default configuration attributes. ([@fnichol][])
* Pull request [#134][]: CHANGELOG Champion, Mr. [@miketheman][]. ([@miketheman][])
* Pull request [#127][]: README updates. ([@vinyar][], fnichol)

### Other Changes

* Remove comma from example ([cf9350a](https://github.com/test-kitchen/kitchen-vagrant/commit/cf9350a))
* Merge https://github.com/test-kitchen/kitchen-vagrant/pull/104 ([464ef58](https://github.com/test-kitchen/kitchen-vagrant/commit/464ef58))
* Merge https://github.com/test-kitchen/kitchen-vagrant/pull/122 ([63f9eef](https://github.com/test-kitchen/kitchen-vagrant/commit/63f9eef))
* Revert "Update README.md" ([aa3ff9b](https://github.com/test-kitchen/kitchen-vagrant/commit/aa3ff9b))
* Use #finalize_config! as hook point for #resolve_config!. ([e0fa698](https://github.com/test-kitchen/kitchen-vagrant/commit/e0fa698))
* Memoize the Vagrant version check as it is being called twice. ([26bb4f3](https://github.com/test-kitchen/kitchen-vagrant/commit/26bb4f3))
* Freeze String constants. ([4d57ed4](https://github.com/test-kitchen/kitchen-vagrant/commit/4d57ed4))
* Document public methods & lexically sort all methods. ([9f9b502](https://github.com/test-kitchen/kitchen-vagrant/commit/9f9b502))
* Update README.md badges. ([46e6f3d](https://github.com/test-kitchen/kitchen-vagrant/commit/46e6f3d))
* A more accurate update of README.md badges. ([0fdd2b0](https://github.com/test-kitchen/kitchen-vagrant/commit/0fdd2b0))
* Extract `vagrant up` logic to a method. ([fa6dcce](https://github.com/test-kitchen/kitchen-vagrant/commit/fa6dcce))
* Refactor rename #update_ssh_state to #update_state. ([f4b87d1](https://github.com/test-kitchen/kitchen-vagrant/commit/f4b87d1))
* Call super in #verify_dependencies. ([0a892d7](https://github.com/test-kitchen/kitchen-vagrant/commit/0a892d7))
* Refactorings of private methods and add full doc comment coverage. ([062c802](https://github.com/test-kitchen/kitchen-vagrant/commit/062c802))
* Add missing `require "erb"` as it is directly used in the class. ([a44c81f](https://github.com/test-kitchen/kitchen-vagrant/commit/a44c81f))
* Add :gui config attr for gui mode with virtualbox & vmware_*. ([3c12ea0](https://github.com/test-kitchen/kitchen-vagrant/commit/3c12ea0))
* Revert "Revert "Update README.md"" ([7e1f129](https://github.com/test-kitchen/kitchen-vagrant/commit/7e1f129))
* Update :gui documentation in README.md. ([1e91000](https://github.com/test-kitchen/kitchen-vagrant/commit/1e91000))
* Ensure a non-frozen String is passed to `Gem::Version.new`. ([951072d](https://github.com/test-kitchen/kitchen-vagrant/commit/951072d))
* Large overhaul to the README. ([e598544](https://github.com/test-kitchen/kitchen-vagrant/commit/e598544))
* Merge (rebased) pull request #128 from tknerr/lxc-provider-support ([3df523d](https://github.com/test-kitchen/kitchen-vagrant/commit/3df523d))
* Merge (rebased) pull request #137 from hugespoon/sl-disk-capacity ([111da5d](https://github.com/test-kitchen/kitchen-vagrant/commit/111da5d))
* Merge (rebased) pull request #142 from kbruner:master ([556c72c](https://github.com/test-kitchen/kitchen-vagrant/commit/556c72c))

## 0.15.0 / 2014-04-28

### New features

* Support vagrant-softlayer plugin

### Improvements

* Improved/updated README documentation + typos
* Remove default memory setting
* Fix relative paths in synced folders

### Other Changes

* Up version for development. ([9a016c8](https://github.com/test-kitchen/kitchen-vagrant/commit/9a016c8))
* Fix typos in README ([#66](https://github.com/test-kitchen/kitchen-vagrant/pull/66)) ([424c945](https://github.com/test-kitchen/kitchen-vagrant/commit/424c945))
* Update YAML examples in README. ([3d576c6](https://github.com/test-kitchen/kitchen-vagrant/commit/3d576c6))
* Fix relative synced folder paths ([#72](https://github.com/test-kitchen/kitchen-vagrant/pull/72)) ([e4f6992](https://github.com/test-kitchen/kitchen-vagrant/commit/e4f6992))
* Improve documentation for setting the Vagrant provider ([#76](https://github.com/test-kitchen/kitchen-vagrant/pull/76)) ([cb93d4f](https://github.com/test-kitchen/kitchen-vagrant/commit/cb93d4f))
* Support vagrant-softlayer plugin syntax ([#80](https://github.com/test-kitchen/kitchen-vagrant/pull/80)) ([36c67aa](https://github.com/test-kitchen/kitchen-vagrant/commit/36c67aa))
* Use more YAML in synced folders ([#82](https://github.com/test-kitchen/kitchen-vagrant/pull/82)) ([f463014](https://github.com/test-kitchen/kitchen-vagrant/commit/f463014))
* Update README.md ([#88](https://github.com/test-kitchen/kitchen-vagrant/pull/88)) ([20bba7a](https://github.com/test-kitchen/kitchen-vagrant/commit/20bba7a))

## 0.14.0 / 2013-12-09

### New features

* Add `config[:vm_hostname]` to set config.vm.hostname in Vagrantfile. ([@fnichol][])

### Improvements

* Add `config[:guest]` documentation in README. ([@fnichol][])

## 0.13.0 / 2013-12-04

### New features

* Use Opscode's new buckets for Virtual machines, allowing for downloads of VirtualBox and VMware Fusion/Workstation Bento boxes (Vagrant minimal base boxes). ([@sethvargo][])

### Other Changes

* Up version for development. ([5764349](https://github.com/test-kitchen/kitchen-vagrant/commit/5764349))
* Update gemspec metadata. ([7e15952](https://github.com/test-kitchen/kitchen-vagrant/commit/7e15952))
* Update links & users in CHANGELOG. ([2b64751](https://github.com/test-kitchen/kitchen-vagrant/commit/2b64751))

## 0.12.0 / 2013-11-29

### Breaking changes

* Remove `use_vagrant_provision` configuration option.

### New features

* Major refactor of Vagrantfile generation, to use an ERB template. For more details please consult the `vagrantfile_erb` section of the README. ([@fnichol][])
* Add `pre_create_command` option to run optional setup such as Bindler. ([@fnichol][])

### Improvements

* Pull request [#56][]: Enabled passing options to the synced folders. ([@antonio-osorio][])
* Pull request [#55][]: Fix README badges. ([@arangamani][])

### Other Changes

* Up version for development. ([aa791a5](https://github.com/test-kitchen/kitchen-vagrant/commit/aa791a5))
* VagrantfileCreator supports test-kitchen v1.0.0.rc.1. ([#57](https://github.com/test-kitchen/kitchen-vagrant/pull/57)) ([89b18e7](https://github.com/test-kitchen/kitchen-vagrant/commit/89b18e7))
* Remove require_chef_omnibus docs in README, now a Provisioner conern. ([288e6b6](https://github.com/test-kitchen/kitchen-vagrant/commit/288e6b6))

## 0.11.3 / 2013-11-09

### Bug fixes

* Revert `quiet` option used for Vagrant version checking. ([@fnichol][])

### Other Changes

* Test on Ruby 1.9 and Ruby 2.0 ([3aa70cb](https://github.com/test-kitchen/kitchen-vagrant/commit/3aa70cb))
* Remove additional references to vagrant-berkshelf and Berkshelf ([a97927c](https://github.com/test-kitchen/kitchen-vagrant/commit/a97927c))
* Revert "Don't use the :quiet option (it doesn't do anything)" ([45de089](https://github.com/test-kitchen/kitchen-vagrant/commit/45de089))

## 0.11.2 / 2013-11-05

### Bug fixes

* Remove misleading `quiet` option ([@sethvargo][])
* Relax dependency on Test Kitchen ([@sethvargo][])
* Remove deprecated references to `vagrant-berkshelf` ([@sethvargo][])

### Improvements

* Allow users to specify custom SSH private key ([@manul][])
* Use platform to determine which vagrant box to download (assume Opscode) ([@sethvargo][])

### Other Changes

* Up version for development. ([5d42ec1](https://github.com/test-kitchen/kitchen-vagrant/commit/5d42ec1))
* Update CHANGELOG. ([93a8ac4](https://github.com/test-kitchen/kitchen-vagrant/commit/93a8ac4))
* Will make it possible to configure your own private ssh key for vagrant instead of the default vagrant private key. Will set the ssh_key in the Vagrantfile if the ssh_key attribute is set in .kitchen.yml This didn't work before as in the config.merge(state) the setting in the .kitchen.yml file is overriden by the setting in the Vagrantfile. ([ef31e96](https://github.com/test-kitchen/kitchen-vagrant/commit/ef31e96))
* Use platform name to determine which vagrant box to download ([abefa8c](https://github.com/test-kitchen/kitchen-vagrant/commit/abefa8c))
* Don't use the :quiet option (it doesn't do anything) ([07c8662](https://github.com/test-kitchen/kitchen-vagrant/commit/07c8662))
* Remove vagrant provisioner ([4993a1b](https://github.com/test-kitchen/kitchen-vagrant/commit/4993a1b))
* Make cane and tailor happy ([6152f0a](https://github.com/test-kitchen/kitchen-vagrant/commit/6152f0a))
* Remove references to vagrant-berkshelf in README ([34740ba](https://github.com/test-kitchen/kitchen-vagrant/commit/34740ba))

## 0.11.1 / 2013-08-29

### Bug fixes

* Pull request [#36][]: README fix for synched_folders. ([@mattray][])

### Improvements

* Pull request [#34][]: Disable synced folders by default. ([@dje][])

### Other Changes

* Up version for development. ([dff1448](https://github.com/test-kitchen/kitchen-vagrant/commit/dff1448))
* Update CHANGELOG.md. ([a3169bc](https://github.com/test-kitchen/kitchen-vagrant/commit/a3169bc))
* Add license to gemspec. ([96eaf76](https://github.com/test-kitchen/kitchen-vagrant/commit/96eaf76))

## 0.11.0 / 2013-07-23

### New features

* Pull request [#30][]: Support computed defaults for a select list of pre-determined platforms (see pull request and readme for quick example). ([@fnichol][])
* Pull request [#25][]: Add rackspace support. ([@josephholsten][])

### Improvements

* Pull request [#20][]: Respect `VAGRANT_DEFAULT_PROVIDER` environment variable. ([@tmatilai][])
* Pull request [#24][]: Allow to override Vagrant default SSH username. ([@gildegoma][])
* Pull request [#21][]: Configure tailor to actually check the code style. ([@tmatilai][])

### Bug fixes

* Pull request [#29][], issue [#28][]: Allow the vagrant guest setting to be set in the generated Vagrantfile via the kitchen.yml. ([@keiths-osc][])
* Pull request [#31][]: Add some quotes around Vagrantfile value. ([@albertsj1][])

### Other Changes

* Up version for development. ([4742374](https://github.com/test-kitchen/kitchen-vagrant/commit/4742374))
* Delegate to super in #converge unless :use_vagrant_provision is set. ([f139e1b](https://github.com/test-kitchen/kitchen-vagrant/commit/f139e1b))
* Remove #jamie-ci notifications from .travis.yml. ([ccf9d95](https://github.com/test-kitchen/kitchen-vagrant/commit/ccf9d95))
* Refactor Rakefile to add `rake quality`. ([31faa0d](https://github.com/test-kitchen/kitchen-vagrant/commit/31faa0d))
* Depend on test-kitchen ~&gt; 1.0.0.beta.1 for upstream change. ([555dffc](https://github.com/test-kitchen/kitchen-vagrant/commit/555dffc))

## 0.10.0 / 2013-05-08

### New features

* Pull request [#12][]: Use SSHBase functionality (using ChefDataUploader) to manage Chef provisioning in the converge action and make Vagrant's built in provisioning an optional mode by setting `use_vagrant_provision: true` in the `driver_config` section of the .kitchen.yml. As a consequence, the vagrant-berkshelf middleware is now also optional and off by default (can be re-enabled by setting `use_vagrant_berkshelf_plugin: true`). ([@fujin][])
* Pull request [#18][]: Add VMware Fusion/Workstation support. ([@TheDude05][])

### Improvements

* Issue [#19][]: Recommend the vagrant-wrapper gem in README. ([@fnichol][])

### Other Changes

* Up version for development. ([bba35eb](https://github.com/test-kitchen/kitchen-vagrant/commit/bba35eb))
* Update README with new config options. ([ee00de3](https://github.com/test-kitchen/kitchen-vagrant/commit/ee00de3))
* Add encrypted_data_bag_secret_key_path to the Vagrantfile if present ([#13](https://github.com/test-kitchen/kitchen-vagrant/pull/13)) ([d2a266a](https://github.com/test-kitchen/kitchen-vagrant/commit/d2a266a))
* Shorten long line in VagrantfileCreator. ([b3c3596](https://github.com/test-kitchen/kitchen-vagrant/commit/b3c3596))
* Use path relative to kitchen_root for encrypted data bag secret file. ([3866265](https://github.com/test-kitchen/kitchen-vagrant/commit/3866265))
* Merge branch 'add-vmware-support' of https://github.com/intoximeters/kitchen-vagrant into intoximeters-add-vmware-support ([e75ac72](https://github.com/test-kitchen/kitchen-vagrant/commit/e75ac72))
* Fix up README lines. ([34490e7](https://github.com/test-kitchen/kitchen-vagrant/commit/34490e7))
* Refactor VagrantfileCreator to reduce ABC complexity. ([9ff4c0e](https://github.com/test-kitchen/kitchen-vagrant/commit/9ff4c0e))

## 0.9.0 / 2013-04-19

### Upstream changes

* Pull request [#16][]: Update Vagrant Berkshelf plugin detection for the vagrant-berkshelf and drop detection for berkshelf-vagrant. ([@martinisoft][])

### Other Changes

* Up version for development. ([fecb098](https://github.com/test-kitchen/kitchen-vagrant/commit/fecb098))

## 0.8.0 / 2013-04-16

### Improvements

* Pull request [#15][]: Support berkshelf-vagrant 1.1.0+ in Vagrantfiles. ([@petejkim][], [@fnichol][])
* Add an explanation of how this driver works in the README. ([@fnichol][])

### Other Changes

* Up version for development. ([7534072](https://github.com/test-kitchen/kitchen-vagrant/commit/7534072))
* Update README with more information for newcomers ([#11](https://github.com/test-kitchen/kitchen-vagrant/pull/11)) ([b76a931](https://github.com/test-kitchen/kitchen-vagrant/commit/b76a931))
* Prototype of Driver README format. ([e12de64](https://github.com/test-kitchen/kitchen-vagrant/commit/e12de64))
* Fix link typo in README. ([719456d](https://github.com/test-kitchen/kitchen-vagrant/commit/719456d))
* Make box a required config value. ([8de0a68](https://github.com/test-kitchen/kitchen-vagrant/commit/8de0a68))
* Add dry_run configuration documentation in README. ([79b1fc6](https://github.com/test-kitchen/kitchen-vagrant/commit/79b1fc6))
* Add explanation in README. ([c96c601](https://github.com/test-kitchen/kitchen-vagrant/commit/c96c601))

## 0.7.4 / 2013-03-28

### Improvements

* Drop `vagrant ssh -c` & communicate directly via SSH. ([@fnichol][])

### Other Changes

* Up version for development. ([c2f9851](https://github.com/test-kitchen/kitchen-vagrant/commit/c2f9851))

## 0.7.3 / 2013-03-28

### Bug fixes

* Calling #destroy should not memoize #create_vagrantfile. ([@fnichol][], [@sandfish8][])

### Other Changes

* Up version for development. ([661def9](https://github.com/test-kitchen/kitchen-vagrant/commit/661def9))
* [Bugfix] Calling #destroy should not memoize #create_vagrantfile. ([55b3ce7](https://github.com/test-kitchen/kitchen-vagrant/commit/55b3ce7))

## 0.7.2 / 2013-03-23

### Bug fixes

* Wrap strings for data_bags_path and roles_path in Vagrantfiles. ([@fnichol][])

### Other Changes

* Up version for development. ([7df1071](https://github.com/test-kitchen/kitchen-vagrant/commit/7df1071))
* Update Code Climate badge on README. ([3d560d6](https://github.com/test-kitchen/kitchen-vagrant/commit/3d560d6))

## 0.7.1 / 2013-03-23

### Bug fixes

* Depend on test-kitchen ~> 1.0.0.alpha.1 to get API updates. ([@fnichol][])

## 0.7.0 / 2013-03-22

### New features

* Pull request [#7][]: [Breaking] Support Vagrant 1.1+ and remove vagrant gem dependency. ([@fnichol][])
* Pull request [#8][]: Add dependency checks for Vagrant and berkshelf-vagrant plugin (if necessary). ([@fnichol][])

### Other Changes

* Up version for development. ([8c9570b](https://github.com/test-kitchen/kitchen-vagrant/commit/8c9570b))
* Update README badges. ([f71942c](https://github.com/test-kitchen/kitchen-vagrant/commit/f71942c))
* Add CHANGELOG. ([c82e04e](https://github.com/test-kitchen/kitchen-vagrant/commit/c82e04e))

## 0.6.0 / 2013-03-02

The initial release.

<!--- The following link definition list is generated by PimpMyChangelog --->

* Introducing kitchen-vagrant ([a474732](https://github.com/test-kitchen/kitchen-vagrant/commit/a474732))
* Depend on test-kitchen ~&gt; 1.0.0.alpha.0. ([8b09887](https://github.com/test-kitchen/kitchen-vagrant/commit/8b09887))
* add support for `require_chef_omnibus` driver option ([#4](https://github.com/test-kitchen/kitchen-vagrant/pull/4)) ([a23888b](https://github.com/test-kitchen/kitchen-vagrant/commit/a23888b))
* Merge branch 'KITCHEN-68' ([6a8e158](https://github.com/test-kitchen/kitchen-vagrant/commit/6a8e158))

* Initial project scaffold, generated from `jamie new_plugin vagrant`. ([c9fb023](https://github.com/test-kitchen/kitchen-vagrant/commit/c9fb023))
* TravisCI and Code Climate &lt;3 &lt;3 &lt;3 ([cd7db9c](https://github.com/test-kitchen/kitchen-vagrant/commit/cd7db9c))
* Extract Vagrant driver implementation from Jamie core. ([e224d1f](https://github.com/test-kitchen/kitchen-vagrant/commit/e224d1f))
* Exclude Jamie::Vagrant.define_vagrant_vm from cane complexity checks. ([6e64983](https://github.com/test-kitchen/kitchen-vagrant/commit/6e64983))

* Do not depend on config['name'], instead use config['vagrant_vm']. ([e16d882](https://github.com/test-kitchen/kitchen-vagrant/commit/e16d882))
* Return from #perform_destroy if instance has not been created. ([b2d1653](https://github.com/test-kitchen/kitchen-vagrant/commit/b2d1653))
* [Jamie API] Driver API updates in 0.1.0.alpha16. ([88d2c4c](https://github.com/test-kitchen/kitchen-vagrant/commit/88d2c4c))

* Save vagrant name as config['hostname'] to use #build_ssh_args value. ([06f70ad](https://github.com/test-kitchen/kitchen-vagrant/commit/06f70ad))

* Add attribution comments. ([138007a](https://github.com/test-kitchen/kitchen-vagrant/commit/138007a))
* Add code stats to Rakefile. ([28cdd91](https://github.com/test-kitchen/kitchen-vagrant/commit/28cdd91))
* Add TravisCI notifications to freenode. ([94c8c60](https://github.com/test-kitchen/kitchen-vagrant/commit/94c8c60))
* Fix Vagrantfile auto-creation by hooking into #create driver action. ([1bfdeeb](https://github.com/test-kitchen/kitchen-vagrant/commit/1bfdeeb))
* Relase 0.2.2, Driver API bugfix. ([bda1f74](https://github.com/test-kitchen/kitchen-vagrant/commit/bda1f74))

* Prevent Vagrant from serializing Jamie::Vagrant::Config to hash or json. ([0b2f622](https://github.com/test-kitchen/kitchen-vagrant/commit/0b2f622))
* [Instance#driver] Jamie core API update. ([2a23075](https://github.com/test-kitchen/kitchen-vagrant/commit/2a23075))
* Add config['dry_run'] support to echo Vagrant commands (no-op mode). ([451c220](https://github.com/test-kitchen/kitchen-vagrant/commit/451c220))
* [API] Driver API update in Jamie. ([c4ebf70](https://github.com/test-kitchen/kitchen-vagrant/commit/c4ebf70))
* Add mild logging after instance creation and destruction. ([117da26](https://github.com/test-kitchen/kitchen-vagrant/commit/117da26))

* Override #login_command to issue `vagrant ssh &lt;hostname&gt;`. ([aa8a17d](https://github.com/test-kitchen/kitchen-vagrant/commit/aa8a17d))

* KITCHEN-68 add basic network options ([#1](https://github.com/test-kitchen/kitchen-vagrant/pull/1)) ([dbe2246](https://github.com/test-kitchen/kitchen-vagrant/commit/dbe2246))
* Update default_config directive in Jamie::Driver::Vagrant. ([8e4aa5a](https://github.com/test-kitchen/kitchen-vagrant/commit/8e4aa5a))

* Merge branch 'symbolize' ([0e890c4](https://github.com/test-kitchen/kitchen-vagrant/commit/0e890c4))

* Up version for development. ([aeec478](https://github.com/test-kitchen/kitchen-vagrant/commit/aeec478))
* Fix version number. ([1f2c2a3](https://github.com/test-kitchen/kitchen-vagrant/commit/1f2c2a3))
* Merge branch 'no-parallel-for' ([94d1519](https://github.com/test-kitchen/kitchen-vagrant/commit/94d1519))
* Depend on jamie ~&gt; 0.1.0.beta1. ([f905d6c](https://github.com/test-kitchen/kitchen-vagrant/commit/f905d6c))

* Fix hash key syntax regression. ([423a64d](https://github.com/test-kitchen/kitchen-vagrant/commit/423a64d))

* Release 0.5.2. ([733374d](https://github.com/test-kitchen/kitchen-vagrant/commit/733374d))

[#7]: https://github.com/test-kitchen/kitchen-vagrant/issues/7
[#8]: https://github.com/test-kitchen/kitchen-vagrant/issues/8
[#12]: https://github.com/test-kitchen/kitchen-vagrant/issues/12
[#15]: https://github.com/test-kitchen/kitchen-vagrant/issues/15
[#16]: https://github.com/test-kitchen/kitchen-vagrant/issues/16
[#18]: https://github.com/test-kitchen/kitchen-vagrant/issues/18
[#19]: https://github.com/test-kitchen/kitchen-vagrant/issues/19
[#20]: https://github.com/test-kitchen/kitchen-vagrant/issues/20
[#21]: https://github.com/test-kitchen/kitchen-vagrant/issues/21
[#24]: https://github.com/test-kitchen/kitchen-vagrant/issues/24
[#25]: https://github.com/test-kitchen/kitchen-vagrant/issues/25
[#28]: https://github.com/test-kitchen/kitchen-vagrant/issues/28
[#29]: https://github.com/test-kitchen/kitchen-vagrant/issues/29
[#30]: https://github.com/test-kitchen/kitchen-vagrant/issues/30
[#31]: https://github.com/test-kitchen/kitchen-vagrant/issues/31
[#34]: https://github.com/test-kitchen/kitchen-vagrant/issues/34
[#36]: https://github.com/test-kitchen/kitchen-vagrant/issues/36
[#55]: https://github.com/test-kitchen/kitchen-vagrant/issues/55
[#56]: https://github.com/test-kitchen/kitchen-vagrant/issues/56
[#84]: https://github.com/test-kitchen/kitchen-vagrant/issues/84
[#95]: https://github.com/test-kitchen/kitchen-vagrant/issues/95
[#101]: https://github.com/test-kitchen/kitchen-vagrant/issues/101
[#102]: https://github.com/test-kitchen/kitchen-vagrant/issues/102
[#104]: https://github.com/test-kitchen/kitchen-vagrant/issues/104
[#106]: https://github.com/test-kitchen/kitchen-vagrant/issues/106
[#107]: https://github.com/test-kitchen/kitchen-vagrant/issues/107
[#112]: https://github.com/test-kitchen/kitchen-vagrant/issues/112
[#117]: https://github.com/test-kitchen/kitchen-vagrant/issues/117
[#118]: https://github.com/test-kitchen/kitchen-vagrant/issues/118
[#121]: https://github.com/test-kitchen/kitchen-vagrant/issues/121
[#122]: https://github.com/test-kitchen/kitchen-vagrant/issues/122
[#126]: https://github.com/test-kitchen/kitchen-vagrant/issues/126
[#127]: https://github.com/test-kitchen/kitchen-vagrant/issues/127
[#128]: https://github.com/test-kitchen/kitchen-vagrant/issues/128
[#129]: https://github.com/test-kitchen/kitchen-vagrant/issues/129
[#134]: https://github.com/test-kitchen/kitchen-vagrant/issues/134
[#137]: https://github.com/test-kitchen/kitchen-vagrant/issues/137
[#142]: https://github.com/test-kitchen/kitchen-vagrant/issues/142
[#146]: https://github.com/test-kitchen/kitchen-vagrant/issues/146
[#147]: https://github.com/test-kitchen/kitchen-vagrant/issues/147
[#148]: https://github.com/test-kitchen/kitchen-vagrant/issues/148
[#151]: https://github.com/test-kitchen/kitchen-vagrant/issues/151
[#152]: https://github.com/test-kitchen/kitchen-vagrant/issues/152
[#154]: https://github.com/test-kitchen/kitchen-vagrant/issues/154
[#155]: https://github.com/test-kitchen/kitchen-vagrant/issues/155
[#156]: https://github.com/test-kitchen/kitchen-vagrant/issues/156
[#157]: https://github.com/test-kitchen/kitchen-vagrant/issues/157
[#158]: https://github.com/test-kitchen/kitchen-vagrant/issues/158
[#161]: https://github.com/test-kitchen/kitchen-vagrant/issues/161
[#163]: https://github.com/test-kitchen/kitchen-vagrant/issues/163
[#166]: https://github.com/test-kitchen/kitchen-vagrant/issues/166
[#171]: https://github.com/test-kitchen/kitchen-vagrant/issues/171
[#174]: https://github.com/test-kitchen/kitchen-vagrant/issues/174
[#190]: https://github.com/test-kitchen/kitchen-vagrant/issues/190
[#191]: https://github.com/test-kitchen/kitchen-vagrant/issues/191
[#197]: https://github.com/test-kitchen/kitchen-vagrant/issues/197
[@Annih]: https://github.com/Annih
[@Igorshp]: https://github.com/Igorshp
[@RobertRehberg]: https://github.com/RobertRehberg
[@TheDude05]: https://github.com/TheDude05
[@albertsj1]: https://github.com/albertsj1
[@albsOps]: https://github.com/albsOps
[@alex-slynko-wonga]: https://github.com/alex-slynko-wonga
[@antonio-osorio]: https://github.com/antonio-osorio
[@arangamani]: https://github.com/arangamani
[@ashb]: https://github.com/ashb
[@atiniir]: https://github.com/atiniir
[@bdclark]: https://github.com/bdclark
[@bradleyd]: https://github.com/bradleyd
[@byggztryng]: https://github.com/byggztryng
[@dje]: https://github.com/dje
[@fnichol]: https://github.com/fnichol
[@fujin]: https://github.com/fujin
[@gildegoma]: https://github.com/gildegoma
[@gouketsu]: https://github.com/gouketsu
[@hugespoon]: https://github.com/hugespoon
[@jhx]: https://github.com/jhx
[@josephholsten]: https://github.com/josephholsten
[@kbruner]: https://github.com/kbruner
[@keiths-osc]: https://github.com/keiths-osc
[@ksubrama]: https://github.com/ksubrama
[@manul]: https://github.com/manul
[@martinisoft]: https://github.com/martinisoft
[@mattray]: https://github.com/mattray
[@mconigliaro]: https://github.com/mconigliaro
[@miketheman]: https://github.com/miketheman
[@petejkim]: https://github.com/petejkim
[@petere]: https://github.com/petere
[@philcallister]: https://github.com/philcallister
[@sandfish8]: https://github.com/sandfish8
[@sethvargo]: https://github.com/sethvargo
[@tknerr]: https://github.com/tknerr
[@tmatilai]: https://github.com/tmatilai
[@vinyar]: https://github.com/vinyar
[@whiteley]: https://github.com/whiteley
[@xmik]: https://github.com/xmik
[@zuazo]: https://github.com/zuazo
