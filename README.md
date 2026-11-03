service.lt2http
===============

What it is
----------
service.lt2http is a Kodi add-on that runs [lt2http](https://github.com/ElementumOrg/lt2http/), a torrent download and streaming
engine with an HTTP API, built on [libtorrent](https://github.com/arvidn/libtorrent). It can download to memory, without using the disk.

There is no Kodi interface yet: the add-on starts lt2http together with Kodi, passes the add-on settings to it and stops it
when Kodi exits. Other add-ons (or anything on the network) use lt2http through its API, by default on `http://127.0.0.1:65225`.
The API is documented in Swagger at `http://127.0.0.1:65225/swagger/ui`.

Contributions are welcome, for example a simple browsing interface in Python to list active torrents, add files,
or start, stop, pause and delete torrents.

Supported platforms
-------------------
The same platforms as Elementum, each with an lt2http binary and a shared library:

| OS      | Platforms                                                                     |
|---------|-------------------------------------------------------------------------------|
| Android | `android-arm`, `android-arm64`, `android-x86`, `android-x64`                  |
| Linux   | `linux-armv6`, `linux-armv7`, `linux-armv7_softfp`, `linux-arm64`, `linux-x86`, `linux-x64` |
| Windows | `windows-x86`, `windows-x64`                                                  |
| macOS   | `darwin-x64`, `darwin-arm64`                                                  |

The platform is detected automatically. If detection picks the wrong one, set it in Settings > General > Application platform type.

Linux builds need glibc 2.30 or newer (2.29 on armv6), Windows builds need Windows 8 or newer.

Installation
------------
- Go to Settings > Services > Control and **enable both Application control options** (lt2http waits for Kodi's JSON-RPC on port 9090)
- Restart Kodi if one or both options were not enabled
- Install the add-on zip from the [Releases](https://github.com/ElementumOrg/service.lt2http/releases) page or the ElementumOrg repository.
  **Do NOT use the `Download ZIP` button on this page.**

How it works
------------
On start (`service.py`), the add-on:
1. Downloads the lt2http files for the detected platform from [lt2http-binaries](https://github.com/ElementumOrg/lt2http-binaries)
   into `resources/bin/<platform>/`, when they are missing or older than the add-on.
2. Copies them into its profile folder (`userdata/addon_data/service.lt2http/bin/<platform>/`), or into the application data
   folder on Android, because some systems cannot run files from the add-on folder.
3. Writes the add-on settings to `special://temp/lt2http-config.json`.
4. Starts lt2http in one of two ways:
   - **Binary:** a separate `lt2http` process, with its output in the Kodi log.
   - **Shared library:** `lt2http.so` (`lt2http.dll` on Windows) is loaded into Kodi with ctypes and runs in a thread.
     Its log is written to `special://temp/lt2http.log` and copied into the Kodi log.

   The binary is used by default. The library is used when the binary cannot be started (Android 10 and later does not allow
   running binaries from application data folders) or when **Settings > General > Force start as a library** is enabled.
5. Restarts lt2http if it stops unexpectedly (up to 3 times), sends changed settings to it (`/settings/set`) and stops it
   with `/shutdown` when Kodi exits.

The API port is set in Settings > Advanced > Local port (`web_port`, default `65225`). lt2http binds it only on start,
so changing it restarts lt2http on the new port.

A binary left running by a crashed Kodi keeps the port busy, so the add-on asks any lt2http on its port to stop before starting
a new one. lt2http does not use a lockfile.

Troubleshooting
---------------
- All add-on messages are in the Kodi log, prefixed with `[service.lt2http]`, followed by the lt2http output.
- "Unable to reach Kodi's JSON-RPC service": enable the Application control options (see Installation).
- lt2http keeps restarting on Android or another restricted system: enable **Force start as a library**.
- Wrong binary for your device: choose it in Settings > General > Application platform type.

Development
-----------
The add-on is Python only, lt2http itself is built in the [lt2http](https://github.com/ElementumOrg/lt2http/) repository.
To test a local lt2http build, run `test_build.sh docker` there: it copies the files into `~/.kodi`.

Before committing:
```
pip install -r requirements.txt
flake8                  # Python lint, configured in setup.cfg
./scripts/xgettext.sh   # validates all translation files
```

Translations live in `resources/language/resource.language.<locale>/strings.po`, with the template in `resources/language/messages.pot`.
A new string gets a free id and is added to `messages.pot` and to every `strings.po` (with an empty `msgstr` where there is no translation).
`./scripts/xgettext_merge.sh` merges `messages.pot` into all locales.

Settings in `resources/settings.xml` use relative conditions like `eq(-2,true)`: they count every `<setting>` element, including
separators, so check them when adding or moving settings.

Release
-------
`release.sh` lints the code, validates translations, builds the add-on zip (`make`) and, on a tag, uploads it as a GitHub release.
The lt2http binaries are released separately, from the lt2http repository into lt2http-binaries.
