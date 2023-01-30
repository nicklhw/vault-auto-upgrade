storage "raft" {
  path = "/vault/data"
  node_id = "vault_s4"
  autopilot_upgrade_version = "1.12.2"

  retry_join {
    leader_api_addr = "http://haproxy:8200"
  }
}

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = 1
}

api_addr = "https://vault_s4:8200"
cluster_addr = "https://vault_s4:8201"

ui = "true"
