# Vault Auto Upgrade Demo

# Run
```shell
export VAULT_LICENSE=$(cat ~/Downloads/vault.hclic)

# Stand up 3 nodes cluster (v1.11) with HA proxy load balancer
make all

# Add 3 new nodes (v1.12) and see auto upgrade in action
make auto-upgrade

############## Vault Cluster members ##############
Node        Address          State       Voter
----        -------          -----       -----
vault_s1    vault_s1:8201    leader      true
vault_s2    vault_s2:8201    follower    true
vault_s3    vault_s3:8201    follower    true
vault_s4    vault_s4:8201    follower    false
vault_s5    vault_s5:8201    follower    false
vault_s6    vault_s6:8201    follower    false
############## Vault Auto-pilot upgrade status: await-new-voters ##############
############## Vault Auto-pilot upgrade status: await-new-voters ##############
############## Vault Auto-pilot upgrade status: await-new-voters ##############
############## Vault Auto-pilot upgrade status: await-new-voters ##############
############## Vault Auto-pilot upgrade status: promoting ##############
############## Vault Auto-pilot upgrade status: promoting ##############
############## Vault Auto-pilot upgrade status: promoting ##############
############## Vault Auto-pilot upgrade status: demoting ##############
############## Vault Auto-pilot upgrade status: demoting ##############
############## Vault Auto-pilot upgrade status: demoting ##############
############## Vault Auto-pilot upgrade status: leader-transfer ##############
############## Vault Auto-pilot upgrade status: leader-transfer ##############
############## Vault Auto-pilot upgrade status: leader-transfer ##############
############## Vault Auto-pilot upgrade status: await-server-removal ##############
############## Vault Cluster members ##############
Node        Address          State       Voter
----        -------          -----       -----
vault_s1    vault_s1:8201    follower    false
vault_s2    vault_s2:8201    follower    false
vault_s3    vault_s3:8201    follower    false
vault_s4    vault_s4:8201    leader      true
vault_s5    vault_s5:8201    follower    true
vault_s6    vault_s6:8201    follower    true
```

# References
- [Automate Upgrades with Vault Enterprise](https://developer.hashicorp.com/vault/tutorials/raft/raft-upgrade-automation#raft-upgrade-automation)