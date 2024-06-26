node_name = "counting"

service {
  name = "counting"
  id   = "counting-1"
  port = 9003
 
  connect {
    sidecar_service {}
  }

  check {
    id          = "counting-check"
    http        = "http://localhost:9003/health"
    method      = "GET"
    interval    = "1s"
    timeout     = "1s"
  }
}
