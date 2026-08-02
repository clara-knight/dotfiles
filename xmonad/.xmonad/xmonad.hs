import XMonad
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.ManageDocks (avoidStruts, docks, manageDocks)
import XMonad.Hooks.DynamicLog
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Run (spawnPipe, hPutStrLn)
main :: IO ()
main = do
    xmproc <- spawnPipe "xmobar ~/.config/xmobar/xmobarrc"
    xmonad $ ewmh $ docks $ def
        { terminal              = "alacritty"
        , borderWidth           = 2
        , normalBorderColor     = "282a36"
        , focusedBorderColor    = "bd93f9"
        , layoutHook            = avoidStruts $ layoutHook def
        , manageHook            = manageDocks <+> manageHook def
        , logHook               = dynamicLogWithPP xmobarPP { ppOutput = hPutStrLn xmproc }
        }
        `additionalKeysP`
        [ ("M-p", spawn "dmenu_run")
		, ("<XF86AudioMute>",		 spawn "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle") -- F10
		, ("<XF86AudioLowerVolume>", spawn "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")  -- F11
		, ("<XF86AudioRaiseVolume>", spawn "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")  -- F11
        ]
