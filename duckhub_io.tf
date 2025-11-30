data "hcloud_zone" "duckhub_io" {
  name = "duckhub.io"
}

resource "hcloud_zone_rrset" "root4_duckhub_io" {
  zone = data.hcloud_zone.duckhub_io.name
  name = "@"
  type = "A"

  records = [
    {
      value   = var.universe4
      comment = "universe"
    }
  ]

  ttl = 3600
}

resource "hcloud_zone_rrset" "root6_duckhub_io" {
  zone = data.hcloud_zone.duckhub_io.name
  name = "@"
  type = "AAAA"

  records = [
    {
      value   = var.universe6
      comment = "universe"
    }
  ]

  ttl = 3600
}

resource "hcloud_zone_rrset" "rootcaa_duckhub_io" {
  zone = data.hcloud_zone.duckhub_io.name
  name = "@"
  type = "CAA"

  records = [for v in var.caa_records : { value = v }]
}

resource "hcloud_zone_rrset" "cnames_duckhub_io" {
  for_each = toset(["quack"])
  zone     = data.hcloud_zone.duckhub_io.name
  name     = each.key
  type     = "CNAME"

  records = [
    {
      value = "${data.hcloud_zone.duckhub_io.name}."
    }
  ]
}
