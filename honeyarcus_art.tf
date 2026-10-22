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

resource "hcloud_zone_rrset" "discord_honeyarcus_art" {
  zone = data.hcloud_zone.honeyarcus_art.name
  name = "_discord"
  type = "TXT"

  records = [
    {
      value = "\"dh=c0148f70f24860a8d4d90ed19aefe55ed2c4ffa4\""
    }
  ]
}
