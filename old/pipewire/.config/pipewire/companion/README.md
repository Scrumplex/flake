# What is this?
These are seperate PipeWire daemons that do some audio magic.

## compressor.conf
This is a filter chain (see [PipeWire Wiki](https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Filter-Chain)) that compresses sound from a virtual sink and loops it back into the default sink.
I use this for VoIP applications.

```
VoIP application  --> Virtual sink -->|                       |--> Default sink
                                      |--> Calf Compressor -->|
```

## desktop-source.conf
This is a loopback device (see [PipeWire Wiki](https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Virtual-Devices#coupled-streams)) that creates a sink.
You can pipe sound into the sink, it will then be looped back into the default sink.
This is useful to easily isolate apps that should be captured by OBS, for example.

```
Application  --> Virtual sink --> Default sink
```

# How to use this?
Enable and start the included systemd template unit:
```
$ systemctl --user enable --now pipewire-companion@compressor.conf
$ systemctl --user enable --now pipewire-companion@desktop-source.conf
```