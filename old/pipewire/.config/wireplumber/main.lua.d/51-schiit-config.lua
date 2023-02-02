rule = {
  matches = {
    {
      { "node.name", "equals", "alsa_output.usb-Schiit_Audio_Schiit_Modi_3_-00.analog-stereo" },
    },
  },
  apply_properties = {
    ["audio.format"] = "S32_LE",
    ["audio.rate"] = 96000,
    ["api.alsa.period-size"] = 128,
  },
}

table.insert(alsa_monitor.rules,rule)
