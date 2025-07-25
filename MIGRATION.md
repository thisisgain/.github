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
| woo hoo | woo hoo |

### Workflow names

| Previous name | New name |
| ------------- | -------- |
| woo hoo       | woo hoo  |

### Workflow configuration

| Previous setting | New setting |
| ---------------- | ----------- |
| woo hoo       | woo hoo  |
