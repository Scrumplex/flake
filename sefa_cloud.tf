data "hcloud_zone" "sefa_cloud" {
  name = "sefa.cloud"
}

resource "hcloud_zone_rrset" "rootcaa_sefa_cloud" {
  zone = data.hcloud_zone.sefa_cloud.name
  name = "@"
  type = "CAA"

  records = [for v in var.caa_records : { value = v }]
}

resource "hcloud_zone_rrset" "eclipse4_sefa_cloud" {
  zone = data.hcloud_zone.sefa_cloud.name
  name = "eclipse"
  type = "A"

  records = [
    {
      value = "10.10.10.12"
    }
  ]
}

resource "hcloud_zone_rrset" "eclipse6_sefa_cloud" {
  zone = data.hcloud_zone.sefa_cloud.name
  name = "eclipse"
  type = "AAAA"

  records = [
    {
      value = "fdcc:546e:5cf:0:da5e:d3ff:feea:f48e"
    }
  ]
}

resource "hcloud_zone_rrset" "eclipsecnames_sefa_cloud" {
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
  zone = data.hcloud_zone.sefa_cloud.name
  name = "${each.key}.eclipse"
  type = "CNAME"

  records = [
    {
      value = "eclipse.sefa.cloud."
    }
  ]
}

resource "hcloud_zone_rrset" "galileo4_sefa_cloud" {
  zone = data.hcloud_zone.sefa_cloud.name
  name = "galileo"
  type = "A"

  records = [
    {
      value = "10.0.0.11"
    }
  ]
}

resource "hcloud_zone_rrset" "galileo6_sefa_cloud" {
  zone = data.hcloud_zone.sefa_cloud.name
  name = "galileo"
  type = "AAAA"

  records = [
    {
      value = "fd19:783f:b287:0:ea2a:44ff:fec8:f727"
    }
  ]
}

resource "hcloud_zone_rrset" "galileocnames_sefa_cloud" {
  for_each = toset([
    "asf",
  ])
  zone = data.hcloud_zone.sefa_cloud.name
  name = "${each.key}.galileo"
  type = "CNAME"

  records = [
    {
      value = "galileo.sefa.cloud."
    }
  ]
}

resource "hcloud_zone_rrset" "cnames_sefa_cloud" {
  for_each = toset([
    "audiobookshelf",
    "box",
    "cache",
    "cook",
    "home",
    "immich",
    "jellyfin",
    "request",
    "smart",
    "vault",
    "view",
  ])
  zone = data.hcloud_zone.sefa_cloud.name
  name = each.key
  type = "CNAME"

  records = [
    {
      value = "${data.hcloud_zone.sefa_cloud.name}."
    }
  ]
}

resource "hcloud_zone_rrset" "cnames_arson_sefa_cloud" {
  for_each = toset([
    "hass",
  ])
  zone = data.hcloud_zone.sefa_cloud.name
  name = each.key
  type = "CNAME"

  records = [
    {
      value = "arson.${data.hcloud_zone.sefa_cloud.name}."
    }
  ]
}

# Verifications

resource "hcloud_zone_rrset" "roottxt_sefa_cloud" {
  zone = data.hcloud_zone.sefa_cloud.name
  name = "@"
  type = "TXT"

  records = [
    {
      value   = "\"Sendinblue-code:40fc54f18aa321c1ef380e8bc74c0f1f\""
      comment = "Brevo/Send in Blue Verification"
    },
    {
      value   = "\"v=spf1 include:spf.sendinblue.com mx ~all\""
      comment = "Brevo/Send in Blue SPF"
    }
  ]
}

resource "hcloud_zone_rrset" "brevotxt_sefa_cloud" {
  for_each = tomap({
    _dmarc            = "\"v=DMARC1; p=none; sp=none; rua=mailto:dmarc@mailinblue.com!10m; ruf=mailto:dmarc@mailinblue.com!10m; rf=afrf; pct=100; ri=86400\""
    "mail._domainkey" = "\"k=rsa;p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDeMVIzrCa3T14JsNY0IRv5/2V1/v2itlviLQBwXsa7shBD6TrBkswsFUToPyMRWC9tbR/5ey0nRBH0ZVxp+lsmTxid2Y2z+FApQ6ra2VsXfbJP3HE6wAO0YTVEJt1TmeczhEd2Jiz/fcabIISgXEdSpTYJhb0ct0VJRxcg4c8c7wIDAQAB\""
  })
  zone = data.hcloud_zone.sefa_cloud.name
  name = each.key
  type = "TXT"

  records = [
    {
      value = each.value
    }
  ]
}
