This is my personal `xmonad` setup for use on Ubuntu 10.10.

## Setting up Gnome

Disable the Nautilus desktop, or you won't see `xmonad`:

    gconftool-2 --type boolean --set /apps/nautilus/preferences/show_desktop false

Put 

## VirtualBox Mac host notes

In VirtualBox, with a Mac host:

* Move VirtualBox modifier to right `Option` key.
* Swap left `Alt` and left `Windows` key using Gnome keyboard
  preferences dialog.

Put this in xmodmap:

    keycode 64 = Hyper_L
    clear Mod3
    add Mod3 = Hyper_L
    clear Mod4
    add Mod4 = Super_L Super_R

This finishes remapping the modifiers so that:

* `Meta` and `Alt` are mapped to the `Command` key.
* `Hyper_L` is mapped to the left `Option` key, and used to control `xmonad`.
* Super_R is mapped to the right command key, and used to control Emacs.
* The right option key is used to control VirtualBox.





Launch xmonad from terminal once logged in.
