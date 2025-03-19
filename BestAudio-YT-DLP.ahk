#Requires AutoHotkey v2.0
#SingleInstance Force
A_IconTip := 'AutoHotKey Script used by typing "~audio" into command prompt after copying the URL of the youtube video'

#SuspendExempt true
^!r:: Reload ; Ctrl+Alt+R
#SuspendExempt false

; Define the function first
ResetYT_DLP(ItemName, ItemPos, MyMenu) {
    IniDelete("yt_dlp_path.ini", "Settings", "yt_dlp_path")
    MsgBox("YT-DLP path has been reset. Script will now reload.")
    Reload
}

; Access the tray menu correctly
MyMenu := A_TrayMenu
MyMenu.Add("Reset The Path of YT-DLP", ResetYT_DLP)

; Load yt-dlp path from INI file or prompt user
yt_dlp_path := IniRead("yt_dlp_path.ini", "Settings", "yt_dlp_path", "")

if (yt_dlp_path = "") {
    Input := InputBox("Enter the path to the yt-dlp exe", "YT-DLP Path Input",)
    if !Input.Result  ; User canceled the InputBox
        return
    yt_dlp_path := Trim(Input.Result)
    IniWrite(yt_dlp_path, "yt_dlp_path.ini", "Settings", "yt_dlp_path")
}

yt_dlp_options := '-f ba* --audio-format wav -x --no-playlist --embed-metadata' ;yt-dlp options

:*X*:~audio::
{
    old_clipboard := A_Clipboard

    command := Format('{1} {2} "{3}"', yt_dlp_path, yt_dlp_options, old_clipboard)

    A_Clipboard := command

    Send "^v"
    Sleep 500 ; Wait a bit for Ctrl+V to be processed
    A_Clipboard := old_clipboard ; Restore previous clipboard content
}
