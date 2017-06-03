#comments-start
  MIT License

  Copyright (c) 2017 by Maxim Biro <nurupo.contributions@gmail.com>

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
#comments-end

#NoTrayIcon

#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_icon=icon.ico
#AutoIt3Wrapper_Res_Comment=Scroll Chrome tabs using mouse wheel
#AutoIt3Wrapper_Res_Description=Scroll Chrome tabs using mouse wheel
#AutoIt3Wrapper_Res_Fileversion=0.0.2.0
#AutoIt3Wrapper_Res_LegalCopyright=Maxim Biro

#include "MouseOnEvent.au3"

$CHROME_TABS_AREA_HEIGHT_MAXIMIZED = 28
$CHROME_TABS_AREA_HEIGHT_NOT_MAXIMIZED = 48
$CHROME_NONTABS_AREA_RIGHT_WIDTH_OFFSET_MAXIMIZED = 200
$CHROME_NONTABS_AREA_RIGHT_WIDTH_OFFSET_NOT_MAXIMIZED = 150

_MouseSetOnEvent($MOUSE_WHEELSCROLLUP_EVENT, "mouseWheelUp")
_MouseSetOnEvent($MOUSE_WHEELSCROLLDOWN_EVENT, "mouseWheelDown")

Opt("TrayMenuMode", 1)
$trayExit = TrayCreateItem("Exit")
TraySetClick(16)
TraySetState()

While 1
    $msg = TrayGetMsg()
    Select
        Case $msg = $trayExit
            Exit
    EndSelect

    Sleep(10)
WEnd

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
