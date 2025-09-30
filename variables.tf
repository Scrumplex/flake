variable "universe4" {
  type    = string
  default = "46.38.242.25"
}

variable "universe6" {
  type    = string
  default = "2a03:4000:7:7a3:8238:c03b:a699:288"
}

variable "caa_records" {
  type = list(string)
  default = [
    "0 issue \"letsencrypt.org\"",
    "0 issuewild \"letsencrypt.org\"",
    "0 iodef \"mailto:contact@scrumplex.net\""
  ]
}
