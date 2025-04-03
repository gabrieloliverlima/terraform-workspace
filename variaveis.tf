
variable "do_token" {
  type = string
}

variable "k8s_name" {
  type = string
  default = "k8s"
}

variable "k8s_region" {
  type = string
  default = "nyc1"
}

variable "k8s_version" {
  type = string
  default = "1.32.2-do.0"
}

variable "worker_pool" {
  type = string
  default = "pool-k8s"
}

variable "k8s_worker_size" {
  type = string
  default = "s-2vcpu-2gb"
}

variable "node_count" {
  type = number
  default = 1
}
