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
#AutoIt3Wrapper_Res_ProductVersion=2.0.1
#AutoIt3Wrapper_Res_Fileversion=2.0.1.0
#AutoIt3Wrapper_Res_CompanyName=Maxim Biro (nurupo)
#AutoIt3Wrapper_Res_LegalCopyright=Copyright 2017-2022 Maxim Biro (nurupo)

Global Const $PROJECT_HOMEPAGE_URL = "https://github.com/nurupo/chrome-mouse-wheel-tab-scroller"
Global Const $PROJECT_DONATE_URL   = "https://github.com/sponsors/nurupo"

#include <EditConstants.au3>
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <Misc.au3>
#include <MsgBoxConstants.au3>
#include <StaticConstants.au3>
#include <TrayConstants.au3>
#include <WinAPIProc.au3>
#include <WinAPIRes.au3>
#include <WinAPISys.au3>
#include <WinAPISysWin.au3>
#include <WindowsConstants.au3>

Opt("MustDeclareVars", 1)
Opt("WinWaitDelay", 0)

; Chrome offsets and class name
Global Const $CHROME_TABS_AREA_HEIGHT_MAXIMIZED = 33
Global Const $CHROME_TABS_AREA_HEIGHT_NOT_MAXIMIZED = 46
Global Const $CHROME_NONTABS_AREA_RIGHT_WIDTH_OFFSET_MAXIMIZED = 200
Global Const $CHROME_NONTABS_AREA_RIGHT_WIDTH_OFFSET_NOT_MAXIMIZED = 150
Global Const $CHROME_WINDOW_CLASS_NAME_PREFIX = "Chrome_WidgetWin_"
Global Const $CHROME_CONTROL_CLASS_NAME = "Chrome_RenderWidgetHostHWND"

; Config constants
Global Const $CFG_DIR_PATH = @AppDataDir & "\chrome-mouse-wheel-tab-scroller"
Global Const $CFG_FILE_PATH = $CFG_DIR_PATH & "\config.ini"
Global Enum $CFG_AUTOFOCUS_AFTERWARDS_KEEP, _
            $CFG_AUTOFOCUS_AFTERWARDS_UNDO, _
            $CFG_AUTOFOCUS_AFTERWARDS_MAX
Global $CFG_AUTOFOCUS_FOCUS_DELAY_VALUES = [3, 4, 5, 8, 11, 15, 20, 25, 30, 35, 40, 50, 75, 100]
Global $CFG_AUTOFOCUS_FOCUS_DELAY_VALUES_DEFAULT_INDEX = 7 ; 25
If $CFG_AUTOFOCUS_FOCUS_DELAY_VALUES_DEFAULT_INDEX >= UBound($CFG_AUTOFOCUS_FOCUS_DELAY_VALUES) Or _
    $CFG_AUTOFOCUS_FOCUS_DELAY_VALUES_DEFAULT_INDEX < 0 Then
    ConsoleWrite("Error: Fix $CFG_AUTOFOCUS_FOCUS_DELAY_VALUES_DEFAULT_INDEX value" & @CRLF)
EndIf

; Config state
Global $cfgReverse = Null
Global $cfgAutofocus = Null
Global $cfgAutofocusAfterwards = Null
Global $cfgAutofocusFocusDelay = Null

; Other application state
Global Enum $MOUSE_WHEEL_SCROLL_UP_EVENT, _
            $MOUSE_WHEEL_SCROLL_DOWN_EVENT
Global $disabled = False

If _Singleton(FileGetVersion(@AutoItExe, $FV_PRODUCTNAME), 1) == 0 Then
    MsgBox($MB_ICONWARNING, "Error", "Another instance of this application is already running.")
    Exit
EndIf

Global Const $inputHandlerForm = GUICreate(FileGetVersion(@AutoItExe, $FV_PRODUCTNAME) & " Raw Input Handler Window")
setupRawInputHandler()

Opt("TrayMenuMode", 1+4)
Global $trayReverse = TrayCreateItem("Reverse the scroll direction")
Global $trayAutofocus = TrayCreateItem("Autofocus Chrome")
Global $trayAutofocusAfterwards = TrayCreateMenu("After autofocusing")
Global $trayAutofocusAfterwardsKeep = TrayCreateItem("Keep it focused", $trayAutofocusAfterwards, -1, $TRAY_ITEM_RADIO)
Global $trayAutofocusAfterwardsUndo = TrayCreateItem("Undo the autofocus (Experimental)", $trayAutofocusAfterwards, -1, $TRAY_ITEM_RADIO)
Global $trayAutofocusFocusDelay = TrayCreateMenu("Wait after focusing")
Global $trayAutofocusFocusDelayValues[UBound($CFG_AUTOFOCUS_FOCUS_DELAY_VALUES)]
For $i = 0 To UBound($trayAutofocusFocusDelayValues)-1
    $trayAutofocusFocusDelayValues[$i] = TrayCreateItem($CFG_AUTOFOCUS_FOCUS_DELAY_VALUES[$i] & " ms" & _
                                                   ($i == $CFG_AUTOFOCUS_FOCUS_DELAY_VALUES_DEFAULT_INDEX ? " (Default)" : ""), _
                                                   $trayAutofocusFocusDelay, -1, $TRAY_ITEM_RADIO)
Next
Global $trayDisable = TrayCreateItem("Disable")
TrayItemSetState($trayDisable, $TRAY_DEFAULT)
Global $trayAbout = TrayCreateItem("About")
TrayCreateItem("")
Global $trayExit = TrayCreateItem("Exit")
TraySetClick($TRAY_CLICK_SECONDARYUP)
TraySetState()
TraySetToolTip(FileGetVersion(@AutoItExe, $FV_PRODUCTNAME))

readConfig()
processConfig()

While 1
    processTrayEvents()
WEnd

Func processTrayEvents()
    Local $msg = TrayGetMsg()
    Switch $msg
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
                    $disabled = True
                Case BitAND($trayDisableState, $TRAY_UNCHECKED)
                    TraySetIcon(@ScriptFullPath, 99)
                    $disabled = False
            EndSelect
        Case $trayAutofocusAfterwardsKeep
            $cfgAutofocusAfterwards = $CFG_AUTOFOCUS_AFTERWARDS_KEEP
            writeConfig()
        Case $trayAutofocusAfterwardsUndo
            $cfgAutofocusAfterwards = $CFG_AUTOFOCUS_AFTERWARDS_UNDO
            writeConfig()
        Case $trayAbout
            Local $trayAboutState = TrayItemGetState($trayAbout)
            $trayAboutState = BitXOR($trayAboutState, $TRAY_CHECKED)
            $trayAboutState = BitOR($trayAboutState, $TRAY_UNCHECKED)
            TrayItemSetState($trayAbout, $trayAboutState)
            Local Static $aboutDialogExists = False
            If Not $aboutDialogExists Then
                $aboutDialogExists = True
                aboutDialog()
                $aboutDialogExists = False
            EndIf
        Case $trayExit
            Exit
        Case Else
            For $i = 0 To UBound($trayAutofocusFocusDelayValues)-1
                If $msg == $trayAutofocusFocusDelayValues[$i] Then
                    $cfgAutofocusFocusDelay = $CFG_AUTOFOCUS_FOCUS_DELAY_VALUES[$i]
                    writeConfig()
                    ExitLoop
                EndIf
            Next
    EndSwitch
EndFunc

Func setupRawInputHandler()
    Local $tRID = DllStructCreate($tagRAWINPUTDEVICE)
    DllStructSetData($tRID, "UsagePage", 0x01) ; Generic Desktop Controls
    DllStructSetData($tRID, "Usage", 0x02) ; Mouse
    DllStructSetData($tRID, "Flags", $RIDEV_INPUTSINK)
    DllStructSetData($tRID, "hTarget", $inputHandlerForm)
    _WinAPI_RegisterRawInputDevices($tRID)
    GUIRegisterMsg($WM_INPUT, "WM_INPUT")
EndFunc

Func WM_INPUT($hWnd, $iMsg, $wParam, $lParam)
    #forceref $iMsg, $wParam
    If $hWnd <> $inputHandlerForm Then
        Return
    EndIf
    If $disabled Then
        Return
    EndIf
    Local $tRIM = DllStructCreate($tagRAWINPUTMOUSE)
    If Not _WinAPI_GetRawInputData($lParam, $tRIM, DllStructGetSize($tRIM), $RID_INPUT) Then
        Return
    EndIf
    Local $iFlags = DllStructGetData($tRIM, 'ButtonFlags')
    If BitAND($iFlags, $RI_MOUSE_WHEEL) Then
        onMouseWheel(_WinAPI_WordToShort(DllStructGetData($tRIM, 'ButtonData')) > 0 ? $MOUSE_WHEEL_SCROLL_UP_EVENT : $MOUSE_WHEEL_SCROLL_DOWN_EVENT)
    EndIf
EndFunc

Func chromeWindowHandleWhenMouseInChromeTabsArea()
    Local Static $pointStruct = DllStructCreate($tagPOINT)
    Local $mousePos = MouseGetPos()
    DllStructSetData($pointStruct, "x", $mousePos[0])
    DllStructSetData($pointStruct, "y", $mousePos[1])
    Local $windowHandle = _WinAPI_WindowFromPoint($pointStruct)
    Local $className = _WinAPI_GetClassName($windowHandle)
    If StringLeft($className, StringLen($CHROME_WINDOW_CLASS_NAME_PREFIX)) <> $CHROME_WINDOW_CLASS_NAME_PREFIX Then
        Return 0
    EndIf
    Local $title = WinGetTitle($windowHandle)
    If $title == "" Then
        ; it's a tab preview window handle, let us get a handle to the actual Chrome window
        $windowHandle = _WinAPI_GetAncestor($windowHandle, $GA_ROOTOWNER)
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

Func _WinWaitActive($windowHandle, $unused, $timeout)
    Local $activeFlag = Null
    $timeout *= 1000
    Local $timer = TimerInit()
    Do
        Local $state = WinGetState($windowHandle)
        $activeFlag = BitAND($state, $WIN_STATE_ACTIVE)
    Until $activeFlag Or TimerDiff($timer) >= $timeout
    If $activeFlag Then
        _Sleep($cfgAutofocusFocusDelay)
    EndIf
    Return $activeFlag ? $windowHandle : 0
EndFunc

Func _Sleep($ms)
    Local $leftToSleep = $ms
    Local $timer
    If $ms > 1 Then
        Local Static $ntdll = DllOpen("ntdll.dll")
        Local Static $winmmdll = DllOpen("winmm.dll")
        DllCall($winmmdll, "int", "timeBeginPeriod", "int", 1)
        Local $timerDiff
        Do
            $timer = TimerInit()
            DllCall($ntdll, "dword", "NtDelayExecution", "int", 0, "int64*", -5000)
            $timerDiff = TimerDiff($timer)
            $leftToSleep -= $timerDiff
        Until $leftToSleep <= $timerDiff
        DllCall($winmmdll, "int", "timeEndPeriod", "int", 1)
    EndIf
    If $leftToSleep > 0 Then
        $timer = TimerInit()
        Do
        Until TimerDiff($timer) >= $leftToSleep
    EndIf
EndFunc

Func onMouseWheel($event)
    Local $windowHandle = chromeWindowHandleWhenMouseInChromeTabsArea()
    If Not $windowHandle Then
        Return
    EndIf
    Local $windowStateBitmask = WinGetState($windowHandle)
    If BitAND($windowStateBitmask, $WIN_STATE_ACTIVE) Then
        processEvent($windowHandle, $event)
    ElseIf $cfgAutofocus Then
        Switch $cfgAutofocusAfterwards
            Case $CFG_AUTOFOCUS_AFTERWARDS_KEEP
                If WinActivate($windowHandle) <> 0 And _WinWaitActive($windowHandle, "", 1) <> 0 Then
                    processEvent($windowHandle, $event)
                EndIf
            Case $CFG_AUTOFOCUS_AFTERWARDS_UNDO
                Local $initiallyActive = WinGetHandle("[ACTIVE]")
                Local $epilogueOpaque = autofocusAfterwardsUndoPrologue($windowHandle)
                If $epilogueOpaque <> Null Then
                    If WinActivate($windowHandle) <> 0 And _WinWaitActive($windowHandle, "", 1) <> 0 Then
                        processEvent($windowHandle, $event)
                    EndIf
                    autofocusAfterwardsUndoEpilogue($epilogueOpaque)
                    WinActivate($initiallyActive)
                    _WinWaitActive($initiallyActive, "", 1)
                EndIf
        EndSwitch
    EndIf
EndFunc

Func autofocusAfterwardsUndoPrologue($windowHandle)
    Local $initialWinList = WinList()
    Local $topmostWinList[$initialWinList[0][0]+1]
    Local $foundIndex = -1
    Local $setWindowPosCount = 0
    ; figure out which windows we want to make temporarily topmost and which are already topmost
    For $i = 1 to $initialWinList[0][0]
        If $initialWinList[$i][1] == $windowHandle Then
            $foundIndex = $i
        EndIf
        $topmostWinList[$i] = False
        Local $state = WinGetState($initialWinList[$i][1])
        If BitAND($state, $WIN_STATE_VISIBLE) And Not BitAND($state, $WIN_STATE_MINIMIZED) Then
            $topmostWinList[$i] = BitAND(_WinAPI_GetWindowLong($initialWinList[$i][1], $GWL_EXSTYLE), $WS_EX_TOPMOST) == $WS_EX_TOPMOST
            If ($foundIndex == -1 And $initialWinList[$i][0] <> "") Or $topmostWinList[$i] Then
                $setWindowPosCount += 1
            Else
                $initialWinList[$i][1] = 0
            EndIf
        Else
            $initialWinList[$i][1] = 0
        EndIf
    Next
    If $foundIndex <= 0 Or $setWindowPosCount <= 0 Then
        Return Null
    EndIf
    Do
        Local $count = 0
        Local $windowPosInfo = _WinAPI_BeginDeferWindowPos($setWindowPosCount)
        ; first move non-topmost windows to the top (by making them temporarily topmost)
        For $i = $foundIndex-1 To 1 Step -1
            If $initialWinList[$i][1] And Not $topmostWinList[$i] Then
                $count += 1
                $windowPosInfo = _WinAPI_DeferWindowPos($windowPosInfo, $initialWinList[$i][1], $HWND_TOPMOST, 0, 0, 0, 0, BitOR($SWP_NOACTIVATE, $SWP_NOMOVE, $SWP_NOSIZE, $SWP_NOOWNERZORDER))
                ;ConsoleWrite("+tmp on-top: " & $windowPosInfo & ", " & $initialWinList[$i][1] & ", " & $initialWinList[$i][0] & @CRLF)
                If Not $windowPosInfo Then
                    ;ConsoleWrite("! removing" & @CRLF)
                    $initialWinList[$i][1] = 0
                    ExitLoop
                EndIf
            EndIf
        Next
        ; then move all of the topmost ones to the top, over the temporarily topmost ones
        If $windowPosInfo Then
            For $i = $initialWinList[0][0] To 1 Step -1
                If $initialWinList[$i][1] And $topmostWinList[$i] Then
                    $count += 1
                    $windowPosInfo = _WinAPI_DeferWindowPos($windowPosInfo, $initialWinList[$i][1], $HWND_TOPMOST, 0, 0, 0, 0, BitOR($SWP_NOACTIVATE, $SWP_NOMOVE, $SWP_NOSIZE, $SWP_NOOWNERZORDER))
                    ;ConsoleWrite("perm on-top: " & $windowPosInfo & ", " & $initialWinList[$i][1] & ", " & $initialWinList[$i][0] & @CRLF)
                    If Not $windowPosInfo Then
                        ;ConsoleWrite("! removing" & @CRLF)
                        $initialWinList[$i][1] = 0
                        ExitLoop
                    EndIf
                EndIf
            Next
        EndIf
        Local $windowPosSuccess = False
        If $windowPosInfo Then
            $windowPosSuccess = _WinAPI_EndDeferWindowPos($windowPosInfo)
            ;ConsoleWrite("end: " & $windowPosSuccess & @CRLF)
        EndIf
    Until $windowPosSuccess Or $count == 0
    Local $epilogueOpaque[4] = [$initialWinList, $topmostWinList, $foundIndex, $setWindowPosCount]
    Return $epilogueOpaque
EndFunc

Func autofocusAfterwardsUndoEpilogue(ByRef $epilogueOpaque)
    If Not IsArray($epilogueOpaque) Then
        Return
    EndIf
    Local $initialWinList = $epilogueOpaque[0]
    Local $topmostWinList = $epilogueOpaque[1]
    Local $foundIndex = $epilogueOpaque[2]
    Local $setWindowPosCount = $epilogueOpaque[3]
    ; undo making windows temporarily topmost. some windows might have disappeared, so we need to handle that too
    Do
        Local $count = 0
        Local $windowPosInfo = _WinAPI_BeginDeferWindowPos($setWindowPosCount)
        For $i = $foundIndex-1 To 1 Step -1
            If $initialWinList[$i][1] And Not $topmostWinList[$i] And WinExists($initialWinList[$i][1]) Then
                $count += 1
                $windowPosInfo = _WinAPI_DeferWindowPos($windowPosInfo, $initialWinList[$i][1], $HWND_NOTOPMOST, 0, 0, 0, 0, BitOR($SWP_NOACTIVATE, $SWP_NOMOVE, $SWP_NOSIZE, $SWP_NOOWNERZORDER))
                ;ConsoleWrite("-tmp on-top: " & $windowPosInfo & ", " & $initialWinList[$i][1] & ", " & $initialWinList[$i][0] & @CRLF)
                ; it might fail if a window has disappeared, so re-do the whole Defer setup without that window
                If Not $windowPosInfo Then
                    ;ConsoleWrite("! removing" & @CRLF)
                    $initialWinList[$i][1] = 0
                    ExitLoop
                EndIf
            EndIf
        Next
        Local $windowPosSuccess = False
        If $windowPosInfo Then
            $windowPosSuccess = _WinAPI_EndDeferWindowPos($windowPosInfo)
            ;ConsoleWrite("end: " & $windowPosSuccess & @CRLF)
        EndIf
    Until $windowPosSuccess Or $count == 0
EndFunc

Func hotkeyControl($windowHandle)
    Local $controlHandle = "" ; in rare occasions there is no matching control, so fallback to an empty string
    ; send input to the last matching window to prevent the tab preview pop-up from eating the hotkey combination we send
    Local $controls = _WinAPI_EnumChildWindows($windowHandle, False)
    Local $maxY = -2^31
    For $i = $controls[0][0] To 1 Step -1
        If $controls[$i][1] == $CHROME_CONTROL_CLASS_NAME Then
            $controlHandle = $controls[$i][0]
            Local $pos = WinGetPos($controls[$i][0])
            If IsArray($pos) Then
                $maxY = $pos[1]
            EndIf
            ExitLoop
        EndIf
    Next
    Return $controlHandle
EndFunc

Func processEvent($windowHandle, $event)
    Local $controlHandle = hotkeyControl($windowHandle)
    Switch $event
        Case $MOUSE_WHEEL_SCROLL_UP_EVENT
            ControlSend($windowHandle, "", $controlHandle, $cfgReverse ? "^{PGDN}" : "^{PGUP}")
        Case $MOUSE_WHEEL_SCROLL_DOWN_EVENT
            ControlSend($windowHandle, "", $controlHandle, $cfgReverse ? "^{PGUP}" : "^{PGDN}")
    EndSwitch
EndFunc

Func readConfig()
    $cfgReverse = Int(IniRead($CFG_FILE_PATH, "options", "reverse", 0)) == 1
    $cfgAutofocus = Int(IniRead($CFG_FILE_PATH, "options", "autofocus", 1)) == 1
    $cfgAutofocusAfterwards = Int(IniRead($CFG_FILE_PATH, "options", "autofocusAfterwards", $CFG_AUTOFOCUS_AFTERWARDS_KEEP))
    If $cfgAutofocusAfterwards < 0 Or $cfgAutofocusAfterwards >= $CFG_AUTOFOCUS_AFTERWARDS_MAX Then
        ConsoleWrite("Warning: Incorrect value for the autofocusAfterwards option in " & $CFG_FILE_PATH & _
                     ", using the default: autofocusAfterwards=" & $CFG_AUTOFOCUS_AFTERWARDS_KEEP & @CRLF)
        $cfgAutofocusAfterwards = $CFG_AUTOFOCUS_AFTERWARDS_KEEP
    EndIf
    $cfgAutofocusFocusDelay = Int(IniRead($CFG_FILE_PATH, "options", "autofocusFocusDelay", _
                                          $CFG_AUTOFOCUS_FOCUS_DELAY_VALUES[$CFG_AUTOFOCUS_FOCUS_DELAY_VALUES_DEFAULT_INDEX]))
    Local $foundAutofocusFocusDelay = False
    For $i = 0 To UBound($CFG_AUTOFOCUS_FOCUS_DELAY_VALUES)-1
        If $cfgAutofocusFocusDelay == $CFG_AUTOFOCUS_FOCUS_DELAY_VALUES[$i] Then
            $foundAutofocusFocusDelay = True
            ExitLoop
        EndIf
    Next
    If Not $foundAutofocusFocusDelay Then
        ConsoleWrite("Warning: Incorrect value for the autofocusFocusDelay option in " & $CFG_FILE_PATH & _
                     ", using the default: autofocusFocusDelay=" & _
                     $CFG_AUTOFOCUS_FOCUS_DELAY_VALUES[$CFG_AUTOFOCUS_FOCUS_DELAY_VALUES_DEFAULT_INDEX] & @CRLF)
        $cfgAutofocusFocusDelay = $CFG_AUTOFOCUS_FOCUS_DELAY_VALUES[$CFG_AUTOFOCUS_FOCUS_DELAY_VALUES_DEFAULT_INDEX]
    EndIf
EndFunc

Func writeConfig()
    DirCreate($CFG_DIR_PATH)

    IniWrite($CFG_FILE_PATH, "options", "reverse", Int($cfgReverse))
    IniWrite($CFG_FILE_PATH, "options", "autofocus", Int($cfgAutofocus))
    IniWrite($CFG_FILE_PATH, "options", "autofocusAfterwards", Int($cfgAutofocusAfterwards))
    IniWrite($CFG_FILE_PATH, "options", "autofocusFocusDelay", Int($cfgAutofocusFocusDelay))
EndFunc

Func processConfig()
    If $cfgReverse Then
        TrayItemSetState($trayReverse, $TRAY_CHECKED)
    EndIf

    If $cfgAutofocus Then
        TrayItemSetState($trayAutofocus, $TRAY_CHECKED)
    EndIf

    Switch $cfgAutofocusAfterwards
        Case $CFG_AUTOFOCUS_AFTERWARDS_KEEP
            TrayItemSetState($trayAutofocusAfterwardsKeep, $TRAY_CHECKED)
        Case $CFG_AUTOFOCUS_AFTERWARDS_UNDO
            TrayItemSetState($trayAutofocusAfterwardsUndo, $TRAY_CHECKED)
    EndSwitch

    For $i = 0 To UBound($CFG_AUTOFOCUS_FOCUS_DELAY_VALUES)-1
        If $cfgAutofocusFocusDelay == $CFG_AUTOFOCUS_FOCUS_DELAY_VALUES[$i] Then
            TrayItemSetState($trayAutofocusFocusDelayValues[$i], $TRAY_CHECKED)
            ExitLoop
        EndIf
    Next
EndFunc

Func aboutDialog()
    Local $formAbout = GUICreate("About", 682, 354, -1, -1, -1, BitOR($WS_EX_TOPMOST,$WS_EX_WINDOWEDGE))
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
    Local $labelHomepage = GUICtrlCreateLabel("Homepage", 544, 112, 66, 20)
    GUICtrlSetFont(-1, 10, $FW_NORMAL, 4)
    GUICtrlSetColor(-1, 0x0000FF)
    GUICtrlSetCursor (-1, $MCID_HAND)
    Local $labelDonate = GUICtrlCreateLabel("Donate", 624, 112, 45, 20)
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
