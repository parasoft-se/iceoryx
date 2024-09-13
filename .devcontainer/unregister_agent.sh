#!/bin/bash

if [[ -f "$GITHUB_RUNNER_WORKSPACE/.github_token" ]]; then
  $GITHUB_RUNNER_INSTALL/config.sh remove --token "$(<$GITHUB_RUNNER_WORKSPACE/.github_token)"
  rm $GITHUB_RUNNER_WORKSPACE/.github_token
fi