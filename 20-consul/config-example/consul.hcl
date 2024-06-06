datacenter = "ua-test"
data_dir = "/opt/consul"
log_level = "INFO"
node_name = "consul-a"
server = true
bootstrap_expect = 3

ui_config {
  enabled = true
}
client_addr    = "0.0.0.0"
bind_addr      = "12.0.0.40"
advertise_addr = "12.0.0.40"

connect {
  enabled = true
}

enable_syslog = true
encrypt = "coJY5MUXRKfM5OaSvwhj9TLxN3uF5TplaUQ7UdNyf/g="
encrypt_verify_incoming = false
encrypt_verify_outgoing = true

acl {
  enabled        = true
  default_policy = "allow"
  down_policy    = "extend-cache"
}
retry_join = ["12.0.0.40", "12.0.0.50", "12.0.0.25"]

performance = {
    raft_multiplier = 1
}
