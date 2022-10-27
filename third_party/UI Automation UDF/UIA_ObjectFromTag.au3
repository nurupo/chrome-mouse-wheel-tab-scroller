#include-once

Func ObjectFromTag($sFunctionPrefix, $tagInterface, ByRef $tInterface, $fPrint = False, $bIsUnknown = Default, $sIID = "{00000000-0000-0000-C000-000000000046}") ; last param is IID_IUnknown by default
	If $bIsUnknown = Default Then $bIsUnknown = True
	Local $sInterface = $tagInterface ; copy interface description
	Local $tagIUnknown = _
		"QueryInterface hresult(ptr;ptr*);" & _
		"AddRef dword();" & _
		"Release dword();"
	; Adding IUnknown methods
	If $bIsUnknown Then $tagInterface = $tagIUnknown & $tagInterface
	; Below line is really simple even though it looks super complex. It's just written weird to fit in one line, not to steal your attention
	Local $aMethods = StringSplit(StringReplace(StringReplace(StringReplace(StringReplace(StringTrimRight(StringReplace(StringRegExpReplace(StringRegExpReplace($tagInterface, "\w+\*", "ptr"), "\h*(\w+)\h*(\w+\*?)\h*(\((.*?)\))\h*(;|;*\z)", "$1\|$2;$4" & @LF), ";" & @LF, @LF), 1), "object", "idispatch"), "hresult", "long"), "bstr", "ptr"), "variant", "ptr"), @LF, 3)
	Local $iUbound = UBound($aMethods)
	Local $sMethod, $aSplit, $sNamePart, $aTagPart, $sTagPart, $sRet, $sParams, $hCallback
	; Allocation
	$tInterface = DllStructCreate("int RefCount;int Size;ptr Object;ptr Methods[" & $iUbound & "];int_ptr Callbacks[" & $iUbound & "];ulong_ptr Slots[16]") ; 16 pointer sized elements more to create space for possible private props
	If @error Then Return SetError(1, 0, 0)
	For $i = 0 To $iUbound - 1
		$aSplit = StringSplit($aMethods[$i], "|", 2)
		If UBound($aSplit) <> 2 Then ReDim $aSplit[2]
		$sNamePart = $aSplit[0]
		$sTagPart = $aSplit[1]
		$sMethod = $sFunctionPrefix & $sNamePart
		If $fPrint Then
			Local $iPar = StringInStr( $sTagPart, ";", 2 ), $t
			If $iPar Then
				$t = "Ret: " & StringLeft( $sTagPart, $iPar - 1 ) & "  " & _
						 "Par: " & StringRight( $sTagPart, StringLen( $sTagPart ) - $iPar )
			Else
				$t = "Ret: " & $sTagPart
			EndIf
			Local $s = "Func " & $sMethod & _
				"( $pSelf ) ; " & $t & @CRLF & _
				"EndFunc" & @CRLF
			ConsoleWrite( $s )
		EndIf
		$aTagPart = StringSplit($sTagPart, ";", 2)
		$sRet = $aTagPart[0]
		$sParams = StringReplace($sTagPart, $sRet, "", 1)
		$sParams = "ptr" & $sParams
		$hCallback = DllCallbackRegister($sMethod, $sRet, $sParams)
		If $fPrint Then ConsoleWrite(@error & @CRLF & @CRLF)
		DllStructSetData($tInterface, "Methods", DllCallbackGetPtr($hCallback), $i + 1) ; save callback pointer
		DllStructSetData($tInterface, "Callbacks", $hCallback, $i + 1) ; save callback handle
	Next
	DllStructSetData($tInterface, "RefCount", 1) ; initial ref count is 1
	DllStructSetData($tInterface, "Size", $iUbound) ; number of interface methods
	DllStructSetData($tInterface, "Object", DllStructGetPtr($tInterface, "Methods")) ; Interface method pointers
	Return ObjCreateInterface(DllStructGetPtr($tInterface, "Object"), $sIID, $sInterface, $bIsUnknown) ; pointer that's wrapped into object
EndFunc

Func DeleteObjectFromTag(ByRef $tInterface)
	For $i = 1 To DllStructGetData($tInterface, "Size")
		DllCallbackFree(DllStructGetData($tInterface, "Callbacks", $i))
	Next
	$tInterface = 0
EndFunc
