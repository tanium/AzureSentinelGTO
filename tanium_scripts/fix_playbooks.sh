#!/bin/bash

for var in `find ./Solutions/Tanium/Playbooks -type f -name azuredeploy.json`
do
  NAME=`echo "$var" | sed 's|./Solutions/Tanium/Playbooks/Tanium-||' | cut -d/ -f1`
  NAME=`echo "${NAME}Tanium"`
  # cat $var | jq >/tmp/tmp.orig
  cat $var |
    jq '.parameters = {}' |
    jq '.parameters .PlaybookName = { "defaultValue": "'"$NAME"'", "type": "string" }' |
    jq '.parameters .ForwarderAPIToken = { "defaultValue": "__Change_Me__", "type": "string" }' |
    jq 'del(.resources[0] .tags)' |
    jq 'del(.variables .AzureSentinelConnectionName)' |
    jq 'del(.variables .ConnectionName)' |
    jq '.parameters .ConnectionName = { "defaultValue": "azuresentinel", "type": "string" }' |
    jq $'.resources[0] .properties .definition .actions? .HTTP .inputs .headers .Authorization = "[parameters(\'ForwarderAPIToken\')]"' |
    jq $'.resources[0] .name = "[parameters(\'PlaybookName\')]"' |
    jq '.resources[0] .location = "[resourceGroup().location]"' >/tmp/tmp.new
  cp /tmp/tmp.new $var
done
