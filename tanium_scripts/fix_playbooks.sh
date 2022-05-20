#!/bin/bash

for var in `find ./Solutions/Tanium/Playbooks -type f -name azuredeploy.json`
do
  cat $var | jq >/tmp/tmp.orig
  cat $var |
    jq '.resources[0] .properties .definition .actions .HTTP .inputs .headers .Authorization = "__CHANGE_ME__"' |
    jq 'del(.resources[0] .tags)' |
    jq $'.variables .AzureSentinelConnectionName = "[concat(\'azuresentinel-\', parameters(\'PlaybookName\'))]"' |
    jq $'.resources[0] .name = "[variables(\'AzureSentinelConnectionName\')]"' |
    jq '.resources[0] .location = "[resourceGroup().location]"' >/tmp/tmp.new
  # diff -uw /tmp/tmp.orig /tmp/tmp.new
  cp /tmp/tmp.new $var
done
