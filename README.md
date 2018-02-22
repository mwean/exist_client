# ExistClient #

A tool for reporting metrics to [Exist.io](https://exist.io/?referred_by=matthewweanmwean). It currently supports time tracking and completed tasks and supports plugins to work with different apps.

## Installation ##

Install the gem:

    $ gem install exist_client

Run the setup command:

    $ exist_client setup

This will create a new directory called `.exist` in your home folder. Inside is a config file `config.yml` where you can configure ExistClient.

## Configuration ##

In the `config.yml` file, you can specify which plugins to use as well as the cutoff hour to switch to a new day (it defaults to 5am).

```yaml
plugins:
  tasks: omni_focus
  time_tracking: qbserve
cutoff_hour: 3
```

## Plugins ##

### Tasks ###
- [OmniFocus](https://github.com/mwean/exist_client-omni_focus)

### Time Tracking ###
- [Qbserve](https://github.com/mwean/exist_client-qbserve)

## Usage ##

In order to use the client, you will need an Exist API key. You can generate one [here](https://exist.io/account/apps/), then make it available as the environment variable `EXIST_API_KEY`.

Once you have your API key, you can send metrics manually with `exist_client report`.

If you're on a Mac and you want to run the report automatically, you can create a launchd agent. You can see an example that runs every day at 1pm [here](launchd_example.plist). The agent runs a helper command that looks like this:

```bash
#!/bin/bash

source ~/.secrets # Load your Exist API key
sleep 5 # Wait for network

# You may need to use something like ~/.rbenv/shims/exist_client if you use a ruby version manager
~/.rbenv/shims/exist_client report
```

## Contributing ##

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/exist_client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License ##

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
