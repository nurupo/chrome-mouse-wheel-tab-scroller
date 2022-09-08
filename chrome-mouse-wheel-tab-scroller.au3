#comments-start
  Copyright (c) 2017-2022 by Maxim Biro <nurupo.contributions@gmail.com>

  SPDX-License-Identifier: GPL-3.0-only

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License version 3,
  as published by the Free Software Foundation.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <https://www.gnu.org/licenses/>.
#comments-end

#NoTrayIcon

#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_icon=icon.ico
#AutoIt3Wrapper_Res_Icon_Add=icon_disabled_right.ico
#AutoIt3Wrapper_Res_ProductName=Chrome Mouse Wheel Tab Scroller
#AutoIt3Wrapper_Res_Comment=Scroll Chrome tabs using mouse wheel
#AutoIt3Wrapper_Res_Description=Scroll Chrome tabs using mouse wheel
#AutoIt3Wrapper_Res_ProductVersion=1.0.0
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_CompanyName=Maxim Biro (nurupo)
#AutoIt3Wrapper_Res_LegalCopyright=Copyright 2017-2022 Maxim Biro (nurupo)

Const $PROJECT_HOMEPAGE_URL = "https://github.com/nurupo/chrome-mouse-wheel-tab-scroller"
Const $PROJECT_DONATE_URL   = "https://github.com/sponsors/nurupo"

#include <EditConstants.au3>
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <Misc.au3>
#include <MsgBoxConstants.au3>
#include <StaticConstants.au3>
#include <TrayConstants.au3>
#include <WinAPIRes.au3>
#include <WinAPISys.au3>
#include <WinAPISysWin.au3>
#include <WindowsConstants.au3>

#include "MouseOnEvent.au3"

; Chrome offsets and class name
Const $CHROME_TABS_AREA_HEIGHT_MAXIMIZED = 28
Const $CHROME_TABS_AREA_HEIGHT_NOT_MAXIMIZED = 48
Const $CHROME_NONTABS_AREA_RIGHT_WIDTH_OFFSET_MAXIMIZED = 200
Const $CHROME_NONTABS_AREA_RIGHT_WIDTH_OFFSET_NOT_MAXIMIZED = 150
Const $CHROME_WINDOW_CLASS_NAME_PREFIX = "Chrome_WidgetWin_"

; Config constants
Const $CFG_DIR_PATH = @AppDataDir & "\chrome-mouse-wheel-tab-scroller"
Const $CFG_FILE_PATH = $CFG_DIR_PATH & "\config.ini"
Enum $CFG_MOUSE_CAPTURE_METHOD_HOOK, _
     $CFG_MOUSE_CAPTURE_METHOD_RAWINPUT, _
     $CFG_MOUSE_CAPTURE_METHOD_MAX

; Config state
$cfgReverse = Null
$cfgAutofocus = Null
$cfgMouseCaptureMethod = Null

; Other application state
$pointStruct = DllStructCreate($tagPOINT)
Dim $HOOKS[2][2] = [ _
                      [$MOUSE_WHEELSCROLLUP_EVENT, "onMouseWheel"], _
                      [$MOUSE_WHEELSCROLLDOWN_EVENT, "onMouseWheel"] _
                   ]
$registeredMouseCaptureMethod = Null
$aboutDialogExists = False
$disabled = False

Opt("WinWaitDelay", 0)

If _Singleton(FileGetVersion(@AutoItExe, $FV_PRODUCTNAME), 1) == 0 Then
    MsgBox($MB_ICONWARNING, "Error", "Another instance of this application is already running.")
    Exit
EndIf

Opt("TrayMenuMode", 1+4)
$trayReverse = TrayCreateItem("Reverse scroll direction")
$trayAutofocus = TrayCreateItem("Autofocus window")
$trayMouseCaptureMethod = TrayCreateMenu("Mouse capture method")
$trayMouseCaptureMethodHook = TrayCreateItem("Hook", $trayMouseCaptureMethod, -1, $TRAY_ITEM_RADIO)
$trayMouseCaptureMethodRawInput = TrayCreateItem("Raw input", $trayMouseCaptureMethod, -1, $TRAY_ITEM_RADIO)
$trayDisable = TrayCreateItem("Disable (Gaming Mode)")
TrayItemSetState($trayDisable, $TRAY_DEFAULT)
$trayAbout = TrayCreateItem("About")
TrayCreateItem("")
$trayExit = TrayCreateItem("Exit")
TraySetClick($TRAY_CLICK_SECONDARYUP)
TraySetState()
TraySetToolTip(FileGetVersion(@AutoItExe, $FV_PRODUCTNAME))

readConfig()
processConfig()
registerHooks()

While 1
    processTrayEvents()
WEnd

Func processTrayEvents()
    Switch TrayGetMsg()
        Case $trayReverse
            $cfgReverse = Not $cfgReverse
            writeConfig()
        Case $trayAutofocus
            Local $trayAutofocusState = TrayItemGetState($trayAutofocus)
            Select
                Case BitAND($trayAutofocusState, $TRAY_CHECKED)
                    $cfgAutofocus = 1
                Case BitAND($trayAutofocusState, $TRAY_UNCHECKED)
                    $cfgAutofocus = 0
            EndSelect
            writeConfig()
        Case $TRAY_EVENT_PRIMARYUP
            Local $trayDisableState = TrayItemGetState($trayDisable)
            Select
                Case BitAND($trayDisableState, $TRAY_CHECKED)
                    $trayDisableState = BitXOR($trayDisableState, $TRAY_CHECKED)
                    $trayDisableState = BitOR($trayDisableState, $TRAY_UNCHECKED)
                Case BitAND($trayDisableState, $TRAY_UNCHECKED)
                    $trayDisableState = BitXOR($trayDisableState, $TRAY_UNCHECKED)
                    $trayDisableState = BitOR($trayDisableState, $TRAY_CHECKED)
            EndSelect
            TrayItemSetState($trayDisable, $trayDisableState)
            ContinueCase
        Case $trayDisable
            Local $trayDisableState = TrayItemGetState($trayDisable)
            Select
                Case BitAND($trayDisableState, $TRAY_CHECKED)
                    TraySetIcon(@ScriptFullPath, 201)
                    unregisterHooks()
                    $disabled = True
                Case BitAND($trayDisableState, $TRAY_UNCHECKED)
                    TraySetIcon(@ScriptFullPath, 99)
                    $disabled = False
                    registerHooks()
            EndSelect
        Case $trayMouseCaptureMethodHook
            $cfgMouseCaptureMethod = $CFG_MOUSE_CAPTURE_METHOD_HOOK
            writeConfig()
            unregisterHooks()
            registerHooks()
        Case $trayMouseCaptureMethodRawInput
            $cfgMouseCaptureMethod = $CFG_MOUSE_CAPTURE_METHOD_RAWINPUT
            writeConfig()
            unregisterHooks()
            registerHooks()
        Case $trayAbout
            Local $trayAboutState = TrayItemGetState($trayAbout)
            $trayAboutState = BitXOR($trayAboutState, $TRAY_CHECKED)
            $trayAboutState = BitOR($trayAboutState, $TRAY_UNCHECKED)
            TrayItemSetState($trayAbout, $trayAboutState)
            If Not $aboutDialogExists Then
                $aboutDialogExists = True
                aboutDialog()
                $aboutDialogExists = False
            EndIf
        Case $trayExit
            Exit
    EndSwitch
EndFunc

Func registerHooks()
    If $disabled Then
        Return
    EndIf
    For $i = 0 To UBound($HOOKS, 1) - 1
        Switch $cfgMouseCaptureMethod
            Case $CFG_MOUSE_CAPTURE_METHOD_HOOK
                _MouseSetOnEvent($HOOKS[$i][0], $HOOKS[$i][1], 0, $MOE_RUNDEFPROC)
            Case $CFG_MOUSE_CAPTURE_METHOD_RAWINPUT
                _MouseSetOnEvent_RI($HOOKS[$i][0], $HOOKS[$i][1])
        EndSwitch
    Next
    $registeredMouseCaptureMethod = $cfgMouseCaptureMethod
EndFunc

Func unregisterHooks()
    If $disabled Then
        Return
    EndIf
    For $i = 0 To UBound($HOOKS, 1) - 1
        Switch $registeredMouseCaptureMethod
            Case $CFG_MOUSE_CAPTURE_METHOD_HOOK
                _MouseSetOnEvent($HOOKS[$i][0])
            Case $CFG_MOUSE_CAPTURE_METHOD_RAWINPUT
                _MouseSetOnEvent_RI($HOOKS[$i][0])
        EndSwitch
    Next
EndFunc

Func chromeWindowHandleWhenMouseInChromeTabsArea()
    Local $mousePos = MouseGetPos()
    DllStructSetData($pointStruct, "x", $mousePos[0])
    DllStructSetData($pointStruct, "y", $mousePos[1])
    Local $windowHandle = _WinAPI_WindowFromPoint($pointStruct)
    Local $className = _WinAPI_GetClassName($windowHandle)
    If StringLeft($className, StringLen($CHROME_WINDOW_CLASS_NAME_PREFIX)) <> $CHROME_WINDOW_CLASS_NAME_PREFIX Then
        Return 0
    EndIf
    Local $windowPos = WinGetPos($windowHandle)
    Local $windowStateBitmask = WinGetState($windowHandle)
    If BitAND($windowStateBitmask, $WIN_STATE_MAXIMIZED) Then
        ; For some reason Chrome's X and Y positions are -8 when the window is maximized, so if it's negative we assume it's 0
        If $windowPos[1] < 0 Then $windowPos[1] = 0
        If $mousePos[1] - $windowPos[1] <= $CHROME_TABS_AREA_HEIGHT_MAXIMIZED And _ ; bottom bound
            $windowPos[0] +  $windowPos[2] - $mousePos[0] >= $CHROME_NONTABS_AREA_RIGHT_WIDTH_OFFSET_MAXIMIZED _ ; right bound
            Then Return $windowHandle
    Else
        If $mousePos[1] - $windowPos[1] <= $CHROME_TABS_AREA_HEIGHT_NOT_MAXIMIZED And _ ; bottom bound
            $windowPos[0] +  $windowPos[2] - $mousePos[0] >= $CHROME_NONTABS_AREA_RIGHT_WIDTH_OFFSET_NOT_MAXIMIZED And _ ; right bound
            $mousePos[1] >= $windowPos[1] And _ ; top bound
            $mousePos[0] >= $windowPos[0] _ ; left bound
            Then Return $windowHandle
    EndIf
    Return 0
EndFunc

; True if we should proceed with switching tabs, False otherwise
Func handleAutofocus($windowHandle)
    Local $windowStateBitmask = WinGetState($windowHandle)
    If BitAND($windowStateBitmask, $WIN_STATE_ACTIVE) Then
        return True
    EndIf
    If Not $cfgAutofocus Then
        return False
    Else
        Return _
            WinActivate($windowHandle) <> 0 And _
            WinWaitActive($windowHandle, "", 1) <> 0
    EndIf
EndFunc

Func onMouseWheel($event)
    If Not handleAutofocus(chromeWindowHandleWhenMouseInChromeTabsArea()) Then
        Return
    EndIf
    Switch $event
        Case $MOUSE_WHEELSCROLLUP_EVENT
            Send($cfgReverse ? "^{PGDN}" : "^{PGUP}")
        Case $MOUSE_WHEELSCROLLDOWN_EVENT
            Send($cfgReverse ? "^{PGUP}" : "^{PGDN}")
    EndSwitch
EndFunc

Func readConfig()
    $cfgReverse = Int(IniRead($CFG_FILE_PATH, "options", "reverse", 0)) == 1
    $cfgAutofocus = Int(IniRead($CFG_FILE_PATH, "options", "autofocus", 1)) == 1
    $cfgMouseCaptureMethod = Int(IniRead($CFG_FILE_PATH, "options", "mouseCaptureMethod", $CFG_MOUSE_CAPTURE_METHOD_RAWINPUT))
    If $cfgMouseCaptureMethod < 0 Or $cfgMouseCaptureMethod >= $CFG_MOUSE_CAPTURE_METHOD_MAX Then
        ConsoleWrite("Warning: Incorrect value for the mouseCaptureMethod option in " & $CFG_FILE_PATH &", using the default: mouseCaptureMethod=" & $CFG_MOUSE_CAPTURE_METHOD_RAWINPUT & @CRLF)
        $cfgMouseCaptureMethod = $CFG_MOUSE_CAPTURE_METHOD_RAWINPUT
    EndIf
EndFunc

Func writeConfig()
    DirCreate($CFG_DIR_PATH)

    IniWrite($CFG_FILE_PATH, "options", "reverse", Int($cfgReverse))
    IniWrite($CFG_FILE_PATH, "options", "autofocus", Int($cfgAutofocus))
    IniWrite($CFG_FILE_PATH, "options", "mouseCaptureMethod", $cfgMouseCaptureMethod)
EndFunc

Func processConfig()
    If $cfgReverse Then
        TrayItemSetState($trayReverse, $TRAY_CHECKED)
    EndIf

    If $cfgAutofocus Then
        TrayItemSetState($trayAutofocus, $TRAY_CHECKED)
    EndIf

    Switch $cfgMouseCaptureMethod
        Case $CFG_MOUSE_CAPTURE_METHOD_HOOK
            TrayItemSetState($trayMouseCaptureMethodHook, $TRAY_CHECKED)
        Case $CFG_MOUSE_CAPTURE_METHOD_RAWINPUT
            TrayItemSetState($trayMouseCaptureMethodRawInput, $TRAY_CHECKED)
    EndSwitch
EndFunc

Func aboutDialog()
    $formAbout = GUICreate("About", 682, 354, -1, -1, -1, BitOR($WS_EX_TOPMOST,$WS_EX_WINDOWEDGE))
    ; Disable the maximize button (no layouting breaks the form when maximized)
    _WinAPI_SetWindowLong(-1, $GWL_STYLE, BitXOr(_WinAPI_GetWindowLong(-1, $GWL_STYLE), $WS_MAXIMIZEBOX))
    GUISetBkColor(0xFFFFFF)
    GUICtrlCreateLabel(FileGetVersion(@AutoItExe, $FV_PRODUCTNAME), 152, 16, 526, 31)
    GUICtrlSetFont(-1, 18)
    GUICtrlCreateIcon(@AutoItExe, 99, 8, 8, 128, 128)
    GUICtrlCreateLabel(FileGetVersion(@AutoItExe, $FV_FILEDESCRIPTION), 152, 48, 526, 22)
    GUICtrlSetFont(-1, 12)
    GUICtrlCreateLabel(FileGetVersion(@AutoItExe, $FV_LEGALCOPYRIGHT), 152, 88, 526, 20)
    GUICtrlSetFont(-1, 10)
    GUICtrlCreateLabel("Version " & FileGetVersion(@AutoItExe, $FV_PRODUCTVERSION), 152, 112, 385, 20)
    GUICtrlSetFont(-1, 10)
    $labelHomepage = GUICtrlCreateLabel("Homepage", 544, 112, 66, 20)
    GUICtrlSetFont(-1, 10, $FW_NORMAL, 4)
    GUICtrlSetColor(-1, 0x0000FF)
    GUICtrlSetCursor (-1, $MCID_HAND)
    $labelDonate = GUICtrlCreateLabel("Donate", 624, 112, 45, 20)
    GUICtrlSetFont(-1, 10, $FW_NORMAL, 4)
    GUICtrlSetColor(-1, 0x0000FF)
    GUICtrlSetCursor (-1, $MCID_HAND)
    GUICtrlCreateEdit("", 8, 144, 665, 201, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_READONLY, $ES_WANTRETURN, $WS_VSCROLL))
    GUICtrlSetData(-1, StringFormat( _
        FileGetVersion(@AutoItExe, $FV_PRODUCTNAME) & @CRLF & _
        "Author: " & FileGetVersion(@AutoItExe, $FV_COMPANYNAME) & @CRLF & _
        "Homepage: " & $PROJECT_HOMEPAGE_URL & @CRLF & _
        "Donate: " & $PROJECT_DONATE_URL & @CRLF & _
        "" & @CRLF & _
        "Credits:" & @CRLF & _
        "" & @CRLF & _
        "MouseOnEvent UDF" & @CRLF & _
        "Author: G.Sandler a.k.a (Mr)CreatoR (CreatoR"&Chr(39)&"s Lab - http://creator-lab.ucoz.ru, http://autoit-script.ru)" & @CRLF & _
        "Homepage: https://www.autoitscript.com/forum/topic/64738-mouseonevent-udf/" & @CRLF & _
        "" & @CRLF & _
        "Google Chrome icon" & @CRLF & _
        "Author: Just UI (https://www.iconfinder.com/justui)" & @CRLF & _
        "Homepage: https://www.iconfinder.com/icons/1298719/chrome_google_icon" & @CRLF & _
        "" & @CRLF & _
        "tab icon" & @CRLF & _
        "Author: Everaldo Coelho (http://www.everaldo.com/)" & @CRLF & _
        "Homepage: https://www.iconfinder.com/icons/3256/tab_icon" & @CRLF & _
        "" & @CRLF & _
        "x icon" & @CRLF & _
        "Author: iconpack (https://www.iconfinder.com/iconpack)" & @CRLF & _
        "Homepage: https://www.iconfinder.com/icons/1398917/circle_close_cross_delete_incorrect_invalid_x_icon" _
        ))
    GUICtrlSetFont(-1, 10)
    GUICtrlSetBkColor(-1, 0xFFFFFF)
    GUISetState(@SW_SHOW)

    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE
                ExitLoop
            Case $labelHomepage
                ShellExecute($PROJECT_HOMEPAGE_URL)
            Case $labelDonate
                ShellExecute($PROJECT_DONATE_URL)
        EndSwitch
        processTrayEvents()
    WEnd

    GUIDelete($formAbout)
EndFunc
