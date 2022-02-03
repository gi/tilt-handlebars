# Contributing

Bug reports and pull requests are welcome on GitHub:
https://github.com/gi/tilt-handlebars.

1. Fork the repository: https://github.com/gi/tilt-handlebars.
1. Create an issue branch: `git checkout -b issue-N/summary origin/develop`)
1. Run [setup](#Setup): `bin/setup`.
1. Add tests for your updates.
1. Run [tests](#Test): `bin/test`.
1. Run linter: `bin/lint`.
1. Commit changes: `git commit -am '[#N] Summary'`.
1. Push changes: `git push origin head`.
1. Create a pull request targeting `develop`.

## Branches

This repository follows a modified version of the
[Gitflow Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow):
* The default development branch is `develop`.
* The main release branch is `main`.

## Development

### Setup

Run `bin/setup` to install dependencies.

### Console

Run `bin/console` for an interactive prompt that will allow you to experiment.

### Test

Run `bin/test` to run the tests.

### Install

Run `bin/rake install` to install this gem onto your local machine.

## Releases

Releases are created automatically by continuous deployment.

***Please avoid creating releases manually.***

To create a new release:
1. Checkout a new branch from `develop`:
    ```sh
    git fetch origin develop
    git checkout -b release-x.y.z origin/develop
    ```
1. Update the version number:
    ```sh
    bin/version x.y.z
    bin/setup
    ```
1. Update the changelog:
    - add mising entries
    - move `[Unreleased]` to `[x.y.z] - YYYY-MM-DD`
1. Commit the changes:
    ```sh
    git commit -m 'vx.y.z'
    ```
1. Push the new branch:
    ```sh
    git push -u origin head
    ```
1. Create a merge/pull request to `main`.

When the `main` branch is updated, continuous deployment will tag and push a new
release.

Afterwards:
1. Create a merge/pull request from `main` to `develop`.
