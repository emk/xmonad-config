import XMonad
import XMonad.Actions.GridSelect
import XMonad.Config.Desktop
import XMonad.Config.Gnome
import XMonad.Layout.FixedColumn
import XMonad.Layout.Grid
import XMonad.Layout.IM
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.SimpleFloat
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.WindowArranger
import XMonad.ManageHook
import qualified XMonad.StackSet as W
import XMonad.Util.Replace
import XMonad.Util.EZConfig

-- The names of my workspaces.  These are arbitrary, though I need to add
-- custom key bindings if I want more than 9.
myWorkspaces = ["1:code", "2:web", "3:im", "4", "5", "6", "7", "8:float", "9"]

-- Rules which are applied to each new window.  The (optional) part before
-- '-->' is a matching rule.  The rest is an action to perform.
myManageHook = composeAll
  [ resource =? "Do"       --> doIgnore           -- Leave Gnome Do alone.
  , resource =? "Pidgin"   --> doShift "3:im"     -- Force to IM workspace.
  , resource =? "gimp-2.6" --> doShift "8:float"  -- Special-case the GIMP.
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
  onWorkspace "8:float" floatLayout $
  defaultLayouts
  where
    -- Combinations of our available layouts, which we can cycle through
    -- using mod-Space.  'Mirror' applies a 90-degree rotation to a layout.
    codeLayouts = fixedLayout ||| tiledLayout ||| Mirror tiledLayout
    webLayouts = tiledLayout ||| Mirror tiledLayout
    defaultLayouts = tiledLayout ||| Mirror tiledLayout ||| fixedLayout

    -- An 80-column fixed layout for Emacs and terminals.  The master
    -- pane will resize so that the contained window is 80 columns wide.
    fixedLayout = FixedColumn 1 20 80 10

    -- A layout for instant messaging.
    imLayout = withIM (1/6) (Title "Buddy List") Grid

    -- A simple floating-window layout.
    floatLayout = windowArrange simpleFloat

-- Hook up my layouts.  We apply 'toggleLayouts' so that we can switch any
-- window into or out of full-screen mode with a single command (see
-- below).  We use smartBorders to turn off the border around the focused
-- window if it's the only window on the screen.
myLayout = smartBorders $ toggleLayouts Full workspaceLayouts

-- Add new keys using EZConfig's Emacs-like syntax.  Note that "M-" means
-- the xmonad modifier key, and not "Meta".
myKeys = 
  [ ("M-g", goToSelected defaultGSConfig)   -- Display window selection grid.
  , ("M-f", sendMessage ToggleLayout)       -- Toggle full-screen layout.
  ]

-- Create a new configuration structure.  I start with the standard
-- 'gnomeConfig', override several fields, and then use EZConfig to patch
-- up the key bindings.
myConfig =
  gnomeConfig
    { workspaces = myWorkspaces
    , layoutHook = desktopLayoutModifiers myLayout
    , manageHook = myManageHook
    , modMask = mod3Mask }
  `additionalKeysP` myKeys

-- The main entry point for our window manager.  It's an ordinary Haskell
-- program.  We specify 'replace' so that it will kill off any running
-- window manager when it starts.
main = do
  replace
  xmonad myConfig
