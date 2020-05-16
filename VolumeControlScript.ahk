; This script is a modified version of CinnTech's volume .ahk script.
; CinnTech's YouTube Channel: https://www.youtube.com/channel/UC5c-tua8oh8QUlmXls9AjvQ

; It requires both nircmid.exe and SoundVolumeView.exe to work.
; https://www.nirsoft.net/utils/nircmd.html
; https://www.nirsoft.net/utils/sound_volume_view.html

; I found this small but powerful tool very handy and wanted to make it easilt accessible to others.
; I've made a few changes to the formatting and allowed microphone muting. I also wanted to add an overview of how to use it.

; For a full overview of the script, check out my github repository:
; https://github.com/h-cheema/Autohotkey-Volume-Control-Script



; Environment Setup...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent			; This keeps the script running permanently.
#SingleInstance		; Only allows one instance of the script to run.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



; Display sound toggle GUI...
soundToggleBox(Device)
	{
		IfWinExist, soundToggleWin
		{
			Gui, destroy
		}
		Gui, +ToolWindow -Caption +0x400000 +alwaysontop
		Gui, Add, text, x35 y8, Default sound: %Device%
		SysGet, screenx, 0
		SysGet, screeny, 1
		xpos:=screenx-275
		ypos:=screeny-100
		Gui, Show, NoActivate x%xpos% y%ypos% h30 w200, soundToggleWin
		SetTimer,soundToggleClose, 2000 
	}
	soundToggleClose:
		SetTimer,soundToggleClose, off
		Gui, destroy
Return



; Change Audio Output Device...
; Example: switch between your USB audio interface and your PC's headphone jack)
#numpadenter::		; Winkey + numpad enter = toggle audio device (Max 2 devices supported right now).
	toggle:=!toggle
	if toggle
	{
		; Uses "nircmd.exe" to adjust volume.
		; https://www.nirsoft.net/utils/nircmd.html
		; Download and place the nircmd.exe file in a reliable place and change the url below to where you saved it.
		Run c:\windows\system32\nircmd.exe setdefaultsounddevice "Speakers"		; Name of the first audio output device in your "sound control panel"
		soundToggleBox("Speakers")											
	}
	else
	{
		Run c:\windows\system32\nircmd.exe setdefaultsounddevice "Headphones"	; Name of the other audio output device in your "sound control panel"
		soundToggleBox("Headphones")
	}
Return
; Speakers/Heaphones/Output Controls...
#WheelDown::Send {Volume_Down 1} 	; #Winkey + Scroll mouse wheel down = decrease volume
#WheelUp::Send {Volume_Up 1} 		; #Winkey + Scroll mouse wheel up = decrease volume
#MButton::Volume_Mute				; #Winkey + Pressing mouse wheel = mute speakers



; Microphone/Input Muting...
#z::
	toggle:=!toggle 
	if toggle
	{
		; Uses "SoundVolumeView.exe" to adjust volume.
		; https://www.nirsoft.net/utils/sound_volume_view.html
		; Download and place the SoundVolumeView.exe file in a reliable place and change the url below to where you saved it.
		Run c:\windows\system32\SoundVolumeView.exe /Mute "Microphone"	; Name of the audio input device in your "sound control panel".
		soundToggleBox("Mic Muted")
	}
	else
	{
		Run c:\windows\system32\SoundVolumeView.exe /Unmute "Microphone"
		soundToggleBox("Mic Unmuted")
	}
Return
