# Change Log

## [1.14.2](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.14.1...v1.14.2) (2023-11-27)


### Bug Fixes

* Add New lint and publish workflows ([#488](https://github.com/test-kitchen/kitchen-vagrant/issues/488)) ([744fdc9](https://github.com/test-kitchen/kitchen-vagrant/commit/744fdc93d006ad32f80994b371c198e5a2a9deb6))

## [1.14.1](https://github.com/test-kitchen/kitchen-vagrant/tree/1.14.1) (2023-02-21)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.14.0...v1.14.1)

- Fix failures auto pruning box images that are in use elsewhere [#485](https://github.com/test-kitchen/kitchen-vagrant/pull/485) ([@Stromweld](https://github.com/Stromweld))

## [1.14.0](https://github.com/test-kitchen/kitchen-vagrant/tree/1.14.0) (2023-02-09)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.13.0...v1.14.0)

- Add arm64 to bento box name [#483](https://github.com/test-kitchen/kitchen-vagrant/pull/483) ([@Stromweld](https://github.com/Stromweld))

## [1.13.0](https://github.com/test-kitchen/kitchen-vagrant/tree/1.13.0) (2022-12-13)

- Drop support for EOL Ruby 2.6 ([@tas50](https://github.com/tas50))
- Avoid failures when the system has the same boxes for multiple providers on disk [#481](https://github.com/test-kitchen/kitchen-vagrant/pull/481) ([@Stromweld](https://github.com/Stromweld))

## [1.12.1](https://github.com/test-kitchen/kitchen-vagrant/tree/1.12.1) (2022-07-11)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.12.0...v1.12.1)

- Fix for Ruby 3.0 compatibility when specifying Vagrantfile network configuration [#477](https://github.com/test-kitchen/kitchen-vagrant/pull/477) ([@PowerKiki](https://github.com/PowerKiKi))

## [1.12.0](https://github.com/test-kitchen/kitchen-vagrant/tree/1.12.0) (2022-06-09)

- Support for Ruby 3.1
- Using chefstyle linting

## [1.11.0]

- Adds `use_cached_chef_client` option to enable using the cached Chef Infra Client installers on non-Bento Vagrant boxes that have `Guest Additions` installed.

## [1.10.0](https://github.com/test-kitchen/kitchen-vagrant/tree/1.10.0) (2021-08-25)

- Only create the virtual drive if it doesn't already exist locally

## [1.9.0](https://github.com/test-kitchen/kitchen-vagrant/tree/1.9.0) (2021-07-02)

- Support Test Kitchen 3.0

## [1.8.0](https://github.com/test-kitchen/kitchen-vagrant/tree/1.8.0) (2021-02-02)

- Require Ruby 2.5 or later (2.3/2.4 are EOL) ([@tas50](https://github.com/tas50))
- Add support for our new Bento `almalinux` boxes [#444](https://github.com/test-kitchen/kitchen-vagrant/pull/444) ([@tas50](https://github.com/tas50))
- Switch all testing to GitHub Actions [#430](https://github.com/test-kitchen/kitchen-vagrant/pull/430) ([@tas50](https://github.com/tas50))
- Remove github changelog generator & countloc development dependencies [#431](https://github.com/test-kitchen/kitchen-vagrant/pull/431) ([@tas50](https://github.com/tas50))
- Remove the Guardfile [#432](https://github.com/test-kitchen/kitchen-vagrant/pull/432) ([@tas50](https://github.com/tas50))
- Add Ruby 3.0 testing [#440](https://github.com/test-kitchen/kitchen-vagrant/pull/440) ([@tas50](https://github.com/tas50))
- Remove guard dev deps / move dev deps to the gemfile [#441](https://github.com/test-kitchen/kitchen-vagrant/pull/441) ([@tas50](https://github.com/tas50))
- Add a Code of Conduct file + misc testing updates [#442](https://github.com/test-kitchen/kitchen-vagrant/pull/442) ([@tas50](https://github.com/tas50))

## [1.7.2](https://github.com/test-kitchen/kitchen-vagrant/tree/1.7.2) (2020-11-10)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.7.1...v1.7.2)

- Ignore error if box not found when updating [#428](https://github.com/test-kitchen/kitchen-vagrant/pull/428) ([@clintoncwolfe](https://github.com/clintoncwolfe))

## [1.7.1](https://github.com/test-kitchen/kitchen-vagrant/tree/1.7.1) (2020-11-03)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.7.0...v1.7.1)

- Don't fail if active boxes can't be pruned [#427](https://github.com/test-kitchen/kitchen-vagrant/pull/427) ([@tas50](https://github.com/tas50))
- Remove redundant encoding comments [#426](https://github.com/test-kitchen/kitchen-vagrant/pull/426) ([@tas50](https://github.com/tas50))
- Use match? when we don't need the match data [#424](https://github.com/test-kitchen/kitchen-vagrant/pull/424) ([@tas50](https://github.com/tas50))
- Optimize our requires to improve performance [#423](https://github.com/test-kitchen/kitchen-vagrant/pull/423) ([@tas50](https://github.com/tas50))

## [1.7.0](https://github.com/test-kitchen/kitchen-vagrant/tree/1.7.0) (2020-07-04)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.6.1...v1.7.0)

- Add new `box_auto_update` and `box_auto_prune` options to pull newer Vagrant base boxes [#421](https://github.com/test-kitchen/kitchen-vagrant/pull/421) ([@Stromweld](https://github.com/Stromweld))

## [1.6.1](https://github.com/test-kitchen/kitchen-vagrant/tree/1.6.1) (2020-01-14)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.6.0...v1.6.1)

- \[README\] fix openstack link [#409](https://github.com/test-kitchen/kitchen-vagrant/pull/409) ([@arthurlogilab](https://github.com/arthurlogilab))
- Use require_relative instead of require [#414](https://github.com/test-kitchen/kitchen-vagrant/pull/414) ([@tas50](https://github.com/tas50))

## [1.6.0](https://github.com/test-kitchen/kitchen-vagrant/tree/1.6.0) (2019-08-05)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.5.2...v1.6.0)

- Don't fail when instance names become too long for Hyper-V [#404](https://github.com/test-kitchen/kitchen-vagrant/pull/404) ([@Xorima](https://github.com/Xorima))
- Require Ruby 2.3 or later (Ruby < 2.3 are no longer supported Ruby releases)

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

## [1.3.6](https://github.com/test-kitchen/kitchen-vagrant/tree/1.3.6) (2018-10-26)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.3.5...v1.3.6)

**Merged pull requests:**

- Updating for new Chefstyle rules [\#382](https://github.com/test-kitchen/kitchen-vagrant/pull/382) ([tyler-ball](https://github.com/tyler-ball))
- Newest vagrant no long requires vagrant-winrm plugin [\#379](https://github.com/test-kitchen/kitchen-vagrant/pull/379) ([tyler-ball](https://github.com/tyler-ball))

## [v1.3.5](https://github.com/test-kitchen/kitchen-vagrant/tree/v1.3.5) (2018-10-23)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.3.4...v1.3.5)

**Closed issues:**

- vagrant winrm-config doesn't detect auto-assigned forwarding for RDP [\#224](https://github.com/test-kitchen/kitchen-vagrant/issues/224)

**Merged pull requests:**

- Slim the size of the gem by removing spec files [\#377](https://github.com/test-kitchen/kitchen-vagrant/pull/377) ([tas50](https://github.com/tas50))

## [v1.3.4](https://github.com/test-kitchen/kitchen-vagrant/tree/v1.3.4) (2018-09-15)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.3.3...v1.3.4)

**Merged pull requests:**

- Fix \#371, change require =\> load [\#373](https://github.com/test-kitchen/kitchen-vagrant/pull/373) ([cheeseplus](https://github.com/cheeseplus))
- Vagrantfile Template: Hyper-v Differencing\_disk deprecation [\#370](https://github.com/test-kitchen/kitchen-vagrant/pull/370) ([cocazoulou](https://github.com/cocazoulou))

## [v1.3.3](https://github.com/test-kitchen/kitchen-vagrant/tree/v1.3.3) (2018-08-13)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.3.2...v1.3.3)

**Closed issues:**

- Hard to identify running VM instance from Hyper-V Manager or PowerShell [\#367](https://github.com/test-kitchen/kitchen-vagrant/issues/367)
- \[Feature\] Add support for vm.name for virtualbox [\#365](https://github.com/test-kitchen/kitchen-vagrant/issues/365)

**Merged pull requests:**

- Adding a per-instance generated vmname for Hyper-V [\#368](https://github.com/test-kitchen/kitchen-vagrant/pull/368) ([stuartpreston](https://github.com/stuartpreston))
- Fix \#365 - add name for virtualbox instances [\#366](https://github.com/test-kitchen/kitchen-vagrant/pull/366) ([cheeseplus](https://github.com/cheeseplus))
- Adding the lifecycle hooks stub to fix tests [\#364](https://github.com/test-kitchen/kitchen-vagrant/pull/364) ([cheeseplus](https://github.com/cheeseplus))
- Add an example for vagrantfile\_erb [\#363](https://github.com/test-kitchen/kitchen-vagrant/pull/363) ([jkugler](https://github.com/jkugler))
- Move github changelog generator to the gemfile and skip install in testing [\#362](https://github.com/test-kitchen/kitchen-vagrant/pull/362) ([tas50](https://github.com/tas50))
- Fix disk examples [\#360](https://github.com/test-kitchen/kitchen-vagrant/pull/360) ([espoelstra](https://github.com/espoelstra))

## [v1.3.2](https://github.com/test-kitchen/kitchen-vagrant/tree/v1.3.2) (2018-04-23)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.3.1...v1.3.2)

**Merged pull requests:**

- Fixing \#349 - allow bento/hardenedbsd [\#355](https://github.com/test-kitchen/kitchen-vagrant/pull/355) ([cheeseplus](https://github.com/cheeseplus))
- Updating travis config [\#354](https://github.com/test-kitchen/kitchen-vagrant/pull/354) ([cheeseplus](https://github.com/cheeseplus))
- Hyper-V: Ensure default switch name is always wrapped in quotes [\#345](https://github.com/test-kitchen/kitchen-vagrant/pull/345) ([stuartpreston](https://github.com/stuartpreston))

## [v1.3.1](https://github.com/test-kitchen/kitchen-vagrant/tree/v1.3.1) (2018-02-20)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.3.0...v1.3.1)

**Merged pull requests:**

- Adding support for HyperV Differencing\_disk [\#342](https://github.com/test-kitchen/kitchen-vagrant/pull/342) ([cocazoulou](https://github.com/cocazoulou))

## [1.3.0](https://github.com/test-kitchen/kitchen-vagrant/tree/1.3.0) (2018-01-17)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.2.2...1.3.0)

- Improve Hyper-V defaults and support [\#338](https://github.com/test-kitchen/kitchen-vagrant/pull/338)

## [1.2.2](https://github.com/test-kitchen/kitchen-vagrant/tree/1.2.2) (2017-11-07)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.2.1...1.2.2)

- For WinRM options, only treat strings as strings. [\#330](https://github.com/test-kitchen/kitchen-vagrant/pull/330)

## [1.2.1](https://github.com/test-kitchen/kitchen-vagrant/tree/1.2.1) (2017-08-22)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.2.0...1.2.1)

- Revert parallel virtualbox [\#325](https://github.com/test-kitchen/kitchen-vagrant/pull/325)
- Shorten directory name for `vagrant_root` [\#323](https://github.com/test-kitchen/kitchen-vagrant/pull/323)

## [1.2.0](https://github.com/test-kitchen/kitchen-vagrant/tree/1.2.0) (2017-08-11)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.1.1...1.2.0)

**Implemented enhancements:**

- Support to create/attach multiple additional VirtualBox disks [\#312](https://github.com/test-kitchen/kitchen-vagrant/pull/312) ([stissot](https://github.com/stissot))
- Parallel virtualbox [\#202](https://github.com/test-kitchen/kitchen-vagrant/pull/202) ([rveznaver](https://github.com/rveznaver))

## [v1.1.1](https://github.com/test-kitchen/kitchen-vagrant/tree/v1.1.1) (2017-07-26)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.1.0...v1.1.1)

**Fixed Bugs**

- Fix detection of vagrant-winrm plugin. [\#309](https://github.com/test-kitchen/kitchen-vagrant/pull/309) ([silverl](https://github.com/silverl))
- Fix bug in Vagrantfile template related to WinRM options. [\#306](https://github.com/test-kitchen/kitchen-vagrant/pull/306) ([aleksey-hariton](https://github.com/aleksey-hariton))
- Disable caching, even for bento boxes. [\#313](https://github.com/test-kitchen/kitchen-vagrant/pull/313) ([robbkidd](https://github.com/robbkidd))

## [v1.1.0](https://github.com/test-kitchen/kitchen-vagrant/tree/v1.1.0) (2017-03-31)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.0.2...v1.1.0)

**New Features:**

- Make kitchen package work [\#275](https://github.com/test-kitchen/kitchen-vagrant/pull/275) ([ccope](https://github.com/ccope))

**Improvements:**

- Only enable the cache when using known bento boxes. Fix \#296 [\#303](https://github.com/test-kitchen/kitchen-vagrant/pull/303) ([cheeseplus](https://github.com/cheeseplus))
- README: add info about cache\_directory disabling [\#299](https://github.com/test-kitchen/kitchen-vagrant/pull/299) ([jugatsu](https://github.com/jugatsu))
- Add ability to override Kitchen cache directory [\#292](https://github.com/test-kitchen/kitchen-vagrant/pull/292) ([Jakauppila](https://github.com/Jakauppila))
- Add support for all misc vagrant providers [\#290](https://github.com/test-kitchen/kitchen-vagrant/pull/290) ([myoung34](https://github.com/myoung34))

## [v1.0.2](https://github.com/test-kitchen/kitchen-vagrant/tree/v1.0.2) (2017-02-13)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.0.1...v1.0.2)

**Fixed bugs:**

- Fixed a bug that can occur when `instance` returns `nil` [\#285](https://github.com/test-kitchen/kitchen-vagrant/pull/285) ([Kuniwak](https://github.com/Kuniwak))

## [v1.0.1](https://github.com/test-kitchen/kitchen-vagrant/tree/v1.0.1) (2017-02-10)

[Full Changelog](https://github.com/test-kitchen/kitchen-vagrant/compare/v1.0.0...v1.0.1)

**Fixed bugs:**

- Fixed cache folder disable for FreeBSD and MacOS/OSX [\#281](https://github.com/test-kitchen/kitchen-vagrant/pull/281) ([brentm5](https://github.com/brentm5)) [\#283](https://github.com/test-kitchen/kitchen-vagrant/pull/283) ([cheeseplus](https://github.com/cheeseplus))

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


## 0.19.0 / 2015-09-18

### Bug fixes

* Pull request [#163][]: Properly quote `config[:ssh]` values. ([@zuazo][])
* Pull request [#191][], pull request [#197][], issue [#190][]: Escape Bundler environment when shelling out to `vagrant` command. ([@ksubrama][], [@tknerr][])

### New features

* Pull request 172, issue [#171][]: Add support for OpenStack provider. ([@xmik][])

### Improvements

* Pull request [#174][]: Correct grammar error in README. ([@albsOps][])
* Support running unit test suite on Windows ([@ksubrama][])


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


## 0.17.0.rc.1 / 2015-03-29

### Improvements

* Pull request [#157][]: Close Transport connection in #destroy. ([@fnichol][])
* Pull request [#158][]: Add plugin metadata to the Driver. ([@fnichol][])


## 0.17.0.beta.4 / 2015-03-26

### Bug fixes

* Pull request [#156][]: Use RDPPort value from `vagrant winrm-config` for WinRM Transports. ([@fnichol][])

### Improvements

* Pull request [#152][]: Translate CPU count for VMWare provider. ([@whiteley][])


## 0.17.0.beta.3 / 2015-03-25

### Bug fixes

* Pull request [#155][]: Use the vagrant-winrm Vagrant plugin to resolve VM IP address. See PR for details. ([@fnichol][])


## 0.17.0.beta.2 / 2015-03-25

* Relax version constraint on Test Kitchen. ([@fnichol][])


## 0.17.0.beta.1 / 2015-03-24

* Pull request [#154][]: Support for WinRM Transport and Windows-based instances. ([@fnichol][])


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


## 0.15.0 / 2014-04-28

### New features

* Support vagrant-softlayer plugin

### Improvements

* Improved/updated README documentation + typos
* Remove default memory setting
* Fix relative paths in synced folders

## 0.14.0 / 2013-12-09

### New features

* Add `config[:vm_hostname]` to set config.vm.hostname in Vagrantfile. ([@fnichol][])

### Improvements

* Add `config[:guest]` documentation in README. ([@fnichol][])


## 0.13.0 / 2013-12-04

### New features

* Use Opscode's new buckets for Virtual machines, allowing for downloads of VirtualBox and VMware Fusion/Workstation Bento boxes (Vagrant minimal base boxes). ([@sethvargo][])


## 0.12.0 / 2013-11-29

### Breaking changes

* Remove `use_vagrant_provision` configuration option.

### New features

* Major refactor of Vagrantfile generation, to use an ERB template. For more details please consult the `vagrantfile_erb` section of the README. ([@fnichol][])
* Add `pre_create_command` option to run optional setup such as Bindler. ([@fnichol][])

### Improvements

* Pull request [#56][]: Enabled passing options to the synced folders. ([@antonio-osorio][])
* Pull request [#55][]: Fix README badges. ([@arangamani][])


## 0.11.3 / 2013-11-09

### Bug fixes

* Revert `quiet` option used for Vagrant version checking. ([@fnichol][])


## 0.11.2 / 2013-11-05

### Bug fixes

* Remove misleading `quiet` option ([@sethvargo][])
* Relax dependency on Test Kitchen ([@sethvargo][])
* Remove deprecated references to `vagrant-berkshelf` ([@sethvargo][])

### Improvements

* Allow users to specify custom SSH private key ([@manul][])
* Use platform to determine which vagrant box to download (assume Opscode) ([@sethvargo][])


## 0.11.1 / 2013-08-29

### Bug fixes

* Pull request [#36][]: README fix for synched_folders. ([@mattray][])

### Improvements

* Pull request [#34][]: Disable synced folders by default. ([@dje][])


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


## 0.10.0 / 2013-05-08

### New features

* Pull request [#12][]: Use SSHBase functionality (using ChefDataUploader) to manage Chef provisioning in the converge action and make Vagrant's built in provisioning an optional mode by setting `use_vagrant_provision: true` in the `driver_config` section of the .kitchen.yml. As a consequence, the vagrant-berkshelf middleware is now also optional and off by default (can be re-enabled by setting `use_vagrant_berkshelf_plugin: true`). ([@fujin][])
* Pull request [#18][]: Add VMware Fusion/Workstation support. ([@TheDude05][])

### Improvements

* Issue [#19][]: Recommend the vagrant-wrapper gem in README. ([@fnichol][])


## 0.9.0 / 2013-04-19

### Upstream changes

* Pull request [#16][]: Update Vagrant Berkshelf plugin detection for the vagrant-berkshelf and drop detection for berkshelf-vagrant. ([@martinisoft][])


## 0.8.0 / 2013-04-16

### Improvements

* Pull request [#15][]: Support berkshelf-vagrant 1.1.0+ in Vagrantfiles. ([@petejkim][], [@fnichol][])
* Add an explanation of how this driver works in the README. ([@fnichol][])


## 0.7.4 / 2013-03-28

### Improvements

* Drop `vagrant ssh -c` & communicate directly via SSH. ([@fnichol][])


## 0.7.3 / 2013-03-28

### Bug fixes

* Calling #destroy should not memoize #create_vagrantfile. ([@fnichol][], [@sandfish8][])


## 0.7.2 / 2013-03-23

### Bug fixes

* Wrap strings for data_bags_path and roles_path in Vagrantfiles. ([@fnichol][])


## 0.7.1 / 2013-03-23

### Bug fixes

* Depend on test-kitchen ~> 1.0.0.alpha.1 to get API updates. ([@fnichol][])


## 0.7.0 / 2013-03-22

### New features

* Pull request [#7][]: [Breaking] Support Vagrant 1.1+ and remove vagrant gem dependency. ([@fnichol][])
* Pull request [#8][]: Add dependency checks for Vagrant and berkshelf-vagrant plugin (if necessary). ([@fnichol][])


## 0.6.0 / 2013-03-02

The initial release.

<!--- The following link definition list is generated by PimpMyChangelog --->
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
