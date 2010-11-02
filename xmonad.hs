import XMonad
import XMonad.Actions.GridSelect
import XMonad.Config.Desktop (desktopLayoutModifiers)
import XMonad.Layout.FixedColumn
import XMonad.Layout.Grid
import XMonad.Layout.IM
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.ToggleLayouts
import qualified XMonad.StackSet as W
import XMonad.Util.Replace
import XMonad.Config.Gnome
import XMonad.ManageHook
import XMonad.Util.EZConfig

myWorkspaces = ["1:code", "2:web", "3:im"] ++ map show [4..9]

myManageHook = composeAll
  [ resource =? "Do" --> doIgnore
  , resource =? "empathy" --> doShift "3:im"
  -- For testing.
  , resource =? "xclock" --> doShift "3:im"
  , manageHook gnomeConfig ]

-- Copied from standard xmonad.hs template config.
tiledLayout = Tall nmaster delta ratio
  where
    -- The default number of windows in the master pane
    nmaster = 1
    -- Default proportion of screen occupied by master pane
    ratio   = 1/2
    -- Percent of screen to increment by when resizing panes
    delta   = 3/100

-- Per-workspace layouts.
-- Inspired by:
--   http://kitenet.net/~joey/blog/entry/xmonad_layouts_for_netbooks/
workspaceLayouts =
  onWorkspace "1:code" codeLayouts $
  onWorkspace "2:web" webLayouts $
  onWorkspace "3:im" imLayouts $
  defaultLayouts
  where
    -- An 80-column fixed layout for Emacs and terminals.
    fixedLayout = FixedColumn 1 20 80 10

    -- A layout for instant messaging.
    imLayout = withIM (1/6) (Title "Contact List") Grid

    -- Combinations of our available layouts.
    codeLayouts = fixedLayout ||| tiledLayout ||| Mirror tiledLayout
    webLayouts = tiledLayout ||| Mirror tiledLayout
    imLayouts = imLayout
    defaultLayouts = tiledLayout ||| Mirror tiledLayout ||| fixedLayout

-- Hook up my layouts.
myLayout = smartBorders $ toggleLayouts Full workspaceLayouts

myKeys = 
  [ ("M-g", goToSelected defaultGSConfig)
  , ("M-f", sendMessage ToggleLayout)
  ]

myConfig =
  gnomeConfig
    { workspaces = myWorkspaces
    , layoutHook = desktopLayoutModifiers myLayout
    , manageHook = myManageHook
    , modMask = mod3Mask }
  `additionalKeysP` myKeys

main = do
  replace
  xmonad myConfig
