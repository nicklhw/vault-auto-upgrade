#!/bin/bash
set -euo pipefail

export VAULT_ADDR=http://localhost:8200
export VAULT_INIT_OUTPUT=vault.json
export VAULT_TOKEN=$(cat ${VAULT_INIT_OUTPUT} | jq -r '.root_token')
export UNSEAL_KEY=$(cat ${VAULT_INIT_OUTPUT} | jq -r '.unseal_keys_b64[0]')

tput setaf 12 && echo "############## Unseal vault_s4 ##############"; tput sgr0
docker exec vault_s4 sh -c "export VAULT_ADDR=http://localhost:8200; vault operator unseal ${UNSEAL_KEY}"

tput setaf 12 && echo "############## Unseal vault_s5 ##############"; tput sgr0
docker exec vault_s5 sh -c "export VAULT_ADDR=http://localhost:8200; vault operator unseal ${UNSEAL_KEY}"

tput setaf 12 && echo "############## Unseal vault_s6 ##############"; tput sgr0
docker exec vault_s6 sh -c "export VAULT_ADDR=http://localhost:8200; vault operator unseal ${UNSEAL_KEY}"

tput setaf 12 && echo "############## Vault Cluster members ##############"; tput sgr0
vault operator raft list-peers

UPGRADE_STATUS=""
while [ "$UPGRADE_STATUS" != "await-server-removal" ]
do
  # vault operator raft autopilot state -format=json | jq -r ".Upgrade"
  UPGRADE_STATUS=$(vault operator raft autopilot state -format=json | jq -r ".Upgrade.Status")
  tput setaf 12 && echo "############## Vault Auto-pilot upgrade status: ${UPGRADE_STATUS} ##############"; tput sgr0
  sleep 3
done

sleep 3

tput setaf 12 && echo "############## Vault Cluster members ##############"; tput sgr0
vault operator raft list-peers
