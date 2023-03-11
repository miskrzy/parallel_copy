variable "resource_group" {
    type = string
}

variable "common_name" {
    type = string
    description = "prefix for name of all created resources"
    default = "parallel_copy"
}

variable "owner_tag" {
    type = string
    description = "owner tag for all created resources"
}