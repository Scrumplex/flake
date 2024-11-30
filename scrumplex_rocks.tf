resource "hetznerdns_zone" "scrumplex_rocks" {
  name = "scrumplex.rocks"
  ttl  = 86400
}

resource "hetznerdns_record" "root4_scrumplex_rocks" {
  zone_id = hetznerdns_zone.scrumplex_rocks.id
  name    = "@"
  value   = var.universe4
  type    = "A"
  ttl     = 3600
}

resource "hetznerdns_record" "root6_scrumplex_rocks" {
  zone_id = hetznerdns_zone.scrumplex_rocks.id
  name    = "@"
  value   = var.universe6
  type    = "AAAA"
  ttl     = 3600
}

resource "hetznerdns_record" "rootcaa_scrumplex_rocks" {
  for_each = toset(var.caa_records)
  zone_id  = hetznerdns_zone.scrumplex_rocks.id
  name     = "@"
  value    = each.key
  type     = "CAA"
}

resource "hetznerdns_record" "cnames_scrumplex_rocks" {
  for_each = toset(["x"])
  zone_id  = hetznerdns_zone.scrumplex_rocks.id
  name     = each.key
  value    = "${hetznerdns_zone.scrumplex_rocks.name}."
  type     = "CNAME"
}

# Verifications

resource "hetznerdns_record" "roottxt_scrumplex_rocks" {
  for_each = tomap({
    ariadne = "openpgp4fpr:e173237ac782296d98f5adace13dfd4b47127951"
  })
  zone_id = hetznerdns_zone.scrumplex_rocks.id
  name    = "@"
  value   = each.value
  type    = "TXT"
}
