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

#include "third_party/UI Automation UDF/UIA_Constants.au3"
#include "third_party/UI Automation UDF/UIAEH_AutomationEventHandler.au3"

Opt("MustDeclareVars", 1)
Opt("SendKeyDelay", 0)
Opt("SendKeyDownDelay", 0)
Opt("WinWaitDelay", 1)

; Chrome offsets and class name
Global Const $CHROME_TABS_AREA_HEIGHT_MAXIMIZED = 33
Global Const $CHROME_TABS_AREA_HEIGHT_NOT_MAXIMIZED = 46
Global Const $CHROME_NONTABS_AREA_RIGHT_WIDTH_OFFSET_MAXIMIZED = 200
Global Const $CHROME_NONTABS_AREA_RIGHT_WIDTH_OFFSET_NOT_MAXIMIZED = 192
Global Const $CHROME_WINDOW_CLASS_NAME_PREFIX = "Chrome_WidgetWin_"
Global Const $CHROME_CONTROL_CLASS_NAME = "Chrome_RenderWidgetHostHWND"

; Config constants
Global Const $CFG_DIR_PATH = @AppDataDir & "\chrome-mouse-wheel-tab-scroller"
Global Const $CFG_FILE_PATH = $CFG_DIR_PATH & "\config.ini"
Global Enum $CFG_AUTOFOCUS_AFTERWARDS_KEEP, _
            $CFG_AUTOFOCUS_AFTERWARDS_UNDO, _
            $CFG_AUTOFOCUS_AFTERWARDS_MAX

; Config state
Global $cfgReverse = Null
Global $cfgWrapAround = Null
Global $cfgAutofocus = Null
Global $cfgAutofocusAfterwards = Null

; Other application state
Global Enum $MOUSE_WHEEL_SCROLL_UP_EVENT, _
            $MOUSE_WHEEL_SCROLL_DOWN_EVENT
Global Enum $TAB_SCROLL_LEFT, _
            $TAB_SCROLL_RIGHT
Global $disabled = False

If _Singleton(FileGetVersion(@AutoItExe, $FV_PRODUCTNAME), 1) == 0 Then
    fatalError("Another instance of this application is already running")
EndIf

Global $aauInitiallyActive
Global $aauInitialWinList
Global $aauTopmostWinList
Global $aauFoundIndex
Global $aauSetWindowPosCount
Global $aauEpilogueNeeded = False

Global Enum $TAB_FIRST, _
            $TAB_LAST
Global $UIACacheMap[]
Global $pTabsPaneToWindowHandleMap[]
Global $oUIAutomation = ObjCreateInterface($sCLSID_CUIAutomation, $sIID_IUIAutomation, $dtag_IUIAutomation)
Global $pTreeWalker, $oTreeWalker
If Not IsObj($oUIAutomation) Then
    fatalError("Failed to create $oUIAutomation")
Else
    $oUIAutomation.RawViewWalker($pTreeWalker)
    $oTreeWalker = ObjCreateInterface($pTreeWalker, $sIID_IUIAutomationTreeWalker, $dtag_IUIAutomationTreeWalker)
    If Not IsObj($oTreeWalker) Then fatalError("Failed to create $oTreeWalker")
    UIAEH_AutomationEventHandlerCreate()
    If Not IsObj($oUIAEH_AutomationEventHandler) Then fatalError("Failed to create $oUIAEH_AutomationEventHandler")
EndIf

Global Const $inputHandlerForm = GUICreate(FileGetVersion(@AutoItExe, $FV_PRODUCTNAME) & " Raw Input Handler Window")
setupRawInputHandler()

Opt("TrayMenuMode", 1+4)
Global $trayReverse = TrayCreateItem("Reverse the scroll direction")
Global $trayWrapAround = TrayCreateItem("Wrap around")
Global $trayAutofocus = TrayCreateItem("Autofocus Chrome")
Global $trayAutofocusAfterwards = TrayCreateMenu("After autofocusing")
Global $trayAutofocusAfterwardsKeep = TrayCreateItem("Keep it focused", $trayAutofocusAfterwards, -1, $TRAY_ITEM_RADIO)
Global $trayAutofocusAfterwardsUndo = TrayCreateItem("Undo the autofocus (Experimental)", $trayAutofocusAfterwards, -1, $TRAY_ITEM_RADIO)
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
    mainEventLoop()
WEnd

Func fatalError($msg)
    If $aauEpilogueNeeded Then
        autofocusAfterwardsUndoEpilogue()
    EndIf
    MsgBox($MB_ICONERROR, FileGetVersion(@AutoItExe, $FV_PRODUCTNAME) & " - Fatal Error", _
           $msg & "." & @CRLF & @CRLF & "The application will terminate due to the error.")
    Exit
EndFunc

Func mainEventLoop()
    processTrayEvents()
    cleanupCache()
EndFunc

Func processTrayEvents()
    Switch TrayGetMsg()
        Case $trayReverse
            $cfgReverse = Not $cfgReverse
            writeConfig()
        Case $trayWrapAround
            $cfgWrapAround = Not $cfgWrapAround
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
    EndSwitch
EndFunc

Func cleanupCache()
    Local Static $UIACacheMapLastChecked = TimerInit()
    If UBound($UIACacheMap) > 1024 And TimerDiff($UIACacheMapLastChecked) > (60 * 1000) Then
        Local $windowHandles = MapKeys($UIACacheMap)
        For $w In $windowHandles
            If WinExists(Ptr($w)) Then
                ContinueLoop
            EndIf
            Local $tabsPaneRuntimeIdPropertyId4
            Local $oTabsPane = $UIACacheMap[$w]["oTabsPane"]
            $oTabsPane.GetCurrentPropertyValue($UIA_RuntimeIdPropertyId, $tabsPaneRuntimeIdPropertyId4)
            Local $tabsPaneRuntimeIdPropertyIdStr
            arrayToString($tabsPaneRuntimeIdPropertyId4, $tabsPaneRuntimeIdPropertyIdStr)
            MapRemove($pTabsPaneToWindowHandleMap, $tabsPaneRuntimeIdPropertyIdStr)
            $oTabsPane.Release()
            If MapExists($UIACacheMap[$w], "oEventSelectedTab") Then
                Local $oOldTab = $UIACacheMap[$w]["oEventSelectedTab"]
                $oOldTab.Release()
            EndIf
            MapRemove($UIACacheMap, $w)
        Next
        $UIACacheMapLastChecked = TimerInit()
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

Func tabsPane($windowHandle)
    Local $pChrome, $oChrome
    $oUIAutomation.ElementFromHandle($windowHandle, $pChrome)
    If Not $pChrome Then fatalError("Failed to set $pChrome")
    $oChrome = ObjCreateInterface($pChrome, $sIID_IUIAutomationElement, $dtag_IUIAutomationElement)
    If Not IsObj($oChrome) Then fatalError("Failed to set $oChrome")

    Local $pCondition1
    $oUIAutomation.CreatePropertyCondition($UIA_ControlTypePropertyId, $UIA_PaneControlTypeId, $pCondition1)
    If Not $pCondition1 Then fatalError("Failed to set $pCondition1")

    Local $pPanes, $oPanes, $iPanesLength
    $oChrome.FindAll($TreeScope_Children, $pCondition1, $pPanes)
    If Not $pPanes Then fatalError("Failed to set $pPanes")
    $oPanes = ObjCreateInterFace($pPanes, $sIID_IUIAutomationElementArray, $dtag_IUIAutomationElementArray)
    If Not IsObj($oPanes) Then fatalError("Failed to set $oPanes")
    $oPanes.Length($iPanesLength)
    If Not $iPanesLength Then fatalError("Failed to set $iPanesLength")

    Local $pCondition2
    $oUIAutomation.CreatePropertyCondition($UIA_ControlTypePropertyId, $UIA_TabItemControlTypeId, $pCondition2)
    If Not $pCondition2 Then fatalError("Failed to set $pCondition2")

    Local $pTabItem, $oTabItem
    For $i = 0 To $iPanesLength - 1
        Local $pPane, $oPane
        $oPanes.GetElement($i, $pPane)
        $oPane = ObjCreateInterface($pPane, $sIID_IUIAutomationElement, $dtag_IUIAutomationElement)
        $oPane.FindFirst($TreeScope_Descendants, $pCondition2, $pTabItem)
        $oTabItem = ObjCreateInterface($pTabItem, $sIID_IUIAutomationElement, $dtag_IUIAutomationElement)
        If IsObj($oTabItem) Then
            ExitLoop
        EndIf
    Next

    If Not IsObj($oTabItem) Then fatalError("Couldn't find $oTabItem")

    Local $pTabsPane
    $oTreeWalker.GetParentElement($oTabItem, $pTabsPane)
    If Not $pTabsPane Then fatalError("Failed to set $pTabsPane")

    Return $pTabsPane
EndFunc

Func isEdgeTabSelected($oTabsPane, $tabSelection)
    Local $pTab, $oTab
    Switch $tabSelection
        Case $TAB_FIRST
            $oTreeWalker.GetFirstChildElement($oTabsPane, $pTab)
        Case $TAB_LAST
            $oTreeWalker.GetLastChildElement($oTabsPane, $pTab)
    EndSwitch
    If Not $pTab Then fatalError("Failed to set $pTab")
    $oTab = ObjCreateInterface($pTab, $sIID_IUIAutomationElement, $dtag_IUIAutomationElement)
    If Not IsObj($oTab) Then fatalError("Failed to set $oTab")

    Return isTabSelected($oTab)
EndFunc

Func isTabSelected($oTab)
    If Not IsObj($oTab) Then
        Return False
    EndIf

    Local $isTabSelected = False
    If $oTab.GetCurrentPropertyValue($UIA_SelectionItemIsSelectedPropertyId, $isTabSelected) <> 0 Then
        fatalError("Failed to get SelectionItemIsSelectedPropertyId")
    EndIf
    Return $isTabSelected
EndFunc

Func selectedTab($oTabsPane)
    Local $pLegacyIAccessiblePattern, $oLegacyIAccessiblePattern
    $oTabsPane.GetCurrentPattern($UIA_LegacyIAccessiblePatternId, $pLegacyIAccessiblePattern)
    If Not $pLegacyIAccessiblePattern Then fatalError("Failed to set $pLegacyIAccessiblePattern")
    $oLegacyIAccessiblePattern = ObjCreateInterface($pLegacyIAccessiblePattern, $sIID_IUIAutomationLegacyIAccessiblePattern, $dtag_IUIAutomationLegacyIAccessiblePattern)
    If Not IsObj($oLegacyIAccessiblePattern) Then fatalError("Failed to set $oLegacyIAccessiblePattern")

    Local $pTabs, $oTabs, $iTabsLength
    $oLegacyIAccessiblePattern.GetCurrentSelection($pTabs)
    If Not $pTabs Then fatalError("Failed to set $pTabs")
    $oTabs = ObjCreateInterFace($pTabs, $sIID_IUIAutomationElementArray, $dtag_IUIAutomationElementArray)
    If Not IsObj($oTabs) Then fatalError("Failed to set $oTabs")
    $oTabs.Length($iTabsLength)
    If Not $iTabsLength Then fatalError("Failed to set $iTabsLength")

    ; There should be just one tab selected
    If $iTabsLength == 1 Then
        Local $pTab, $oTab
        $oTabs.GetElement(0, $pTab)
        $oTab = ObjCreateInterface($pTab, $sIID_IUIAutomationElement, $dtag_IUIAutomationElement)
        Return $oTab
    EndIf

    fatalError($iTabsLength & " tabs are selected?!")
EndFunc

Func selectTab($windowHandle, $direction)
    Local $oTabsPane = $UIACacheMap[$windowHandle]["oTabsPane"]
    Local $oSelectedTab = Null

    If isTabSelected($UIACacheMap[$windowHandle]["oPreviouslySelectedTab"]) Then
        $oSelectedTab = $UIACacheMap[$windowHandle]["oPreviouslySelectedTab"]
    ElseIf isTabSelected($UIACacheMap[$windowHandle]["oEventSelectedTab"]) Then
        $oSelectedTab = $UIACacheMap[$windowHandle]["oEventSelectedTab"]
    Else
        $oSelectedTab = selectedTab($oTabsPane)
    EndIf

    Local $pTab, $oTab
    Switch $direction
        Case $TAB_SCROLL_RIGHT
            $oTreeWalker.GetNextSiblingElement($oSelectedTab, $pTab)
            If Not $pTab Then
                $oTreeWalker.GetFirstChildElement($oTabsPane, $pTab)
                If Not $pTab Then fatalError("Failed to set $pTab")
            EndIf
        Case $TAB_SCROLL_LEFT
            $oTreeWalker.GetPreviousSiblingElement($oSelectedTab, $pTab)
            If Not $pTab Then
                $oTreeWalker.GetLastChildElement($oTabsPane, $pTab)
                If Not $pTab Then fatalError("Failed to set $pTab")
            EndIf
    EndSwitch
    $oTab = ObjCreateInterface($pTab, $sIID_IUIAutomationElement, $dtag_IUIAutomationElement)
    If Not IsObj($oTab) Then fatalError("Failed to set $oTab")

    Local $pLegacyIAccessiblePattern, $oLegacyIAccessiblePattern
    $oTab.GetCurrentPattern($UIA_LegacyIAccessiblePatternId, $pLegacyIAccessiblePattern)
    If Not $pLegacyIAccessiblePattern Then fatalError("Failed to set $pLegacyIAccessiblePattern")
    $oLegacyIAccessiblePattern = ObjCreateInterface($pLegacyIAccessiblePattern, $sIID_IUIAutomationLegacyIAccessiblePattern, $dtag_IUIAutomationLegacyIAccessiblePattern)
    If Not IsObj($oLegacyIAccessiblePattern) Then fatalError("Failed to set $oLegacyIAccessiblePattern")

    $oLegacyIAccessiblePattern.DoDefaultAction()
    $UIACacheMap[$windowHandle]["oPreviouslySelectedTab"] = $oTab
EndFunc

Func tabsBoundingBoxElement($oTabsPane)
    Local $pParent1, $oParent1
    $oTreeWalker.GetParentElement($oTabsPane, $pParent1)
    If Not $pParent1 Then fatalError("Failed to set $pParent1")
    $oParent1 = ObjCreateInterface($pParent1, $sIID_IUIAutomationElement, $dtag_IUIAutomationElement)
    If Not IsObj($oParent1) Then fatalError("Failed to set $oParent1")

    Local $pParent2, $oParent2
    $oTreeWalker.GetParentElement($oParent1, $pParent2)
    If Not $pParent2 Then fatalError("Failed to set $pParent2")
    $oParent2 = ObjCreateInterface($pParent2, $sIID_IUIAutomationElement, $dtag_IUIAutomationElement)
    If Not IsObj($oParent2) Then fatalError("Failed to set $oParent2")

    Return $oParent2
EndFunc

Func boundingBox($oElement)
    Local $aRect
    $oElement.GetCurrentPropertyValue($UIA_BoundingRectanglePropertyId, $aRect)
    Return $aRect
EndFunc

Func positionToCoordinates(ByRef $pos)
    ; For some reason Chrome's X and Y positions are -8 when the window is maximized, so if it's negative we assume it's 0
    If $pos[0] < 0 Then $pos[0] = 0
    If $pos[1] < 0 Then $pos[1] = 0
    ; change [x, y, w, h] to [x1, y1, x2, y2]
    $pos[2] += $pos[0]
    $pos[3] += $pos[1]
EndFunc

Func arrayToString(ByRef $arr, ByRef $str)
    For $i = 0 To UBound($arr)-1
        $str &= $arr[$i] & ","
    Next
EndFunc

Func cacheWindowInfo($windowHandle)
    ; cache only on the first time
    If MapExists($UIACacheMap, $windowHandle) Then
        Return
    EndIf
    Local $pTabsPane, $oTabsPane, $oTabsBoundingBoxElement
    $pTabsPane = tabsPane($windowHandle) ; the direct parent of tab items
    $oTabsPane = ObjCreateInterface($pTabsPane, $sIID_IUIAutomationElement, $dtag_IUIAutomationElement)
    If Not IsObj($oTabsPane) Then fatalError("Failed to set $oTabsPane")
    $oTabsPane.AddRef() ; has to outlive its window for up to cleanup cache
    $oTabsBoundingBoxElement = tabsBoundingBoxElement($oTabsPane) ; a parent of tabsPane that has the bounding box extening all the way to the system buttons
    Local $tabsPaneRuntimeIdPropertyId4
    $oTabsPane.GetCurrentPropertyValue($UIA_RuntimeIdPropertyId, $tabsPaneRuntimeIdPropertyId4)
    Local $tabsPaneRuntimeIdPropertyIdStr
    arrayToString($tabsPaneRuntimeIdPropertyId4, $tabsPaneRuntimeIdPropertyIdStr)
    Local $map[]
    $map["oTabsPane"] = $oTabsPane
    $map["oTabsBoundingBoxElement"] = $oTabsBoundingBoxElement
    $UIACacheMap[$windowHandle] = $map
    $pTabsPaneToWindowHandleMap[$tabsPaneRuntimeIdPropertyIdStr] = $windowHandle
    Local $iError = $oUIAutomation.AddAutomationEventHandler($UIA_SelectionItem_ElementSelectedEventId, $pTabsPane, $TreeScope_Children, 0, $oUIAEH_AutomationEventHandler)
    If $iError Then ConsoleWrite("Warning: AddAutomationEventHandler() call failed.")
EndFunc

Func UIAEH_AutomationEventHandler_HandleAutomationEvent($pSelf, $pSender, $iEventId)
    If $iEventId <> $UIA_SelectionItem_ElementSelectedEventId Then
        ConsoleWrite("Warning: got event: " & $iEventId & " but expected " & $UIA_SelectionItem_ElementSelectedEventId & @CRLF)
        Return 0
    EndIf
    Local $oTab = ObjCreateInterface($pSender, $sIID_IUIAutomationElement, $dtag_IUIAutomationElement)
    If Not IsObj($oTab) Then
        ConsoleWrite("Warning: Failed to set $oTab." & @CRLF)
        Return 0
    EndIf
    Local $pTabsPane, $oTabsPane
    $oTreeWalker.GetParentElement($oTab, $pTabsPane)
    If Not $pTabsPane Then
        ConsoleWrite("Warning: Failed to set $pTabsPane." & @CRLF)
        Return 0
    EndIf
    $oTabsPane = ObjCreateInterface($pTabsPane, $sIID_IUIAutomationElement, $dtag_IUIAutomationElement)
    If Not IsObj($oTabsPane) Then
        ConsoleWrite("Warning: Failed to set $oTabsPane." & @CRLF)
        Return 0
    EndIf
    Local $tabsPaneRuntimeIdPropertyId4
    $oTabsPane.GetCurrentPropertyValue($UIA_RuntimeIdPropertyId, $tabsPaneRuntimeIdPropertyId4)
    Local $tabsPaneRuntimeIdPropertyIdStr
    arrayToString($tabsPaneRuntimeIdPropertyId4, $tabsPaneRuntimeIdPropertyIdStr)
    If Not MapExists($pTabsPaneToWindowHandleMap, $tabsPaneRuntimeIdPropertyIdStr) Then
        ConsoleWrite("Warning: No $tabsPaneRuntimeIdPropertyIdStr in $pTabsPaneToWindowHandleMap found." & @CRLF)
        Return 0
    EndIf
    Local $windowHandle = $pTabsPaneToWindowHandleMap[$tabsPaneRuntimeIdPropertyIdStr]
    If Not MapExists($UIACacheMap, $windowHandle) Then
        ConsoleWrite("Warning: No $windowHandle in $UIACacheMap found." & @CRLF)
        Return 0
    EndIf
    $oTab.AddRef()
    If MapExists($UIACacheMap[$windowHandle], "oEventSelectedTab") Then
        Local $oOldTab = $UIACacheMap[$windowHandle]["oEventSelectedTab"]
        $oOldTab.Release()
    EndIf
    $UIACacheMap[$windowHandle]["oEventSelectedTab"] = $oTab
    Return 0
    #forceref $pSelf
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
    Local $bottomBound = -1
    Local $rightBound = -1
    cacheWindowInfo($windowHandle)
    ; TODO(nurupo): change to the dot notation once https://www.autoitscript.com/trac/autoit/ticket/3924 is fixed
    Local $tabsAreaBoundingBox = boundingBox($UIACacheMap[$windowHandle]["oTabsBoundingBoxElement"])
    If IsArray($tabsAreaBoundingBox) Then
        positionToCoordinates($tabsAreaBoundingBox)
        $bottomBound = $tabsAreaBoundingBox[3]
        $rightBound = $tabsAreaBoundingBox[2]
    Else
        ; fallback to the hardcoded bounding box
        Local $windowPos = WinGetPos($windowHandle)
        positionToCoordinates($windowPos)
        Local $windowStateBitmask = WinGetState($windowHandle)
        If BitAND($windowStateBitmask, $WIN_STATE_MAXIMIZED) Then
            $bottomBound = $windowPos[1] + $CHROME_TABS_AREA_HEIGHT_MAXIMIZED + 20
            $rightBound = $windowPos[2] - $CHROME_NONTABS_AREA_RIGHT_WIDTH_OFFSET_MAXIMIZED - 20
        Else
            $bottomBound = $windowPos[1] + $CHROME_TABS_AREA_HEIGHT_NOT_MAXIMIZED + 20
            $rightBound = $windowPos[2] - $CHROME_NONTABS_AREA_RIGHT_WIDTH_OFFSET_NOT_MAXIMIZED - 20
        EndIf
    EndIf
    If $mousePos[1] <= $bottomBound And $mousePos[0] <= $rightBound Then
        Return $windowHandle
    EndIf
    Return 0
EndFunc

Func _WinWaitActive($windowHandle, $unused, $timeout)
    Local $timer = TimerInit()
    Local $activeFlag = Null
    Do
        Local $state = WinGetState($windowHandle)
        $activeFlag = BitAND($state, $WIN_STATE_ACTIVE)
    Until $activeFlag Or TimerDiff($timer) >= $timeout*1000
    Return $activeFlag ? $windowHandle : 0
EndFunc

; This function might get called again in the middle if it already executing,
; e.g. if a user makes a couple of mouse wheel events in a short succession.
; This is due to some function calls used within this function processing the
; event loop inside, resulting in the next mouse wheel event being processed
; before the last one is done processing. This is undesirable, so to make sure
; that only one function call is processing the mouse wheel events, we enqueue
; the events and use a processing flag as a guard. The function is always
; called from the same thread, so it's not a multi-threading issue but rather
; an unintentional indirect recursion one.
Func onMouseWheel($event)
    Local $windowHandle = chromeWindowHandleWhenMouseInChromeTabsArea()
    If Not $windowHandle Then
        Return
    EndIf
    ; we assume that all queued events operate on the same Chrome window $windowHandle as in level 1 recursion, so we don't enqueue the $windowHandle along with the event
    Local Static $processing = False
    Local Static $eventList[128] ; from some testing, i find it hard to exceed 128, although not impossible, so that's a good starting capacity
    Local Static $eventListSize = 0
    ; enqueue the event
    ; make sure the queue is big enough
    If $eventListSize == UBound($eventList) Then
        ReDim $eventList[Int(($eventListSize * 1.5) + 1)] ; we don't size down the array, but that should be fine (tm)
    EndIf
    If Not $cfgReverse Then
        $eventList[$eventListSize] = $event == $MOUSE_WHEEL_SCROLL_UP_EVENT ? $TAB_SCROLL_LEFT : $TAB_SCROLL_RIGHT
    Else
        $eventList[$eventListSize] = $event == $MOUSE_WHEEL_SCROLL_UP_EVENT ? $TAB_SCROLL_RIGHT : $TAB_SCROLL_LEFT
    EndIf
    $eventListSize += 1
    ; return if we are not the first recusion level, let the first recursion level process all the events
    If $processing Then
        Return
    EndIf
    $processing = True
    While $eventListSize > 0
        Local $processed = False
        If Not $cfgWrapAround And _
            (($eventList[$eventListSize-1] == $TAB_SCROLL_LEFT  And isEdgeTabSelected($UIACacheMap[$windowHandle]["oTabsPane"], $TAB_FIRST)) Or _
             ($eventList[$eventListSize-1] == $TAB_SCROLL_RIGHT And isEdgeTabSelected($UIACacheMap[$windowHandle]["oTabsPane"], $TAB_LAST))) Then
            $eventListSize = 0
            ExitLoop
        EndIf
        Local $windowStateBitmask = WinGetState($windowHandle)
        If BitAND($windowStateBitmask, $WIN_STATE_ACTIVE) Then
            dequeueAndProcessEvents($windowHandle, $eventList, $eventListSize)
            $processed = True
        ElseIf $cfgAutofocus Then
            Switch $cfgAutofocusAfterwards
                Case $CFG_AUTOFOCUS_AFTERWARDS_KEEP
                    If WinActivate($windowHandle) <> 0 And _WinWaitActive($windowHandle, "", 1) <> 0 Then
                        dequeueAndProcessEvents($windowHandle, $eventList, $eventListSize)
                        $processed = True
                    EndIf
                Case $CFG_AUTOFOCUS_AFTERWARDS_UNDO
                    $aauInitiallyActive = WinGetHandle("[ACTIVE]")
                    $aauInitialWinList = WinList()
                    Dim $aauTopmostWinList[$aauInitialWinList[0][0]+1]
                    $aauFoundIndex = -1
                    $aauSetWindowPosCount = 0
                    ; figure out which windows we want to make temporarily topmost and which are already topmost
                    For $i = 1 to $aauInitialWinList[0][0]
                        If $aauInitialWinList[$i][1] == $windowHandle Then
                            $aauFoundIndex = $i
                        EndIf
                        $aauTopmostWinList[$i] = False
                        Local $state = WinGetState($aauInitialWinList[$i][1])
                        If BitAND($state, $WIN_STATE_VISIBLE) And Not BitAND($state, $WIN_STATE_MINIMIZED) Then
                            $aauTopmostWinList[$i] = BitAND(_WinAPI_GetWindowLong($aauInitialWinList[$i][1], $GWL_EXSTYLE), $WS_EX_TOPMOST) == $WS_EX_TOPMOST
                            If ($aauFoundIndex == -1 And $aauInitialWinList[$i][0] <> "") Or $aauTopmostWinList[$i] Then
                                $aauSetWindowPosCount += 1
                            Else
                                $aauInitialWinList[$i][1] = 0
                            EndIf
                        Else
                            $aauInitialWinList[$i][1] = 0
                        EndIf
                    Next
                    If $aauFoundIndex > 0 And $aauSetWindowPosCount > 0 Then
                        autofocusAfterwardsUndoPrologue()
                        dequeueAndProcessEvents($windowHandle, $eventList, $eventListSize)
                        $processed = True
                        autofocusAfterwardsUndoEpilogue()
                    EndIf
            EndSwitch
        EndIf
        ; discard the event queue if we can't process it
        If Not $processed Then
            $eventListSize = 0
        EndIf
    WEnd
    $processing = False
EndFunc

Func autofocusAfterwardsUndoPrologue()
    Do
        Local $count = 0
        Local $windowPosInfo = _WinAPI_BeginDeferWindowPos($aauSetWindowPosCount)
        ; first move non-topmost windows to the top (by making them temporarily topmost)
        For $i = $aauFoundIndex-1 To 1 Step -1
            If $aauInitialWinList[$i][1] And Not $aauTopmostWinList[$i] Then
                $count += 1
                $windowPosInfo = _WinAPI_DeferWindowPos($windowPosInfo, $aauInitialWinList[$i][1], $HWND_TOPMOST, 0, 0, 0, 0, BitOR($SWP_NOACTIVATE, $SWP_NOMOVE, $SWP_NOSIZE, $SWP_NOOWNERZORDER))
                ;ConsoleWrite("+tmp on-top: " & $windowPosInfo & ", " & $aauInitialWinList[$i][1] & ", " & $aauInitialWinList[$i][0] & @CRLF)
                If Not $windowPosInfo Then
                    ;ConsoleWrite("! removing" & @CRLF)
                    $aauInitialWinList[$i][1] = 0
                    ExitLoop
                EndIf
            EndIf
        Next
        ; then move all of the topmost ones to the top, over the temporarily topmost ones
        If $windowPosInfo Then
            For $i = $aauInitialWinList[0][0] To 1 Step -1
                If $aauInitialWinList[$i][1] And $aauTopmostWinList[$i] Then
                    $count += 1
                    $windowPosInfo = _WinAPI_DeferWindowPos($windowPosInfo, $aauInitialWinList[$i][1], $HWND_TOPMOST, 0, 0, 0, 0, BitOR($SWP_NOACTIVATE, $SWP_NOMOVE, $SWP_NOSIZE, $SWP_NOOWNERZORDER))
                    ;ConsoleWrite("perm on-top: " & $windowPosInfo & ", " & $aauInitialWinList[$i][1] & ", " & $aauInitialWinList[$i][0] & @CRLF)
                    If Not $windowPosInfo Then
                        ;ConsoleWrite("! removing" & @CRLF)
                        $aauInitialWinList[$i][1] = 0
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
    $aauEpilogueNeeded = True
EndFunc

Func autofocusAfterwardsUndoEpilogue()
    ; undo making windows temporarily topmost. some windows might have disappeared, so we need to handle that too
    Do
        Local $count = 0
        Local $windowPosInfo = _WinAPI_BeginDeferWindowPos($aauSetWindowPosCount)
        For $i = $aauFoundIndex-1 To 1 Step -1
            If $aauInitialWinList[$i][1] And Not $aauTopmostWinList[$i] And WinExists($aauInitialWinList[$i][1]) Then
                $count += 1
                $windowPosInfo = _WinAPI_DeferWindowPos($windowPosInfo, $aauInitialWinList[$i][1], $HWND_NOTOPMOST, 0, 0, 0, 0, BitOR($SWP_NOACTIVATE, $SWP_NOMOVE, $SWP_NOSIZE, $SWP_NOOWNERZORDER))
                ;ConsoleWrite("-tmp on-top: " & $windowPosInfo & ", " & $aauInitialWinList[$i][1] & ", " & $aauInitialWinList[$i][0] & @CRLF)
                ; it might fail if a window has disappeared, so re-do the whole Defer setup without that window
                If Not $windowPosInfo Then
                    ;ConsoleWrite("! removing" & @CRLF)
                    $aauInitialWinList[$i][1] = 0
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
    $aauEpilogueNeeded = False
    WinActivate($aauInitiallyActive)
    _WinWaitActive($aauInitiallyActive, "", 1)
EndFunc

Func dequeueAndProcessEvents($windowHandle, ByRef $eventList, ByRef $eventListSize)
    $eventListSize -= 1
    selectTab($windowHandle, $eventList[$eventListSize])
EndFunc

Func readConfig()
    $cfgReverse = Int(IniRead($CFG_FILE_PATH, "options", "reverse", 0)) == 1
    $cfgWrapAround = Int(IniRead($CFG_FILE_PATH, "options", "wrapAround", 0)) == 1
    $cfgAutofocus = Int(IniRead($CFG_FILE_PATH, "options", "autofocus", 1)) == 1
    $cfgAutofocusAfterwards = Int(IniRead($CFG_FILE_PATH, "options", "autofocusAfterwards", $CFG_AUTOFOCUS_AFTERWARDS_KEEP))
    If $cfgAutofocusAfterwards < 0 Or $cfgAutofocusAfterwards >= $CFG_AUTOFOCUS_AFTERWARDS_MAX Then
        ConsoleWrite("Warning: Incorrect value for the autofocusAfterwards option in " & $CFG_FILE_PATH &", using the default: autofocusAfterwards=" & $CFG_AUTOFOCUS_AFTERWARDS_KEEP & @CRLF)
        $cfgAutofocusAfterwards = $CFG_AUTOFOCUS_AFTERWARDS_KEEP
    EndIf
EndFunc

Func writeConfig()
    DirCreate($CFG_DIR_PATH)

    IniWrite($CFG_FILE_PATH, "options", "reverse", Int($cfgReverse))
    IniWrite($CFG_FILE_PATH, "options", "wrapAround", Int($cfgWrapAround))
    IniWrite($CFG_FILE_PATH, "options", "autofocus", Int($cfgAutofocus))
    IniWrite($CFG_FILE_PATH, "options", "autofocusAfterwards", $cfgAutofocusAfterwards)
EndFunc

Func processConfig()
    If $cfgReverse Then
        TrayItemSetState($trayReverse, $TRAY_CHECKED)
    EndIf

    If $cfgWrapAround Then
        TrayItemSetState($trayWrapAround, $TRAY_CHECKED)
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
        "UI Automation UDF" & @CRLF & _
        "Author: LarsJ and others" & @CRLF & _
        "Homepage: https://www.autoitscript.com/forum/topic/201683-ui-automation-udfs/" & @CRLF & _
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
        mainEventLoop()
    WEnd

    GUIDelete($formAbout)
EndFunc