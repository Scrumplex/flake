resource "hetznerdns_zone" "scrumplex_net" {
  name = "scrumplex.net"
  ttl  = 86400
}

resource "hetznerdns_record" "root4_scrumplex_net" {
  zone_id = hetznerdns_zone.scrumplex_net.id
  name    = "@"
  value   = var.universe4
  type    = "A"
  ttl     = 3600
}

resource "hetznerdns_record" "root6_scrumplex_net" {
  zone_id = hetznerdns_zone.scrumplex_net.id
  name    = "@"
  value   = var.universe6
  type    = "AAAA"
  ttl     = 3600
}

resource "hetznerdns_record" "rootcaa_scrumplex_net" {
  for_each = toset(var.caa_records)
  zone_id  = hetznerdns_zone.scrumplex_net.id
  name     = "@"
  value    = each.key
  type     = "CAA"
}

resource "hetznerdns_record" "cnames_scrumplex_net" {
  for_each = toset(["x", "live", "skins", "grafana", "beta"])
  zone_id  = hetznerdns_zone.scrumplex_net.id
  name     = each.key
  value    = "${hetznerdns_zone.scrumplex_net.name}."
  type     = "CNAME"
}

resource "hetznerdns_record" "play_scrumplex_net" {
  zone_id = hetznerdns_zone.scrumplex_net.id
  name    = "play"
  value   = "home.sefa.cloud."
  type    = "CNAME"
}

# Verifications

resource "hetznerdns_record" "verify_bing_scrumplex_net" {
  zone_id = hetznerdns_zone.scrumplex_net.id
  name    = "3835887576857d098bf556039da5a1ed"
  value   = "verify.bing.com."
  type    = "CNAME"
}

resource "hetznerdns_record" "atproto_scrumplex_net" {
  zone_id = hetznerdns_zone.scrumplex_net.id
  name    = "_atproto"
  value   = "did=did:plc:cryskse2nxtwd4feybx3vhcq"
  type    = "TXT"
}

resource "hetznerdns_record" "discord_scrumplex_net" {
  zone_id = hetznerdns_zone.scrumplex_net.id
  name    = "_discord"
  value   = "dh=6b63a4f3f7bd4c47da77cc7dd3ecfb8060dcc8e5"
  type    = "TXT"
}

resource "hetznerdns_record" "roottxt_scrumplex_net" {
  for_each = tomap({
    google    = "\"google-site-verification=NaynR7Wx8QUQ6X_LjIZn510VZ6Xk7OCwy-fXoNLkbzw\""
    ariadne   = "openpgp4fpr:e173237ac782296d98f5adace13dfd4b47127951"
    abuseipdb = "\"abuseipdb-verification=OL4gRvY2\""
  })
  zone_id = hetznerdns_zone.scrumplex_net.id
  name    = "@"
  value   = each.value
  type    = "TXT"
}

# Mailbox.org records

resource "hetznerdns_record" "mbomx_scrumplex_net" {
  for_each = toset(["10 mxext1.mailbox.org.", "20 mxext3.mailbox.org.", "10 mxext2.mailbox.org."])
  zone_id  = hetznerdns_zone.scrumplex_net.id
  name     = "@"
  value    = each.key
  type     = "MX"
}

resource "hetznerdns_record" "mbotxt_scrumplex_net" {
  for_each = tomap({
    "@"                  = "\"v=spf1 include:mailbox.org -all\""
    _dmarc               = "\"v=DMARC1; p=none; rua=mailto:postmaster@scrumplex.net; ruf=mailto:postmaster@scrumplex.net; fo=1; pct=25; adkim=r; aspf=r\""
    "mbo0001._domainkey" = "\"v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2K4PavXoNY8eGK2u61LIQlOHS8f5sWsCK5b+HMOfo0M+aNHwfqlVdzi/IwmYnuDKuXYuCllrgnxZ4fG4yVaux58v9grVsFHdzdjPlAQfp5rkiETYpCMZwgsmdseJ4CoZaosPHLjPumFE/Ua2WAQQljnunsM9TONM9L6KxrO9t5IISD1XtJb0bq1lVI/e72k3m\" \"nPd/q77qzhTDmwN4TSNJZN8sxzUJx9HNSMRRoEIHSDLTIJUK+Up8IeCx0B7CiOzG5w/cHyZ3AM5V8lkqBaTDK46AwTkTVGJf59QxUZArG3FEH5vy9HzDmy0tGG+053/x4RqkhqMg5/ClDm+lpZqWwIDAQAB\""
    "mbo0002._domainkey" = "\"v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqxEKIg2c48ecfmy/+rj35sBOhdfIYGNDCMeHy0b36DX6MNtS7zA/VDR2q5ubtHzraL5uUGas8kb/33wtrWFYxierLRXy12qj8ItdYCRugu9tXTByEED05WdBtRzJmrb8YBMfeK0E0K3wwoWfhIk/wzKbjMkbqYBOTYLlIcVGQWzOfN7/n3n+VChfu6sGFK3k2\" \"qrJNnw22iFy4C8Ks7j77+tCpm0PoUwA2hOdLrRw3ldx2E9PH0GVwIMJRgekY6cS7DrbHrj/AeGlwfwwCSi9T23mYvc79nVrh2+82ZqmkpZSTD2qq+ukOkyjdRuUPck6e2b+x141Nzd81dIZVfOEiwIDAQAB\""
  })
  zone_id = hetznerdns_zone.scrumplex_net.id
  name    = each.key
  value   = each.value
  type    = "TXT"
}
