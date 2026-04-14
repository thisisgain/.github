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

| Previous name | New name |
| ------------- | -------- |
| `ACQUIA_REPO` | `REMOTE_REPO` |
| `TARGET_REPO` | `REMOTE_REPO` |
| `TARGET_SSH_KEY` | `REMOTE_SSH_KEY` |
| `SSH_KEY` | `REMOTE_SSH_KEY` |
| `SSH_HOSTKEYS_ACQUIA` | `KNOWN_HOSTS` |
| `GITHUB_TOKEN` | Either `GITHUB_WRITE_TOKEN` or `GITHUB_READ_TOKEN` |
| `GITHUB_ACCESS_TOKEN` | Either `GITHUB_WRITE_TOKEN` or `GITHUB_READ_TOKEN` |
| `ENVIRONMENT_ID` | `ACQUIA_ENVIRONMENT_ID` |
| `PROD_ENVIRONMENT_ID` | `ACQUIA_ENVIRONMENT_ID` |

### Workflow inputs

| Previous name | New name |
| ------------- | -------- |
| `pantheon_site_name` | `pantheon_machine_name` |
| `composer_directory` | `directory` |
| `settings_ci` | `copy_ci_settings` |
| `remote_repo` | `push_to_remote` |
| `branch` | `target_branch` |

### Workflow names

| Previous name | New name |
| ------------- | -------- |
| woo hoo       | woo hoo  |

### Workflow configuration

| Previous setting | New setting |
| ---------------- | ----------- |
| woo hoo       | woo hoo  |

## Eleven Miles/Bitbucket

...

## Catch Digital/Bitbucket
