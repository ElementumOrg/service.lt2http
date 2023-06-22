
[![Build Status](https://travis-ci.org/ElementumOrg/service.lt2http.svg?branch=master)](https://travis-ci.org/ElementumOrg/service.lt2http)
[![Join the chat at https://gitter.im/ElementumApp/Lobby](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/ElementumApp/Lobby)


Support
----------
- Source is open, so you can fork everything.
- Any participation in development is welcome.


What it is
----------
service.lt2http is a Kodi addon wrapper for [lt2http](https://github.com/ElementumOrg/lt2http/) application. 
There is no Kodi interface yet, addons acts like a lt2http service starter and updates the settings, according to Kodi addon settings.

I would appreciate if someone would like to add a simple browsing functionality in Python, to be able to list active torrents, or add file, start/stop/pause/delete torrent, etc..

Supported platforms
-------------------
- Windows 32/64 bits
- Linux 32/64 bits
- Linux ARM (armv6, armv7, armv8/arm64)
- OS X 64 bits
- Android ARM (4.4.x, and later), x86, x64, ARM, ARM64

Minimum supported Kodi version: 16 (Jarvis)

Download
--------
See the [Releases](http://elementum.surge.sh/) page. **Do NOT use the `Download ZIP` button on this page.**


Installation
------------
- Go to Settings > Service settings > Control and **enable both Application control options**
- Restart Kodi if one or both options were not enabled
- Install lt2http like any other add-on

Build
-----
service.lt2http has only Python scripts to run the lt2http application from Kodi and stop gracefully.
When new version is installed - proper binary is downloaded from GitHub.

Release
-------

Release is done by `release.sh` script, that gets precompiled binaries, collects everything into module zip file and upload as a Github release.

How it works
------------
lt2http is a torrent downloading application, whis REST web-server on front and ability to stream downloaded data to media player or downloader. It supports download to the memory, without using the hard disk.

The BitTorrent streaming engine is very resilient (or at least it's designed to be). It's built on top of [libtorrent](https://github.com/arvidn/libtorrent) package.

