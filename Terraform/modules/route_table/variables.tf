variable "vpc_id" {
  type = string
}

variable "name" {
  type = string
}

variable "routes" {
  type = map(object({
    cidr_block = string
    gateway_id = optional(string)
    instance_id = optional(string)
  }))
}