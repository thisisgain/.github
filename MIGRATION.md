# Migrating from existing build tools

This file includes information to support migration from individual agency
build tools to the new GitHub Actions workflows.

There are a number of example workflows in `./.github/examples` that can be used
as reference, but this document aims to speed up the migration process.

## Access Digital/GitHub

This repository is based on the old Access Digital composable GitHub Actions,
which were widely used across projects within the agency.

Unfortunately it isn't a 1:1 migration of secrets and workflows. There are
certain things that will need to be implemented differently.

### Secrets

These are the "secret" variables in Github, assigned to a repository. Some have
been updated to reflect their actual use, while others have been updated to
reduce the number of similarly-named secrets.

As a general note: all references to `artefact` or `ARTEFACT` have been updated
to `artifact` or `ARTIFACT`.

| Previous name | New name |
| ------------- | -------- |
| `ACQUIA_REPO` | `REMOTE_REPO` |
| `ARTEFACT_REPO` | `REMOTE_REPO` |
| `ARTEFACT_SSH_KEY` | `REMOTE_SSH_KEY` |
| `ENVIRONMENT_ID` | `ACQUIA_ENVIRONMENT_ID` |
| `GIT_ACCESS_TOKEN` | `GITHUB_ACCESS_TOKEN` |
| `GITHUB_TOKEN` | `GITHUB_ACCESS_TOKEN` |
| `PANTHEON_REPO` | `REMOTE_REPO` |
| `PANTHEON_SSH_KEY` | `REMOTE_SSH_KEY` |
| `PROD_ENVIRONMENT_ID` | `ACQUIA_ENVIRONMENT_ID` |
| `SSH_KEY` | `REMOTE_SSH_KEY` |
| `SSH_HOSTKEYS_ACQUIA` | `KNOWN_HOSTS` |
| `TARGET_REPO` | `REMOTE_REPO` |
| `TARGET_SSH_KEY` | `REMOTE_SSH_KEY` |

### Workflow names

Most of these should be a straight swap. Remember to also update the repository
prefix:

* From: `accessdigital/.github/.github`
* To: `thisisgain/.github/.github`

| Previous name | New name |
| ------------- | -------- |
| `acquia-backup-database.yml` | `00-acquia-backup-databases.yml` |
| `blt-push-code.yml` | `03-deploy-blt.yml` |
| `blt-test.yml` | `02-test-blt.yml` |
| `composer-security.yml` | `02-test-composer-security.yml` |
| `git-deploy-branch.yml` | `03-deploy-git-update.yml` |
| `install.yml` | `00-drush-site-install.yml` |
| `node-analysis.yml` | `02-test-npm-audit.yml` |
| `npm.yml` | `01-build-npm.yml` |
| `pantheon-create-multidev.yml` | `00-pantheon-create-multidev.yml` |
| `pantheon-push-code.yml` | `03-deploy-pantheon.yml` |
| `pantheon-remove-branch.yml` | `00-pantheon-remove-branch.yml` |
| `php-analysis.yml` | `02-test-php-analysis.yml` |
| `php-phpunit.yml` | `02-test-php-phpunit.yml` |
| `phpcs.yml` | Removed in favour of `02-test-php-analysis.yml` |
| `push-code.yml` | `03-deploy-artifact.yml` |
| `push-git.yml` | `03-deploy-git-push.yml` |

### Workflow inputs

For consistency, some input variables have changed as well. These will need to
be updated.

| Previous name | New name |
| ------------- | -------- |
| `branch` | `target_branch` |
| `composer_directory` | `directory` |
| `drupal_check` | Now split into two inputs: `drupal_check` to enable, `drupal_check_directories` with directories. |
| `pantheon_site_name` | `pantheon_machine_name` |
| `remote_repo` | `push_to_remote` |
| `settings_ci` | `copy_ci_settings` |

## Eleven Miles/Bitbucket

...

## Catch Digital/Bitbucket

Coming from Bitbucket Pipelines to Github Actions, there are a few things to
check:

1. The image: pipelines will likely run on `catchdigital/toolbox` which includes
   a number of useful tools and features. If you choose to use `ubuntu-latest`
   or another Docker image, you may need to manually install tools within that
   toolbox, eg `acli`, `python2` (no longer supported but required for some old
   front-end build tasks), etc.
2. Composer scripts: some tasks are defined in the project's `composer.json`
   file. You can keep using them, but some of them have equivalents in the new
   workflow files that could replace them.
3. Users and authentication: most sites will use `support@catchdigital.com` to
   authenticate with remote hosts, or for Git commits. Each client should have
   their own account, `geeks+CLIENT.gha@thisisgain.com`, which should have its
   own SSH key and be added to associated services (eg hosting platforms).
4. Secrets: make sure to go through the pipelines file and check for any
   variables, eg `$ACQUIA_SECRET`, that should be recreated as secrets on
   Github. Some variables, eg `$BITBUCKET_BRANCH`, do not need to be created as
   secrets, so it's worth reviewing carefully. There may be additional secrets
   that will need to be created - review the workflows you're hoping to use.

### Recommended structure

Bitbucket only requires a single pipeline file, but you can have multiple files
on Github. Depending on the type of project and the deployment process, the
following is recommended:

* For ongoing review of work, `pull-request.yml`:
  - Acts on pull requests, whenever they're opened or updated.
  - Build and test the site (both back- and front-end).
  - If the "build" label is applied to a pull request, push a complete artifact
    to the hosting platform, so it can be tested.
* For deployment to a remote host, `deploy.yml`:
  - For automated deployments, act when pull requests are merged or when a tag
    is published.
  - For manual deployments, only act on workflow trigger, either against a
    branch or a tag.
  - Build and push a complete artifact to the hosting platform for deployment.

### Suggested workflows

Roughly, each "step" in a Bitbucket pipeline corresponds to a job in a workflow.

This is just a guide/suggestion for the workflows that could replace steps in a
pipelines file.

| Pipelines step | Suggested workflow |
| -------------- | ------------------ |
| `&install-composer` | `01-build-composer.yml` |
| `&install-node` | `01-build-npm.yml` |
| `&deploy-branch` | `03-deploy-XXX.yml`, where `XXX` is the deployment method |
| `&deploy-tag` | `03-deploy-XXX.yml`, where `XXX` is the deployment method |

You may want to break some steps down further, where they have multiple scripts.
For example the `&install-composer` step installs and validates the Composer
build, which is covered by `01-build-composer.yml`. It may also run a
`composer drupal:validate` script, which runs a GrumPHP code scan. This is
included in `02-test-php-analysis.yml`, along with several other scanning tools.
If you choose to use this separate workflow, you could take advantage of more
testing tools.
