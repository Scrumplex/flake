data "hcloud_zone" "scrumplex_rocks" {
  name = "scrumplex.rocks"
}

resource "hcloud_zone_rrset" "root4_scrumplex_rocks" {
  zone = data.hcloud_zone.scrumplex_rocks.name
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

resource "hcloud_zone_rrset" "root6_scrumplex_rocks" {
  zone = data.hcloud_zone.scrumplex_rocks.name
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

resource "hcloud_zone_rrset" "rootcaa_scrumplex_rocks" {
  zone = data.hcloud_zone.scrumplex_rocks.name
  name = "@"
  type = "CAA"

  records = [for v in var.caa_records : { value = v }]
}

resource "hcloud_zone_rrset" "cnames_scrumplex_rocks" {
  for_each = toset(["x"])
  zone     = data.hcloud_zone.scrumplex_rocks.name
  name     = each.key
  type     = "CNAME"

  records = [
    {
      value = "${data.hcloud_zone.scrumplex_rocks.name}."
    }
  ]
}

# Verifications

resource "hcloud_zone_rrset" "roottxt_scrumplex_rocks" {
  zone = data.hcloud_zone.scrumplex_rocks.name
  name = "@"
  type = "TXT"

  records = [
    {
      value   = "\"openpgp4fpr:e173237ac782296d98f5adace13dfd4b47127951\""
      comment = "ariadne"
    }
  ]
}
