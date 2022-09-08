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
#AutoIt3Wrapper_Res_Icon_Add=icon_disabled.ico
#AutoIt3Wrapper_Res_Comment=Scroll Chrome tabs using mouse wheel
#AutoIt3Wrapper_Res_Description=Scroll Chrome tabs using mouse wheel
#AutoIt3Wrapper_Res_Fileversion=0.2.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Maxim Biro

#include "MouseOnEvent.au3"

Const $CHROME_TABS_AREA_HEIGHT_MAXIMIZED = 28
Const $CHROME_TABS_AREA_HEIGHT_NOT_MAXIMIZED = 48
Const $CHROME_NONTABS_AREA_RIGHT_WIDTH_OFFSET_MAXIMIZED = 200
Const $CHROME_NONTABS_AREA_RIGHT_WIDTH_OFFSET_NOT_MAXIMIZED = 150

Const $CFG_DIR_PATH = @AppDataDir & "\chrome-mouse-wheel-tab-scroller"
Const $CFG_FILE_PATH = $CFG_DIR_PATH & "\config.ini"
Enum $CFG_MOUSE_CAPTURE_METHOD_HOOK, _
     $CFG_MOUSE_CAPTURE_METHOD_RAWINPUT, _
     $CFG_MOUSE_CAPTURE_METHOD_MAX

$cfgReverse = False
$cfgMouseCaptureMethod = Null

Dim $HOOKS[2][2] = [ _
                      [$MOUSE_WHEELSCROLLUP_EVENT, "mouseWheelUp"], _
                      [$MOUSE_WHEELSCROLLDOWN_EVENT, "mouseWheelDown"] _
                   ]
$registeredMouseCaptureMethod = Null
$disabled = False

Opt("TrayMenuMode", 1)
$trayReverse = TrayCreateItem("Reverse scroll direction")
$trayMouseCaptureMethod = TrayCreateMenu("Mouse capture method")
$trayMouseCaptureMethodHook = TrayCreateItem("Hook", $trayMouseCaptureMethod, -1, $TRAY_ITEM_RADIO)
$trayMouseCaptureMethodRawInput = TrayCreateItem("Raw input", $trayMouseCaptureMethod, -1, $TRAY_ITEM_RADIO)
$trayDisable = TrayCreateItem("Disable (Gaming Mode)")
$trayExit = TrayCreateItem("Exit")
TraySetClick(16)
TraySetState()

readConfig()
processConfig()
registerHooks()

While 1
    Switch TrayGetMsg()
        Case $trayReverse
            $cfgReverse = Not $cfgReverse
            writeConfig()

            $trayDisableState = TrayItemGetState($trayDisable)
            If BitAnd($trayDisableState, $TRAY_UNCHECKED) Then
                unregisterHooks()
            EndIf
            swapHooks()
            If BitAnd($trayDisableState, $TRAY_UNCHECKED) Then
                registerHooks()
            EndIf
        Case $trayDisable
            $trayDisableState = TrayItemGetState($trayDisable)
            Select
                Case BitAnd($trayDisableState, $TRAY_CHECKED)
                    TraySetIcon(@ScriptFullPath, 201)
                    unregisterHooks()
                    $disabled = True
                Case BitAnd($trayDisableState, $TRAY_UNCHECKED)
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
        Case $trayExit
            Exit
    EndSwitch
WEnd

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

Func swapHooks()
    $tmp = $HOOKS[0][0]
    $HOOKS[0][0] = $HOOKS[1][0]
    $HOOKS[1][0] = $tmp
EndFunc

Func isMouseInChromeTabsArea()
    $windowList = WinList("[REGEXPCLASS:Chrome_WidgetWin_]")
    For $i = 1 To $windowList[0][0]
        $windowStateBitmask = WinGetState($windowList[$i][1])
        $isWindowActive = BitAND($windowStateBitmask, 8)
        If $isWindowActive Then
            $mousePos = MouseGetPos()
            $windowPos = WinGetPos($windowList[$i][1])
            $isWindowMaximized = BitAND($windowStateBitmask, 32)
            If $isWindowMaximized Then
                ; For some reason Chrome's Y position is -8 when the window is maximized, so if it's negative we assume it's 0
                If $windowPos[1] < 0 Then $windowPos[1] = 0
                Return $mousePos[1] - $windowPos[1] <= $CHROME_TABS_AREA_HEIGHT_MAXIMIZED And _ ; bottom bound
                        $windowPos[0] +  $windowPos[2] - $mousePos[0] >= $CHROME_NONTABS_AREA_RIGHT_WIDTH_OFFSET_MAXIMIZED ; right bound
            Else
                Return $mousePos[1] - $windowPos[1] <= $CHROME_TABS_AREA_HEIGHT_NOT_MAXIMIZED And _ ; bottom bound
                        $windowPos[0] +  $windowPos[2] - $mousePos[0] >= $CHROME_NONTABS_AREA_RIGHT_WIDTH_OFFSET_NOT_MAXIMIZED And _ ; right bound
                        $mousePos[1] >= $windowPos[1] And _ ; top bound
                        $mousePos[0] >= $windowPos[0] ; left bound
            EndIf
        EndIf
    Next
    Return False
EndFunc

Func mouseWheelUp()
    If isMouseInChromeTabsArea() Then
        Send("^{PGUP}")
    EndIf
EndFunc

Func mouseWheelDown()
    If isMouseInChromeTabsArea() Then
        Send("^{PGDN}")
    EndIf
EndFunc

Func readConfig()
    $cfgReverse = Int(IniRead($CFG_FILE_PATH, "options", "reverse", 0)) == 1
    $cfgMouseCaptureMethod = Int(IniRead($CFG_FILE_PATH, "options", "mouseCaptureMethod", $CFG_MOUSE_CAPTURE_METHOD_RAWINPUT))
    If $cfgMouseCaptureMethod < 0 Or $cfgMouseCaptureMethod >= $CFG_MOUSE_CAPTURE_METHOD_MAX Then
        ConsoleWrite("Warning: Incorrect value for the mouseCaptureMethod option in " & $CFG_FILE_PATH &", using the default: mouseCaptureMethod=" & $CFG_MOUSE_CAPTURE_METHOD_RAWINPUT & @CRLF)
        $cfgMouseCaptureMethod = $CFG_MOUSE_CAPTURE_METHOD_RAWINPUT
    EndIf
EndFunc

Func writeConfig()
    DirCreate($CFG_DIR_PATH)

    IniWrite($CFG_FILE_PATH, "options", "reverse", Int($cfgReverse))
    IniWrite($CFG_FILE_PATH, "options", "mouseCaptureMethod", $cfgMouseCaptureMethod)
EndFunc

Func processConfig()
    If $cfgReverse Then
        TrayItemSetState($trayReverse, $TRAY_CHECKED)
    EndIf

    Switch $cfgMouseCaptureMethod
        Case $CFG_MOUSE_CAPTURE_METHOD_HOOK
            TrayItemSetState($trayMouseCaptureMethodHook, $TRAY_CHECKED)
        Case $CFG_MOUSE_CAPTURE_METHOD_RAWINPUT
            TrayItemSetState($trayMouseCaptureMethodRawInput, $TRAY_CHECKED)
    EndSwitch
EndFunc
