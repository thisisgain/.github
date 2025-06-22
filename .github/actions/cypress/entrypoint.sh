#!/bin/sh

set -e

# Add the given entry to the hosts file so we can use "real" URLs.
if [ -n "$INPUT_HOSTS_ENTRY" ]; then
  echo "$INPUT_HOSTS_ENTRY" >> /etc/hosts
fi

cypress run --config video=false --browser chrome
