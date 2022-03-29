variable "access_key" {
  default = "Zp7tql8vMEnf01C0MySS"
}

variable "secret_key" {
  default = "SVFibQ24bEk7No5zhdhmiLUArGLNGFUQeVhlkaf8"
}

variable "region" {
  default = "KR"
}

variable "lb_info" {
  default = {
    target-1 = {
      protocol = "HTTP"
      port = 80
    }
  }
}
