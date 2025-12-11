data "hcloud_zone" "scrumplex_net" {
  name = "scrumplex.net"
}

resource "hcloud_zone_rrset" "root4_scrumplex_net" {
  zone = data.hcloud_zone.scrumplex_net.name
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

resource "hcloud_zone_rrset" "root6_scrumplex_net" {
  zone = data.hcloud_zone.scrumplex_net.name
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

resource "hcloud_zone_rrset" "rootcaa_scrumplex_net" {
  zone = data.hcloud_zone.scrumplex_net.name
  name = "@"
  type = "CAA"

  records = [for v in var.caa_records : { value = v }]
}

resource "hcloud_zone_rrset" "cnames_scrumplex_net" {
  for_each = toset(["x", "skins", "grafana", "beta"])
  zone     = data.hcloud_zone.scrumplex_net.name
  name     = each.key
  type     = "CNAME"

  records = [
    {
      value = "${data.hcloud_zone.scrumplex_net.name}."
    }
  ]
}

resource "hcloud_zone_rrset" "play_scrumplex_net" {
  zone = data.hcloud_zone.scrumplex_net.name
  name = "play"
  type = "CNAME"

  records = [
    {
      value = "home.sefa.cloud."
    }
  ]
}

# Verifications

resource "hcloud_zone_rrset" "verify_bing_scrumplex_net" {
  zone = data.hcloud_zone.scrumplex_net.name
  name = "3835887576857d098bf556039da5a1ed"
  type = "CNAME"

  records = [
    {
      value = "verify.bing.com."
    }
  ]
}

resource "hcloud_zone_rrset" "atproto_scrumplex_net" {
  zone = data.hcloud_zone.scrumplex_net.name
  name = "_atproto"
  type = "TXT"

  records = [
    {
      value = "\"did=did:plc:cryskse2nxtwd4feybx3vhcq\""
    }
  ]
}

resource "hcloud_zone_rrset" "discord_scrumplex_net" {
  zone = data.hcloud_zone.scrumplex_net.name
  name = "_discord"
  type = "TXT"

  records = [
    {
      value = "\"dh=6b63a4f3f7bd4c47da77cc7dd3ecfb8060dcc8e5\""
    }
  ]
}

resource "hcloud_zone_rrset" "roottxt_scrumplex_net" {
  zone = data.hcloud_zone.scrumplex_net.name
  name = "@"
  type = "TXT"

  records = [
    {
      value   = "\"google-site-verification=NaynR7Wx8QUQ6X_LjIZn510VZ6Xk7OCwy-fXoNLkbzw\""
      comment = "google"
    },
    {
      value   = "\"openpgp4fpr:e173237ac782296d98f5adace13dfd4b47127951\""
      comment = "ariadne"
    },
    {
      value   = "\"abuseipdb-verification=OL4gRvY2\""
      comment = "abuseipdb"
    },
    {
      value   = "\"v=spf1 include:mailbox.org -all\""
      comment = "mailbox.org SPF"
    }
  ]
}

# Mailbox.org records

resource "hcloud_zone_rrset" "mbomx_scrumplex_net" {
  zone = data.hcloud_zone.scrumplex_net.name
  name = "@"
  type = "MX"

  records = [
    {
      value = "10 mxext1.mailbox.org."
    },
    {
      value = "20 mxext3.mailbox.org."
    },
    {
      value = "10 mxext2.mailbox.org."
    }
  ]
}

resource "hcloud_zone_rrset" "mbotxt_scrumplex_net" {
  for_each = tomap({
    _dmarc               = "\"v=DMARC1; p=none; rua=mailto:postmaster@scrumplex.net; ruf=mailto:postmaster@scrumplex.net; fo=1; pct=25; adkim=r; aspf=r\""
    "mbo0001._domainkey" = "\"v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2K4PavXoNY8eGK2u61LIQlOHS8f5sWsCK5b+HMOfo0M+aNHwfqlVdzi/IwmYnuDKuXYuCllrgnxZ4fG4yVaux58v9grVsFHdzdjPlAQfp5rkiETYpCMZwgsmdseJ4CoZaosPHLjPumFE/Ua2WAQQljnunsM9TONM9L6KxrO9t5IISD1XtJb0bq1lVI/e72k3m\" \"nPd/q77qzhTDmwN4TSNJZN8sxzUJx9HNSMRRoEIHSDLTIJUK+Up8IeCx0B7CiOzG5w/cHyZ3AM5V8lkqBaTDK46AwTkTVGJf59QxUZArG3FEH5vy9HzDmy0tGG+053/x4RqkhqMg5/ClDm+lpZqWwIDAQAB\""
    "mbo0002._domainkey" = "\"v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqxEKIg2c48ecfmy/+rj35sBOhdfIYGNDCMeHy0b36DX6MNtS7zA/VDR2q5ubtHzraL5uUGas8kb/33wtrWFYxierLRXy12qj8ItdYCRugu9tXTByEED05WdBtRzJmrb8YBMfeK0E0K3wwoWfhIk/wzKbjMkbqYBOTYLlIcVGQWzOfN7/n3n+VChfu6sGFK3k2\" \"qrJNnw22iFy4C8Ks7j77+tCpm0PoUwA2hOdLrRw3ldx2E9PH0GVwIMJRgekY6cS7DrbHrj/AeGlwfwwCSi9T23mYvc79nVrh2+82ZqmkpZSTD2qq+ukOkyjdRuUPck6e2b+x141Nzd81dIZVfOEiwIDAQAB\""
  })
  zone = data.hcloud_zone.scrumplex_net.name
  name = each.key
  type = "TXT"
  records = [
    {
      value = each.value
    }
  ]
}
