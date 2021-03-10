#!/bin/bash
voip_sink_monitor="VoIP Audio/Sink sink Monitor"
output_sink_playback="[G533 Wireless Headset Dongle] Analog Stereo"
calf_client_name="calf-compressor"

sleep 1


jack_connect "$voip_sink_monitor:monitor_FL" "$calf_client_name:PW Compressor In #1"
jack_connect "$voip_sink_monitor:monitor_FR" "$calf_client_name:PW Compressor In #2"
jack_connect "$calf_client_name:PW Compressor Out #1" "$output_sink_playback:playback_FL"
jack_connect "$calf_client_name:PW Compressor Out #2" "$output_sink_playback:playback_FR"

