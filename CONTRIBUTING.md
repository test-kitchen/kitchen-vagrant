# Contributing to kitchen-vagrant

Thanks for your interest in improving kitchen-vagrant. Bug reports, feature requests, and pull requests are all welcome.

## Reporting issues

Report bugs and request features on the [issue tracker](https://github.com/test-kitchen/kitchen-vagrant/issues). For bugs, please include:

- the version of kitchen-vagrant, Test Kitchen, and Vagrant you are using
- your Vagrant provider and its version
- your `kitchen.yml`
- the output of the failing command, ideally with `-l debug`

Because the driver works by generating a `Vagrantfile`, the generated file in
the instance's sandbox directory is usually the most useful thing to attach.
Setting `dry_run: true` prints the Vagrant commands without running them.

## Development setup

Clone the repository and install the dependencies:

```sh
git clone https://github.com/test-kitchen/kitchen-vagrant.git
cd kitchen-vagrant
bundle install
```

## Running the tests

```sh
bundle exec rake        # unit tests + style, the default task
bundle exec rake test   # unit tests only
bundle exec rake style  # Cookstyle / RuboCop only
```

To run a single spec file:

```sh
bundle exec rspec spec/kitchen/driver/vagrant_spec.rb
```

Many style offenses can be corrected automatically:

```sh
bundle exec cookstyle -a
```

The unit suite enforces **100% line coverage** of `lib/` via SimpleCov, and an
HTML report is written to `coverage/` on every run. A change that adds code
without adding tests will fail the build on coverage alone.

The unit tests do not invoke Vagrant, so they run without VirtualBox or any
other provider installed.

## Generating the documentation

```sh
bundle exec rake docs           # generate YARD docs into doc/
bundle exec rake docs:coverage  # report undocumented objects
bundle exec rake docs:serve     # browse them at http://localhost:8808
```

Documentation is deliberately excluded from the default task and from CI, so it
can never fail a build.

## Manual testing

Changes that affect the generated `Vagrantfile` should be exercised end to end
with a real provider, since the unit tests only assert on the rendered template.
Run `kitchen test` against at least one Linux and, where relevant, one Windows
platform, and check the generated Vagrantfile in the sandbox directory.

The repository ships a `kitchen.yml` for exactly this. It uses the `shell`
provisioner and the Cinc Auditor verifier, so a run exercises the driver
without pulling in a full Chef Infra setup.

The verifier lives in the `integration` bundle group, which is excluded by
default:

```sh
bundle config set --local with integration
bundle install
```

Cinc republishes patched InSpec gems under the same name and version as
Chef's. Bundler treats a same-name, same-version gem as already satisfied, so
a previously installed Chef gem is never re-downloaded even when the lockfile
points at `rubygems.cinc.sh`. The run then fails at verify time with
`Chef InSpec cannot execute without valid licenses`.

Check the `inspec-core` gem specifically:

```sh
bundle exec ruby -e 'puts File.read(File.join(Gem.loaded_specs["inspec-core"].gem_dir, "lib/inspec/dist.rb"))[/EXEC_NAME = "(.+)"/, 1]'
```

It must print `cinc-auditor`. If it prints `inspec`, the Chef build is on
disk; remove it and reinstall:

```sh
gem uninstall inspec inspec-core -v <version> --force
bundle install
```

Do not check this with `require "inspec/dist"`. The `cinc-auditor-bin` gem
ships its own `lib/inspec/dist.rb` that shadows `inspec-core`'s on the load
path, so the required constant reports `cinc-auditor` regardless of which
build of `inspec-core` is actually installed. The gemspec metadata is no help
either — Cinc republishes it unchanged, so both builds report the Chef author
and license. Only the file contents differ.

### Isolating Vagrant from Bundler

Vagrant ships its own embedded Ruby. Running it from inside `bundle exec`
leaks `RUBYOPT` and `GEM_PATH` into that Ruby, which fails immediately with a
`gem_prelude` backtrace — and because the driver shells out to `vagrant` for
every operation, it fails on the very first call. Wrap Vagrant in a script
that clears the environment, as CI does:

```sh
mkdir -p bin
cat > bin/vagrant << 'EOF'
#!/usr/bin/env bash
env -i \
  PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
  HOME="$HOME" USER="$USER" LOGNAME="$LOGNAME" \
  /usr/local/bin/vagrant "$@"
EOF
chmod +x bin/vagrant
export PATH="$(pwd)/bin:$PATH"
```

Adjust the final path if Vagrant is not at `/usr/local/bin/vagrant`.

### Choosing a provider

CI runs VirtualBox on Linux. Locally, pick whatever provider you have and tell
the driver about it — it reads `VAGRANT_DEFAULT_PROVIDER`:

```sh
export VAGRANT_DEFAULT_PROVIDER=vmware_desktop
bundle exec kitchen verify almalinux-9
```

On an Apple Silicon Mac, VMware is the practical choice: VirtualBox's ARM
build cannot run the x86 boxes most platforms publish. See
[Using the VMware provider](README.md#using-the-vmware-provider) in the README
for the setup, which needs a privileged utility service in addition to the
`vagrant-vmware-desktop` plugin.

Note that the `windows-11` platform in `kitchen.yml` cannot run under VMware on
Apple Silicon — `stromweld/windows-11` publishes a `vmware_desktop` build for
`amd64` only. Use UTM or Parallels to exercise the Windows and WinRM paths on
that hardware.

Remember to `kitchen destroy` when you are done, so stray VMs do not accumulate.

## Submitting changes

1. Fork the repository.
2. Create a feature branch off `main`.
3. Make your change, adding or updating tests to cover it — the suite requires
   100% line coverage.
4. Make sure `bundle exec rake` passes.
5. Push the branch to your fork and open a pull request.

Please keep pull requests focused on a single change — it makes review much
faster. Update the documentation in `README.md` when you add or change a
configuration option.

## Release process

Releases are handled by the maintainers.

1. Update `lib/kitchen/driver/vagrant_version.rb` with the new version.
2. Update `CHANGELOG.md`.
3. Merge to `main`; the publish workflow builds the gem and pushes it to
   RubyGems.
