In Virtual Box, with a Mac host:
  Move Virtual Box modifier to right Option key.
  Swap left Alt and left Windows key using Gnome keyboard
    preferences dialog.

Put this in xmodmap:

  clear Mod3
  add Mod3 = Super_L
  clear Mod4
  add Mod4 = Super_R'S

Disable Nautilus desktop:

  gconftool-2 --type boolean --set /apps/nautilus/preferences/show_desktop false

Launch xmonad from terminal once logged in.
