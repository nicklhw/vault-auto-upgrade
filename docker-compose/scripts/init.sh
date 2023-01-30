#!/bin/bash
set -euo pipefail

export VAULT_S1_DNS=vault_s1
export VAULT_INIT_OUTPUT=vault.json
export VAULT_SKIP_VERIFY=true

# Init vault_s1
tput setaf 12 && echo "############## Init vault_s1 ##############"; tput sgr0
docker exec vault_s1 sh -c "export VAULT_ADDR=http://localhost:8200; vault operator init -format=json -n 1 -t 1 > /vault/config/${VAULT_INIT_OUTPUT}"
mv ../vault/vault_s1/${VAULT_INIT_OUTPUT} .

export VAULT_TOKEN=$(cat ${VAULT_INIT_OUTPUT} | jq -r '.root_token')
tput setaf 12 && echo "############## Root VAULT TOKEN is: $VAULT_TOKEN ##############"; tput sgr0

# Unseal vault_s1
tput setaf 12 && echo "############## Unseal vault_s1 ##############"; tput sgr0
export UNSEAL_KEY=$(cat ${VAULT_INIT_OUTPUT} | jq -r '.unseal_keys_b64[0]')
docker exec vault_s1 sh -c "export VAULT_ADDR=http://localhost:8200; vault operator unseal ${UNSEAL_KEY}"

sleep 5

# Join vault_s2
tput setaf 12 && echo "############## Join vault_s2 ##############"; tput sgr0
docker exec vault_s2 sh -c "export VAULT_ADDR=http://localhost:8200; vault operator raft join http://${VAULT_S1_DNS}:8200"

# Unseal vault_s2
tput setaf 12 && echo "############## Unseal vault_s2 ##############"; tput sgr0
docker exec vault_s2 sh -c "export VAULT_ADDR=http://localhost:8200; vault operator unseal ${UNSEAL_KEY}"

# Join vault_s3
tput setaf 12 && echo "############## Join vault_s3 ##############"; tput sgr0
docker exec vault_s3 sh -c "export VAULT_ADDR=http://localhost:8200; vault operator raft join http://${VAULT_S1_DNS}:8200"

# Unseal VAULT_s3
tput setaf 12 && echo "############## Unseal vault_s3 ##############"; tput sgr0
docker exec vault_s3 sh -c "export VAULT_ADDR=http://localhost:8200; vault operator unseal ${UNSEAL_KEY}"

sleep 5

tput setaf 12 && echo "############## Vault Cluster members ##############"; tput sgr0
export VAULT_ADDR=http://localhost:8200
vault operator raft list-peers

export VAULT_TOKEN=$(cat ${VAULT_INIT_OUTPUT} | jq -r '.root_token')
vault token lookup

tput setaf 12 && echo "############## Configure admin policy on vault ##############"; tput sgr0

vault policy write admin ./admin_policy.hcl

tput setaf 12 && echo "############## Enable userpass auth on vault ##############"; tput sgr0

vault auth enable userpass

vault write auth/userpass/users/admin password="passw0rd" policies="admin" token_ttl=10m token_max_ttl=60m

tput setaf 12 && echo "############## Vault Auto-pilot upgrade status ##############"; tput sgr0

vault operator raft autopilot state -format=json | jq -r ".Upgrade"