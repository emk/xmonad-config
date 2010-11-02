import XMonad
import XMonad.Actions.GridSelect
import XMonad.Config.Desktop (desktopLayoutModifiers)
import XMonad.Layout.FixedColumn
import XMonad.Layout.Grid
import XMonad.Layout.IM
import XMonad.Util.Replace
import XMonad.Config.Gnome
import XMonad.ManageHook
import XMonad.Util.EZConfig

myManageHook :: [ManageHook]
myManageHook =
  -- From http://images.ubuntuforums.org/showthread.php?t=975329
  [ resource  =? "Do"   --> doIgnore
  ]

-- Copied from standard xmonad.hs template config.
tiledLayout = Tall nmaster delta ratio
  where
    -- The default number of windows in the master pane
    nmaster = 1
    -- Default proportion of screen occupied by master pane
    ratio   = 1/2
    -- Percent of screen to increment by when resizing panes
    delta   = 3/100

-- An 80-column fixed layout for Emacs and terminals.
fixedLayout = FixedColumn 1 20 80 10

imLayout = withIM (1/6) (Title "Contact List") Grid

myLayout = tiledLayout ||| Mirror tiledLayout
       ||| fixedLayout ||| imLayout ||| Full

myKeys = 
  [("M-g", goToSelected defaultGSConfig)
  ]

myConfig =
  gnomeConfig {
    layoutHook = desktopLayoutModifiers myLayout,
    manageHook = composeAll myManageHook
             <+> manageHook gnomeConfig,
    modMask = mod3Mask }
  `additionalKeysP` myKeys

main = do
  replace
  xmonad myConfig
