output "virtual_machines" {
  value       = module.nodes.virtual_machines
  description = "The provisioned virtual machines on harvester. (https://registry.terraform.io/providers/harvester/harvester/latest/docs/data-sources/virtualmachine)"
}