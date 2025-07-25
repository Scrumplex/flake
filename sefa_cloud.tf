resource "hetznerdns_zone" "sefa_cloud" {
  name = "sefa.cloud"
  ttl  = 86400
}

resource "hetznerdns_record" "rootcaa_sefa_cloud" {
  for_each = toset(var.caa_records)
  zone_id  = hetznerdns_zone.sefa_cloud.id
  name     = "@"
  value    = each.key
  type     = "CAA"
}

resource "hetznerdns_record" "eclipse4_sefa_cloud" {
  zone_id = hetznerdns_zone.sefa_cloud.id
  name    = "eclipse"
  value   = "10.10.10.12"
  type    = "A"
}

resource "hetznerdns_record" "eclipse6_sefa_cloud" {
  zone_id = hetznerdns_zone.sefa_cloud.id
  name    = "eclipse"
  value   = "fdcc:546e:5cf:0:da5e:d3ff:feea:f48e"
  type    = "AAAA"
}

resource "hetznerdns_record" "eclipsecnames_sefa_cloud" {
  for_each = toset([
    "nzb",
    "paperless",
    "prowlarr",
    "radarr",
    "slskd",
    "sonarr",
    "syncthing",
    "torrent",
  ])
  zone_id = hetznerdns_zone.sefa_cloud.id
  name    = "${each.key}.eclipse"
  value   = "eclipse.sefa.cloud."
  type    = "CNAME"
}

resource "hetznerdns_record" "cnames_sefa_cloud" {
  for_each = toset([
    "actual",
    "audiobookshelf",
    "box",
    "buildbot",
    "cache",
    "cook",
    "home",
    "immich",
    "jellyfin",
    "miniflux",
    "request",
    "smart",
    "vault",
    "view",
  ])
  zone_id = hetznerdns_zone.sefa_cloud.id
  name    = each.key
  value   = "${hetznerdns_zone.sefa_cloud.name}."
  type    = "CNAME"
}

resource "hetznerdns_record" "cnames_arson_sefa_cloud" {
  for_each = toset([
    "hass",
  ])
  zone_id = hetznerdns_zone.sefa_cloud.id
  name    = each.key
  value   = "arson.${hetznerdns_zone.sefa_cloud.name}."
  type    = "CNAME"
}

# Verifications

resource "hetznerdns_record" "roottxt_sefa_cloud" {
  for_each = tomap({
    sendinblue = "Sendinblue-code:40fc54f18aa321c1ef380e8bc74c0f1f"
  })
  zone_id = hetznerdns_zone.sefa_cloud.id
  name    = "@"
  value   = each.value
  type    = "TXT"
}

# Send in Blue records

resource "hetznerdns_record" "mbotxt_sefa_cloud" {
  for_each = tomap({
    "@"               = "\"v=spf1 include:spf.sendinblue.com mx ~all\""
    _dmarc            = "\"v=DMARC1; p=none; sp=none; rua=mailto:dmarc@mailinblue.com!10m; ruf=mailto:dmarc@mailinblue.com!10m; rf=afrf; pct=100; ri=86400\""
    "mail._domainkey" = "\"k=rsa;p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDeMVIzrCa3T14JsNY0IRv5/2V1/v2itlviLQBwXsa7shBD6TrBkswsFUToPyMRWC9tbR/5ey0nRBH0ZVxp+lsmTxid2Y2z+FApQ6ra2VsXfbJP3HE6wAO0YTVEJt1TmeczhEd2Jiz/fcabIISgXEdSpTYJhb0ct0VJRxcg4c8c7wIDAQAB\""
  })
  zone_id = hetznerdns_zone.sefa_cloud.id
  name    = each.key
  value   = each.value
  type    = "TXT"
}
