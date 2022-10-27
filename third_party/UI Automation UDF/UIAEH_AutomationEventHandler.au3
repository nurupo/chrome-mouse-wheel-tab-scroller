#include-once
#include "UIA_Constants.au3"
#include "UIA_ObjectFromTag.au3"

Global $oUIAEH_AutomationEventHandler, $tUIAEH_AutomationEventHandler

Func UIAEH_AutomationEventHandlerCreate()
	$oUIAEH_AutomationEventHandler = ObjectFromTag( "UIAEH_AutomationEventHandler_", $dtag_IUIAutomationEventHandler, $tUIAEH_AutomationEventHandler )
EndFunc

Func UIAEH_AutomationEventHandlerDelete()
	$oUIAEH_AutomationEventHandler = 0
	DeleteObjectFromTag( $tUIAEH_AutomationEventHandler )
EndFunc

#cs
; Insert the two functions here in user code

; This is the function that receives events
Func UIAEH_AutomationEventHandler_HandleAutomationEvent( $pSelf, $pSender, $iEventId ) ; Ret: long  Par: ptr;int
	ConsoleWrite( @CRLF & "UIAEH_AutomationEventHandler_HandleAutomationEvent: $iEventId = " & $iEventId & @CRLF )
	Local $oSender = ObjCreateInterface( $pSender, $sIID_IUIAutomationElement,  $dtag_IUIAutomationElement  ) ; Windows 7
	;Local $oSender = ObjCreateInterface( $pSender, $sIID_IUIAutomationElement2, $dtag_IUIAutomationElement2 ) ; Windows 8
	;Local $oSender = ObjCreateInterface( $pSender, $sIID_IUIAutomationElement3, $dtag_IUIAutomationElement3 ) ; Windows 8.1
	;Local $oSender = ObjCreateInterface( $pSender, $sIID_IUIAutomationElement4, $dtag_IUIAutomationElement4 ) ; Windows 10 First
	;Local $oSender = ObjCreateInterface( $pSender, $sIID_IUIAutomationElement9, $dtag_IUIAutomationElement9 ) ; Windows 10 Last
	$oSender.AddRef()
	ConsoleWrite( "Title     = " & UIAEH_GetCurrentPropertyValue( $oSender, $UIA_NamePropertyId ) & @CRLF & _
	              "Class     = " & UIAEH_GetCurrentPropertyValue( $oSender, $UIA_ClassNamePropertyId ) & @CRLF & _
	              "Ctrl type = " & UIAEH_GetCurrentPropertyValue( $oSender, $UIA_ControlTypePropertyId ) & @CRLF & _
	              "Ctrl name = " & UIAEH_GetCurrentPropertyValue( $oSender, $UIA_LocalizedControlTypePropertyId ) & @CRLF & _
	              "Handle    = " & "0x" & Hex( UIAEH_GetCurrentPropertyValue( $oSender, $UIA_NativeWindowHandlePropertyId ) ) & @CRLF & _
	              "Value     = " & UIAEH_GetCurrentPropertyValue( $oSender, $UIA_ValueValuePropertyId ) & @CRLF  )
	Return 0x00000000 ; $S_OK
	#forceref $pSelf
EndFunc

; Auxiliary function (for simple properties only)
; There must be only one instance of this function
Func UIAEH_GetCurrentPropertyValue( $oSender, $iPropertyId )
	Local $vPropertyValue
	$oSender.GetCurrentPropertyValue( $iPropertyId, $vPropertyValue )
	Return $vPropertyValue
EndFunc
#ce

Func UIAEH_AutomationEventHandler_QueryInterface( $pSelf, $pRIID, $pObj ) ; Ret: long  Par: ptr;ptr*
	Switch DllCall( "ole32.dll", "int", "StringFromGUID2", "struct*", $pRIID, "wstr", "", "int", 40 )[2]
		Case "{00000000-0000-0000-C000-000000000046}" ; $sIID_IUnknown
			DllStructSetData( DllStructCreate( "ptr", $pObj ), 1, $pSelf )
			UIAEH_AutomationEventHandler_AddRef( $pSelf )
			Return 0x00000000 ; $S_OK
		Case $sIID_IUIAutomationEventHandler
			DllStructSetData( DllStructCreate( "ptr", $pObj ), 1, $pSelf )
			UIAEH_AutomationEventHandler_AddRef( $pSelf )
			Return 0x00000000 ; $S_OK
		Case Else
			Return 0x80004002 ; $E_NOINTERFACE
	EndSwitch
EndFunc

Func UIAEH_AutomationEventHandler_AddRef( $pSelf ) ; Ret: ulong
	Return 1
	#forceref $pSelf
EndFunc

Func UIAEH_AutomationEventHandler_Release( $pSelf ) ; Ret: ulong
	Return 1
	#forceref $pSelf
EndFunc
