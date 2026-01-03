This is a simple UI application for quick system-wide start of a shadowsocks local client daemon

# Dependencies

To run it, you need the following packages:

- `shadowsocks-rust` (or any other implementation of shadowsocks)
- `zenity`
- `notify-send`

# Installing

It will create `.desktop` file:

```
git clone git@github.com:mickleon/shadowsocks_ui
cd shadowsocks_ui
./install.sh
```

After that, the "Shadowsocks" icon should be in the application menu.

# Usage

The script reads the dconf `/system/proxy/` settings and edits them to run the system-wide proxy. 

**If you already have the shadowsocks daemon running, sript will kill it.**

Clicking on the icon on the desktop launches shadowsocks if it is not running (if you have `'none'` in the `/system/proxy/mode`). If it is running (if you have `'manual'` in the  `/system/proxy/mode`), clicking on the icon kills shadowsocks.

If you right-click on the icon, an additional "Change configuration" item will appear in the context menu, allowing you to select any configuration for shadowsocks from the `./config/configs` directory. By default, there will be only one file `example.json`, and it will also be in the file `./config/current_conf`, which defines the path to the current configuration.
