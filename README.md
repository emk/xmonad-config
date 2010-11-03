# Running xmonad, xmobar and the Gnome panel

This is my personal `xmonad` setup for use on Ubuntu 10.10, running under
VirtualBox on a Mac laptop.  The inspiration for this configuration comes
from [xmonad layouts for netbooks][netbook].  See the [xmonad tour][tour]
for an overview of using `xmonad`.

This configurtion includes Gnome panel (on the top) and xmobar (on the
bottom).  The two docks can be toggled with **M-b**.  This layout defines
several special workspaces:

* `1:code` is intended for editor and terminal windows.  The master pane
  will automatically resize itself to be 80 columns wide.
* `2:web` holds a web browser.
* `3:im` holds the Pidgin IM client.  The buddy list will be displayed in a
  column on the left, and individual IM windows will be layed out on a
  grid on the right.
* `8:float` has primitive floating windows, and is very useful for running
  the Gimp.

[netbook]: http://kitenet.net/~joey/blog/entry/xmonad_layouts_for_netbooks/
[tour]: http://xmonad.org/tour.html

## Installing xmonad

This _should_ give you everything you need:

    sudo apt-get install xmonad libghc6-xmonad-dev libghc6-xmonad-contrib-dev \
        xmobar gnome-go pidgin
    git clone http://github.com/emk/xmonad-config.git

Set up some symlinks so `xmonad` and `xmobar` can find their configuration
files:

    cd
    ln -s xmonad-config .xmonad
    ln -s .xmonad/xmobarrc .xmobarrc

## Setting up Gnome

Switch to the "Clearlooks" theme if you want the Gnome panel and `xmobar`
to match.  Adjust the background alpha of Gnome Terminal to taste, and
disable its menu bar.

Disable the Nautilus desktop, or you won't see `xmonad`:

    gconftool-2 --type boolean --set /apps/nautilus/preferences/show_desktop false

Remove the bottom Gnome panel, but leave the top one intact.

If you're running Empathy, quit it and configure Pidgin instead.  Empathy
is a very slick IM client, but it doesn't reliably support audio, video or
file transfers.  It also does some funny stuff with `WM_CLASS` that make it
hard to control using `xmonad` and other window managers.  Don't worry;
Pidgin has full Gnome integration, including the messaging menu.

Configure Pidgin's **Libnotify Popups** plugin to turn off "Buddy logged
in" messages.

## VirtualBox Mac host notes

In VirtualBox, with a Mac host:

* Move VirtualBox modifier to right **Option** key.
* Swap left **Alt** and left **Windows** key using Gnome keyboard
  preferences dialog.

Put this in `~/.xmodmap`:

    keycode 64 = Hyper_L
    clear Mod3
    add Mod3 = Hyper_L
    clear Mod4
    add Mod4 = Super_L Super_R

This finishes remapping the modifiers so that:

* `Meta` and `Alt` are mapped to the **Command** key.
* `Hyper_L` is mapped to the left **Option** key, and used to control `xmonad`.
* `Super_R` is mapped to the right **Command** key, and used to control Emacs.
* The right **Option** key is used to control VirtualBox.

At this point, you'll want to log out of your Gnome session and log back
in.

## Starting xmonad

Start `xmonad` from a terminal:

    xmonad &

## Using xmonad

See the [xmonad tour][tour] for a basic tutorial.  This configuration
defines several other useful keys as well.  Below, **M-** indicates
`Hyper_L`, our `xmonad` modifier key, which is mapped to the right **Option**
key.  **S-** indicates `Super_R`, which is mapped to the right **Command**
key.

* **M-b**: Toggle display of Gnome panel and `xmobar`.
* **M-f**: Toggle full-screen mode for current window.
* **M-g**: Select an open window from a grid and go to it.
* **S-Space**: Launch Gnome Go.
