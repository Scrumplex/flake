resource "hetznerdns_zone" "duckhub_io" {
  name = "duckhub.io"
  ttl  = 86400
}

resource "hetznerdns_record" "root4_duckhub_io" {
  zone_id = hetznerdns_zone.duckhub_io.id
  name    = "@"
  value   = var.universe4
  type    = "A"
  ttl     = 3600
}

resource "hetznerdns_record" "root6_duckhub_io" {
  zone_id = hetznerdns_zone.duckhub_io.id
  name    = "@"
  value   = var.universe6
  type    = "AAAA"
  ttl     = 3600
}

resource "hetznerdns_record" "rootcaa_duckhub_io" {
  for_each = toset(var.caa_records)
  zone_id  = hetznerdns_zone.duckhub_io.id
  name     = "@"
  value    = each.key
  type     = "CAA"
}

resource "hetznerdns_record" "cnames_duckhub_io" {
  for_each = toset(["quack"])
  zone_id  = hetznerdns_zone.duckhub_io.id
  name     = each.key
  value    = "${hetznerdns_zone.duckhub_io.name}."
  type     = "CNAME"
}
