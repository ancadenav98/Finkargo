resource "aws_route_table" "main" {
  vpc_id = var.vpc_id

  dynamic "route" {
    for_each = var.routes
    content {
      cidr_block = route.value.cidr_block
      gateway_id = route.value.gateway_id
      instance_id = route.value.instance_id
    }
  }

  tags = {
    Name = var.name
  }
}