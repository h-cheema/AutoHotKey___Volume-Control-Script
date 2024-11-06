; This script is a modified version of this script: https://obrienlabs.net/use-autohotkey-toggle-default-playback-sound-device/ by https://obrienlabs.net  
; I added a few features like microphone muting, volume adjustment, code documentation and a complete overview of the script.

; It requires both nircmid.exe and SoundVolumeView.exe to work.
;;; https://www.nirsoft.net/utils/nircmd.html
;;; https://www.nirsoft.net/utils/sound_volume_view.html

; I found this small but powerful tool very handy and wanted to make it easily accessible and understandable for others.

; NOTE: In sensitive situations, you should always mute your microphone physically. 
;;; This method is just a simple quick first resort if you don't enough have time.

; For a full overview of the script, check out my github repository:
;;; https://github.com/h-cheema/Autohotkey-Volume-Control-Script



; Environment Setup...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent			; This keeps the script running permanently.
#SingleInstance		; Only allows one instance of the script to run.
#MaxThreads 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Speakers/Heaphones/Output Controls...
#WheelUp::Send {Volume_Up 2} 		; #Winkey + Scroll mouse wheel up = increase volume
#WheelDown::Send {Volume_Down 2} 	; #Winkey + Scroll mouse wheel down = decrease volume
#MButton::Volume_Mute			; #Winkey + Pressing mouse wheel = mute speakers



; Change Audio Output Device...
; Example: switch between your USB audio interface and your PC's headphone jack)
#numpadenter::		; Winkey + numpad enter = toggle audio device (Max 2 devices supported right now).
	toggle:=!toggle
	if toggle
	{
		Run c:\windows\system32\nircmd.exe setdefaultsounddevice "Headphones"	; Name of the other audio output device in your "sound control panel"
		soundToggleBox("Headphones")
	}
	else
	{

		Run c:\windows\system32\nircmd.exe setdefaultsounddevice "Speakers"		; Name of the first audio output device in your "sound control panel"
		soundToggleBox("Speakers")											
	}
Return

#Backspace::		; Winkey + numpad enter = toggle audio device (Max 2 devices supported right now).
	toggle:=!toggle
    	Run c:\windows\system32\nircmd.exe setdefaultsounddevice "Headset"	; Name of the other audio output device in your "sound control panel"
    	soundToggleBox("Headset")
Return



; Microphone/Input Muting...
#z::
	toggle:=!toggle 
	if toggle
	{
		; Uses "SoundVolumeView.exe" to adjust volume.
		; https://www.nirsoft.net/utils/sound_volume_view.html
		; Download and place the SoundVolumeView.exe file in your c:\windows\system32\ folder.
		Run c:\windows\system32\SoundVolumeView.exe /Mute "Microphone"	; Name of the audio input device in your "sound control panel".
		soundToggleBox("Mic Muted")
		
		; Plays a "on" beep once the microphone is muted
		Run c:\windows\system32\nircmd.exe beep 660 132
		sleep 20 ; Ensures the beeps are consective.
		Run c:\windows\system32\nircmd.exe beep 520 130
	}
	else
	{
		Run c:\windows\system32\SoundVolumeView.exe /Unmute "Microphone"
		soundToggleBox("Mic Unmuted")

		; Plays an "off" beep once the microphone is unmuted
		Run c:\windows\system32\nircmd.exe beep 660 132
		sleep 20 ; Ensures the beeps are consective.
		Run c:\windows\system32\nircmd.exe beep 660 132
	}
	sleep, 200 ; Creates a short pause letting the beeps play completely through.
Return


; Display sound toggle GUI...
soundToggleBox(Device)
	{
		IfWinExist, soundToggleWin
		{
			Gui, destroy
		}
		Gui, +ToolWindow -Caption +0x400000 +alwaysontop
		Gui, Add, text, x8 y8, Sound: %Device%
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


!PgDn::
	; Send Ctrl + Win + Right to go to the next desktop
	SendInput, {Ctrl Down}{LWin Down}{Right}{LWin Up}{Ctrl Up}
Return


!PgUp::
	; Send Ctrl + Win + Left to go to the next desktop
	SendInput, {Ctrl Down}{LWin Down}{Left}{LWin Up}{Ctrl Up}
Return


!MButton::
	; Send Start + Tab to open virtual desktop selection.
	SendInput, {LWin Down}{Tab}{LWin Up}
Return
