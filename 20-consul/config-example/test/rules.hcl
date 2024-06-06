node  "web-server-01" {
  policy  = "write"
}

key_prefix  "apps/eCommerce" {
  policy  = "write"
}

session_prefix  "" {
  policy  = "write"
}

service "eCommerce-Front-End" {
  policy = "write"
}
