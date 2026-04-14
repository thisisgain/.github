# GAIN Composable GitHub Actions

This repository contains a number of composable GitHub Actions that can be
combined to create workflows for the automated build, test and deployment of
work from GitHub to a number of remote hosting platforms, including but not
limited to:

* Acquia
* Pantheon
* Platform.sh

It also includes several boilerplate/example workflows that can be used as a
starting point for building your own GitHub Actions workflows.

## Table of contents

- [GAIN Composable GitHub Actions](#gain-composable-github-actions)
  - [Table of contents](#table-of-contents)
  - [Quickstart](#quickstart)
  - [How to use](#how-to-use)
    - [Where to add workflows](#where-to-add-workflows)
    - [Basic workflow file structure](#basic-workflow-file-structure)
    - [Adding jobs to a workflow](#adding-jobs-to-a-workflow)
    - [Choosing which jobs to add](#choosing-which-jobs-to-add)
    - [Running a workflow](#running-a-workflow)
  - [Secrets in jobs](#secrets-in-jobs)
  - [Customising jobs](#customising-jobs)
  - [Further reading](#further-reading)

## Quickstart

Quickstart example workflows have been provided in the `examples` directory. To
get started using one of them:

1. Copy one of the examples into your repository, so it sits at
   `.github/workflows/NAME.yml`.
2. Check the list of required secrets, and add them to Github. (You will need
   admin access on the repo.)
3. Commit the code and push it up to your repository.

Depending on the workflow and the triggers, and assuming you have entered all of
the secrets correctly, you should start seeing the workflow trigger
automatically!

## How to use

### Where to add workflows

To create a GitHub Action workflow in your own repository, you must create a
GitHub folder in your repo root.

```
.
|- .github
  |- workflows
    |- workflow.yml
```

You can have any number of workflows within the `.github/workflows` directory;
they will run depending on the conditions defined in the workflow.

### Basic workflow file structure

All workflow files start with the same basic structure:

```yml
name: Workflow name
run-name: Workflow action for ${{ github.ref_name }}

The action(s) that will start the workflow.
on:
  push:
    branches:
      - main

Set a default shell.
defaults:
  run:
    shell: bash

Wait for previous jobs to finish.
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}

Here is where you will add the composable jobs.
jobs:
  shortname:
    name: 'My job'
    ...
```

### Adding jobs to a workflow

Under `jobs` you can add any number of the composable jobs. There is no
limit but be aware that the more you add, the longer the workflow will take to
run!

The most simple jobs can just be added directly with no configuration:

```yml
jobs:
  composer-build:
    name: 'Composer build'
    uses: thisisgain/.github/.github/workflows/01-build-composer.yml@main
    with:
      container: registry.gitlab.com/freelygive/docker/drupal-php-node:p8.2-cli-n14
```

You can mark any action as needing an earlier action in order to run. In this
case it won't try to run unless the named action succeeds:

```yml
phpunit:
  name: 'PHPUnit'
  needs: [composer-build]
  uses: thisisgain/.github/.github/workflows/02-test-php-phpunit.yml@main
  with:
    container: registry.gitlab.com/freelygive/docker/drupal-php-node:p8.2-cli-n14
```

You can combine any of these preset workflows with custom workflows within the
same file.

### Choosing which jobs to add

The workflow files have been named according to where in a build/deploy process
they occur:

* `00`: Helper workflows.
* `01`: Build tasks.
* `02`: Test tasks.
* `03`: Deploy tasks.
* `04`: Ongoing scan tasks. _(There are none of these currently.)_

Therefore to build an artifact, run tests, and deploy to an environment, you
would need:

* One or more "build" tasks (eg `01-build-composer`)
* One or more "test" tasks (eg `02-test-php-analysis`)
* One or more "deploy" tasks (eg `03-deploy-acquia`)

Helper tasks may run independently of CI, eg on a regular (cron) cycle or only
when triggered manually, but they can be used within workflows as well.

The workflows are independent, and you can add multiple workflows of each type,
eg if you need to deploy to multiple places you can add multiple deploy jobs.

Equally, if you want to deploy different parts of a repository to different
locations (eg a Node app to one place and a WordPress backend to another), you
can do that by combining the workflows and restricting which part of the
codebase they run against.

You may need to add extra secrets to your repository, and/or roll a custom
version of a workflow if you have specific requirements. Don't forget you can
always contribute to the repository if there is a change you think would be
useful across multiple projects.

### Running a workflow

Depending on the way you set up the workflow within your own repository, the
workflows will run as defined, and are made up of one or many events and any
activity types/filters. A single workflow can be triggered by multiple events:

```yml
on:
  workflow_dispatch:
  pull_request:
    types:
      - opened
  push:
    branches:
      - main
```

A workflow can be configured to run on when a specific activity on GitHub takes
place - this is known as the "event". The most commonly used events include:

| Name                | Trigger |
| ------------------- | ------- |
| `pull_request`      | When activity on a pull request occurs. |
| `push`              | When a commit or tag is pushed. |
| `release`           | When release activity in the repository occurs. |
| `workflow_dispatch` | Manual trigger. |

It is then possible to restrict when an event is triggered. GitHub refers to
these in two ways: activity types and filters. Ostensibly these behave the same
way, but have different names/labels.

Activity types do not accept any additional options, while filters do:

| Event               | Activity types | Filters |
| ------------------- | -------------- | ------- |
| `pull_request`      | `opened`, `closed`, `labeled`, `reopened` | _None_ |
| `push`              | _None_ | `branches`, `tags` |
| `release`           | `published`, `created`, `prereleased` | _None_ |

All of the above can be combined into a single workflow trigger, with multiple
types and filters applied for each. Wildcards can be used in the filters:

```yml
on:
  pull_request:
    types:
      - opened
      - labeled
      - reopened
  push:
    branches:
      - main
      - 'release/**'
    tags:
      - '*'
```

The `workflow_dispatch` event is a special case that allows you to manually
trigger a workflow from the Actions page in the repository. Be careful with
this: if any jobs within the workflow use references that only exist on a
pull request, the workflow will fail to run.

## Secrets in jobs

Some workflows require secrets to be added to your GitHub repository. You need
to be a repo admin to be able to set up these keys.

Go to Settings > Secrets and variables > Actions to set the variables. They
should be added as Repository secrets. The workflow includes the variable name
but the value will differ.

| Name                     | Description |
| ------------------------ | ----------- |
| **General**                            |
| `SSH_CONFIG`             | Any additional SSH configuration; can be empty. |
| `KNOWN_HOSTS`            | Any additional known hosts; can be empty but should be set using the `ssh-keygen` command. |
| `CI_LOCAL_SETTINGS`     | A local settings file to include when creating a CLI build. |
| **Remote repository**                  |
| `REMOTE_REPO`            | The URL of the remote/target repository, where the work should be deployed to. |
| `REMOTE_SSH_KEY`         | A private SSH key authorised to push to the remote repository. |
| `GITHUB_READ_TOKEN`      | A GitHub access token authorised to read a remote repository. Used to perform unshallow fetches for deployments. |
| `GITHUB_WRITE_TOKEN`     | A GitHub access token authorised to write to a remote repository. Used if you are deploying to a remote GitHub repository. |
| **Hosting specific: Acquia**           |
| `ACQUIA_ENVIRONMENT_ID`  | The Acquia environment ID. |
| `ACLI_CLIENT_ID`         | A client ID for authenticating with Acquia CLI. |
| `ACLI_CLIENT_SECRET`     | A client secret for authenticating with Acquia CLI. |
| **Hosting specific: Pantheon**         |
| `PANTHEON_MACHINE_NAME`  | The machine name for the Pantheon project. |
| `PANTHEON_MACHINE_TOKEN` | A machine token authorised to interact with the Pantheon project via Terminus. |

## Customising jobs

Most of the jobs are configurable, so if there's something you do/don't want
it to run, you can modify the values as it's being run:

```yml
php-analysis:
  name: 'PHP Analysis'
  needs: [composer-build]
  uses: thisisgain/.github/.github/workflows/02-test-php-analysis.yml@main
  with:
    container: registry.gitlab.com/freelygive/docker/drupal-php-node:p8.2-cli-n14
    phpstan: true
```

If a job is configurable, it will include a section at the top of the file with
a number of inputs:

```yml
on:
  workflow_call:
    inputs:
      option1:
        description: 'Description of required option'
        type: string
        required: true
      option2:
        description: 'Description of option with default value'
        type: string
        required: false
        default: '8.2'
```

When adding the job to your workflow, you then define the values for those
options:

```yml
jobs:
  my-job:
    name: 'My job'
    uses: thisisgain/.github/.github/workflows/00-example-workflow.yml@main
    with:
      option1: 'my_string'
```

* If an input is required, it must be set or the job will fail to run.
* If an optional input is skipped, it's assumed to be null/empty.
* If an optional input has a default value, this will be used, if no input is
  provided when setting up the job.

You can view the files in the [workflows directory](./github/workflows) to see
what options there are for each workflow. This is a short list of some examples:

| Workflow | Setting | Default | Other values |
| -------- | ------- | ------- | ------------ |
| `00-acquia-backup-databases` | `php_version` | `8.2` | Any valid PHP version. |
| `00-pantheon-remove-branch` | `strip_prefix` | _None_ | A prefix to strip when generating a safe branch name. |
| `01-build-npm` | `run_build` | `true` | Run `npm run build` command when this job runs. |
| `02-test-php-analysis` | `phpcs` | `true` | Run PHP Coding Standards checks. |
| `03-deploy-git-artifact` | `target_ref` | _None_ | An optional target reference to push code to. |

## Further reading

* [GitHub Actions documentation][1]
* [Events that trigger workflows][2]
* [Using secrets in GitHub actions][3]
* [Acquia CLI tool documentation][4]
* [Pantheon Terminus CLI tool documentation][5]

---

[1]: https://docs.github.com/en/actions
[2]: https://docs.github.com/en/actions/reference/events-that-trigger-workflows
[3]: https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions
[4]: https://docs.acquia.com/acquia-cloud-platform/add-ons/acquia-cli/overview
[5]: https://docs.pantheon.io/terminus
