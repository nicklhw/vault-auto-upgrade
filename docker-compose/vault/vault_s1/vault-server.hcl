storage "raft" {
  path = "/vault/data"
  node_id = "vault_s1"
}

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = 1
}

api_addr = "https://vault_s1:8200"
cluster_addr = "https://vault_s1:8201"

ui = "true"
