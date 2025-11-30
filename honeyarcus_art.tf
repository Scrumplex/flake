data "hcloud_zone" "honeyarcus_art" {
  name = "honeyarcus.art"
}

resource "hcloud_zone_rrset" "root4_honeyarcus_art" {
  zone = data.hcloud_zone.honeyarcus_art.name
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

resource "hcloud_zone_rrset" "root6_honeyarcus_art" {
  zone = data.hcloud_zone.honeyarcus_art.name
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

resource "hcloud_zone_rrset" "rootcaa_honeyarcus_art" {
  zone = data.hcloud_zone.honeyarcus_art.name
  name = "@"
  type = "CAA"

  records = [for v in var.caa_records : { value = v }]
}
