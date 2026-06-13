return {
    mainMod = "SUPER",
    altMod = "ALT",

    terminal = "kitty",
    fileManager = "thunar",
    browser = "brave --password-store=basic",
    menu = "rofi -show drun",

    waybarToggle = "~/.config/waybar/script/toggle.sh",
    wallpaperSelector = "~/.config/hypr/script/wallpaper_selector.sh",
    lockscreen = "~/.config/hypr/script/lockscreen.sh",
    clipboard = "~/.config/hypr/script/clipboard.sh | wl-copy",

    animationsEnabled = false,
    waybarStart = "$HOME/.config/hypr/script/waybar.sh",
    wallpaperDaemon = "awww-daemon",
    wallpaperCmd = "sleep 1 && awww img $HOME/Pictures/wallpapers/MaiPhuongDangIu.jpg --transition-type center",
}
