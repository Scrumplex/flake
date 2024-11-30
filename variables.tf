variable "universe4" {
  type    = string
  default = "152.53.129.141"
}

variable "universe6" {
  type    = string
  default = "2a0a:4cc0:c0:335:8238:c03b:a699:288"
}

variable "caa_records" {
  type = list(string)
  default = [
    "0 issue \"letsencrypt.org\"",
    "0 issuewild \"letsencrypt.org\"",
    "0 iodef \"mailto:contact@scrumplex.net\""
  ]
}
