// Launches a set number of Ubuntu EC2 instances
resource "aws_instance" "nodes" {
  // Loop through each of the EC2 nodes
  for_each = { for node in var.compute_nodes: node.name => node }

  ami           = data.aws_ami.ubuntu.id
  instance_type = each.value.instance_size
  subnet_id     = lookup(var.public_subnets, each.value.subnet_id)

  // Set up Cloud-Init User Data
  user_data = templatefile("${path.module}/user_data.tpl", { ssh_users = local.ssh_users })

  root_block_device {
    volume_size = each.value.root_volume_size
  }

  // EC2 and associated Resource tags
  tags        = var.tags
  volume_tags = var.tags
}
