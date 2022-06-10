#!/bin/bash
set -e

# /subscriptions/8cacf840-893d-4966-8f82-768f12f19076/resourceGroups/RG_1/providers/Microsoft.Resources/deployments/Microsoft.Template-20220609155607/operations/4548232D700A36FC

GEN_FILE="Solutions/Tanium/Package/mainTemplate.json"
ORIG_FILE="Solutions/Tanium/Package/mainTemplate.original.json"
NEW_FILE="Solutions/Tanium/Package/mainTempate.custom.json"
ZIP_FILE="Solutions/Tanium/Package/1.0.1.zip"

cat "$GEN_FILE" | jq > "$ORIG_FILE"
cat "$GEN_FILE" |
  jq '.resources += [
        {
            "type": "Microsoft.Web/connections",
            "apiVersion": "2016-06-01",
            "name": "azuresentinel",
            "location": "[resourceGroup().location]",
            "kind": "V1",
            "properties": {
                "displayName": "azuresentinel",
                "customParameterValues": {},
                "parameterValueType": "Alternative",
                "api": {
                   "id": "[concat('"'"'/subscriptions/'"'"', subscription().subscriptionId, '"'"'/providers/Microsoft.Web/locations/'"'"', resourceGroup().location, '"'"'/managedApis/azuresentinel'"'"')]"
                }
            }
        },
        {
            "type": "Microsoft.Web/connections",
            "apiVersion": "2016-06-01",
            "name": "taniumsentinel",
            "location": "[resourceGroup().location]",
            "properties": {
                "displayName": "Tanium Sentinel API Connection",
                "customParameterValues": {},
                "api": {
                    "id": "[concat('"'"'/subscriptions/'"'"', subscription().subscriptionId, '"'"'/providers/Microsoft.Web/locations/'"'"', resourceGroup().location, '"'"'/managedApis/azuresentinel'"'"')]"
                }
            }
        }
  ]' > "$NEW_FILE"

diff -u  "$ORIG_FILE" "$NEW_FILE" || true
cp "$NEW_FILE" "$GEN_FILE"
cp "$NEW_FILE" ./mainTemplate.json
cp "$ZIP_FILE" ./.tmp.zip
zip .tmp.zip mainTemplate.json
cp  .tmp.zip "$ZIP_FILE"
rm ./mainTemplate.json .tmp.zip
rm "$NEW_FILE" "$ORIG_FILE"
