#!/bin/bash

cat <<EOF > /etc/nomad.d/client.hcl

ata_dir  = "/opt/nomad"

datacenter = "dc1"

# Give the agent a unique name. Defaults to hostname
name = "client"

advertise {
  rpc = "{{ GetInterfaceIP \"eth0\" }}"
  http = "{{ GetInterfaceIP \"eth0\" }}"
  serf = "{{ GetInterfaceIP \"eth0\" }}"
}

# Enable the client
client {
  enabled = true
  server_join {
    retry_join = ["192.168.10.11", "192.168.10.12", "192.168.10.13"]
    retry_max = 5
    retry_interval = "15s"
  }

  options = {
    "driver.raw_exec" = "1"
    "driver.raw_exec.enable" = "1"
  }

}
EOF

# adjust interfce if not named eth0
[ -d /etc/nomad.d/ ] && {
  IFACE=`route -n | awk '$1 ~ "192.168.*.*" {print $8}'`
  sed -i "s/eth0/${IFACE}/g" /etc/nomad.d/*.hcl
}