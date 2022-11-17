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
#AutoIt3Wrapper_Res_Language=0x0409
#AutoIt3Wrapper_Res_Icon_Add=icon_disabled_right.ico
#AutoIt3Wrapper_Res_ProductName=Chrome Mouse Wheel Tab Scroller
#AutoIt3Wrapper_Res_Description=Chrome Mouse Wheel Tab Scroller
#AutoIt3Wrapper_Res_Comment=Scroll Chrome tabs using mouse wheel
#AutoIt3Wrapper_Res_ProductVersion=2.0.1
#AutoIt3Wrapper_Res_Fileversion=2.0.1.0
#AutoIt3Wrapper_Res_CompanyName=Maxim Biro (nurupo)
#AutoIt3Wrapper_Res_LegalCopyright=Copyright 2017-2022 Maxim Biro (nurupo)

Global Const $RES_PRODUCT_NAME    = "Chrome Mouse Wheel Tab Scroller"
Global Const $RES_COMMENT         = "Scroll Chrome tabs using mouse wheel"
Global Const $RES_PRODUCT_VERSION = "2.0.1"
Global Const $RES_COMPANY_NAME    = "Maxim Biro (nurupo)"
Global Const $RES_LEGAL_COPYRIGHT = "Copyright 2017-2022 Maxim Biro (nurupo)"

Global Const $PROJECT_GITHUB_URL     = "https://github.com/nurupo/chrome-mouse-wheel-tab-scroller"
Global Const $PROJECT_GITHUB_API_URL = "https://api.github.com/repos/nurupo/chrome-mouse-wheel-tab-scroller"
Global Const $PROJECT_HOMEPAGE_URL   = $PROJECT_GITHUB_URL
Global Const $PROJECT_DONATE_URL     = "https://github.com/sponsors/nurupo"

#include <APISysConstants.au3>
#include <EditConstants.au3>
#include <File.au3>
#include <FileConstants.au3>
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiMenu.au3>
#include <InetConstants.au3>
#include <Misc.au3>
#include <MsgBoxConstants.au3>
#include <Security.au3>
#include <StaticConstants.au3>
#include <StringConstants.au3>
#include <TrayConstants.au3>
#include <WinAPIGdi.au3>
#include <WinAPIFiles.au3>
#include <WinAPIIcons.au3>
#include <WinAPIProc.au3>
#include <WinAPIRes.au3>
#include <WinAPISys.au3>
#include <WinAPISysWin.au3>
#include <WindowsConstants.au3>

Opt("MustDeclareVars", 1)
Opt("TCPTimeout", 1000)
Opt("WinWaitDelay", 0)
AutoItWinSetTitle($RES_PRODUCT_NAME)

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
            $CFG_AUTOFOCUS_AFTERWARDS_UNDO_SIMPLE, _
            $CFG_AUTOFOCUS_AFTERWARDS_UNDO_COMPREHENSIVE, _
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
Global $cfgCheckUpdateOnLaunch = Null

; Other application state
Global Enum $STARTUP_CURRENT_USER_AS_ADMIN, _
            $STARTUP_CURRENT_USER_AS_REGULAR, _
            $STARTUP_DISABLED, _
            $STARTUP_MAX
Global $startup = Null

Global Enum $MOUSE_WHEEL_SCROLL_UP_EVENT, _
            $MOUSE_WHEEL_SCROLL_DOWN_EVENT

; https://www.wolframalpha.com/input?i=%28sum+from+i%3D0+to+i%3D4+of+30*3%5Ei%29%2F60%2F60
Global Const $CHECK_UPDATE_ON_LAUNCH_MAX_TRIES = 4
Global Const $CHECK_UPDATE_ON_LAUNCH_DELAY = 30*1000
Global Const $CHECK_UPDATE_ON_LAUNCH_DELAY_GROWTH_RATE = 2
Global $checkUpdateOnLaunchTries = 0
Global $checkUpdateOnLaunchTimer = Null
Global $checkUpdateOnLaunchNextTime = 0
Global $checkUpdateOnLaunch = False

Global $disabled = False
Global $isAdmin = IsAdmin()

Global $formAbout
Global $formAboutPos
GUIRegisterMsg($WM_GETMINMAXINFO, "WM_GETMINMAXINFO")

Global Enum $OPTIONS_EARLY, _
            $OPTIONS_LATE
Global $optDelaySingletonCheck = False

processOptions($OPTIONS_EARLY)

Func singleInstance($level = 1)
    If _Singleton($RES_PRODUCT_NAME, 1) == 0 Then
        If Not $isAdmin Or ($isAdmin And (Not $optDelaySingletonCheck Or $level == 10)) Then
            MsgBox($MB_ICONWARNING, "Error", "Another instance of this application is already running.")
            Exit
        EndIf
        ; This program could restart itself as Admin and request to give the old process some time to exit
        If $isAdmin And $optDelaySingletonCheck Then
            Sleep(500)
            singleInstance($level+1)
        EndIf
    EndIf
EndFunc
singleInstance()

Global Const $WM_TRAYNOTIFY = $WM_USER + 1
Global Const $NIN_BALLOONUSERCLICK = $WM_USER + 5
Global Const $AUTOIT_SUBCLASS_ID = 20221027
Global $autoitSubclassCallback = DllCallbackRegister("autoItWinSubclass", "lresult", "hwnd;uint;wparam;lparam;uint_ptr;dword_ptr")
DllCall("comctl32.dll", "bool", "SetWindowSubclass", "hwnd", autoItWinGetHandle(), "ptr", _
        DllCallbackGetPtr($autoitSubclassCallback), "uint_ptr", $AUTOIT_SUBCLASS_ID, "dword_ptr", 0)
OnAutoItExitRegister("onExit")
Func onExit()
    DllCall("comctl32.dll", "bool", "RemoveWindowSubclass", "hwnd", autoItWinGetHandle(), "ptr", _
            DllCallbackGetPtr($autoitSubclassCallback), "uint_ptr", $AUTOIT_SUBCLASS_ID)
    DllCallbackFree($autoitSubclassCallback)
EndFunc

Global Const $inputHandlerForm = GUICreate($RES_PRODUCT_NAME & " Raw Input Handler Window")
setupRawInputHandler()

Opt("TrayMenuMode", 1+4)
Global $trayRestartAsAdmin = -1
If Not $isAdmin Then
    $trayRestartAsAdmin = TrayCreateItem("Restart as Administrator")
    trayItemSetShieldIcon()
    TrayCreateItem("")
EndIf
Global $trayReverse = TrayCreateItem("Reverse the scroll direction")
Global $trayAutofocus = TrayCreateItem("Autofocus Chrome")
Global $trayAutofocusAfterwards = TrayCreateMenu("After autofocusing")
Global $trayAutofocusAfterwardsKeep = TrayCreateItem("Keep it focused", $trayAutofocusAfterwards, -1, $TRAY_ITEM_RADIO)
Global $trayAutofocusAfterwardsUndoSimple = TrayCreateItem("Undo the autofocus (fast but simple)", $trayAutofocusAfterwards, -1, $TRAY_ITEM_RADIO)
Global $trayAutofocusAfterwardsUndoComprehensive = TrayCreateItem("Undo the autofocus (comprehensive but slow)", $trayAutofocusAfterwards, -1, $TRAY_ITEM_RADIO)
Global $trayAutofocusFocusDelay = TrayCreateMenu("Wait after focusing")
Global $trayAutofocusFocusDelayValues[UBound($CFG_AUTOFOCUS_FOCUS_DELAY_VALUES)]
For $i = 0 To UBound($trayAutofocusFocusDelayValues)-1
    $trayAutofocusFocusDelayValues[$i] = TrayCreateItem($CFG_AUTOFOCUS_FOCUS_DELAY_VALUES[$i] & " ms" & _
                                                   ($i == $CFG_AUTOFOCUS_FOCUS_DELAY_VALUES_DEFAULT_INDEX ? " (Default)" : ""), _
                                                   $trayAutofocusFocusDelay, -1, $TRAY_ITEM_RADIO)
Next
Global $trayDisable = TrayCreateItem("Disable")
TrayItemSetState($trayDisable, $TRAY_DEFAULT)
TrayCreateItem("")
Global $trayStartup = TrayCreateMenu("Run at startup")
Global $trayStartupCurrentUserAsAdmin = TrayCreateItem("As Administrator", $trayStartup, -1, $TRAY_ITEM_RADIO)
Global $trayStartupCurrentUserAsRegular = TrayCreateItem("As " & @UserName, $trayStartup, -1, $TRAY_ITEM_RADIO)
Global $trayStartupDisable = TrayCreateItem("Disable", $trayStartup, -1, $TRAY_ITEM_RADIO)
Global $trayCheckUpdateOnLaunch = TrayCreateItem("Check for updates on launch")
Global $trayAbout = TrayCreateItem("About")
TrayCreateItem("")
Global $trayExit = TrayCreateItem("Exit")
TraySetClick($TRAY_CLICK_SECONDARYUP)
TraySetState()
TraySetToolTip($RES_PRODUCT_NAME)

readConfig()
processConfig()
startupTraySync()
processOptions($OPTIONS_LATE)

While 1
    processTrayEvents()
    checkUpdateOnLaunch()
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
                    trayItemSetCheck($trayDisable, $TRAY_UNCHECKED)
                Case BitAND($trayDisableState, $TRAY_UNCHECKED)
                    trayItemSetCheck($trayDisable, $TRAY_CHECKED)
            EndSelect
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
        Case $trayAutofocusAfterwardsUndoSimple
            $cfgAutofocusAfterwards = $CFG_AUTOFOCUS_AFTERWARDS_UNDO_SIMPLE
            writeConfig()
        Case $trayAutofocusAfterwardsUndoComprehensive
            $cfgAutofocusAfterwards = $CFG_AUTOFOCUS_AFTERWARDS_UNDO_COMPREHENSIVE
            writeConfig()
        Case $trayStartupCurrentUserAsAdmin
            startupTrayChange($startup, $STARTUP_CURRENT_USER_AS_ADMIN)
            startupTraySync()
        Case $trayStartupCurrentUserAsRegular
            startupTrayChange($startup, $STARTUP_CURRENT_USER_AS_REGULAR)
            startupTraySync()
        Case $trayStartupDisable
            startupTrayChange($startup, $STARTUP_DISABLED)
            startupTraySync()
        Case $trayCheckUpdateOnLaunch
            $cfgCheckUpdateOnLaunch = Not $cfgCheckUpdateOnLaunch
            writeConfig()
        Case $trayAbout
            trayItemSetCheck($trayAbout, $TRAY_UNCHECKED)
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
            If Not $isAdmin Then
                If $msg == $trayRestartAsAdmin Then
                    restartAsAdmin()
                EndIf
            EndIf
    EndSwitch
EndFunc

Func checkUpdateOnLaunch()
    If $checkUpdateOnLaunch And _
        $checkUpdateOnLaunchTimer <> Null And $checkUpdateOnLaunchNextTime > 0 And _
        TimerDiff($checkUpdateOnLaunchTimer) >= $checkUpdateOnLaunchNextTime Then
        If checkUpdate(False) Or $checkUpdateOnLaunchTries == $CHECK_UPDATE_ON_LAUNCH_MAX_TRIES Then
            $checkUpdateOnLaunch = False
            $checkUpdateOnLaunchTimer = Null
            $checkUpdateOnLaunchNextTime = 0
        Else
            $checkUpdateOnLaunchTries += 1
            $checkUpdateOnLaunchTimer = TimerInit()
            ; exponential backoff
            $checkUpdateOnLaunchNextTime = $CHECK_UPDATE_ON_LAUNCH_DELAY*((1 + $CHECK_UPDATE_ON_LAUNCH_DELAY_GROWTH_RATE)^$checkUpdateOnLaunchTries)
       EndIf
    EndIf
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
            Case $CFG_AUTOFOCUS_AFTERWARDS_UNDO_SIMPLE
                ContinueCase
            Case $CFG_AUTOFOCUS_AFTERWARDS_UNDO_COMPREHENSIVE
                Local $initiallyActive = WinGetHandle("[ACTIVE]")
                Local $epilogueOpaque = autofocusAfterwardsUndoPrologue($windowHandle)
                If $epilogueOpaque <> Null Then
                    If WinActivate($windowHandle) <> 0 And _WinWaitActive($windowHandle, "", 1) <> 0 Then
                        processEvent($windowHandle, $event)
                    EndIf
                    If $cfgAutofocusAfterwards == $CFG_AUTOFOCUS_AFTERWARDS_UNDO_SIMPLE Then
                        autofocusAfterwardsUndoSimpleEpilogue($epilogueOpaque)
                    ElseIf $cfgAutofocusAfterwards == $CFG_AUTOFOCUS_AFTERWARDS_UNDO_COMPREHENSIVE Then
                        autofocusAfterwardsUndoComprehensiveEpilogue($epilogueOpaque)
                    EndIf
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

Func autofocusAfterwardsUndoSimpleEpilogue(ByRef $epilogueOpaque)
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

Func autofocusAfterwardsUndoComprehensiveEpilogue(ByRef $epilogueOpaque)
    If Not IsArray($epilogueOpaque) Then
        Return
    EndIf
    Local $initialWinList = $epilogueOpaque[0]
    Local $topmostWinList = $epilogueOpaque[1]
    Local $foundIndex = $epilogueOpaque[2]
    Local $setWindowPosCount = $epilogueOpaque[3]
    ; undo making windows temporarily topmost. some windows might have disappeared, so we need to handle that too
    For $i = $foundIndex-1 To 1 Step -1
        If $initialWinList[$i][1] And WinExists($initialWinList[$i][1]) Then
            If Not $topmostWinList[$i] Then
                _WinAPI_SetWindowPos($initialWinList[$i][1], $HWND_NOTOPMOST, 0, 0, 0, 0, BitOR($SWP_NOACTIVATE, $SWP_NOMOVE, $SWP_NOSIZE, $SWP_NOOWNERZORDER))
            EndIf
            If $initialWinList[$i][0] <> "" Then
                WinActivate($initialWinList[$i][1])
                _WinWaitActive($initialWinList[$i][1], "", 1)
            EndIf
        EndIf
    Next
EndFunc

Func processEvent($windowHandle, $event)
    Switch $event
        Case $MOUSE_WHEEL_SCROLL_UP_EVENT
            Send($cfgReverse ? "^{PGDN}" : "^{PGUP}")
            ControlSend($windowHandle, "", "", "^")
        Case $MOUSE_WHEEL_SCROLL_DOWN_EVENT
            Send($cfgReverse ? "^{PGUP}" : "^{PGDN}")
            ControlSend($windowHandle, "", "", "^")
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
    $cfgCheckUpdateOnLaunch = Int(IniRead($CFG_FILE_PATH, "options", "checkUpdateOnLaunch", 1)) == 1
EndFunc

Func writeConfig()
    DirCreate($CFG_DIR_PATH)

    IniWrite($CFG_FILE_PATH, "options", "reverse", Int($cfgReverse))
    IniWrite($CFG_FILE_PATH, "options", "autofocus", Int($cfgAutofocus))
    IniWrite($CFG_FILE_PATH, "options", "autofocusAfterwards", Int($cfgAutofocusAfterwards))
    IniWrite($CFG_FILE_PATH, "options", "autofocusFocusDelay", Int($cfgAutofocusFocusDelay))
    IniWrite($CFG_FILE_PATH, "options", "checkUpdateOnLaunch", Int($cfgcheckUpdateOnLaunch))
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
        Case $CFG_AUTOFOCUS_AFTERWARDS_UNDO_SIMPLE
            TrayItemSetState($trayAutofocusAfterwardsUndoSimple, $TRAY_CHECKED)
        Case $CFG_AUTOFOCUS_AFTERWARDS_UNDO_COMPREHENSIVE
            TrayItemSetState($trayAutofocusAfterwardsUndoComprehensive, $TRAY_CHECKED)
    EndSwitch

    For $i = 0 To UBound($CFG_AUTOFOCUS_FOCUS_DELAY_VALUES)-1
        If $cfgAutofocusFocusDelay == $CFG_AUTOFOCUS_FOCUS_DELAY_VALUES[$i] Then
            TrayItemSetState($trayAutofocusFocusDelayValues[$i], $TRAY_CHECKED)
            ExitLoop
        EndIf
    Next

    If $cfgcheckUpdateOnLaunch Then
        TrayItemSetState($traycheckUpdateOnLaunch, $TRAY_CHECKED)
        $checkUpdateOnLaunch = True
        $checkUpdateOnLaunchTimer = TimerInit()
        $checkUpdateOnLaunchNextTime = $CHECK_UPDATE_ON_LAUNCH_DELAY
    EndIf
EndFunc

Func checkUpdate($verbose)
    Local $latestJson = BinaryToString(InetRead($PROJECT_GITHUB_API_URL & "/releases/latest", $INET_FORCERELOAD), $SB_UTF8)
    Local $latestTagName = jsonValue($latestJson, "tag_name")
    If Not IsString($latestTagName) Then
        If $verbose Then
            TrayTip("Failed to fetch the update information", "Unable to fetch the update information", 30)
        EndIf
        Return False
    EndIf
    Local $latestPublishedAt = releaseDate($latestJson, "published_at")
    If $latestTagName == ("v" & $RES_PRODUCT_VERSION) Then
        If $verbose Then
            TrayTip("Already up to date!", "You are running the latest version: " & $latestTagName & $latestPublishedAt, 30)
        EndIf
        Return True
    EndIf
    Local $currentJson = BinaryToString(InetRead($PROJECT_GITHUB_API_URL & "/releases/tag/" & _
                                        $RES_PRODUCT_VERSION, $INET_FORCERELOAD), $SB_UTF8)
    Local $currentPublishedAt = releaseDate($currentJson, "published_at")
    TrayTip("An update is availalbe", "Current version: " & $RES_PRODUCT_VERSION & $currentPublishedAt & @CRLF & _
                                      "New version: " & $latestTagName & $latestPublishedAt, 30)
    Return True
EndFunc

Func releaseDate(ByRef $json, $key)
    Local $date = jsonValue($json, $key)
    If IsString($date) Then
        $date = StringSplit($date, "T")
        If IsArray($date) Then
            $date = " (" & $date[1] & ")"
        EndIf
    EndIf
    If Not IsString($date) Then
        $date = ""
    EndIf
    Return $date
EndFunc

Func jsonValue(ByRef $json, $key)
    Local $tagNamePos = StringInStr($json, '"' & $key & '"')
    If $tagNamePos > 0 Then
        Local $tagNamePos1 = StringInStr($json, '"', 0, 3, $tagNamePos)
        Local $tagNamePos2 = StringInStr($json, '"', 0, 4, $tagNamePos)
        If $tagNamePos1 > 0 And $tagNamePos2 > 0 Then
            Return StringMid($json, $tagNamePos1+1, $tagNamePos2-$tagNamePos1-1)
        EndIf
    EndIf
    Return Null
EndFunc

Func autoItWinSubclass($hwnd, $uMsg, $wParam, $lParam, $uIdSubclass, $dwRefData)
    #forceref $hwnd, $uMsg, $wParam, $lParam, $uIdSubclass, $dwRefData
    If $uMsg = $WM_TRAYNOTIFY And $uIdSubclass = $AUTOIT_SUBCLASS_ID And $lParam = $NIN_BALLOONUSERCLICK Then
        ; we could use html_url from GitHub API to link to the latest release directly, but I prefer linking to the Releases page instead
        ShellExecute($PROJECT_GITHUB_URL & "/releases")
    EndIf
    Return DllCall("comctl32.dll", "lresult", "DefSubclassProc", "hwnd", $hwnd, "uint", $uMsg, "wparam", $wParam, "lparam", $lParam)[0]
EndFunc

Func autoItWinGetHandle()
    Local $oldTitle = AutoItWinGetTitle()
    Local $newTitle = $RES_PRODUCT_NAME & String(Random(0, (2^31)-1))
    AutoItWinSetTitle($newTitle)
    Local $windowHandle = WinGetHandle($newTitle)
    AutoItWinSetTitle($oldTitle)
    Return $windowHandle
EndFunc

Func restartAsAdmin($params = "")
    If Not @Compiled Then $params = '/AutoIt3ExecuteScript "' & @ScriptFullPath & '" ' & $params
    $params &= " --delay-singleton-check"
    If ShellExecute(@AutoItExe, $params, @WorkingDir, "runas") > 0 Then Exit
EndFunc

Func trayItemSetShieldIcon($trayItemPos = -1, $trayMenu = 0)
    Local Static $shieldBitmap = 0
    If Not $shieldBitmap Then
        Local $shieldIcon = _WinAPI_LoadIconMetric(0, $IDI_SHIELD, $LIM_SMALL)
        If $shieldIcon == 0 Then Return False
        Local $iconInfo = _WinAPI_GetIconInfoEx($shieldIcon)
        If Not IsArray($iconInfo) Then Return False
        $shieldBitmap = _WinAPI_CopyImage($iconInfo[4], $IMAGE_BITMAP, 0, 0, $LR_CREATEDIBSECTION)
        If Not $shieldBitmap Then Return False
    EndIf
    Local $trayMenuHandle = TrayItemGetHandle($trayMenu)
    If Not $trayMenuHandle Then Return False
    If $trayItemPos == -1 Then
        $trayItemPos = _GUICtrlMenu_GetItemCount($trayMenuHandle)-1
    EndIf
    If $trayItemPos < 0 Then Return False
    Return _GUICtrlMenu_SetItemBitmaps($trayMenuHandle, $trayItemPos, $shieldBitmap, $shieldBitmap)
EndFunc

Func startupCreate($name, $type, $params = "")
    If Not @Compiled Then $params = '/AutoIt3ExecuteScript "' & @ScriptFullPath & '" ' & $params
    $params &= " --startup"
    Switch $type
        Case $STARTUP_CURRENT_USER_AS_ADMIN
            Local $taskXml = _
                '<?xml version="1.0" encoding="UTF-16"?>' & @CRLF & _
                '<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">' & @CRLF & _
                '  <RegistrationInfo>' & @CRLF & _
                '    <Date>' & @YEAR & '-' & @MON & '-' & @MDAY & 'T' & @HOUR & ':' & @MIN & ':' & @SEC & '.' & @MSEC & '</Date>' & @CRLF & _
                '    <Description>Runs ' & $name & ' on startup</Description>' & @CRLF & _
                '    <URI>\' & $name & '</URI>' & @CRLF & _
                '  </RegistrationInfo>' & @CRLF & _
                '  <Triggers>' & @CRLF & _
                '    <LogonTrigger>' & @CRLF & _
                '      <Enabled>true</Enabled>' & @CRLF & _
                '      <UserId>' & @ComputerName & '\' & @UserName & '</UserId>' & @CRLF & _
                '    </LogonTrigger>' & @CRLF & _
                '  </Triggers>' & @CRLF & _
                '  <Principals>' & @CRLF & _
                '    <Principal id="Author">' & @CRLF & _
                '      <UserId>' & _Security__SidToStringSid(_Security__GetAccountSid(@UserName)) & '</UserId>' & @CRLF & _
                '      <LogonType>InteractiveToken</LogonType>' & @CRLF & _
                '      <RunLevel>HighestAvailable</RunLevel>' & @CRLF & _
                '    </Principal>' & @CRLF & _
                '  </Principals>' & @CRLF & _
                '  <Settings>' & @CRLF & _
                '    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>' & @CRLF & _
                '    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>' & @CRLF & _
                '    <StopIfGoingOnBatteries>false</StopIfGoingOnBatteries>' & @CRLF & _
                '    <AllowHardTerminate>true</AllowHardTerminate>' & @CRLF & _
                '    <StartWhenAvailable>false</StartWhenAvailable>' & @CRLF & _
                '    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>' & @CRLF & _
                '    <IdleSettings>' & @CRLF & _
                '      <StopOnIdleEnd>true</StopOnIdleEnd>' & @CRLF & _
                '      <RestartOnIdle>false</RestartOnIdle>' & @CRLF & _
                '    </IdleSettings>' & @CRLF & _
                '    <AllowStartOnDemand>true</AllowStartOnDemand>' & @CRLF & _
                '    <Enabled>true</Enabled>' & @CRLF & _
                '    <Hidden>false</Hidden>' & @CRLF & _
                '    <RunOnlyIfIdle>false</RunOnlyIfIdle>' & @CRLF & _
                '    <WakeToRun>false</WakeToRun>' & @CRLF & _
                '    <ExecutionTimeLimit>PT0S</ExecutionTimeLimit>' & @CRLF & _
                '    <Priority>7</Priority>' & @CRLF & _
                '  </Settings>' & @CRLF & _
                '  <Actions Context="Author">' & @CRLF & _
                '    <Exec>' & @CRLF & _
                '      <Command>"' & @AutoItExe & '"</Command>' & @CRLF & _
                '      <Arguments>' & $params & '</Arguments>' & @CRLF & _
                '    </Exec>' & @CRLF & _
                '  </Actions>' & @CRLF & _
                '</Task>' & @CRLF
                Local $taskXmlFilePath = _TempFile()
                If Not FileWrite($taskXmlFilePath, $taskXml) Then Return False
                If RunWait('schtasks.exe /Create /XML "' & $taskXmlFilePath & '" /TN "' & $name & '"', "", @SW_HIDE) Then Return False
                Return FileDelete($taskXmlFilePath) == 1
        Case $STARTUP_CURRENT_USER_AS_REGULAR
            Return RegWrite("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", $name, "REG_SZ", '"' & @AutoItExe & '" ' & $params) == 1
            ;Return FileCreateShortcut($executable, @StartupDir & "/" & $name & ".lnk", "", $params) == 1
    EndSwitch
EndFunc

Func startupDelete($name, $type)
    Switch $type
        Case $STARTUP_CURRENT_USER_AS_ADMIN
            Return RunWait('schtasks.exe /Delete /F /TN "' & $name & '"', "", @SW_HIDE) == 0
        Case $STARTUP_CURRENT_USER_AS_REGULAR
            Return RegDelete("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", $name) == 1
            ;Return FileDelete(@StartupDir & "/" & $name & ".lnk") == 1
    EndSwitch
EndFunc

Func startupExists($name, $type)
    Switch $type
        Case $STARTUP_CURRENT_USER_AS_ADMIN
            Return RunWait('schtasks.exe /Query /TN "' & $name & '"', "", @SW_HIDE) == 0
        Case $STARTUP_CURRENT_USER_AS_REGULAR
            RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", $name)
            Return @error == 0
            ;Return FileExists(@StartupDir & "/" & $name & ".lnk") == 1
    EndSwitch
EndFunc

Func startupTraySync()
    trayItemSetCheck($trayStartupCurrentUserAsAdmin, $TRAY_UNCHECKED)
    trayItemSetCheck($trayStartupCurrentUserAsRegular, $TRAY_UNCHECKED)
    trayItemSetCheck($trayStartupDisable, $TRAY_UNCHECKED)
    Local $hasStartupAdmin = startupExists($RES_PRODUCT_NAME, $STARTUP_CURRENT_USER_AS_ADMIN)
    Local $hasStartupRegular = startupExists($RES_PRODUCT_NAME, $STARTUP_CURRENT_USER_AS_REGULAR)
    If $hasStartupAdmin Then
        trayItemSetCheck($trayStartupCurrentUserAsAdmin, $TRAY_CHECKED)
        $startup = $STARTUP_CURRENT_USER_AS_ADMIN
        If $hasStartupRegular Then
            startupDelete($RES_PRODUCT_NAME, $STARTUP_CURRENT_USER_AS_REGULAR)
        EndIf
    ElseIf $hasStartupRegular Then
        trayItemSetCheck($trayStartupCurrentUserAsRegular, $TRAY_CHECKED)
        $startup = $STARTUP_CURRENT_USER_AS_REGULAR
    Else
        trayItemSetCheck($trayStartupDisable, $TRAY_CHECKED)
        $startup = $STARTUP_DISABLED
    EndIf
EndFunc

Func trayItemSetCheck($trayItem, $checkFlag)
    Local $oppositeFlag = Null
    If $checkFlag == $TRAY_CHECKED Then
        $oppositeFlag = $TRAY_UNCHECKED
    Else
        $oppositeFlag = $TRAY_CHECKED
    EndIf
    Local $state = TrayItemGetState($trayItem)
    $state = BitXOR($state, $oppositeFlag)
    $state = BitOR($state, $checkFlag)
    TrayItemSetState($trayItem, $state)
EndFunc

Func startupTrayChange($startupOld, $startupNew)
    Switch $startupOld
        Case $STARTUP_CURRENT_USER_AS_ADMIN
            Switch $startupNew
                Case $STARTUP_CURRENT_USER_AS_ADMIN
                    ; noop
                Case $STARTUP_CURRENT_USER_AS_REGULAR
                    If Not requireAdmin("--startup-select " & $startupNew) Then Return
                    If Not startupDelete($RES_PRODUCT_NAME, $STARTUP_CURRENT_USER_AS_ADMIN) Then Return
                    If Not startupCreate($RES_PRODUCT_NAME, $STARTUP_CURRENT_USER_AS_REGULAR) Then Return
                Case $STARTUP_DISABLED
                    If Not requireAdmin("--startup-select " & $startupNew) Then Return
                    If Not startupDelete($RES_PRODUCT_NAME, $STARTUP_CURRENT_USER_AS_ADMIN) Then Return
            EndSwitch
        Case $STARTUP_CURRENT_USER_AS_REGULAR
            Switch $startupNew
                Case $STARTUP_CURRENT_USER_AS_ADMIN
                    If Not requireAdmin("--startup-select " & $startupNew) Then Return
                    If Not requireProgramFiles("--startup-select " & $startupNew) Then Return
                    If Not startupDelete($RES_PRODUCT_NAME, $STARTUP_CURRENT_USER_AS_REGULAR) Then Return
                    If Not startupCreate($RES_PRODUCT_NAME, $STARTUP_CURRENT_USER_AS_ADMIN) Then Return
                Case $STARTUP_CURRENT_USER_AS_REGULAR
                    ; noop
                Case $STARTUP_DISABLED
                    If Not startupDelete($RES_PRODUCT_NAME, $STARTUP_CURRENT_USER_AS_REGULAR) Then Return
            EndSwitch
        Case $STARTUP_DISABLED
            Switch $startupNew
                Case $STARTUP_CURRENT_USER_AS_ADMIN
                    If Not requireAdmin("--startup-select " & $startupNew) Then Return
                    If Not requireProgramFiles("--startup-select " & $startupNew) Then Return
                    If Not startupCreate($RES_PRODUCT_NAME, $STARTUP_CURRENT_USER_AS_ADMIN) Then Return
                Case $STARTUP_CURRENT_USER_AS_REGULAR
                    If Not startupCreate($RES_PRODUCT_NAME, $STARTUP_CURRENT_USER_AS_REGULAR) Then Return
                Case $STARTUP_DISABLED
                    ; noop
            EndSwitch
    EndSwitch
EndFunc

Func requireAdmin($restartParams)
    If $isAdmin Then Return True
    restartAsAdmin($restartParams)
    Return False
EndFunc

Func pathInProgramFiles($path)
    $path = _WinAPI_GetFullPathName($path)
    Local $programFilesDirs = [EnvGet("SystemDrive") & "\Program Files\", _
                               EnvGet("SystemDrive") & "\Program Files (x86)\", _
                               @ProgramFilesDir & "\"]
    For $i = 0 To UBound($programFilesDirs)-1
        If StringLeft($path, StringLen($programFilesDirs[$i])) == $programFilesDirs[$i] Then
            Return True
        EndIf
    Next
    Return False
EndFunc

Func requireProgramFiles($restartParams)
    If Not $isAdmin Then Return False
    If Not @Compiled Then
        Local $autoitFullPath = _WinAPI_GetFullPathName(@AutoItExe)
        If Not pathInProgramFiles($autoitFullPath) Then
            MsgBox($MB_OK+$MB_ICONERROR, $RES_PRODUCT_NAME, _
                   "Error: AutoIt is installed into a potentially insecure folder:" & @CRLF & _
                   '"' & $autoitFullPath & '"' & @CRLF & _
                   @CRLF & _
                   "Please install AutoIt into the Program Files folder.")
            Return False
        EndIf
    EndIf
    Local $scriptFullPath = _WinAPI_GetFullPathName(@ScriptFullPath)
    Local $newScriptDir = @ProgramFilesDir & "\" & $RES_PRODUCT_NAME
    Local $newScriptFullPath = $newScriptDir & "\" & @ScriptName
    If pathInProgramFiles($scriptFullPath) Then Return True
    Local $button = MsgBox($MB_YESNO+$MB_ICONWARNING, $RES_PRODUCT_NAME, _
                           "For security reasons, the program will be moved from:" & @CRLF & _
                           '"' & $scriptFullPath & '"' & @CRLF & _
                           "to:" & @CRLF & _
                           '"' & $newScriptFullPath & '"' & @CRLF & _
                           @CRLF & _
                           "Proceed?")
    If $button == $IDNO Or $button == $IDTIMEOUT Then Return False
    DirRemove($newScriptDir, $DIR_REMOVE)
    If Not DirCreate($newScriptDir) Then Return False
    If Not FileCopy($scriptFullPath, $newScriptFullPath) Then Return False
    $restartParams &= " --delay-singleton-check"
    If @Compiled Then
        If Run('"' & $newScriptFullPath & '" ' & $restartParams) == 0 Then Return False
    Else
        If Run('"' & @AutoItExe & '" /AutoIt3ExecuteScript "' & $newScriptFullPath & '" ' & $restartParams) == 0 Then Return False
    EndIf
    exitAndSelfDelete()
    Return False
EndFunc

Func exitAndSelfDelete()
    Local $batFilePath = _TempFile(@TempDir, "~", ".bat")
    FileWrite($batFilePath, _
              'ping -n 2 127.0.0.1 > nul' & @CRLF & _
              ':loop' & @CRLF & _
              'del "' & @ScriptFullPath & '"' & @CRLF & _
              'if exist "' & @ScriptFullPath & '" goto loop' & @CRLF & _
              'del %0')
    If Run($batFilePath, "", @SW_HIDE) <> 0 Then Exit
EndFunc

Func processOptions($type)
    For $i = 1 To $CmdLine[0]
        If StringLeft($CmdLine[$i], 2) <> "--" Then ContinueLoop
        Local $option = StringLower($CmdLine[$i])
        Local $arg = Null
        If $i+1 <= $CmdLine[0] And StringLeft($CmdLine[$i+1], 2) <> "--" Then
            $arg = $CmdLine[$i+1]
        EndIf
        Switch $type
            Case $OPTIONS_EARLY
                Switch $option
                    Case "--delay-singleton-check"
                        If Not $isAdmin Then ContinueLoop
                        $optDelaySingletonCheck = True
                    Case "--statup"
                        ; nothing for now, might be useful later
                EndSwitch
            Case $OPTIONS_LATE
                Switch $option
                    Case "--startup-select"
                        If Not $isAdmin Then ContinueLoop
                        If Not IsString($arg) Then ContinueLoop
                        Local $startupNew = Int($arg)
                        If $startupNew < 0 Or $startupNew >= $STARTUP_MAX Then ContinueLoop
                        startupTrayChange($startup, $startupNew)
                        startupTraySync()
                EndSwitch
        EndSwitch
    Next
EndFunc

Func WM_GETMINMAXINFO($hWnd, $iMsg, $wParam, $lParam)
    If $hWnd <> $formAbout Then $GUI_RUNDEFMSG
    Local $minmaxinfo = DllStructCreate("long;long;long;long;long;long;long;long;long;long", $lParam)
    DllStructSetData($minmaxinfo, 7, $formAboutPos[2]) ; min x
    DllStructSetData($minmaxinfo, 8, $formAboutPos[3]) ; min y
    Return 0
EndFunc

Func aboutDialog()
    $formAbout = GUICreate("About", 682, 354, -1, -1, $WS_OVERLAPPEDWINDOW, $WS_EX_TOPMOST)
    $formAboutPos = WinGetPos($formAbout)
    GUISetBkColor(0xFFFFFF)
    GUICtrlCreateLabel($RES_PRODUCT_NAME, 152, 16, 526, 31)
    GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKTOP + $GUI_DOCKLEFT)
    GUICtrlSetFont(-1, 18)
    GUICtrlCreateIcon(@AutoItExe, 99, 8, 8, 128, 128)
    GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKTOP + $GUI_DOCKLEFT)
    GUICtrlCreateLabel($RES_COMMENT, 152, 48, 526, 22)
    GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKTOP + $GUI_DOCKLEFT)
    GUICtrlSetFont(-1, 12)
    GUICtrlCreateLabel($RES_LEGAL_COPYRIGHT, 152, 88, 526, 20)
    GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKTOP + $GUI_DOCKLEFT)
    GUICtrlSetFont(-1, 10)
    GUICtrlCreateLabel("Version " & $RES_PRODUCT_VERSION, 152, 112, 268, 20)
    GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKTOP + $GUI_DOCKLEFT)
    GUICtrlSetFont(-1, 10)
    Local $labelHomepage = GUICtrlCreateLabel("Homepage", 421, 112, 66, 20)
    GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKTOP + $GUI_DOCKRIGHT)
    GUICtrlSetFont(-1, 10, $FW_NORMAL, 4)
    GUICtrlSetColor(-1, 0x0000FF)
    GUICtrlSetCursor(-1, $MCID_HAND)
    Local $labelCheckUpdate = GUICtrlCreateLabel("Check for updates", 501, 112, 109, 20)
    GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKTOP + $GUI_DOCKRIGHT)
    GUICtrlSetFont(-1, 10, $FW_NORMAL, 4)
    GUICtrlSetColor(-1, 0x0000FF)
    GUICtrlSetCursor(-1, $MCID_HAND)
    Local $labelDonate = GUICtrlCreateLabel("Donate", 624, 112, 45, 20)
    GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKTOP + $GUI_DOCKRIGHT)
    GUICtrlSetFont(-1, 10, $FW_NORMAL, 4)
    GUICtrlSetColor(-1, 0x0000FF)
    GUICtrlSetCursor(-1, $MCID_HAND)
    GUICtrlCreateEdit("", 8, 144, 665, 201, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_READONLY, $ES_WANTRETURN, $WS_VSCROLL))
    GUICtrlSetResizing(-1, $GUI_DOCKBORDERS + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
    GUICtrlSetData(-1, StringFormat( _
        $RES_PRODUCT_NAME & @CRLF & _
        "Author: " & $RES_COMPANY_NAME & @CRLF & _
        "Homepage: " & $PROJECT_HOMEPAGE_URL & @CRLF & _
        "Donate: " & $PROJECT_DONATE_URL & @CRLF & _
        "" & @CRLF & _
        "Credits:" & @CRLF & _
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
            Case $labelCheckUpdate
                GUISetCursor($MCID_WAIT, $GUI_CURSOR_OVERRIDE, $formAbout)
                _Sleep(1) ; for the cursor to get set
                checkUpdate(True)
                GUISetCursor($MCID_ARROW, $GUI_CURSOR_NOOVERRIDE, $formAbout)
        EndSwitch
        processTrayEvents()
    WEnd

    GUIDelete($formAbout)
EndFunc