import XMonad
import XMonad.Actions.DynamicWorkspaces
import XMonad.Actions.SpawnOn
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops (ewmh, fullscreenEventHook)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.NoBorders
import XMonad.StackSet (shift, view)
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig
import XMonad.Util.Run

import Codec.Binary.UTF8.String
import System.IO

main = do
  spawnPipe $ "~/.xmonad/bar"
  xmonad $
    ewmh $
    docks $
    withUrgencyHook NoUrgencyHook $
    defaultConfig
    { terminal = myTerminal
    , modMask = mod4Mask
    , borderWidth = 8
    , normalBorderColor = "#073642"
    , focusedBorderColor = activeColor
    , layoutHook = avoidStruts . smartBorders $ myLayout
    , manageHook = manageSpawn <+> myManageHook <+> manageHook defaultConfig
    , startupHook = setWMName "LG3D"
    , workspaces = myWorkspaces
    , handleEventHook = handleEventHook defaultConfig <+> fullscreenEventHook
    , logHook = myLoghook
    } `additionalKeysP`
    myKeysP

myLoghook =
  dynamicLogWithPP
    defaultPP
    { ppCurrent = lemonbarColor "-" activeColor . wrap " " " "
    , ppWsSep = ""
    , ppSep = ""
    , ppVisible = lemonbarColor "-" "-" . wrap " " " "
    , ppUrgent = lemonbarColor "-" "#dc322f" . wrap " " " "
    , ppHidden = lemonbarColor "-" "#073642" . wrap " " " "
    , ppTitle = const ""
    , ppLayout =
        \s ->
          case s of
            "Full" -> " F "
            otherwise -> ""
    , ppOutput =
        \s -> do
          h <- openFile "/tmp/xmonad" WriteMode
          hPutStrLn h (decodeString s)
          hClose h
    }

myTerminal = "urxvt"

myLayout = Tall 1 (5 / 100) (50 / 100) ||| Full

myWorkspaces = map show [1 .. 9] ++ ["0", "[", "]"]

myManageHook = myCompose <+> (fmap not isDialog --> doF avoidMaster)

activeColor = "#268bd2"

avoidMaster =
  W.modify' $ \x ->
    case x of
      W.Stack t [] (r:rs) -> W.Stack t [r] rs
      oterwise -> x

myCompose =
  composeAll
    [ (className =? "Transmission-gtk" <&&> stringProperty "WM_WINDOW_ROLE" =? "tr-main") --> doShift "9"
    , isFullscreen --> (doF W.focusDown <+> doFullFloat)
    ]

myKeysP =
  [ ("M-p", spawnHere "rofi -show run")
  , ("M-S-<Space>", spawn "cmus-remote -u")
  , ("M-S-t", spawn myTerminal)
  , ("M-q", spawn "pkill lemonbar; xmonad --recompile && xmonad --restart")
  ] ++
  [ (otherModMasks ++ "M-" ++ [key], action tag)
  | (tag, key) <- zip myWorkspaces "1234567890[]"
  , (otherModMasks, action) <- [("", windows . view), ("S-", windows . shift)]
  ]

lemonbarColor :: String -> String -> String -> String
lemonbarColor fg bg s = concat ["%{F", fg, "}%{B", bg, "}", s, "%{B-}%{F-}"]
