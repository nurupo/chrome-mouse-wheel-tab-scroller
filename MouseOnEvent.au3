#Region Header

#CS

    Title:          MouseOnEvent UDF
    Filename:       MouseOnEvent.au3
    Description:    Set an events handler for Mouse device.
    Author:         G.Sandler a.k.a (Mr)CreatoR (CreatoR's Lab - http://creator-lab.ucoz.ru, http://autoit-script.ru)
    Version:        2.3
    Requirements:   AutoIt v3.3.6.1 - 3.3.14.1, Developed/Tested on Win 7, with standard 3-buttons mouse device.
    Uses:           WinAPIEx.au3, APIConstants.au3, WindowsConstants.au3, GUIConstantsEx.au3, Timers.au3
	Forum Link:     http://www.autoitscript.com/forum/index.php?showtopic=64738
    Notes:          
                    * This UDF (when using _MouseSetOnEvent_RI function) register $WM_INPUT windows message, can cause a conflict with other UDFs/scripts.
					* Do not mix _MouseSetOnEvent and _MouseSetOnEvent_RI, can cause unpredictable behavior.
					* The original events-messages (such as $WM_MOUSEMOVE) can be used as well.
                    * Blocking $sFuncName function with commands such as "Msgbox()" can lead to unexpected behavior,
					   the return to the system should be as fast as possible!
					* When $MOUSE_PRIMARYDOWN_EVENT and $MOUSE_SECONDARYDOWN_EVENT are set,
					   the $MOUSE_PRIMARYDBLCLK_EVENT and $MOUSE_SECONDARYDBLCLK_EVENT events are also set by force,
					   to unset these events use _MouseSetOnEvent($MOUSE_PRIMARYDBLCLK_EVENT or $MOUSE_SECONDARYDBLCLK_EVENT).
					* - When using Obfuscator/Au3Stripper, make sure to add following (and user event) functions to ignore list (#Obfuscator_Ignore_Funcs/#Au3Stripper_Ignore_Funcs):
							__MouseSetOnEvent_DoubleClickExpire, __MouseSetOnEvent_DoubleClickExpire_RI, __MouseSetOnEvent_MainHandler, __MouseSetOnEvent_MainHandler_RI, __MouseSetOnEvent_WaitHookReturn
					  - And also add following variables to ignore list (#Obfuscator_Ignore_Variables/#Au3Stripper_Ignore_Variables):
							$a__MSOE_Events, $a__MSOE_Events_RI, $a__MSOE_PrmDblClk_Data, $a__MSOE_ScnDblClk_Data, $a__MSOE_XbtnDblClk_Data, $a__MSOE_RI_PrmDblClk_Data, $a__MSOE_RI_ScnDblClk_Data, $a__MSOE_RI_WhlDblClk_Data, $a__MSOE_RI_XbtnDblClk_Data
					
    ChangLog:
			v2.3 [04.11.2015]
			* Added user public constants $MOE_RUNDEFPROC and $MOE_BLOCKDEFPROC, to use in Event function to define current event blocking.
			* Fixed issue with crash on changing events array.
			* Fixed issue with high CPU caused by incorrect timer kill.
			* Docs updated.
			
			v2.2 [13.08.2015]
			* AutoIt 3.3.6.1 - 3.3.8.1 supported again.
			* Code improvements and cosmetic changes.
			
			v2.1 [12.08.2015]
			* Now if $iBlockDefProc is 0 (or when using _MouseSetOnEvent_RI), user function $sFuncName called by PostMessage to prevent issues with hook (or WM_* message) stoppage.
			* Cosmetic code changes.
			* Docs updated.
			
			v2.0 [08.08.2015]
			* Script breaking version!
			* Dropped AutoIt 3.3.6.1 - 3.3.8.1 support.
			* Added alternative _MouseSetOnEvent_RI function using Raw Input Data instead of mouse hook. !!! This function does not support $iBlockDefProc.
			* Added support for XBUTTON2 detection. Use $MOUSE_XBUTTON2DOWN_EVENT, $MOUSE_XBUTTON2UP_EVENT, and $MOUSE_XBUTTON2DBLCLK_EVENT constants to separate between XBUTTON and XBUTTON2.
			* Cosmetic changes in the UDF code.
			
			v1.9 [22.07.2012]
			* Script breaking version!
			* Dropped AutoIt 3.3.0.0 support.
			* Instead of $sParam1 and $sParam2, now $vParam used as last parameter.
			* Event function ($sFuncName) now called with $iEvent as first parameter, and $vParam as second (both optional).
			* Now $iBlockDefProc is set to -1 by default (event function can define whether to block event process or not, simply by returning 1 or 0).
			* Fixed not working $MOUSE_PRIMARYDBLCLK_EVENT and $MOUSE_SECONDARYDBLCLK_EVENT,
			  now handled manually because windows does not always receive these events (depending on CS_DBLCLKS style).
			  (not tested properly, so these events will have "experimental" label for now).
			* Fixed error related to "Subscript used with non-Array variable", caused when window with handle of $hTargetWnd parameter is not found (window closed).
			* Examples updated.
			
			v1.8 [02.06.2010]
			* Fixed an issue with wrong handling when $MOUSE_XBUTTONUP/DOWN_EVENT and few other events are set.
			* Fixed an issue when user attempts to set other function for the event that already have been set.
			  Now the function and other parameters are replaced for the current event.
			* UDF file renamed (removed "Set" in the middle and "_UDF" at the end of the name).
			* Cosmetic changes in the UDF code.
			* Docs updated.
			
			v1.7 [14.10.2009]
			* Stability fixes. Thanks again to wraithdu.
			
			v1.6 [13.10.2009]
			* Fixed an issue with releasing the resources of mouse hook. Thanks to wraithdu.
			
			v1.5 [09.10.2009]
			+ Added wheel button up/down *scrolling* event recognition.
				Thanks to JRowe (http://www.autoitscript.com/forum/index.php?showtopic=103362).
			* Fixed an issue with returning value from __MouseSetOnEvent_MainHandler - should call _WinAPI_CallNextHookEx before return.
			* Constants starting with MOUSE_EXTRABUTTON* renamed to MOUSE_XBUTTON*, as it should be in the first place.
			* Few examples updated.
			
			v1.4 [30.09.2009]
			+ Added UDF header to the function.
			+ Now the original events-messages (such as $WM_MOUSEMOVE) can be used as well.
			+ Added missing events (althought i am not sure if they are still supported)
				$MOUSE_PRIMARYDBLCLK_EVENT - Primary mouse button double click.
				$MOUSE_SECONDARYDBLCLK_EVENT - Secondary mouse button double click.
				$MOUSE_WHEELDBLCLK_EVENT - Wheel mouse button double click.
				$MOUSE_EXTRABUTTONDBLCLK_EVENT - Side mouse button double click.
				
			* Changed global vars and internal functions names to be more unique.
			* Fixed variables declaration and misspelling.
			
			v1.3 [27.10.2008]
			* Added optional parameter $iBlockDefProc - Define wether the Mouse events handler will block the default processing or not (Default is 1, block).
			  If this is -1, then user can Return from the event function to set processing operation (see the attached example «AutoDrag Window.au3»).
			
			v1.2 [05.04.2008]
			* Added: [Optional] parameter $hTargetWnd, if set, the OnEvent function will be called only on $hTargetWnd window, otherwise will be standard Event processing.
			  Note: Can be a little(?) buggy when you mix different events.
			
			v1.1 [22.03.2008]
			* Fixed: Incorrect ReDim when remove event from the array, it was causing UDF to crash script with error.
			* Spell/Grammar corrections 
			* Added: An example of _BlockMouseClicksInput().
			
			v1.0 [21.02.2008]
			* First public release.
#CE

#include-once
#include <WinAPIEx.au3>
#include <APIConstants.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <Timers.au3>

OnAutoItExitRegister('__MouseSetOnEvent_OnExitFunc')

#Au3Stripper_Ignore_Funcs=__MouseSetOnEvent_MainHandler,__MouseSetOnEvent_MainHandler_RI,__MouseSetOnEvent_WM_CALL,__MouseSetOnEvent_WaitHookReturn,__MouseSetOnEvent_DoubleClickExpire,__MouseSetOnEvent_DoubleClickExpire_RI,__MouseSetOnEvent_OnExitFunc

#EndRegion Header

#Region Global Constants and Variables

Global $a__MSOE_Events[1][1]
Global $a__MSOE_Events_RI[1][1]
Global $b__MSOE_Events_Changing		= False
Global $b__MSOE_Events_RI_Changing	= False
Global $h__MSOE_MouseProc 			= -1
Global $h__MSOE_MouseHook 			= -1
Global $i__MSOE_EventReturn			= 1
Global $h__MSOE_Hook_Timer			= 0

Global $a__MSOE_PrmDblClk_Data[4]
Global $a__MSOE_ScnDblClk_Data[4]
Global $a__MSOE_XbtnDblClk_Data[4]

Global $a__MSOE_RI_PrmDblClk_Data[4]
Global $a__MSOE_RI_ScnDblClk_Data[4]
Global $a__MSOE_RI_WhlDblClk_Data[4]
Global $a__MSOE_RI_XbtnDblClk_Data[4]

Global $a__MSOE_DblClk_Data			= __MouseSetOnEvent_GetDoubleClickData()
Global Enum $i__MSOE_DblClkData_iTimer, $i__MSOE_DblClkData_hTimer, $i__MSOE_DblClkData_iLastMXPos, $i__MSOE_DblClkData_iLastMYPos

Global Const $i__MSOE_WM_CALL		= _WinAPI_RegisterWindowMessage('WM_MSOE_CALL')
Global Const $h__MSOE_AutHwnd		= WinGetHandle('[CLASS:AutoIt v3;TITLE:' & AutoItWinGetTitle() & ']')
Global Const $h__MSOE_RI_HWND		= GUICreate('~RawInputData_Handler~')

GUIRegisterMsg($i__MSOE_WM_CALL, '__MouseSetOnEvent_WM_CALL')

#EndRegion Global Constants and Variables

#Region Public Constants

Global Const $MOUSE_MOVE_EVENT				= 0x200 		;512 (WM_MOUSEMOVE) 		; ==> Mouse moving.
Global Const $MOUSE_PRIMARYDOWN_EVENT		= 0x201 		;513 (WM_LBUTTONDOWN) 		; ==> Primary mouse button down.
Global Const $MOUSE_PRIMARYUP_EVENT			= 0x202 		;514 (WM_LBUTTONUP) 		; ==> Primary mouse button up.
Global Const $MOUSE_PRIMARYDBLCLK_EVENT		= 0x203 		;515 (WM_LBUTTONDBLCLK) 	; ==> Primary mouse button double click.
Global Const $MOUSE_SECONDARYDOWN_EVENT		= 0x204 		;516 (WM_RBUTTONDOWN) 		; ==> Secondary mouse button down.
Global Const $MOUSE_SECONDARYUP_EVENT		= 0x205 		;517 (WM_RBUTTONUP) 		; ==> Secondary mouse button up.
Global Const $MOUSE_SECONDARYDBLCLK_EVENT	= 0x206 		;518 (WM_RBUTTONDBLCLK) 	; ==> Secondary mouse button double click.
Global Const $MOUSE_WHEELDOWN_EVENT			= 0x207 		;519 (WM_MBUTTONDOWN) 		; ==> Wheel mouse button pressed down.
Global Const $MOUSE_WHEELUP_EVENT			= 0x208 		;520 (WM_MBUTTONUP) 		; ==> Wheel mouse button up.
Global Const $MOUSE_WHEELDBLCLK_EVENT		= 0x209 		;521 (WM_MBUTTONDBLCLK) 	; ==> Wheel mouse button double click.
Global Const $MOUSE_WHEELSCROLL_EVENT		= 0x20A 		;522 (WM_MOUSEWHEEL) 		; ==> Wheel mouse scroll.
Global Const $MOUSE_WHEELSCROLLDOWN_EVENT	= 0x20A + 8 	;530 (WM_MOUSEWHEEL + 8) 	; ==> Wheel mouse scroll Down.
Global Const $MOUSE_WHEELSCROLLUP_EVENT		= 0x20A + 16 	;538 (WM_MOUSEWHEEL + 16) 	; ==> Wheel mouse scroll Up.
Global Const $MOUSE_XBUTTONDOWN_EVENT		= 0x20B 		;523 (WM_XBUTTONDOWN) 		; ==> Side mouse button down (usually navigating next/back buttons).
Global Const $MOUSE_XBUTTONUP_EVENT			= 0x20C 		;524 (WM_XBUTTONUP) 		; ==> Side mouse button up.
Global Const $MOUSE_XBUTTONDBLCLK_EVENT		= 0x20D 		;525 (WM_XBUTTONDBLCLK) 	; ==> Side mouse button double click.
Global Const $MOUSE_XBUTTON2DOWN_EVENT		= 0x20B + 8 	;531 (WM_XBUTTONDOWN + 8) 	; ==> Side mouse button 2 down.
Global Const $MOUSE_XBUTTON2UP_EVENT		= 0x20C + 8 	;532 (WM_XBUTTONUP + 8) 	; ==> Side mouse button 2 up.
Global Const $MOUSE_XBUTTON2DBLCLK_EVENT	= 0x20D + 8 	;533 (WM_XBUTTONDBLCLK + 8) ; ==> Side mouse button 2 double click.

Global Const $MOE_RUNDEFPROC				= 0
Global Const $MOE_BLOCKDEFPROC				= 1

#EndRegion Public Constants

#Region Public Functions

; #FUNCTION# ====================================================================================================
; Name...........:	_MouseSetOnEvent
; Description....:	Set an events handler (a hook) for Mouse device.
; Syntax.........:	_MouseSetOnEvent($iEvent, $sFuncName = "", $hTargetWnd = 0, $iBlockDefProc = -1, $vParam = "")
; Parameters.....:	$iEvent 		- The event to set, here is the list of supported events:
;										$MOUSE_MOVE_EVENT - Mouse moving.
;										$MOUSE_PRIMARYDOWN_EVENT - Primary mouse button down.
;										$MOUSE_PRIMARYUP_EVENT - Primary mouse button up.
;										$MOUSE_PRIMARYDBLCLK_EVENT - Primary mouse button double click.
;										$MOUSE_SECONDARYDOWN_EVENT - Secondary mouse button down.
;										$MOUSE_SECONDARYUP_EVENT - Secondary mouse button up.
;										$MOUSE_SECONDARYDBLCLK_EVENT - Secondary mouse button double click.
;										$MOUSE_WHEELDOWN_EVENT - Wheel mouse button pressed down.
;										$MOUSE_WHEELUP_EVENT - Wheel mouse button up.
;										$MOUSE_WHEELDBLCLK_EVENT - Wheel mouse button double click.
;										$MOUSE_WHEELSCROLL_EVENT - Wheel mouse scroll.
;										$MOUSE_WHEELSCROLLDOWN_EVENT - Wheel mouse scroll *Down*.
;										$MOUSE_WHEELSCROLLUP_EVENT - Wheel mouse scroll *Up*.
;										$MOUSE_XBUTTONDOWN_EVENT - Side mouse button down (usualy navigating next/back buttons).
;										$MOUSE_XBUTTONUP_EVENT - Side mouse button up.
;										$MOUSE_XBUTTONDBLCLK_EVENT - Side mouse button double click.
;										$MOUSE_XBUTTON2DOWN_EVENT - Side mouse button 2 down (usualy navigating next/back buttons).
;										$MOUSE_XBUTTON2UP_EVENT - Side mouse button 2 up.
;										$MOUSE_XBUTTON2DBLCLK_EVENT - Side mouse button 2 double click.
;
;					$sFuncName 		- [Optional] Function name to call when the event is triggered.
;										If this parameter is empty string ("") or omited, the function will *unset* the $iEvent.
;					$hTargetWnd 	- [Optional] Window handle to set the event for, e.g the event is set only for this window.
;					$iBlockDefProc 	- [Optional] Defines if the event should be blocked (actualy block the mouse action).
;										If this parameter = -1 (default), then event function can define whether to block event process or not, simply by returning $MOE_BLOCKDEFPROC (1) or $MOE_RUNDEFPROC (0).
;					$vParam 		- [Optional] Parameter to pass to the event function ($sFuncName).
;					
; Return values..:	Success 		- If the event is set in the first time, or when the event is unset properly, the return is 1,
;										if it's set on existing event, the return is 2.
;					Failure 		- Returns 0 on UnSet event mode when there is no set events yet.
; Author.........:	G.Sandler ((Mr)CreatoR, CreatoR's Lab - http://creator-lab.ucoz.ru, http://autoit-script.ru)
; Modified.......:	
; Remarks........:	1) The original events-messages (such as $WM_MOUSEMOVE) can be used as well.
;					2) Blocking of $sFuncName function by window messages with commands
;                     such as "Msgbox()" can lead to unexpected behavior, the return to the system should be as fast as possible!
; Related........:	
; Link...........:	http://www.autoitscript.com/forum/index.php?showtopic=64738
; Example........:	Yes.
; ===============================================================================================================
Func _MouseSetOnEvent($iEvent, $sFuncName = "", $hTargetWnd = 0, $iBlockDefProc = -1, $vParam = "")
	$b__MSOE_Events_Changing = True
	
	If $sFuncName = "" Then ;Unset Event
		If $a__MSOE_Events[0][0] < 1 Then
			Return 0
		EndIf
		
		Local $aTmp_Mouse_Events[1][1] = [[0]]
		
		For $i = 1 To $a__MSOE_Events[0][0]
			If $a__MSOE_Events[$i][0] <> $iEvent Then
				$aTmp_Mouse_Events[0][0] += 1
				ReDim $aTmp_Mouse_Events[$aTmp_Mouse_Events[0][0]+1][5]
				
				$aTmp_Mouse_Events[$aTmp_Mouse_Events[0][0]][0] = $a__MSOE_Events[$i][0]
				$aTmp_Mouse_Events[$aTmp_Mouse_Events[0][0]][1] = $a__MSOE_Events[$i][1]
				$aTmp_Mouse_Events[$aTmp_Mouse_Events[0][0]][2] = $a__MSOE_Events[$i][2]
				$aTmp_Mouse_Events[$aTmp_Mouse_Events[0][0]][3] = $a__MSOE_Events[$i][3]
				$aTmp_Mouse_Events[$aTmp_Mouse_Events[0][0]][4] = $a__MSOE_Events[$i][4]
			EndIf
		Next
		
		$a__MSOE_Events = $aTmp_Mouse_Events
		
		If $a__MSOE_Events[0][0] < 1 Then
			If $i__MSOE_EventReturn = 1 Then
				__MouseSetOnEvent_OnExitFunc()
			ElseIf $i__MSOE_EventReturn = 0 Then
				$h__MSOE_Hook_Timer = _Timer_SetTimer($h__MSOE_AutHwnd, 10, "__MouseSetOnEvent_WaitHookReturn")
			EndIf
		EndIf
		
		$b__MSOE_Events_Changing = False
		
		Return 1
	EndIf
	
	;First event
	If $a__MSOE_Events[0][0] < 1 Then
		$h__MSOE_MouseProc = DllCallbackRegister("__MouseSetOnEvent_MainHandler", "int", "int;ptr;ptr")
		$h__MSOE_MouseHook = _WinAPI_SetWindowsHookEx($WH_MOUSE_LL, DllCallbackGetPtr($h__MSOE_MouseProc), _WinAPI_GetModuleHandle(0), 0)
	EndIf
	
	;Search thru events, and if the event already set, we just (re)set the new function and other parameters
	For $i = 1 To $a__MSOE_Events[0][0]
		If $a__MSOE_Events[$i][0] = $iEvent Then
			$a__MSOE_Events[$i][0] = $iEvent
			$a__MSOE_Events[$i][1] = $sFuncName
			$a__MSOE_Events[$i][2] = $hTargetWnd
			$a__MSOE_Events[$i][3] = $iBlockDefProc
			$a__MSOE_Events[$i][4] = $vParam
			
			$b__MSOE_Events_Changing = False
			
			Return 2
		EndIf
	Next
	
	$a__MSOE_Events[0][0] += 1
	ReDim $a__MSOE_Events[$a__MSOE_Events[0][0]+1][5]
	
	$a__MSOE_Events[$a__MSOE_Events[0][0]][0] = $iEvent
	$a__MSOE_Events[$a__MSOE_Events[0][0]][1] = $sFuncName
	$a__MSOE_Events[$a__MSOE_Events[0][0]][2] = $hTargetWnd
	$a__MSOE_Events[$a__MSOE_Events[0][0]][3] = $iBlockDefProc
	$a__MSOE_Events[$a__MSOE_Events[0][0]][4] = $vParam
	
	$b__MSOE_Events_Changing = False
	
	;Add primary/secondary double click event, if needed can be disabled later
	If $iEvent = $MOUSE_PRIMARYDOWN_EVENT Then
		_MouseSetOnEvent($MOUSE_PRIMARYDBLCLK_EVENT, $sFuncName, $hTargetWnd, $iBlockDefProc, $vParam)
	EndIf
	
	If $iEvent = $MOUSE_SECONDARYDOWN_EVENT Then
		_MouseSetOnEvent($MOUSE_SECONDARYDBLCLK_EVENT, $sFuncName, $hTargetWnd, $iBlockDefProc, $vParam)
	EndIf
	
	Return 1
EndFunc

; #FUNCTION# ====================================================================================================
; Name...........:	_MouseSetOnEvent_RI
; Description....:	Set an events handler (using Raw Input Data) for Mouse device.
; Syntax.........:	_MouseSetOnEvent_RI($iEvent, $sFuncName = "", $hTargetWnd = 0, $vParam = "")
; Parameters.....:	$iEvent 		- The event to set, here is the list of supported events:
;										$MOUSE_MOVE_EVENT - Mouse moving.
;										$MOUSE_PRIMARYDOWN_EVENT - Primary mouse button down.
;										$MOUSE_PRIMARYUP_EVENT - Primary mouse button up.
;										$MOUSE_PRIMARYDBLCLK_EVENT - Primary mouse button double click.
;										$MOUSE_SECONDARYDOWN_EVENT - Secondary mouse button down.
;										$MOUSE_SECONDARYUP_EVENT - Secondary mouse button up.
;										$MOUSE_SECONDARYDBLCLK_EVENT - Secondary mouse button double click.
;										$MOUSE_WHEELDOWN_EVENT - Wheel mouse button pressed down.
;										$MOUSE_WHEELUP_EVENT - Wheel mouse button up.
;										$MOUSE_WHEELDBLCLK_EVENT - Wheel mouse button double click.
;										$MOUSE_WHEELSCROLL_EVENT - Wheel mouse scroll.
;										$MOUSE_WHEELSCROLLDOWN_EVENT - Wheel mouse scroll *Down*.
;										$MOUSE_WHEELSCROLLUP_EVENT - Wheel mouse scroll *Up*.
;										$MOUSE_XBUTTONDOWN_EVENT - Side mouse button down (usualy navigating next/back buttons).
;										$MOUSE_XBUTTONUP_EVENT - Side mouse button up.
;										$MOUSE_XBUTTONDBLCLK_EVENT - Side mouse button double click.
;										$MOUSE_XBUTTON2DOWN_EVENT - Side mouse button 2 down (usualy navigating next/back buttons).
;										$MOUSE_XBUTTON2UP_EVENT - Side mouse button 2 up.
;										$MOUSE_XBUTTON2DBLCLK_EVENT - Side mouse button 2 double click.
;
;					$sFuncName 		- [Optional] Function name to call when the event is triggered.
;										If this parameter is empty string ("") or omited, the function will *unset* the $iEvent.
;					$hTargetWnd 	- [Optional] Window handle to set the event for, e.g the event is set only for this window.
;					$vParam 		- [Optional] Parameter to pass to the event function ($sFuncName).
;					
; Return values..:	Success 		- If the event is set in the first time, or when the event is unset properly, the return is 1,
;										if it's set on existing event, the return is 2.
;					Failure 		- Returns 0 on UnSet event mode when there is no set events yet.
; Author.........:	G.Sandler ((Mr)CreatoR, CreatoR's Lab - http://creator-lab.ucoz.ru, http://autoit-script.ru)
; Modified.......:	
; Remarks........:	1) The original events-messages (such as $WM_MOUSEMOVE) can be used as well.
;					2) Blocking of $sFuncName function by window messages with commands
;                     such as "Msgbox()" can lead to unexpected behavior, the return to the system should be as fast as possible!
; Related........:	
; Link...........:	http://www.autoitscript.com/forum/index.php?showtopic=64738
; Example........:	Yes.
; ===============================================================================================================
Func _MouseSetOnEvent_RI($iEvent, $sFuncName = '', $hTargetWnd = 0, $vParam = '')
	$b__MSOE_Events_RI_Changing = True
	
	If $sFuncName = '' Then ;Unset Event
		If $a__MSOE_Events_RI[0][0] < 1 Then
			Return 0
		EndIf
		
		Local $aTmp_Mouse_Events[1][1] = [[0]]
		
		For $i = 1 To $a__MSOE_Events_RI[0][0]
			If $a__MSOE_Events_RI[$i][0] <> $iEvent Then
				$aTmp_Mouse_Events[0][0] += 1
				ReDim $aTmp_Mouse_Events[$aTmp_Mouse_Events[0][0]+1][4]
				
				$aTmp_Mouse_Events[$aTmp_Mouse_Events[0][0]][0] = $a__MSOE_Events_RI[$i][0]
				$aTmp_Mouse_Events[$aTmp_Mouse_Events[0][0]][1] = $a__MSOE_Events_RI[$i][1]
				$aTmp_Mouse_Events[$aTmp_Mouse_Events[0][0]][2] = $a__MSOE_Events_RI[$i][2]
				$aTmp_Mouse_Events[$aTmp_Mouse_Events[0][0]][3] = $a__MSOE_Events_RI[$i][3]
			EndIf
		Next
		
		$a__MSOE_Events_RI = $aTmp_Mouse_Events
		$b__MSOE_Events_RI_Changing = False
		
		Return 1
	EndIf
	
	;First event
	If $a__MSOE_Events_RI[0][0] < 1 Then
		; To obtain the values of "UsagePage" and "Usage" members of this structure read HID Usage Tables documentation
		; http://www.usb.org/developers/devclass_docs/HID1_11.pdf
		Local $tRID = DllStructCreate($tagRAWINPUTDEVICE)
		DllStructSetData($tRID, 'UsagePage', 0x01) ; Generic Desktop Controls
		DllStructSetData($tRID, 'Usage', 0x02) ; Mouse
		DllStructSetData($tRID, 'Flags', $RIDEV_INPUTSINK)
		DllStructSetData($tRID, 'hTarget', $h__MSOE_RI_HWND)
		Local $pRID = DllStructGetPtr($tRID)
		
		; Register HID input to obtain row input from mice
		_WinAPI_RegisterRawInputDevices($pRID)
		
		; Register WM_INPUT message
		GUIRegisterMsg($WM_INPUT, '__MouseSetOnEvent_MainHandler_RI')
	EndIf
	
	;Search thru events, and if the event already set, we just (re)set the new function and other parameters
	For $i = 1 To $a__MSOE_Events_RI[0][0]
		If $a__MSOE_Events_RI[$i][0] = $iEvent Then
			$a__MSOE_Events_RI[$i][0] = $iEvent
			$a__MSOE_Events_RI[$i][1] = $sFuncName
			$a__MSOE_Events_RI[$i][2] = $hTargetWnd
			$a__MSOE_Events_RI[$i][3] = $vParam
			
			$b__MSOE_Events_RI_Changing = False
			
			Return 2
		EndIf
	Next
	
	$a__MSOE_Events_RI[0][0] += 1
	ReDim $a__MSOE_Events_RI[$a__MSOE_Events_RI[0][0]+1][4]
	
	$a__MSOE_Events_RI[$a__MSOE_Events_RI[0][0]][0] = $iEvent
	$a__MSOE_Events_RI[$a__MSOE_Events_RI[0][0]][1] = $sFuncName
	$a__MSOE_Events_RI[$a__MSOE_Events_RI[0][0]][2] = $hTargetWnd
	$a__MSOE_Events_RI[$a__MSOE_Events_RI[0][0]][3] = $vParam
	
	$b__MSOE_Events_RI_Changing = False
	
	;Add primary/secondary double click event, if needed can be disabled later
	If $iEvent = $MOUSE_PRIMARYDOWN_EVENT Then
		_MouseSetOnEvent_RI($MOUSE_PRIMARYDBLCLK_EVENT, $sFuncName, $hTargetWnd, $vParam)
	EndIf
	
	If $iEvent = $MOUSE_SECONDARYDOWN_EVENT Then
		_MouseSetOnEvent_RI($MOUSE_SECONDARYDBLCLK_EVENT, $sFuncName, $hTargetWnd, $vParam)
	EndIf
	
	Return 1
EndFunc

#EndRegion Public Functions

#Region Internal Functions

Func __MouseSetOnEvent_MainHandler($nCode, $wParam, $lParam)
	If $nCode < 0 Then
		Return _WinAPI_CallNextHookEx($h__MSOE_MouseHook, $nCode, $wParam, $lParam) ;Continue processing
	EndIf
	
	Local $iEvent = _WinAPI_LoWord($wParam)
	Local $iRet, $iBlockDefProc_Ret
	Local $iWScrollDirection = 0
	
	If $a__MSOE_Events[0][0] < 1 Or $b__MSOE_Events_Changing Then
		Return 0
	EndIf
	
	Local Const $stMSLLHOOKSTRUCT = $tagPOINT & ";dword mouseData;dword flags;dword time;ulong_ptr dwExtraInfo"
	Local $tMSLLHOOKSTRUCT = DllStructCreate($stMSLLHOOKSTRUCT, $lParam)
	
	Switch $iEvent
		Case $MOUSE_WHEELSCROLL_EVENT
			$iWScrollDirection = _WinAPI_HiWord(DllStructGetData($tMSLLHOOKSTRUCT, 3))
		Case $MOUSE_PRIMARYDOWN_EVENT
			__MouseSetOnEvent_DoubleClickSetTimer('Prm')
			If @extended Then $iEvent = $MOUSE_PRIMARYDBLCLK_EVENT
		Case $MOUSE_SECONDARYDOWN_EVENT
			__MouseSetOnEvent_DoubleClickSetTimer('Scn')
			If @extended Then $iEvent = $MOUSE_SECONDARYDBLCLK_EVENT
		Case $MOUSE_XBUTTONDOWN_EVENT
			Local $iXButton = _WinAPI_HiWord(DllStructGetData($tMSLLHOOKSTRUCT, 'mouseData'))
			
			If $iXButton <> 1 Then ;$XBUTTON2
				$iEvent = $MOUSE_XBUTTON2DOWN_EVENT
			EndIf
			
			__MouseSetOnEvent_DoubleClickSetTimer('Xbtn')
			
			If @extended Then
				$iEvent = $MOUSE_XBUTTONDBLCLK_EVENT
				
				If $iXButton <> 1 Then ;$XBUTTON2
					$iEvent = $MOUSE_XBUTTON2DBLCLK_EVENT
				EndIf
			EndIf
		Case $MOUSE_XBUTTONUP_EVENT
			If _WinAPI_HiWord(DllStructGetData($tMSLLHOOKSTRUCT, 'mouseData')) <> 1 Then ;$XBUTTON2
				$iEvent = $MOUSE_XBUTTON2UP_EVENT
			EndIf
	EndSwitch
	
	For $i = 1 To $a__MSOE_Events[0][0]
		If $b__MSOE_Events_Changing Then
			ExitLoop
		EndIf
		
		If $a__MSOE_Events[$i][0] = $iEvent Or $iWScrollDirection <> 0 Then
			;Handle wheel scroll up/down
			If $iEvent = $MOUSE_WHEELSCROLL_EVENT And ($a__MSOE_Events[$i][0] = $MOUSE_WHEELSCROLL_EVENT Or $a__MSOE_Events[$i][0] = $MOUSE_WHEELSCROLLUP_EVENT Or $a__MSOE_Events[$i][0] = $MOUSE_WHEELSCROLLDOWN_EVENT) Then
				If $iWScrollDirection > 0 And $a__MSOE_Events[$i][0] = $MOUSE_WHEELSCROLLUP_EVENT Then
					$iEvent = $MOUSE_WHEELSCROLLUP_EVENT
				ElseIf $iWScrollDirection < 0 And $a__MSOE_Events[$i][0] = $MOUSE_WHEELSCROLLDOWN_EVENT Then
					$iEvent = $MOUSE_WHEELSCROLLDOWN_EVENT
				ElseIf $a__MSOE_Events[$i][0] = $MOUSE_WHEELSCROLLUP_EVENT Or $a__MSOE_Events[$i][0] = $MOUSE_WHEELSCROLLDOWN_EVENT Then
					ContinueLoop
				EndIf
			ElseIf $iWScrollDirection <> 0 Then
				ContinueLoop
			EndIf
			
			If $a__MSOE_Events[$i][2] <> 0 And Not __MouseSetOnEvent_IsHoveredWnd($a__MSOE_Events[$i][2]) Then
				Return 0 ;Allow default processing
			EndIf
			
			$i__MSOE_EventReturn = 0
			$iBlockDefProc_Ret = $a__MSOE_Events[$i][3]
			
			If $iBlockDefProc_Ret = $MOE_RUNDEFPROC Then
				_WinAPI_PostMessage($h__MSOE_RI_HWND, $i__MSOE_WM_CALL, $i, $iEvent)
				ExitLoop
			EndIf
			
			$iRet = Call($a__MSOE_Events[$i][1], $iEvent, $a__MSOE_Events[$i][4])
			
			If @error = 0xDEAD And @extended = 0xBEEF Then
				$iRet = Call($a__MSOE_Events[$i][1], $iEvent)
				
				If @error = 0xDEAD And @extended = 0xBEEF Then
					$iRet = Call($a__MSOE_Events[$i][1])
				EndIf
			EndIf
			
			$i__MSOE_EventReturn = 1
			
			If $iBlockDefProc_Ret = -1 Then
				$iBlockDefProc_Ret = $iRet
			EndIf
			
			Return $iBlockDefProc_Ret ;Block default processing (or not :))
		EndIf
	Next
	
	Return _WinAPI_CallNextHookEx($h__MSOE_MouseHook, $nCode, $wParam, $lParam) ;Continue processing
EndFunc

Func __MouseSetOnEvent_MainHandler_RI($hWnd, $iMsg, $wParam, $lParam)
	#forceref $iMsg, $wParam
	
	Local $tRIM, $iRet, $iEvent = 0
	Local $iWScrollDirection = 0
	
	If $a__MSOE_Events_RI[0][0] < 1 Or $b__MSOE_Events_RI_Changing Then
		Return 0
	EndIf
	
	Switch $hWnd
		Case $h__MSOE_RI_HWND
			Local $tRIM = DllStructCreate($tagRAWINPUTMOUSE)
			
			If _WinAPI_GetRawInputData($lParam, DllStructGetPtr($tRIM), DllStructGetSize($tRIM), $RID_INPUT) Then
				Local $Flags = DllStructGetData($tRIM, 'ButtonFlags')
				
				Select
					Case BitAND($Flags, $RI_MOUSE_LEFT_BUTTON_DOWN)
						$iEvent = $MOUSE_PRIMARYDOWN_EVENT
						__MouseSetOnEvent_DoubleClickSetTimer('RI_Prm')
						If @extended Then $iEvent = $MOUSE_PRIMARYDBLCLK_EVENT
					Case BitAND($Flags, $RI_MOUSE_LEFT_BUTTON_UP)
						$iEvent = $MOUSE_PRIMARYUP_EVENT
					Case BitAND($Flags, $RI_MOUSE_RIGHT_BUTTON_DOWN)
						$iEvent = $MOUSE_SECONDARYDOWN_EVENT
						__MouseSetOnEvent_DoubleClickSetTimer('RI_Scn')
						If @extended Then $iEvent = $MOUSE_SECONDARYDBLCLK_EVENT
					Case BitAND($Flags, $RI_MOUSE_RIGHT_BUTTON_UP)
						$iEvent = $MOUSE_SECONDARYUP_EVENT
					Case BitAND($Flags, $RI_MOUSE_MIDDLE_BUTTON_DOWN)
						$iEvent = $MOUSE_WHEELDOWN_EVENT
						__MouseSetOnEvent_DoubleClickSetTimer('RI_Whl')
						If @extended Then $iEvent = $MOUSE_WHEELDBLCLK_EVENT
					Case BitAND($Flags, $RI_MOUSE_MIDDLE_BUTTON_UP)
						$iEvent = $MOUSE_WHEELUP_EVENT
					Case BitAND($Flags, $RI_MOUSE_BUTTON_4_DOWN) Or BitAND($Flags, $RI_MOUSE_BUTTON_5_DOWN)
						$iEvent = $MOUSE_XBUTTONDOWN_EVENT
						
						If BitAND($Flags, $RI_MOUSE_BUTTON_5_DOWN) Then
							$iEvent = $MOUSE_XBUTTON2DOWN_EVENT
						EndIf
						
						__MouseSetOnEvent_DoubleClickSetTimer('RI_Xbtn')
						
						If @extended Then
							$iEvent = $MOUSE_XBUTTONDBLCLK_EVENT
							
							If BitAND($Flags, $RI_MOUSE_BUTTON_5_DOWN) Then
								$iEvent = $MOUSE_XBUTTON2DBLCLK_EVENT
							EndIf
						EndIf
					Case BitAND($Flags, $RI_MOUSE_BUTTON_4_UP) Or BitAND($Flags, $RI_MOUSE_BUTTON_5_UP)
						$iEvent = $MOUSE_XBUTTONUP_EVENT
						
						If BitAND($Flags, $RI_MOUSE_BUTTON_5_UP) Then
							$iEvent = $MOUSE_XBUTTON2UP_EVENT
						EndIf
					Case BitAND($Flags, $RI_MOUSE_WHEEL)
						$iEvent = $MOUSE_WHEELSCROLL_EVENT
						
						If _WinAPI_WordToShort(DllStructGetData($tRIM, 'ButtonData')) > 0 Then
							$iWScrollDirection = 1
						Else
							$iWScrollDirection = -1
						EndIf
				EndSelect
			EndIf
	EndSwitch
	
	If DllStructGetData($tRIM, 'LastX') + DllStructGetData($tRIM, 'LastY') <> 0 Then
		$iEvent = $MOUSE_MOVE_EVENT
	EndIf
	
	If $iEvent = 0 Then
		Return $GUI_RUNDEFMSG
	EndIf
	
	For $i = 1 To $a__MSOE_Events_RI[0][0]
		If $b__MSOE_Events_RI_Changing Then
			ExitLoop
		EndIf
		
		If $a__MSOE_Events_RI[$i][0] = $iEvent Or $iWScrollDirection <> 0 Then
			;Handle wheel scroll up/down
			If $iEvent = $MOUSE_WHEELSCROLL_EVENT And ($a__MSOE_Events_RI[$i][0] = $MOUSE_WHEELSCROLL_EVENT Or $a__MSOE_Events_RI[$i][0] = $MOUSE_WHEELSCROLLUP_EVENT Or $a__MSOE_Events_RI[$i][0] = $MOUSE_WHEELSCROLLDOWN_EVENT) Then
				If $iWScrollDirection > 0 And $a__MSOE_Events_RI[$i][0] = $MOUSE_WHEELSCROLLUP_EVENT Then
					$iEvent = $MOUSE_WHEELSCROLLUP_EVENT
				ElseIf $iWScrollDirection < 0 And $a__MSOE_Events_RI[$i][0] = $MOUSE_WHEELSCROLLDOWN_EVENT Then
					$iEvent = $MOUSE_WHEELSCROLLDOWN_EVENT
				ElseIf $a__MSOE_Events_RI[$i][0] = $MOUSE_WHEELSCROLLUP_EVENT Or $a__MSOE_Events_RI[$i][0] = $MOUSE_WHEELSCROLLDOWN_EVENT Then
					ContinueLoop
				EndIf
			ElseIf $iWScrollDirection <> 0 Then
				ContinueLoop
			EndIf
			
			If $a__MSOE_Events_RI[$i][2] <> 0 And Not __MouseSetOnEvent_IsHoveredWnd($a__MSOE_Events_RI[$i][2]) Then
				Return $GUI_RUNDEFMSG
			EndIf
			
			_WinAPI_PostMessage($h__MSOE_RI_HWND, $i__MSOE_WM_CALL, ($i * -1), $iEvent)
			
			ExitLoop
		EndIf
	Next
	
	Return $GUI_RUNDEFMSG
EndFunc

Func __MouseSetOnEvent_WM_CALL($hWnd, $iMsg, $wParam, $lParam)
	#forceref $hWnd, $iMsg
	
	Local $iIndex = Number($wParam)
	Local $iEvent = Number($lParam)
	Local $sFuncName, $vFuncParam
	
	If $iIndex < 0 Then
		$iIndex *= -1
		
		If $iIndex <= 0 Or $iIndex > UBound($a__MSOE_Events_RI) - 1 Then
			Return $GUI_RUNDEFMSG
		EndIf
		
		$sFuncName = $a__MSOE_Events_RI[$iIndex][1]
		$vFuncParam = $a__MSOE_Events_RI[$iIndex][3]
	Else
		If $iIndex <= 0 Or $iIndex > UBound($a__MSOE_Events) - 1 Then
			Return $GUI_RUNDEFMSG
		EndIf
		
		$sFuncName = $a__MSOE_Events[$iIndex][1]
		$vFuncParam = $a__MSOE_Events[$iIndex][4]
	EndIf
	
	Call($sFuncName, $iEvent, $vFuncParam)
	
	If @error = 0xDEAD And @extended = 0xBEEF Then
		Call($sFuncName, $iEvent)
		
		If @error = 0xDEAD And @extended = 0xBEEF Then
			Call($sFuncName)
		EndIf
	EndIf
	
	Return $GUI_RUNDEFMSG
EndFunc

Func __MouseSetOnEvent_WaitHookReturn($hWnd, $iMsg, $iIDTimer, $dwTime)
	If $i__MSOE_EventReturn = 1 Then
		_Timer_KillTimer($h__MSOE_AutHwnd, $h__MSOE_Hook_Timer)
		__MouseSetOnEvent_OnExitFunc()
	EndIf
EndFunc

Func __MouseSetOnEvent_IsHoveredWnd($hWnd)
	Local $tPoint = _WinAPI_GetMousePos()
	Return _WinAPI_GetAncestor(_WinAPI_WindowFromPoint($tPoint), $GA_ROOT) = $hWnd
EndFunc

Func __MouseSetOnEvent_DoubleClickSetTimer($sEvntVar)
	Local $iRetExt = 0
	Local $aData = Eval('a__MSOE_' & $sEvntVar & 'DblClk_Data')
	Local $sExpireFunc = '__MouseSetOnEvent_DoubleClickExpire'
	
	If StringLeft($sEvntVar, 2) = 'RI' Then
		$sExpireFunc = '__MouseSetOnEvent_DoubleClickExpire_RI'
	EndIf
	
	If $aData[$i__MSOE_DblClkData_iTimer] = 0 Then
		$aData[$i__MSOE_DblClkData_iTimer] = TimerInit()
		$aData[$i__MSOE_DblClkData_iLastMXPos] = MouseGetPos(0)
		$aData[$i__MSOE_DblClkData_iLastMYPos] = MouseGetPos(1)
		$aData[$i__MSOE_DblClkData_hTimer] = _Timer_SetTimer($h__MSOE_AutHwnd, $a__MSOE_DblClk_Data[0] + 50, $sExpireFunc)
	ElseIf $aData[$i__MSOE_DblClkData_iTimer] > 0 Then
		If TimerDiff($aData[$i__MSOE_DblClkData_iTimer]) <= $a__MSOE_DblClk_Data[0] Then
			Local $aCurrentMPos = MouseGetPos()
			Local $aLastMPos[2] = [$aData[$i__MSOE_DblClkData_iLastMXPos], $aData[$i__MSOE_DblClkData_iLastMYPos]]
			Local $iDC_Width = $aCurrentMPos[0] - $aLastMPos[0]
			
			If $aLastMPos[0] > $aCurrentMPos[0] Then
				$iDC_Width = $aLastMPos[0] - $aCurrentMPos[0]
			EndIf
			
			Local $iDC_Height = $aCurrentMPos[1] - $aLastMPos[1]
			
			If $aLastMPos[1] > $aCurrentMPos[1] Then
				$iDC_Height = $aLastMPos[1] - $aCurrentMPos[1]
			EndIf
			
			If $iDC_Width <= $a__MSOE_DblClk_Data[1] And $iDC_Height <= $a__MSOE_DblClk_Data[2] Then
				$iRetExt = 1
			EndIf
		EndIf
		
		$aData[$i__MSOE_DblClkData_iTimer] = 0
	Else
		Return
	EndIf
	
	Assign('a__MSOE_' & $sEvntVar & 'DblClk_Data', $aData, 2)
	SetExtended($iRetExt)
EndFunc

Func __MouseSetOnEvent_DoubleClickExpire($hWnd, $iMsg, $iIDTimer, $dwTime)
	Local $aData, $aEvntVars[3] = ['Prm', 'Scn', 'Xbtn']
	
	If $hWnd == 1 Then ;It's RawInput call
		Dim $aEvntVars[4] = ['RI_Whl', 'RI_Prm', 'RI_Scn', 'RI_Xbtn']
	EndIf
	
	For $i = 0 To UBound($aEvntVars) - 1
		$aData = Eval('a__MSOE_' & $aEvntVars[$i] & 'DblClk_Data')
		
		If TimerDiff($aData[$i__MSOE_DblClkData_iTimer]) > $a__MSOE_DblClk_Data[0] Then
			_Timer_KillTimer($h__MSOE_AutHwnd, $aData[$i__MSOE_DblClkData_hTimer])
			
			$aData[$i__MSOE_DblClkData_hTimer] = 0
			$aData[$i__MSOE_DblClkData_iTimer] = 0
			
			Assign('a__MSOE_' & $aEvntVars[$i] & 'DblClk_Data', $aData, 2)
		EndIf
	Next
EndFunc

Func __MouseSetOnEvent_DoubleClickExpire_RI($hWnd, $iMsg, $iIDTimer, $dwTime)
	__MouseSetOnEvent_DoubleClickExpire(1, $iMsg, $iIDTimer, $dwTime)
EndFunc

Func __MouseSetOnEvent_GetDoubleClickData()
	Local $aRet[3] = _
		[ _
			RegRead('HKEY_CURRENT_USER\Control Panel\Mouse', 'DoubleClickSpeed'), _
			RegRead('HKEY_CURRENT_USER\Control Panel\Mouse', 'DoubleClickWidth'), _
			RegRead('HKEY_CURRENT_USER\Control Panel\Mouse', 'DoubleClickHeight') _
		]
	
	Local $aGDCT = DllCall('User32.dll', 'uint', 'GetDoubleClickTime')
	
	If Not @error And $aGDCT[0] > 0 Then
		$aRet[0] = $aGDCT[0]
	EndIf
	
	Return $aRet
EndFunc

Func __MouseSetOnEvent_OnExitFunc()
	If $h__MSOE_MouseHook <> -1 Then
		_WinAPI_UnhookWindowsHookEx($h__MSOE_MouseHook)
		$h__MSOE_MouseHook = -1
	EndIf
	
	If $h__MSOE_MouseProc <> -1 Then
		DllCallbackFree($h__MSOE_MouseProc)
		$h__MSOE_MouseProc = -1
	EndIf
EndFunc

#EndRegion Internal Functions
