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
