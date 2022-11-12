rule = {
  matches = {
    {
      { "device.name", "equals", "alsa_card.pci-0000_15_00.4" },
    },
  },
  apply_properties = {
    ["api.alsa.use-acp"] = true,
    ["api.acp.auto-profile"] = false,
    ["api.acp.auto-port"] = false,
    ["device.profile-set"] = "scrumplex.conf",
    ["device.profile"] = "scrumplex",
  },
}
table.insert(alsa_monitor.rules,rule)
