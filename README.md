# Agdraft
[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)


## Getting Started

After you have cloned this repo, make sure you have been added as a collaborator to the heroku agdraft project, you have the heroku toolbelt installed and then log into heroku via command line:

    % heroku login

Install Postgres.app here: http://postgresapp.com/

Make sure you have rbenv installed and are using ruby 2.3.0. We are using rails 4.2.6

Then run this setup script to set up your machine with the necessary dependencies to run and test this app:

    % ./bin/setup

It assumes you have a machine equipped with Ruby, Postgres, etc. If not, set up
your machine with [this script].

[this script]: https://github.com/thoughtbot/laptop

Alternatively for a more simple setup, just make sure you are running a postgres server on your machine and you have heroku toolbelt installed.

After setting up, you can run the application using [Heroku Local]:

    % heroku local

[Heroku Local]: https://devcenter.heroku.com/articles/heroku-local

## Guidelines

Use the following guides for getting things done well, and
programming in style.

* [Protocol](http://github.com/thoughtbot/guides/blob/master/protocol)
* [Best Practices](http://github.com/thoughtbot/guides/blob/master/best-practices)
* [Style I](https://github.com/bbatsov/rubocop)
Rubocop configuation at [.rubocop.yml](.rubocop.yml)

We follow the following naming convention for branches:
`[group]/[name]`

Where `group` will be one of these four groupings:
```
wip       Works in progress; stuff I know won't be finished soon
feat      Feature I'm adding or expanding
bug       Bug fix or experiment
junk      Throwaway branch created to experiment
```
and `name` will be a `brief-description` separated by dashes (-).

## Deploying

If you have previously run the `./bin/setup` script,
you can deploy to staging and production with:

    $ ./bin/deploy staging
    $ ./bin/deploy production
