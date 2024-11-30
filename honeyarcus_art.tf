resource "hetznerdns_zone" "honeyarcus_art" {
  name = "honeyarcus.art"
  ttl  = 86400
}

resource "hetznerdns_record" "root4_honeyarcus_art" {
  zone_id = hetznerdns_zone.honeyarcus_art.id
  name    = "@"
  value   = var.universe4
  type    = "A"
  ttl     = 3600
}

resource "hetznerdns_record" "root6_honeyarcus_art" {
  zone_id = hetznerdns_zone.honeyarcus_art.id
  name    = "@"
  value   = var.universe6
  type    = "AAAA"
  ttl     = 3600
}

resource "hetznerdns_record" "rootcaa_honeyarcus_art" {
  for_each = toset(var.caa_records)
  zone_id  = hetznerdns_zone.honeyarcus_art.id
  name     = "@"
  value    = each.key
  type     = "CAA"
}
