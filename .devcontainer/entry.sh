#!/bin/bash

pid=0

#SIGTERM-handler for clean shutdowns, will de-register agent so we don't get a bunch of dead agents in GitHub
sigterm_handler()
{
  if [ $pid -ne 0 ]; then
    kill -SIGTERM "$pid"
    wait "$pid"

    $GITHUB_RUNNER_INSTALL/config.sh remove --token $TOKEN
    rm $GITHUB_RUNNER_WORKSPACE/.github_token
  fi

  exit 143;
}

trap 'kill ${!}; sigterm_handler' SIGTERM

if [[ -f "${GITHUB_RUNNER_WORKSPACE}/.github_token" ]]; then
  $GITHUB_RUNNER_INSTALL/config.sh remove --token "$(<${GITHUB_RUNNER_WORKSPACE}/.github_token)"
  rm $GITHUB_RUNNER_WORKSPACE/.github_token
fi

TOKEN=$(curl -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer ${GITHUB_PAT}" https://api.github.com/repos/parasoft-se/iceoryx/actions/runners/registration-token | jq -r '.token')

touch $GITHUB_RUNNER_WORKSPACE/.github_token
echo $TOKEN >> $GITHUB_RUNNER_WORKSPACE/.github_token

$GITHUB_RUNNER_INSTALL/config.sh --url https://github.com/parasoft-se/iceoryx --token $TOKEN --work $GITHUB_RUNNER_WORKSPACE --name $(uname -r)_$(cat $GITHUB_RUNNER_WORKSPACE/.host_user)_$(echo $RANDOM | md5sum | head -c 10) --unattended
$GITHUB_RUNNER_INSTALL/run.sh &
pid="$!"

# wait forever
while true
do
  tail -f /dev/null & wait ${!}
done