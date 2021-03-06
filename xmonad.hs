import System.IO
import XMonad
import XMonad.Actions.GridSelect
import XMonad.Config.Gnome
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ICCCMFocus
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Layout.FixedColumn
import XMonad.Layout.Grid
import XMonad.Layout.IM
import XMonad.Layout.Named
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Reflect
import XMonad.Layout.SimpleFloat
import XMonad.Layout.Tabbed
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.WindowArranger
import XMonad.ManageHook
import qualified XMonad.StackSet as W
import XMonad.Util.Replace
import XMonad.Util.Run
import XMonad.Util.EZConfig

-- The names of my workspaces.  These are arbitrary, though I need to add
-- custom key bindings if I want more than 9.
myWorkspaces = ["1:code", "2:web", "3:im", "4", "5",
                "6", "7:skype", "8:gimp", "9"]

-- Colors from the default Ubuntu 10.10 theme.
themeBackground = "#3c3b37"
themeHighlight  = "#f07746"
-- Colors from the Ubuntu 10.10 "Clearlooks" theme.
--themeBackground = "#edeceb"
--themeHighlight  = "#84a9d7"

-- Rules which are applied to each new window.  The (optional) part before
-- '-->' is a matching rule.  The rest is an action to perform.
myManageHook = composeAll
  [ resource =? "Do"       --> doIgnore           -- Leave Gnome Do alone.
  , resource =? "Pidgin"   --> doShift "3:im"     -- Force to IM workspace.
  , resource =? "skype"    --> doShift "7:skype"  -- Force to Skype workspace.
  , resource =? "gimp-2.6" --> doShift "8:gimp"   -- Special-case the GIMP.
  , manageDocks                                   -- For xmobar and gnome-panel.
  , manageHook gnomeConfig ]                      -- Gnome defaults.

-- A standard tiled layout, with a master pane and a secondary pane off to
-- the side.  The master pane typically holds one window; the secondary
-- pane holds the rest.  Copied from standard xmonad.hs template config.
tiledLayout = Tall nmaster delta ratio
  where
    nmaster = 1      -- The default number of windows in the master pane.
    ratio   = 1/2    -- Default proportion of screen occupied by master pane.
    delta   = 3/100  -- Percent of screen to increment by when resizing panes.

-- Per-workspace layouts.  We set up custom layouts (and even lists of
-- custom layouts) for the most important workspaces, so we can tweak
-- window management fairly precisely.
--
-- Inspired by:
--   http://kitenet.net/~joey/blog/entry/xmonad_layouts_for_netbooks/
workspaceLayouts =
  onWorkspace "1:code" codeLayouts $
  onWorkspace "2:web" webLayouts $
  onWorkspace "3:im" imLayout $
  onWorkspace "7:skype" skypeLayouts $
  --onWorkspace "8:gimp" gimpLayout $
  defaultLayouts
  where
    -- Combinations of our available layouts, which we can cycle through
    -- using mod-Space.  'Mirror' applies a 90-degree rotation to a layout.
    codeLayouts = fixedLayout ||| tiledLayout ||| Mirror tiledLayout
    webLayouts = tiledLayout ||| Mirror tiledLayout
    skypeLayouts = skypeLayout ||| defaultLayouts
    defaultLayouts = tiledLayout ||| Mirror tiledLayout ||| fixedLayout |||
                     floatLayout ||| simpleTabbed

    -- An 80-column fixed layout for Emacs and terminals.  The master
    -- pane will resize so that the contained window is 80 columns wide.
    fixedLayout = FixedColumn 1 20 80 10

    -- A layout for instant messaging.  Devote 1/6th of the screen to
    -- the Buddy List, and arrange other windows in a grid.
    imLayout = withIM (1/6) (Or (Title "Liste de contacts")
                                (Title "Buddy List")) Grid

    -- Another IM layout, for use with Skype.
    skypeLayout = withIM (1/6) skypeMainWindow Grid
    skypeMainWindow = (And (Resource "skype")
                           (Not (Or (Title "Transferts de fichiers")
                                    (Role "ConversationsWindow"))))

    -- A simple floating-window layout.  This isn't particularly good,
    -- to be honest, but further configuration might improve it.
    floatLayout = windowArrange simpleFloat

-- Hook up my layouts.  We apply 'toggleLayouts' so that we can switch any
-- window into or out of full-screen mode with a single command (see
-- below).  We use 'smartBorders' to turn off the border around the focused
-- window if it's the only window on the screen.  And 'avoidStruts' leaves
-- space for gnome-panel and xmobar.
myLayout = avoidStruts $ smartBorders $ toggleLayouts Full workspaceLayouts

-- Add new keys using EZConfig's Emacs-like syntax.  Note that "M-" means
-- the xmonad modifier key, and not "Meta".
myKeys = 
  [ ("M-g", goToSelected defaultGSConfig)   -- Display window selection grid.
  , ("M-f", sendMessage ToggleLayout)       -- Toggle full-screen layout.
  ]

-- Print the current xmonad status to a pipe for display by xmobar.
-- Instead of using the usual xmobarPP configuration, we use defaultPP and
-- override the colors to match the Ubuntu 10.10 "Clearlooks" theme.
-- Note that we assume "position = Bottom" appears in your xmobar config,
-- and that the Gnome bottom panel has been removed.
--
-- takeTopFocus is for playing nicely with certain Java apps, as explained
-- at http://www.willprice.org/2012/11/07/processing-and-xmonad.html
myLogHook xmobarPipe = dynamicLogWithPP xmobarPrinter >> takeTopFocus
  where
    xmobarPrinter = defaultPP
      { ppOutput  = hPutStrLn xmobarPipe
      , ppCurrent = xmobarColor "black" themeHighlight . wrap "[" "]"
      , ppTitle   = xmobarColor "green"  "" . shorten 80
      , ppVisible = wrap "(" ")"
      , ppUrgent  = xmobarColor "red" themeHighlight }

-- Create a new configuration structure.  I start with the standard
-- 'gnomeConfig', override several fields, and then use EZConfig to patch
-- up the key bindings.
myConfig xmobarPipe =
  gnomeConfig
    { workspaces = myWorkspaces
    , layoutHook = myLayout
    , manageHook = myManageHook
    , logHook    = myLogHook xmobarPipe
    -- Helps with certain Java apps, if I recall correctly.
    , startupHook = setWMName "LG3D"
    , normalBorderColor  = themeBackground
    , focusedBorderColor = themeHighlight
    , modMask    = mod3Mask }
  `additionalKeysP` myKeys

-- The main entry point for our window manager.  It's an ordinary Haskell
-- program.  We specify 'replace' so that it will kill off any running
-- window manager when it starts.
main = do
  replace                           -- Shut down current window manager.
  xmobarPipe <- spawnPipe "xmobar"  -- Start xmobar panel.
  xmonad $ myConfig xmobarPipe      -- Start xmonad with our config.
