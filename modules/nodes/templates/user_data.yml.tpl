#cloud-config
user: ${var.ssh_user}
package_update: true
package_upgrade: true
packages:
  - qemu-guest-agent
ssh_authorized_keys:
  - >-
    ${join("\n    ", ssh_keys[*].public_key)}
write_files:
  - path: /etc/rancher/rke2/config.yaml
    content: |
      secrets-encryption: "true"
      protect-kernel-defaults: "true"
  - path: /etc/sysctl.d/90-kubelet.conf
    content: |
      vm.panic_on_oom=0
      vm.overcommit_memory=1
      kernel.panic=10
      kernel.panic_on_oops=1
      kernel.keys.root_maxbytes=25000000
  - path: /etc/sysctl.d/90-rke2.conf
    content: |
      net.ipv4.conf.all.forwarding=1
      net.ipv6.conf.all.forwarding=1
runcmd:
  - sudo systemctl enable --now qemu-guest-agent
  - sudo sysctl -p /etc/sysctl.d/90-kubelet.conf
  - sudo sysctl -p /etc/sysctl.d/90-rke2.conf
  - sudo systemctl disable --now firewalld
  - ${registration_cmd}