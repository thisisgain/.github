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
| `GIT_ACCESS_TOKEN` | Either `GITHUB_WRITE_TOKEN` or `GITHUB_READ_TOKEN` |
| `GITHUB_TOKEN` | Either `GITHUB_WRITE_TOKEN` or `GITHUB_READ_TOKEN` |
| `GITHUB_ACCESS_TOKEN` | Either `GITHUB_WRITE_TOKEN` or `GITHUB_READ_TOKEN` |
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

...
