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
$CFG_REVERSE = False

Dim $HOOKS[2][2] = [ _
                      [$MOUSE_WHEELSCROLLUP_EVENT, "mouseWheelUp"], _
                      [$MOUSE_WHEELSCROLLDOWN_EVENT, "mouseWheelDown"] _
                   ]

Opt("TrayMenuMode", 1)
$trayReverse = TrayCreateItem("Reverse scroll direction")
$trayDisable = TrayCreateItem("Disable (Gaming Mode)")
$trayExit = TrayCreateItem("Exit")
TraySetClick(16)
TraySetState()

readConfig()

If $CFG_REVERSE Then
    TrayItemSetState($trayReverse, $TRAY_CHECKED)
    swapHooks()
EndIf

registerHooks()

While 1
    $msg = TrayGetMsg()
    Select
        Case $msg = $trayExit
            Exit
        Case $msg = $trayReverse
            $CFG_REVERSE = Not $CFG_REVERSE
            writeConfig()
            
            $trayDisableState = TrayItemGetState($trayDisable)
            If BitAnd($trayDisableState, $TRAY_UNCHECKED) Then
                unregisterHooks()
            EndIf
            swapHooks()
            If BitAnd($trayDisableState, $TRAY_UNCHECKED) Then
                registerHooks()
            EndIf
        Case $msg = $trayDisable
            $trayDisableState = TrayItemGetState($trayDisable)
            Select
                Case BitAnd($trayDisableState, $TRAY_CHECKED)
                    TraySetIcon(@ScriptFullPath, 201)
                    unregisterHooks()
                Case BitAnd($trayDisableState, $TRAY_UNCHECKED)
                    TraySetIcon(@ScriptFullPath, 99)
                    registerHooks()
            EndSelect
    EndSelect

    Sleep(10)
WEnd

Func registerHooks()
    For $i = 0 To UBound($HOOKS, 1) - 1
        _MouseSetOnEvent($HOOKS[$i][0], $HOOKS[$i][1])
    Next
EndFunc

Func unregisterHooks()
    For $i = 0 To UBound($HOOKS, 1) - 1
        _MouseSetOnEvent($HOOKS[$i][0])
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
    $CFG_REVERSE = IniRead($CFG_FILE_PATH, "options", "reverse", "False") == "True"
EndFunc

Func writeConfig()
    DirCreate($CFG_DIR_PATH)
    
    IniWrite($CFG_FILE_PATH, "options", "reverse", String($CFG_REVERSE))
EndFunc
