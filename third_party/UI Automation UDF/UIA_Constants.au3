; UIA constants and definitions for Windows XP, Windows Vista and Windows 7 are copied from
; CUIAutomation2.au3 by junkew: https://www.autoitscript.com/forum/index.php?showtopic=153520.

#include-once

; module UIA_PatternIds
Global Const $UIA_InvokePatternId            = 10000
Global Const $UIA_SelectionPatternId         = 10001
Global Const $UIA_ValuePatternId             = 10002
Global Const $UIA_RangeValuePatternId        = 10003
Global Const $UIA_ScrollPatternId            = 10004
Global Const $UIA_ExpandCollapsePatternId    = 10005
Global Const $UIA_GridPatternId              = 10006
Global Const $UIA_GridItemPatternId          = 10007
Global Const $UIA_MultipleViewPatternId      = 10008
Global Const $UIA_WindowPatternId            = 10009
Global Const $UIA_SelectionItemPatternId     = 10010
Global Const $UIA_DockPatternId              = 10011
Global Const $UIA_TablePatternId             = 10012
Global Const $UIA_TableItemPatternId         = 10013
Global Const $UIA_TextPatternId              = 10014
Global Const $UIA_TogglePatternId            = 10015
Global Const $UIA_TransformPatternId         = 10016
Global Const $UIA_ScrollItemPatternId        = 10017
Global Const $UIA_LegacyIAccessiblePatternId = 10018
Global Const $UIA_ItemContainerPatternId     = 10019
Global Const $UIA_VirtualizedItemPatternId   = 10020
Global Const $UIA_SynchronizedInputPatternId = 10021
Global Const $UIA_ObjectModelPatternId       = 10022 ; Windows 8
Global Const $UIA_AnnotationPatternId        = 10023 ; Windows 8
Global Const $UIA_TextPattern2Id             = 10024 ; Windows 8
Global Const $UIA_StylesPatternId            = 10025 ; Windows 8
Global Const $UIA_SpreadsheetPatternId       = 10026 ; Windows 8
Global Const $UIA_SpreadsheetItemPatternId   = 10027 ; Windows 8
Global Const $UIA_TransformPattern2Id        = 10028 ; Windows 8
Global Const $UIA_TextChildPatternId         = 10029 ; Windows 8
Global Const $UIA_DragPatternId              = 10030 ; Windows 8
Global Const $UIA_DropTargetPatternId        = 10031 ; Windows 8
Global Const $UIA_TextEditPatternId          = 10032 ; Windows 8.1
Global Const $UIA_CustomNavigationPatternId  = 10033 ; Windows 10
Global Const $UIA_SelectionPattern2Id        = 10034 ; Windows 10-1709

; module UIA_EventIds
Global Const $UIA_ToolTipOpenedEventId                             = 20000
Global Const $UIA_ToolTipClosedEventId                             = 20001
Global Const $UIA_StructureChangedEventId                          = 20002
Global Const $UIA_MenuOpenedEventId                                = 20003
Global Const $UIA_AutomationPropertyChangedEventId                 = 20004
Global Const $UIA_AutomationFocusChangedEventId                    = 20005
Global Const $UIA_AsyncContentLoadedEventId                        = 20006
Global Const $UIA_MenuClosedEventId                                = 20007
Global Const $UIA_LayoutInvalidatedEventId                         = 20008
Global Const $UIA_Invoke_InvokedEventId                            = 20009
Global Const $UIA_SelectionItem_ElementAddedToSelectionEventId     = 20010
Global Const $UIA_SelectionItem_ElementRemovedFromSelectionEventId = 20011
Global Const $UIA_SelectionItem_ElementSelectedEventId             = 20012
Global Const $UIA_Selection_InvalidatedEventId                     = 20013
Global Const $UIA_Text_TextSelectionChangedEventId                 = 20014
Global Const $UIA_Text_TextChangedEventId                          = 20015
Global Const $UIA_Window_WindowOpenedEventId                       = 20016
Global Const $UIA_Window_WindowClosedEventId                       = 20017
Global Const $UIA_MenuModeStartEventId                             = 20018
Global Const $UIA_MenuModeEndEventId                               = 20019
Global Const $UIA_InputReachedTargetEventId                        = 20020
Global Const $UIA_InputReachedOtherElementEventId                  = 20021
Global Const $UIA_InputDiscardedEventId                            = 20022
Global Const $UIA_SystemAlertEventId                               = 20023 ; Windows 8
Global Const $UIA_LiveRegionChangedEventId                         = 20024 ; Windows 8
Global Const $UIA_HostedFragmentRootsInvalidatedEventId            = 20025 ; Windows 8
Global Const $UIA_Drag_DragStartEventId                            = 20026 ; Windows 8
Global Const $UIA_Drag_DragCancelEventId                           = 20027 ; Windows 8
Global Const $UIA_Drag_DragCompleteEventId                         = 20028 ; Windows 8
Global Const $UIA_DropTarget_DragEnterEventId                      = 20029 ; Windows 8
Global Const $UIA_DropTarget_DragLeaveEventId                      = 20030 ; Windows 8
Global Const $UIA_DropTarget_DroppedEventId                        = 20031 ; Windows 8
Global Const $UIA_TextEdit_TextChangedEventId                      = 20032 ; Windows 8.1
Global Const $UIA_TextEdit_ConversionTargetChangedEventId          = 20033 ; Windows 8.1
Global Const $UIA_ChangesEventId                                   = 20034 ; Windows 10
Global Const $UIA_NotificationEventId                              = 20035 ; Windows 10
Global Const $UIA_ActiveTextPositionChangedEventId                 = 20036 ; Windows 10

; module UIA_PropertyIds
Global Const $UIA_RuntimeIdPropertyId                           = 30000
Global Const $UIA_BoundingRectanglePropertyId                   = 30001
Global Const $UIA_ProcessIdPropertyId                           = 30002
Global Const $UIA_ControlTypePropertyId                         = 30003
Global Const $UIA_LocalizedControlTypePropertyId                = 30004
Global Const $UIA_NamePropertyId                                = 30005
Global Const $UIA_AcceleratorKeyPropertyId                      = 30006
Global Const $UIA_AccessKeyPropertyId                           = 30007
Global Const $UIA_HasKeyboardFocusPropertyId                    = 30008
Global Const $UIA_IsKeyboardFocusablePropertyId                 = 30009
Global Const $UIA_IsEnabledPropertyId                           = 30010
Global Const $UIA_AutomationIdPropertyId                        = 30011
Global Const $UIA_ClassNamePropertyId                           = 30012
Global Const $UIA_HelpTextPropertyId                            = 30013
Global Const $UIA_ClickablePointPropertyId                      = 30014
Global Const $UIA_CulturePropertyId                             = 30015
Global Const $UIA_IsControlElementPropertyId                    = 30016
Global Const $UIA_IsContentElementPropertyId                    = 30017
Global Const $UIA_LabeledByPropertyId                           = 30018
Global Const $UIA_IsPasswordPropertyId                          = 30019
Global Const $UIA_NativeWindowHandlePropertyId                  = 30020
Global Const $UIA_ItemTypePropertyId                            = 30021
Global Const $UIA_IsOffscreenPropertyId                         = 30022
Global Const $UIA_OrientationPropertyId                         = 30023
Global Const $UIA_FrameworkIdPropertyId                         = 30024
Global Const $UIA_IsRequiredForFormPropertyId                   = 30025
Global Const $UIA_ItemStatusPropertyId                          = 30026
Global Const $UIA_IsDockPatternAvailablePropertyId              = 30027
Global Const $UIA_IsExpandCollapsePatternAvailablePropertyId    = 30028
Global Const $UIA_IsGridItemPatternAvailablePropertyId          = 30029
Global Const $UIA_IsGridPatternAvailablePropertyId              = 30030
Global Const $UIA_IsInvokePatternAvailablePropertyId            = 30031
Global Const $UIA_IsMultipleViewPatternAvailablePropertyId      = 30032
Global Const $UIA_IsRangeValuePatternAvailablePropertyId        = 30033
Global Const $UIA_IsScrollPatternAvailablePropertyId            = 30034
Global Const $UIA_IsScrollItemPatternAvailablePropertyId        = 30035
Global Const $UIA_IsSelectionItemPatternAvailablePropertyId     = 30036
Global Const $UIA_IsSelectionPatternAvailablePropertyId         = 30037
Global Const $UIA_IsTablePatternAvailablePropertyId             = 30038
Global Const $UIA_IsTableItemPatternAvailablePropertyId         = 30039
Global Const $UIA_IsTextPatternAvailablePropertyId              = 30040
Global Const $UIA_IsTogglePatternAvailablePropertyId            = 30041
Global Const $UIA_IsTransformPatternAvailablePropertyId         = 30042
Global Const $UIA_IsValuePatternAvailablePropertyId             = 30043
Global Const $UIA_IsWindowPatternAvailablePropertyId            = 30044
Global Const $UIA_ValueValuePropertyId                          = 30045
Global Const $UIA_ValueIsReadOnlyPropertyId                     = 30046
Global Const $UIA_RangeValueValuePropertyId                     = 30047
Global Const $UIA_RangeValueIsReadOnlyPropertyId                = 30048
Global Const $UIA_RangeValueMinimumPropertyId                   = 30049
Global Const $UIA_RangeValueMaximumPropertyId                   = 30050
Global Const $UIA_RangeValueLargeChangePropertyId               = 30051
Global Const $UIA_RangeValueSmallChangePropertyId               = 30052
Global Const $UIA_ScrollHorizontalScrollPercentPropertyId       = 30053
Global Const $UIA_ScrollHorizontalViewSizePropertyId            = 30054
Global Const $UIA_ScrollVerticalScrollPercentPropertyId         = 30055
Global Const $UIA_ScrollVerticalViewSizePropertyId              = 30056
Global Const $UIA_ScrollHorizontallyScrollablePropertyId        = 30057
Global Const $UIA_ScrollVerticallyScrollablePropertyId          = 30058
Global Const $UIA_SelectionSelectionPropertyId                  = 30059
Global Const $UIA_SelectionCanSelectMultiplePropertyId          = 30060
Global Const $UIA_SelectionIsSelectionRequiredPropertyId        = 30061
Global Const $UIA_GridRowCountPropertyId                        = 30062
Global Const $UIA_GridColumnCountPropertyId                     = 30063
Global Const $UIA_GridItemRowPropertyId                         = 30064
Global Const $UIA_GridItemColumnPropertyId                      = 30065
Global Const $UIA_GridItemRowSpanPropertyId                     = 30066
Global Const $UIA_GridItemColumnSpanPropertyId                  = 30067
Global Const $UIA_GridItemContainingGridPropertyId              = 30068
Global Const $UIA_DockDockPositionPropertyId                    = 30069
Global Const $UIA_ExpandCollapseExpandCollapseStatePropertyId   = 30070
Global Const $UIA_MultipleViewCurrentViewPropertyId             = 30071
Global Const $UIA_MultipleViewSupportedViewsPropertyId          = 30072
Global Const $UIA_WindowCanMaximizePropertyId                   = 30073
Global Const $UIA_WindowCanMinimizePropertyId                   = 30074
Global Const $UIA_WindowWindowVisualStatePropertyId             = 30075
Global Const $UIA_WindowWindowInteractionStatePropertyId        = 30076
Global Const $UIA_WindowIsModalPropertyId                       = 30077
Global Const $UIA_WindowIsTopmostPropertyId                     = 30078
Global Const $UIA_SelectionItemIsSelectedPropertyId             = 30079
Global Const $UIA_SelectionItemSelectionContainerPropertyId     = 30080
Global Const $UIA_TableRowHeadersPropertyId                     = 30081
Global Const $UIA_TableColumnHeadersPropertyId                  = 30082
Global Const $UIA_TableRowOrColumnMajorPropertyId               = 30083
Global Const $UIA_TableItemRowHeaderItemsPropertyId             = 30084
Global Const $UIA_TableItemColumnHeaderItemsPropertyId          = 30085
Global Const $UIA_ToggleToggleStatePropertyId                   = 30086
Global Const $UIA_TransformCanMovePropertyId                    = 30087
Global Const $UIA_TransformCanResizePropertyId                  = 30088
Global Const $UIA_TransformCanRotatePropertyId                  = 30089
Global Const $UIA_IsLegacyIAccessiblePatternAvailablePropertyId = 30090
Global Const $UIA_LegacyIAccessibleChildIdPropertyId            = 30091
Global Const $UIA_LegacyIAccessibleNamePropertyId               = 30092
Global Const $UIA_LegacyIAccessibleValuePropertyId              = 30093
Global Const $UIA_LegacyIAccessibleDescriptionPropertyId        = 30094
Global Const $UIA_LegacyIAccessibleRolePropertyId               = 30095
Global Const $UIA_LegacyIAccessibleStatePropertyId              = 30096
Global Const $UIA_LegacyIAccessibleHelpPropertyId               = 30097
Global Const $UIA_LegacyIAccessibleKeyboardShortcutPropertyId   = 30098
Global Const $UIA_LegacyIAccessibleSelectionPropertyId          = 30099
Global Const $UIA_LegacyIAccessibleDefaultActionPropertyId      = 30100
Global Const $UIA_AriaRolePropertyId                            = 30101
Global Const $UIA_AriaPropertiesPropertyId                      = 30102
Global Const $UIA_IsDataValidForFormPropertyId                  = 30103
Global Const $UIA_ControllerForPropertyId                       = 30104
Global Const $UIA_DescribedByPropertyId                         = 30105
Global Const $UIA_FlowsToPropertyId                             = 30106
Global Const $UIA_ProviderDescriptionPropertyId                 = 30107
Global Const $UIA_IsItemContainerPatternAvailablePropertyId     = 30108
Global Const $UIA_IsVirtualizedItemPatternAvailablePropertyId   = 30109
Global Const $UIA_IsSynchronizedInputPatternAvailablePropertyId = 30110
Global Const $UIA_OptimizeForVisualContentPropertyId            = 30111 ; Windows 8
Global Const $UIA_IsObjectModelPatternAvailablePropertyId       = 30112 ; Windows 8
Global Const $UIA_AnnotationAnnotationTypeIdPropertyId          = 30113 ; Windows 8
Global Const $UIA_AnnotationAnnotationTypeNamePropertyId        = 30114 ; Windows 8
Global Const $UIA_AnnotationAuthorPropertyId                    = 30115 ; Windows 8
Global Const $UIA_AnnotationDateTimePropertyId                  = 30116 ; Windows 8
Global Const $UIA_AnnotationTargetPropertyId                    = 30117 ; Windows 8
Global Const $UIA_IsAnnotationPatternAvailablePropertyId        = 30118 ; Windows 8
Global Const $UIA_IsTextPattern2AvailablePropertyId             = 30119 ; Windows 8
Global Const $UIA_StylesStyleIdPropertyId                       = 30120 ; Windows 8
Global Const $UIA_StylesStyleNamePropertyId                     = 30121 ; Windows 8
Global Const $UIA_StylesFillColorPropertyId                     = 30122 ; Windows 8
Global Const $UIA_StylesFillPatternStylePropertyId              = 30123 ; Windows 8
Global Const $UIA_StylesShapePropertyId                         = 30124 ; Windows 8
Global Const $UIA_StylesFillPatternColorPropertyId              = 30125 ; Windows 8
Global Const $UIA_StylesExtendedPropertiesPropertyId            = 30126 ; Windows 8
Global Const $UIA_IsStylesPatternAvailablePropertyId            = 30127 ; Windows 8
Global Const $UIA_IsSpreadsheetPatternAvailablePropertyId       = 30128 ; Windows 8
Global Const $UIA_SpreadsheetItemFormulaPropertyId              = 30129 ; Windows 8
Global Const $UIA_SpreadsheetItemAnnotationObjectsPropertyId    = 30130 ; Windows 8
Global Const $UIA_SpreadsheetItemAnnotationTypesPropertyId      = 30131 ; Windows 8
Global Const $UIA_IsSpreadsheetItemPatternAvailablePropertyId   = 30132 ; Windows 8
Global Const $UIA_Transform2CanZoomPropertyId                   = 30133 ; Windows 8
Global Const $UIA_IsTransformPattern2AvailablePropertyId        = 30134 ; Windows 8
Global Const $UIA_LiveSettingPropertyId                         = 30135 ; Windows 8
Global Const $UIA_IsTextChildPatternAvailablePropertyId         = 30136 ; Windows 8
Global Const $UIA_IsDragPatternAvailablePropertyId              = 30137 ; Windows 8
Global Const $UIA_DragIsGrabbedPropertyId                       = 30138 ; Windows 8
Global Const $UIA_DragDropEffectPropertyId                      = 30139 ; Windows 8
Global Const $UIA_DragDropEffectsPropertyId                     = 30140 ; Windows 8
Global Const $UIA_IsDropTargetPatternAvailablePropertyId        = 30141 ; Windows 8
Global Const $UIA_DropTargetDropTargetEffectPropertyId          = 30142 ; Windows 8
Global Const $UIA_DropTargetDropTargetEffectsPropertyId         = 30143 ; Windows 8
Global Const $UIA_DragGrabbedItemsPropertyId                    = 30144 ; Windows 8
Global Const $UIA_Transform2ZoomLevelPropertyId                 = 30145 ; Windows 8
Global Const $UIA_Transform2ZoomMinimumPropertyId               = 30146 ; Windows 8
Global Const $UIA_Transform2ZoomMaximumPropertyId               = 30147 ; Windows 8
Global Const $UIA_FlowsFromPropertyId                           = 30148 ; Windows 8
Global Const $UIA_IsTextEditPatternAvailablePropertyId          = 30149 ; Windows 8.1
Global Const $UIA_IsPeripheralPropertyId                        = 30150 ; Windows 8.1
Global Const $UIA_IsCustomNavigationPatternAvailablePropertyId  = 30151 ; Windows 10
Global Const $UIA_PositionInSetPropertyId                       = 30152 ; Windows 10
Global Const $UIA_SizeOfSetPropertyId                           = 30153 ; Windows 10
Global Const $UIA_LevelPropertyId                               = 30154 ; Windows 10
Global Const $UIA_AnnotationTypesPropertyId                     = 30155 ; Windows 10
Global Const $UIA_AnnotationObjectsPropertyId                   = 30156 ; Windows 10
Global Const $UIA_LandmarkTypePropertyId                        = 30157 ; Windows 10
Global Const $UIA_LocalizedLandmarkTypePropertyId               = 30158 ; Windows 10
Global Const $UIA_FullDescriptionPropertyId                     = 30159 ; Windows 10
Global Const $UIA_FillColorPropertyId                           = 30160 ; Windows 10
Global Const $UIA_OutlineColorPropertyId                        = 30161 ; Windows 10
Global Const $UIA_FillTypePropertyId                            = 30162 ; Windows 10
Global Const $UIA_VisualEffectsPropertyId                       = 30163 ; Windows 10
Global Const $UIA_OutlineThicknessPropertyId                    = 30164 ; Windows 10
Global Const $UIA_CenterPointPropertyId                         = 30165 ; Windows 10
Global Const $UIA_RotationPropertyId                            = 30166 ; Windows 10
Global Const $UIA_SizePropertyId                                = 30167 ; Windows 10
Global Const $UIA_IsSelectionPattern2AvailablePropertyId        = 30168 ; Windows 10
Global Const $UIA_Selection2FirstSelectedItemPropertyId         = 30169 ; Windows 10
Global Const $UIA_Selection2LastSelectedItemPropertyId          = 30170 ; Windows 10
Global Const $UIA_Selection2CurrentSelectedItemPropertyId       = 30171 ; Windows 10
Global Const $UIA_Selection2ItemCountPropertyId                 = 30172 ; Windows 10
Global Const $UIA_HeadingLevelPropertyId                        = 30173 ; Windows 10
Global Const $UIA_IsDialogPropertyId                            = 30174 ; Windows 10

; module UIA_TextAttributeIds
Global Const $UIA_AnimationStyleAttributeId          = 40000
Global Const $UIA_BackgroundColorAttributeId         = 40001
Global Const $UIA_BulletStyleAttributeId             = 40002
Global Const $UIA_CapStyleAttributeId                = 40003
Global Const $UIA_CultureAttributeId                 = 40004
Global Const $UIA_FontNameAttributeId                = 40005
Global Const $UIA_FontSizeAttributeId                = 40006
Global Const $UIA_FontWeightAttributeId              = 40007
Global Const $UIA_ForegroundColorAttributeId         = 40008
Global Const $UIA_HorizontalTextAlignmentAttributeId = 40009
Global Const $UIA_IndentationFirstLineAttributeId    = 40010
Global Const $UIA_IndentationLeadingAttributeId      = 40011
Global Const $UIA_IndentationTrailingAttributeId     = 40012
Global Const $UIA_IsHiddenAttributeId                = 40013
Global Const $UIA_IsItalicAttributeId                = 40014
Global Const $UIA_IsReadOnlyAttributeId              = 40015
Global Const $UIA_IsSubscriptAttributeId             = 40016
Global Const $UIA_IsSuperscriptAttributeId           = 40017
Global Const $UIA_MarginBottomAttributeId            = 40018
Global Const $UIA_MarginLeadingAttributeId           = 40019
Global Const $UIA_MarginTopAttributeId               = 40020
Global Const $UIA_MarginTrailingAttributeId          = 40021
Global Const $UIA_OutlineStylesAttributeId           = 40022
Global Const $UIA_OverlineColorAttributeId           = 40023
Global Const $UIA_OverlineStyleAttributeId           = 40024
Global Const $UIA_StrikethroughColorAttributeId      = 40025
Global Const $UIA_StrikethroughStyleAttributeId      = 40026
Global Const $UIA_TabsAttributeId                    = 40027
Global Const $UIA_TextFlowDirectionsAttributeId      = 40028
Global Const $UIA_UnderlineColorAttributeId          = 40029
Global Const $UIA_UnderlineStyleAttributeId          = 40030
Global Const $UIA_AnnotationTypesAttributeId         = 40031 ; Windows 8
Global Const $UIA_AnnotationObjectsAttributeId       = 40032 ; Windows 8
Global Const $UIA_StyleNameAttributeId               = 40033 ; Windows 8
Global Const $UIA_StyleIdAttributeId                 = 40034 ; Windows 8
Global Const $UIA_LinkAttributeId                    = 40035 ; Windows 8
Global Const $UIA_IsActiveAttributeId                = 40036 ; Windows 8
Global Const $UIA_SelectionActiveEndAttributeId      = 40037 ; Windows 8
Global Const $UIA_CaretPositionAttributeId           = 40038 ; Windows 8
Global Const $UIA_CaretBidiModeAttributeId           = 40039 ; Windows 8
Global Const $UIA_LineSpacingAttributeId             = 40040 ; Windows 10
Global Const $UIA_BeforeParagraphSpacingAttributeId  = 40041 ; Windows 10
Global Const $UIA_AfterParagraphSpacingAttributeId   = 40042 ; Windows 10
Global Const $UIA_SayAsInterpretAsAttributeId        = 40043 ; Windows 10

; module UIA_ControlTypeIds
Global Const $UIA_ButtonControlTypeId       = 50000
Global Const $UIA_CalendarControlTypeId     = 50001
Global Const $UIA_CheckBoxControlTypeId     = 50002
Global Const $UIA_ComboBoxControlTypeId     = 50003
Global Const $UIA_EditControlTypeId         = 50004
Global Const $UIA_HyperlinkControlTypeId    = 50005
Global Const $UIA_ImageControlTypeId        = 50006
Global Const $UIA_ListItemControlTypeId     = 50007
Global Const $UIA_ListControlTypeId         = 50008
Global Const $UIA_MenuControlTypeId         = 50009
Global Const $UIA_MenuBarControlTypeId      = 50010
Global Const $UIA_MenuItemControlTypeId     = 50011
Global Const $UIA_ProgressBarControlTypeId  = 50012
Global Const $UIA_RadioButtonControlTypeId  = 50013
Global Const $UIA_ScrollBarControlTypeId    = 50014
Global Const $UIA_SliderControlTypeId       = 50015
Global Const $UIA_SpinnerControlTypeId      = 50016
Global Const $UIA_StatusBarControlTypeId    = 50017
Global Const $UIA_TabControlTypeId          = 50018
Global Const $UIA_TabItemControlTypeId      = 50019
Global Const $UIA_TextControlTypeId         = 50020
Global Const $UIA_ToolBarControlTypeId      = 50021
Global Const $UIA_ToolTipControlTypeId      = 50022
Global Const $UIA_TreeControlTypeId         = 50023
Global Const $UIA_TreeItemControlTypeId     = 50024
Global Const $UIA_CustomControlTypeId       = 50025
Global Const $UIA_GroupControlTypeId        = 50026
Global Const $UIA_ThumbControlTypeId        = 50027
Global Const $UIA_DataGridControlTypeId     = 50028
Global Const $UIA_DataItemControlTypeId     = 50029
Global Const $UIA_DocumentControlTypeId     = 50030
Global Const $UIA_SplitButtonControlTypeId  = 50031
Global Const $UIA_WindowControlTypeId       = 50032
Global Const $UIA_PaneControlTypeId         = 50033
Global Const $UIA_HeaderControlTypeId       = 50034
Global Const $UIA_HeaderItemControlTypeId   = 50035
Global Const $UIA_TableControlTypeId        = 50036
Global Const $UIA_TitleBarControlTypeId     = 50037
Global Const $UIA_SeparatorControlTypeId    = 50038
Global Const $UIA_SemanticZoomControlTypeId = 50039 ; Windows 8
Global Const $UIA_AppBarControlTypeId       = 50040 ; Windows 8.1

; module UIA_AnnotationTypes
Global Const $UIA_AnnotationType_Unknown                = 60000
Global Const $UIA_AnnotationType_SpellingError          = 60001
Global Const $UIA_AnnotationType_GrammarError           = 60002
Global Const $UIA_AnnotationType_Comment                = 60003
Global Const $UIA_AnnotationType_FormulaError           = 60004
Global Const $UIA_AnnotationType_TrackChanges           = 60005
Global Const $UIA_AnnotationType_Header                 = 60006
Global Const $UIA_AnnotationType_Footer                 = 60007
Global Const $UIA_AnnotationType_Highlighted            = 60008
Global Const $UIA_AnnotationType_Endnote                = 60009
Global Const $UIA_AnnotationType_Footnote               = 60010
Global Const $UIA_AnnotationType_InsertionChange        = 60011
Global Const $UIA_AnnotationType_DeletionChange         = 60012
Global Const $UIA_AnnotationType_MoveChange             = 60013
Global Const $UIA_AnnotationType_FormatChange           = 60014
Global Const $UIA_AnnotationType_UnsyncedChange         = 60015
Global Const $UIA_AnnotationType_EditingLockedChange    = 60016
Global Const $UIA_AnnotationType_ExternalChange         = 60017
Global Const $UIA_AnnotationType_ConflictingChange      = 60018
Global Const $UIA_AnnotationType_Author                 = 60019
Global Const $UIA_AnnotationType_AdvancedProofingIssue  = 60020
Global Const $UIA_AnnotationType_DataValidationError    = 60021
Global Const $UIA_AnnotationType_CircularReferenceError = 60022
Global Const $UIA_AnnotationType_Mathematics            = 60023

; module UIA_StyleIds
Global Const $UIA_StyleId_Custom       = 70000
Global Const $UIA_StyleId_Heading1     = 70001
Global Const $UIA_StyleId_Heading2     = 70002
Global Const $UIA_StyleId_Heading3     = 70003
Global Const $UIA_StyleId_Heading4     = 70004
Global Const $UIA_StyleId_Heading5     = 70005
Global Const $UIA_StyleId_Heading6     = 70006
Global Const $UIA_StyleId_Heading7     = 70007
Global Const $UIA_StyleId_Heading8     = 70008
Global Const $UIA_StyleId_Heading9     = 70009
Global Const $UIA_StyleId_Title        = 70010
Global Const $UIA_StyleId_Subtitle     = 70011
Global Const $UIA_StyleId_Normal       = 70012
Global Const $UIA_StyleId_Emphasis     = 70013
Global Const $UIA_StyleId_Quote        = 70014
Global Const $UIA_StyleId_BulletedList = 70015
Global Const $UIA_StyleId_NumberedList = 70016

; module UIA_LandmarkTypeIds
Global Const $UIA_CustomLandmarkTypeId     = 80000
Global Const $UIA_FormLandmarkTypeId       = 80001
Global Const $UIA_MainLandmarkTypeId       = 80002
Global Const $UIA_NavigationLandmarkTypeId = 80003
Global Const $UIA_SearchLandmarkTypeId     = 80004

; module UIA_HeadingLevelIds
Global Const $UIA_HeadingLevel_None = 80050
Global Const $UIA_HeadingLevel1     = 80051
Global Const $UIA_HeadingLevel2     = 80052
Global Const $UIA_HeadingLevel3     = 80053
Global Const $UIA_HeadingLevel4     = 80054
Global Const $UIA_HeadingLevel5     = 80055
Global Const $UIA_HeadingLevel6     = 80056
Global Const $UIA_HeadingLevel7     = 80057
Global Const $UIA_HeadingLevel8     = 80058
Global Const $UIA_HeadingLevel9     = 80059

; module UIA_ChangeIds
Global Const $UIA_SummaryChangeId = 90000

; module UIA_MetadataIds
Global Const $UIA_SayAsInterpretAsMetadataId = 100000


; enum ActiveEnd
Global Const $ActiveEnd_None  = 0
Global Const $ActiveEnd_Start = 1
Global Const $ActiveEnd_End   = 2

; enum AnimationStyle
Global Const $AnimationStyle_None = 0
Global Const $AnimationStyle_LasVegasLights = 1
Global Const $AnimationStyle_BlinkingBackground = 2
Global Const $AnimationStyle_SparkleText = 3
Global Const $AnimationStyle_MarchingBlackAnts = 4
Global Const $AnimationStyle_MarchingRedAnts = 5
Global Const $AnimationStyle_Shimmer = 6
Global Const $AnimationStyle_Other = -1

; enum AutomationElementMode
Global Const $AutomationElementMode_None = 0
Global Const $AutomationElementMode_Full = 1

; enum BulletStyle
Global Const $BulletStyle_None               = 0
Global Const $BulletStyle_HollowRoundBullet  = 1
Global Const $BulletStyle_FilledRoundBullet  = 2
Global Const $BulletStyle_HollowSquareBullet = 3
Global Const $BulletStyle_FilledSquareBullet = 4
Global Const $BulletStyle_DashBullet         = 5
Global Const $BulletStyle_Other              = -1

; enum CapStyle
Global Const $CapStyle_None          = 0
Global Const $CapStyle_SmallCap      = 1
Global Const $CapStyle_AllCap        = 2
Global Const $CapStyle_AllPetiteCaps = 3
Global Const $CapStyle_PetiteCaps    = 4
Global Const $CapStyle_Unicase       = 5
Global Const $CapStyle_Titling       = 6
Global Const $CapStyle_Other         = -1

; enum CaretPosition
Global Const $CaretPosition_Unknown         = 0
Global Const $CaretPosition_EndOfLine       = 1
Global Const $CaretPosition_BeginningOfLine = 2

; enum CaretBidiMode
Global Const $CaretBidiMode_LTR = 0
Global Const $CaretBidiMode_RTL = 1

; enum CoalesceEventsOptions
Global Const $CoalesceEventsOptions_Disabled = 0
Global Const $CoalesceEventsOptions_Enabled  = 1

; enum ConnectionRecoveryBehaviorOptions
Global Const $ConnectionRecoveryBehaviorOptions_Disabled = 0
Global Const $ConnectionRecoveryBehaviorOptions_Enabled  = 1

; enum DockPosition
Global Const $DockPosition_Top    = 0
Global Const $DockPosition_Left   = 1
Global Const $DockPosition_Bottom = 2
Global Const $DockPosition_Right  = 3
Global Const $DockPosition_Fill   = 4
Global Const $DockPosition_None   = 5

; enum ExpandCollapseState
Global Const $ExpandCollapseState_Collapsed         = 0
Global Const $ExpandCollapseState_Expanded          = 1
Global Const $ExpandCollapseState_PartiallyExpanded = 2
Global Const $ExpandCollapseState_LeafNode          = 3

; enum FillType
Global Const $FillType_None     = 0
Global Const $FillType_Color    = 1
Global Const $FillType_Gradient = 2
Global Const $FillType_Picture  = 3
Global Const $FillType_Pattern  = 4

; enum FlowDirections
Global Const $FlowDirections_Default     = 0
Global Const $FlowDirections_RightToLeft = 1
Global Const $FlowDirections_BottomToTop = 2
Global Const $FlowDirections_Vertical    = 4

; enum HorizontalTextAlignment
Global Const $HorizontalTextAlignment_Left      = 0
Global Const $HorizontalTextAlignment_Centered  = 1
Global Const $HorizontalTextAlignment_Right     = 2
Global Const $HorizontalTextAlignment_Justified = 3

; enum LiveSetting
Global Const $LiveSetting_Off       = 0
Global Const $LiveSetting_Polite    = 1
Global Const $LiveSetting_Assertive = 2

; enum NavigateDirection
Global Const $NavigateDirection_Parent          = 0
Global Const $NavigateDirection_NextSibling     = 1
Global Const $NavigateDirection_PreviousSibling = 2
Global Const $NavigateDirection_FirstChild      = 3
Global Const $NavigateDirection_LastChild       = 4

; enum NotificationKind
Global Const $NotificationKind_ItemAdded       = 0
Global Const $NotificationKind_ItemRemoved     = 1
Global Const $NotificationKind_ActionCompleted = 2
Global Const $NotificationKind_ActionAborted   = 3
Global Const $NotificationKind_Other           = 4

; enum NotificationProcessing
Global Const $NotificationProcessing_ImportantAll          = 0
Global Const $NotificationProcessing_ImportantMostRecent   = 1
Global Const $NotificationProcessing_All                   = 2
Global Const $NotificationProcessing_MostRecent            = 3
Global Const $NotificationProcessing_CurrentThenMostRecent = 4

; enum OrientationType
Global Const $OrientationType_None       = 0
Global Const $OrientationType_Horizontal = 1
Global Const $OrientationType_Vertical   = 2

; enum OutlineStyles
Global Const $OutlineStyles_None     = 0 
Global Const $OutlineStyles_Outline  = 1 
Global Const $OutlineStyles_Shadow   = 2 
Global Const $OutlineStyles_Engraved = 4 
Global Const $OutlineStyles_Embossed = 8

; enum PropertyConditionFlags
Global Const $PropertyConditionFlags_None           = 0
Global Const $PropertyConditionFlags_IgnoreCase     = 1
Global Const $PropertyConditionFlags_MatchSubstring = 2 ; Windows 10-1809

; enum ProviderOptions
Global Const $ProviderOptions_ClientSideProvider     =   1
Global Const $ProviderOptions_ServerSideProvider     =   2
Global Const $ProviderOptions_NonClientAreaProvider  =   4
Global Const $ProviderOptions_OverrideProvider       =   8
Global Const $ProviderOptions_ProviderOwnsSetFocus   =  16
Global Const $ProviderOptions_UseComThreading        =  32
Global Const $ProviderOptions_RefuseNonClientSupport =  64
Global Const $ProviderOptions_HasNativeIAccessible   = 128
Global Const $ProviderOptions_UseClientCoordinates   = 256

; enum RowOrColumnMajor
Global Const $RowOrColumnMajor_RowMajor      = 0
Global Const $RowOrColumnMajor_ColumnMajor   = 1
Global Const $RowOrColumnMajor_Indeterminate = 2

; enum SayAsInterpretAs
Global Const $SayAsInterpretAs_None                       =  0
Global Const $SayAsInterpretAs_Spell                      =  1
Global Const $SayAsInterpretAs_Cardinal                   =  2
Global Const $SayAsInterpretAs_Ordinal                    =  3
Global Const $SayAsInterpretAs_Number                     =  4
Global Const $SayAsInterpretAs_Date                       =  5
Global Const $SayAsInterpretAs_Time                       =  6
Global Const $SayAsInterpretAs_Telephone                  =  7
Global Const $SayAsInterpretAs_Currency                   =  8
Global Const $SayAsInterpretAs_Net                        =  9
Global Const $SayAsInterpretAs_Url                        = 10
Global Const $SayAsInterpretAs_Address                    = 11
Global Const $SayAsInterpretAs_Alphanumeric               = 12
Global Const $SayAsInterpretAs_Name                       = 13
Global Const $SayAsInterpretAs_Media                      = 14
Global Const $SayAsInterpretAs_Date_MonthDayYear          = 15
Global Const $SayAsInterpretAs_Date_DayMonthYear          = 16
Global Const $SayAsInterpretAs_Date_YearMonthDay          = 17
Global Const $SayAsInterpretAs_Date_YearMonth             = 18
Global Const $SayAsInterpretAs_Date_MonthYear             = 19
Global Const $SayAsInterpretAs_Date_DayMonth              = 20
Global Const $SayAsInterpretAs_Date_MonthDay              = 21
Global Const $SayAsInterpretAs_Date_Year                  = 22
Global Const $SayAsInterpretAs_Time_HoursMinutesSeconds12 = 23
Global Const $SayAsInterpretAs_Time_HoursMinutes12        = 24
Global Const $SayAsInterpretAs_Time_HoursMinutesSeconds24 = 25
Global Const $SayAsInterpretAs_Time_HoursMinutes24        = 26

; enum ScrollAmount
Global Const $ScrollAmount_LargeDecrement = 0
Global Const $ScrollAmount_SmallDecrement = 1
Global Const $ScrollAmount_NoAmount       = 2
Global Const $ScrollAmount_LargeIncrement = 3
Global Const $ScrollAmount_SmallIncrement = 4

; enum StructureChangeType
Global Const $StructureChangeType_ChildAdded          = 0
Global Const $StructureChangeType_ChildRemoved        = 1
Global Const $StructureChangeType_ChildrenInvalidated = 2
Global Const $StructureChangeType_ChildrenBulkAdded   = 3
Global Const $StructureChangeType_ChildrenBulkRemoved = 4
Global Const $StructureChangeType_ChildrenReordered   = 5

; enum SupportedTextSelection
Global Const $SupportedTextSelection_None     = 0
Global Const $SupportedTextSelection_Single   = 1
Global Const $SupportedTextSelection_Multiple = 2

; enum SynchronizedInputType
Global Const $SynchronizedInputType_KeyUp          =  1
Global Const $SynchronizedInputType_KeyDown        =  2
Global Const $SynchronizedInputType_LeftMouseUp    =  4
Global Const $SynchronizedInputType_LeftMouseDown  =  8
Global Const $SynchronizedInputType_RightMouseUp   = 16
Global Const $SynchronizedInputType_RightMouseDown = 32

; enum TextDecorationLineStyle
Global Const $TextDecorationLineStyle_None            =  0
Global Const $TextDecorationLineStyle_Single          =  1
Global Const $TextDecorationLineStyle_WordsOnly       =  2
Global Const $TextDecorationLineStyle_Double          =  3
Global Const $TextDecorationLineStyle_Dot             =  4
Global Const $TextDecorationLineStyle_Dash            =  5
Global Const $TextDecorationLineStyle_DashDot         =  6
Global Const $TextDecorationLineStyle_DashDotDot      =  7
Global Const $TextDecorationLineStyle_Wavy            =  8
Global Const $TextDecorationLineStyle_ThickSingle     =  9
Global Const $TextDecorationLineStyle_DoubleWavy      = 11
Global Const $TextDecorationLineStyle_ThickWavy       = 12
Global Const $TextDecorationLineStyle_LongDash        = 13
Global Const $TextDecorationLineStyle_ThickDash       = 14
Global Const $TextDecorationLineStyle_ThickDashDot    = 15
Global Const $TextDecorationLineStyle_ThickDashDotDot = 16
Global Const $TextDecorationLineStyle_ThickDot        = 17
Global Const $TextDecorationLineStyle_ThickLongDash   = 18
Global Const $TextDecorationLineStyle_Other           = -1

; enum TextEditChangeType
Global Const $TextEditChangeType_None                 = 0
Global Const $TextEditChangeType_AutoCorrect          = 1
Global Const $TextEditChangeType_Composition          = 2
Global Const $TextEditChangeType_CompositionFinalized = 3
Global Const $TextEditChangeType_AutoComplete         = 4

; enum TextPatternRangeEndpoint
Global Const $TextPatternRangeEndpoint_Start = 0
Global Const $TextPatternRangeEndpoint_End   = 1

; enum TextUnit
Global Const $TextUnit_Character = 0
Global Const $TextUnit_Format    = 1
Global Const $TextUnit_Word      = 2
Global Const $TextUnit_Line      = 3
Global Const $TextUnit_Paragraph = 4
Global Const $TextUnit_Page      = 5
Global Const $TextUnit_Document  = 6

; enum ToggleState
Global Const $ToggleState_Off           = 0
Global Const $ToggleState_On            = 1
Global Const $ToggleState_Indeterminate = 2

; enum TreeScope
Global Const $TreeScope_Element     =  1
Global Const $TreeScope_Children    =  2
Global Const $TreeScope_Descendants =  4
Global Const $TreeScope_Subtree     =  7
Global Const $TreeScope_Parent      =  8
Global Const $TreeScope_Ancestors   = 16

; enum TreeTraversalOptions
Global Const $TreeTraversalOptions_Default          = 0
Global Const $TreeTraversalOptions_PostOrder        = 1
Global Const $TreeTraversalOptions_LastToFirstOrder = 2

; enum VisualEffects
Global Const $VisualEffects_None       =  0
Global Const $VisualEffects_Shadow     =  1
Global Const $VisualEffects_Reflection =  2
Global Const $VisualEffects_Glow       =  4
Global Const $VisualEffects_SoftEdges  =  8
Global Const $VisualEffects_Bevel      = 16

; enum WindowInteractionState
Global Const $WindowInteractionState_Running                 = 0
Global Const $WindowInteractionState_Closing                 = 1
Global Const $WindowInteractionState_ReadyForUserInteraction = 2
Global Const $WindowInteractionState_BlockedByModalWindow    = 3
Global Const $WindowInteractionState_NotResponding           = 4

; enum WindowVisualState
Global Const $WindowVisualState_Normal    = 0
Global Const $WindowVisualState_Maximized = 1
Global Const $WindowVisualState_Minimized = 2

; enum ZoomUnit
Global Const $ZoomUnit_NoAmount       = 0
Global Const $ZoomUnit_LargeDecrement = 1
Global Const $ZoomUnit_SmallDecrement = 2
Global Const $ZoomUnit_LargeIncrement = 3
Global Const $ZoomUnit_SmallIncrement = 4


#cs
struct ExtendedProperty
	{
	BSTR PropertyName;
	BSTR PropertyValue;
	} ;
typedef void *UIA_HWND;
#ce

#cs
struct UiaChangeInfo
	{
	int uiaId;
	VARIANT payload;
	VARIANT extraInfo;
	} ;
#ce


Global Const $sCLSID_CUIAutomation = "{FF48DBA4-60EF-4201-AA87-54103EEF594E}"
Global Const $sCLSID_CUIAutomation8 = "{E22AD333-B25F-460C-83D0-0581107395C9}" ; Windows 8


Global Const $sIID_IUIAutomation = "{30CBE57D-D9D0-452A-AB13-7AC5AC4825EE}"
Global Const $dtag_IUIAutomation = _
	"CompareElements hresult(ptr;ptr;long*);" & _
	"CompareRuntimeIds hresult(ptr;ptr;long*);" & _
	"GetRootElement hresult(ptr*);" & _
	"ElementFromHandle hresult(hwnd;ptr*);" & _
	"ElementFromPoint hresult(struct;ptr*);" & _
	"GetFocusedElement hresult(ptr*);" & _
	"GetRootElementBuildCache hresult(ptr;ptr*);" & _
	"ElementFromHandleBuildCache hresult(hwnd;ptr;ptr*);" & _
	"ElementFromPointBuildCache hresult(struct;ptr;ptr*);" & _
	"GetFocusedElementBuildCache hresult(ptr;ptr*);" & _
	"CreateTreeWalker hresult(ptr;ptr*);" & _
	"ControlViewWalker hresult(ptr*);" & _
	"ContentViewWalker hresult(ptr*);" & _
	"RawViewWalker hresult(ptr*);" & _
	"RawViewCondition hresult(ptr*);" & _
	"ControlViewCondition hresult(ptr*);" & _
	"ContentViewCondition hresult(ptr*);" & _
	"CreateCacheRequest hresult(ptr*);" & _
	"CreateTrueCondition hresult(ptr*);" & _
	"CreateFalseCondition hresult(ptr*);" & _
	"CreatePropertyCondition hresult(int;variant;ptr*);" & _
	"CreatePropertyConditionEx hresult(int;variant;long;ptr*);" & _
	"CreateAndCondition hresult(ptr;ptr;ptr*);" & _
	"CreateAndConditionFromArray hresult(ptr;ptr*);" & _
	"CreateAndConditionFromNativeArray hresult(ptr;int;ptr*);" & _
	"CreateOrCondition hresult(ptr;ptr;ptr*);" & _
	"CreateOrConditionFromArray hresult(ptr;ptr*);" & _
	"CreateOrConditionFromNativeArray hresult(ptr;int;ptr*);" & _
	"CreateNotCondition hresult(ptr;ptr*);" & _
	"AddAutomationEventHandler hresult(int;ptr;long;ptr;ptr);" & _
	"RemoveAutomationEventHandler hresult(int;ptr;ptr);" & _
	"AddPropertyChangedEventHandlerNativeArray hresult(ptr;long;ptr;ptr;struct*;int);" & _
	"AddPropertyChangedEventHandler hresult(ptr;long;ptr;ptr;ptr);" & _
	"RemovePropertyChangedEventHandler hresult(ptr;ptr);" & _
	"AddStructureChangedEventHandler hresult(ptr;long;ptr;ptr);" & _
	"RemoveStructureChangedEventHandler hresult(ptr;ptr);" & _
	"AddFocusChangedEventHandler hresult(ptr;ptr);" & _
	"RemoveFocusChangedEventHandler hresult(ptr);" & _
	"RemoveAllEventHandlers hresult();" & _
	"IntNativeArrayToSafeArray hresult(int;int;ptr*);" & _
	"IntSafeArrayToNativeArray hresult(ptr;int*;int*);" & _
	"RectToVariant hresult(struct;variant*);" & _
	"VariantToRect hresult(variant;struct*);" & _
	"SafeArrayToRectNativeArray hresult(ptr;struct*;int*);" & _
	"CreateProxyFactoryEntry hresult(ptr;ptr*);" & _
	"ProxyFactoryMapping hresult(ptr*);" & _
	"GetPropertyProgrammaticName hresult(int;bstr*);" & _
	"GetPatternProgrammaticName hresult(int;bstr*);" & _
	"PollForPotentialSupportedPatterns hresult(ptr;ptr*;ptr*);" & _
	"PollForPotentialSupportedProperties hresult(ptr;ptr*;ptr*);" & _
	"CheckNotSupported hresult(variant;long*);" & _
	"ReservedNotSupportedValue hresult(ptr*);" & _
	"ReservedMixedAttributeValue hresult(ptr*);" & _
	"ElementFromIAccessible hresult(idispatch;int;ptr*);" & _
	"ElementFromIAccessibleBuildCache hresult(iaccessible;int;ptr;ptr*);"

Global Const $sIID_IUIAutomation2 = "{34723AFF-0C9D-49D0-9896-7AB52DF8CD8A}" ; Windows 8
Global Const $dtag_IUIAutomation2 = $dtag_IUIAutomation & _
	"get_AutoSetFocus hresult(bool*);" & _
	"put_AutoSetFocus hresult(bool);" & _
	"get_ConnectionTimeout hresult(dword*);" & _
	"put_ConnectionTimeout hresult(dword);" & _
	"get_TransactionTimeout hresult(dword*);" & _
	"put_TransactionTimeout hresult(dword);"

Global Const $sIID_IUIAutomation3 = "{73D768DA-9B51-4B89-936E-C209290973E7}" ; Windows 8.1
Global Const $dtag_IUIAutomation3 = $dtag_IUIAutomation2 & _
	"AddTextEditTextChangedEventHandler hresult(ptr;long;long;ptr;ptr);" & _
	"RemoveTextEditTextChangedEventHandler hresult(ptr;ptr);"

Global Const $sIID_IUIAutomation4 = "{1189C02A-05F8-4319-8E21-E817E3DB2860}" ; Windows 10-1607
Global Const $dtag_IUIAutomation4 = $dtag_IUIAutomation3 & _
	"AddChangesEventHandler hresult(ptr;long;struct*;int;ptr;ptr);" & _
	"RemoveChangesEventHandler hresult(ptr;ptr);"

Global Const $sIID_IUIAutomation5 = "{25F700C8-D816-4057-A9DC-3CBDEE77E256}" ; Windows 10-1607
Global Const $dtag_IUIAutomation5 = $dtag_IUIAutomation4 & _
	"AddNotificationEventHandler hresult(ptr;long;ptr;ptr);" & _
	"RemoveNotificationEventHandler hresult(ptr;ptr);"

Global Const $sIID_IUIAutomation6 = "{AAE072DA-29E3-413D-87A7-192DBF81ED10}" ; Windows 10-1809
Global Const $dtag_IUIAutomation6 = $dtag_IUIAutomation5 & _
	"CreateEventHandlerGroup hresult(ptr*);" & _
	"AddEventHandlerGroup hresult(ptr;ptr);" & _
	"RemoveEventHandlerGroup hresult(ptr;ptr);" & _
	"get_ConnectionRecoveryBehavior hresult(long*);" & _
	"put_ConnectionRecoveryBehavior hresult(long);" & _
	"get_CoalesceEvents hresult(long*);" & _
	"put_CoalesceEvents hresult(long);" & _
	"AddActiveTextPositionChangedEventHandler hresult(ptr;long;ptr;ptr);" & _
	"RemoveActiveTextPositionChangedEventHandler hresult(ptr;ptr);"


Global Const $sIID_IUIAutomationElement = "{D22108AA-8AC5-49A5-837B-37BBB3D7591E}"
Global Const $dtag_IUIAutomationElement = _
	"SetFocus hresult();" & _
	"GetRuntimeId hresult(ptr*);" & _
	"FindFirst hresult(long;ptr;ptr*);" & _
	"FindAll hresult(long;ptr;ptr*);" & _
	"FindFirstBuildCache hresult(long;ptr;ptr;ptr*);" & _
	"FindAllBuildCache hresult(long;ptr;ptr;ptr*);" & _
	"BuildUpdatedCache hresult(ptr;ptr*);" & _
	"GetCurrentPropertyValue hresult(int;variant*);" & _
	"GetCurrentPropertyValueEx hresult(int;long;variant*);" & _
	"GetCachedPropertyValue hresult(int;variant*);" & _
	"GetCachedPropertyValueEx hresult(int;long;variant*);" & _
	"GetCurrentPatternAs hresult(int;none;none*);" & _
	"GetCachedPatternAs hresult(int;none;none*);" & _
	"GetCurrentPattern hresult(int;ptr*);" & _
	"GetCachedPattern hresult(int;ptr*);" & _
	"GetCachedParent hresult(ptr*);" & _
	"GetCachedChildren hresult(ptr*);" & _
	"CurrentProcessId hresult(int*);" & _
	"CurrentControlType hresult(int*);" & _
	"CurrentLocalizedControlType hresult(bstr*);" & _
	"CurrentName hresult(bstr*);" & _
	"CurrentAcceleratorKey hresult(bstr*);" & _
	"CurrentAccessKey hresult(bstr*);" & _
	"CurrentHasKeyboardFocus hresult(long*);" & _
	"CurrentIsKeyboardFocusable hresult(long*);" & _
	"CurrentIsEnabled hresult(long*);" & _
	"CurrentAutomationId hresult(bstr*);" & _
	"CurrentClassName hresult(bstr*);" & _
	"CurrentHelpText hresult(bstr*);" & _
	"CurrentCulture hresult(int*);" & _
	"CurrentIsControlElement hresult(long*);" & _
	"CurrentIsContentElement hresult(long*);" & _
	"CurrentIsPassword hresult(long*);" & _
	"CurrentNativeWindowHandle hresult(hwnd*);" & _
	"CurrentItemType hresult(bstr*);" & _
	"CurrentIsOffscreen hresult(long*);" & _
	"CurrentOrientation hresult(long*);" & _
	"CurrentFrameworkId hresult(bstr*);" & _
	"CurrentIsRequiredForForm hresult(long*);" & _
	"CurrentItemStatus hresult(bstr*);" & _
	"CurrentBoundingRectangle hresult(struct*);" & _
	"CurrentLabeledBy hresult(ptr*);" & _
	"CurrentAriaRole hresult(bstr*);" & _
	"CurrentAriaProperties hresult(bstr*);" & _
	"CurrentIsDataValidForForm hresult(long*);" & _
	"CurrentControllerFor hresult(ptr*);" & _
	"CurrentDescribedBy hresult(ptr*);" & _
	"CurrentFlowsTo hresult(ptr*);" & _
	"CurrentProviderDescription hresult(bstr*);" & _
	"CachedProcessId hresult(int*);" & _
	"CachedControlType hresult(int*);" & _
	"CachedLocalizedControlType hresult(bstr*);" & _
	"CachedName hresult(bstr*);" & _
	"CachedAcceleratorKey hresult(bstr*);" & _
	"CachedAccessKey hresult(bstr*);" & _
	"CachedHasKeyboardFocus hresult(long*);" & _
	"CachedIsKeyboardFocusable hresult(long*);" & _
	"CachedIsEnabled hresult(long*);" & _
	"CachedAutomationId hresult(bstr*);" & _
	"CachedClassName hresult(bstr*);" & _
	"CachedHelpText hresult(bstr*);" & _
	"CachedCulture hresult(int*);" & _
	"CachedIsControlElement hresult(long*);" & _
	"CachedIsContentElement hresult(long*);" & _
	"CachedIsPassword hresult(long*);" & _
	"CachedNativeWindowHandle hresult(hwnd*);" & _
	"CachedItemType hresult(bstr*);" & _
	"CachedIsOffscreen hresult(long*);" & _
	"CachedOrientation hresult(long*);" & _
	"CachedFrameworkId hresult(bstr*);" & _
	"CachedIsRequiredForForm hresult(long*);" & _
	"CachedItemStatus hresult(bstr*);" & _
	"CachedBoundingRectangle hresult(struct*);" & _
	"CachedLabeledBy hresult(ptr*);" & _
	"CachedAriaRole hresult(bstr*);" & _
	"CachedAriaProperties hresult(bstr*);" & _
	"CachedIsDataValidForForm hresult(long*);" & _
	"CachedControllerFor hresult(ptr*);" & _
	"CachedDescribedBy hresult(ptr*);" & _
	"CachedFlowsTo hresult(ptr*);" & _
	"CachedProviderDescription hresult(bstr*);" & _
	"GetClickablePoint hresult(struct*;long*);"

Global Const $sIID_IUIAutomationElement2 = "{6749C683-F70D-4487-A698-5F79D55290D6}" ; Windows 8
Global Const $dtag_IUIAutomationElement2 = $dtag_IUIAutomationElement & _
	"get_CurrentOptimizeForVisualContent hresult(bool*);" & _
	"get_CachedOptimizeForVisualContent hresult(bool*);" & _
	"get_CurrentLiveSetting hresult(long*);" & _
	"get_CachedLiveSetting hresult(long*);" & _
	"get_CurrentFlowsFrom hresult(ptr*);" & _
	"get_CachedFlowsFrom hresult(ptr*);"

Global Const $sIID_IUIAutomationElement3 = "{8471DF34-AEE0-4A01-A7DE-7DB9AF12C296}" ; Windows 8.1
Global Const $dtag_IUIAutomationElement3 = $dtag_IUIAutomationElement2 & _
	"ShowContextMenu hresult();" & _
	"get_CurrentIsPeripheral hresult(bool*);" & _
	"get_CachedIsPeripheral hresult(bool*);"

Global Const $sIID_IUIAutomationElement4 = "{3B6E233C-52FB-4063-A4C9-77C075C2A06B}" ; Windows 10
Global Const $dtag_IUIAutomationElement4 = $dtag_IUIAutomationElement3 & _
	"get_CurrentPositionInSet hresult(int*);" & _
	"get_CurrentSizeOfSet hresult(int*);" & _
	"get_CurrentLevel hresult(int*);" & _
	"get_CurrentAnnotationTypes hresult(ptr*);" & _
	"get_CurrentAnnotationObjects hresult(ptr*);" & _
	"get_CachedPositionInSet hresult(int*);" & _
	"get_CachedSizeOfSet hresult(int*);" & _
	"get_CachedLevel hresult(int*);" & _
	"get_CachedAnnotationTypes hresult(ptr*);" & _
	"get_CachedAnnotationObjects hresult(ptr*);"

Global Const $sIID_IUIAutomationElement5 = "{98141C1D-0D0E-4175-BBE2-6BFF455842A7}" ; Windows 10-1703
Global Const $dtag_IUIAutomationElement5 = $dtag_IUIAutomationElement4 & _
	"get_CurrentLandmarkType hresult(long*);" & _
	"get_CurrentLocalizedLandmarkType hresult(bstr*);" & _
	"get_CachedLandmarkType hresult(long*);" & _
	"get_CachedLocalizedLandmarkType hresult(bstr*);"

Global Const $sIID_IUIAutomationElement6 = "{4780D450-8BCA-4977-AFA5-A4A517F555E3}" ; Windows 10-1703
Global Const $dtag_IUIAutomationElement6 = $dtag_IUIAutomationElement5 & _
	"get_CurrentFullDescription hresult(bstr*);" & _
	"get_CachedFullDescription hresult(bstr*);"

Global Const $sIID_IUIAutomationElement7 = "{204E8572-CFC3-4C11-B0C8-7DA7420750B7}" ; Windows 10-1703
Global Const $dtag_IUIAutomationElement7 = $dtag_IUIAutomationElement6 & _
	"FindFirstWithOptions hresult(long;ptr;long;ptr;ptr*);" & _
	"FindAllWithOptions hresult(long;ptr;long;ptr;ptr*);" & _
	"FindFirstWithOptionsBuildCache hresult(long;ptr;ptr;long;ptr;ptr*);" & _
	"FindAllWithOptionsBuildCache hresult(long;ptr;ptr;long;ptr;ptr*);" & _
	"GetCurrentMetadataValue hresult(int;long;variant*);"

Global Const $sIID_IUIAutomationElement8 = "{8C60217D-5411-4CDE-BCC0-1CEDA223830C}" ; Windows 10-1803
Global Const $dtag_IUIAutomationElement8 = $dtag_IUIAutomationElement7 & _
	"get_CurrentHeadingLevel hresult(long*);" & _
	"get_CachedHeadingLevel hresult(long*);"

Global Const $sIID_IUIAutomationElement9 = "{39325FAC-039D-440E-A3A3-5EB81A5CECC3}" ; Windows 10-1809
Global Const $dtag_IUIAutomationElement9 = $dtag_IUIAutomationElement8 & _
	"get_CurrentIsDialog hresult(bool*);" & _
	"get_CachedIsDialog hresult(bool*);"


Global Const $sIID_IUIAutomationElementArray = "{14314595-B4BC-4055-95F2-58F2E42C9855}"
Global Const $dtag_IUIAutomationElementArray = _
	"Length hresult(int*);" & _
	"GetElement hresult(int;ptr*);"


Global Const $sIID_IUIAutomationAndCondition = "{A7D0AF36-B912-45FE-9855-091DDC174AEC}"
Global Const $dtag_IUIAutomationAndCondition = _
	"ChildCount hresult(int*);" & _
	"GetChildrenAsNativeArray hresult(ptr*;int*);" & _
	"GetChildren hresult(ptr*);"

Global Const $sIID_IUIAutomationBoolCondition = "{1B4E1F2E-75EB-4D0B-8952-5A69988E2307}"
Global Const $dtag_IUIAutomationBoolCondition = _
	"BooleanValue hresult(long*);"

Global Const $sIID_IUIAutomationNotCondition = "{F528B657-847B-498C-8896-D52B565407A1}"
Global Const $dtag_IUIAutomationNotCondition = _
	"GetChild hresult(ptr*);"

Global Const $sIID_IUIAutomationOrCondition = "{8753F032-3DB1-47B5-A1FC-6E34A266C712}"
Global Const $dtag_IUIAutomationOrCondition = _
	"ChildCount hresult(int*);" & _
	"GetChildrenAsNativeArray hresult(ptr*;int*);" & _
	"GetChildren hresult(ptr*);"

Global Const $sIID_IUIAutomationPropertyCondition = "{99EBF2CB-5578-4267-9AD4-AFD6EA77E94B}"
Global Const $dtag_IUIAutomationPropertyCondition = _
	"propertyId hresult(int*);" & _
	"PropertyValue hresult(variant*);" & _
	"PropertyConditionFlags hresult(long*);"


Global Const $sIID_IUIAutomationAnnotationPattern = "{9A175B21-339E-41B1-8E8B-623F6B681098}" ; Windows 8
Global Const $dtag_IUIAutomationAnnotationPattern = _
	"get_CurrentAnnotationTypeId hresult(int*);" & _
	"get_CurrentAnnotationTypeName hresult(bstr*);" & _
	"get_CurrentAuthor hresult(bstr*);" & _
	"get_CurrentDateTime hresult(bstr*);" & _
	"get_CurrentTarget hresult(ptr*);" & _
	"get_CachedAnnotationTypeId hresult(int*);" & _
	"get_CachedAnnotationTypeName hresult(bstr*);" & _
	"get_CachedAuthor hresult(bstr*);" & _
	"get_CachedDateTime hresult(bstr*);" & _
	"get_CachedTarget hresult(ptr*);"

Global Const $sIID_IUIAutomationCustomNavigationPattern = "{01EA217A-1766-47ED-A6CC-ACF492854B1F}" ; Windows 10
Global Const $dtag_IUIAutomationCustomNavigationPattern = _
	"Navigate hresult(long;ptr*);"

Global Const $sIID_IUIAutomationDockPattern = "{FDE5EF97-1464-48F6-90BF-43D0948E86EC}"
Global Const $dtag_IUIAutomationDockPattern = _
	"SetDockPosition hresult(long);" & _
	"CurrentDockPosition hresult(long*);" & _
	"CachedDockPosition hresult(long*);"

Global Const $sIID_IUIAutomationDragPattern = "{1DC7B570-1F54-4BAD-BCDA-D36A722FB7BD}" ; Windows 8
Global Const $dtag_IUIAutomationDragPattern = _
	"get_CurrentIsGrabbed hresult(bool*);" & _
	"get_CachedIsGrabbed hresult(bool*);" & _
	"get_CurrentDropEffect hresult(bstr*);" & _
	"get_CachedDropEffect hresult(bstr*);" & _
	"get_CurrentDropEffects hresult(ptr*);" & _
	"get_CachedDropEffects hresult(ptr*);" & _
	"GetCurrentGrabbedItems hresult(ptr*);" & _
	"GetCachedGrabbedItems hresult(ptr*);"

Global Const $sIID_IUIAutomationDropTargetPattern = "{69A095F7-EEE4-430E-A46B-FB73B1AE39A5}" ; Windows 8
Global Const $dtag_IUIAutomationDropTargetPattern = _
	"get_CurrentDropTargetEffect hresult(bstr*);" & _
	"get_CachedDropTargetEffect hresult(bstr*);" & _
	"get_CurrentDropTargetEffects hresult(ptr*);" & _
	"get_CachedDropTargetEffects hresult(ptr*);"

Global Const $sIID_IUIAutomationExpandCollapsePattern = "{619BE086-1F4E-4EE4-BAFA-210128738730}"
Global Const $dtag_IUIAutomationExpandCollapsePattern = _
	"Expand hresult();" & _
	"Collapse hresult();" & _
	"CurrentExpandCollapseState hresult(long*);" & _
	"CachedExpandCollapseState hresult(long*);"

Global Const $sIID_IUIAutomationGridPattern = "{414C3CDC-856B-4F5B-8538-3131C6302550}"
Global Const $dtag_IUIAutomationGridPattern = _
	"GetItem hresult(int;int;ptr*);" & _
	"CurrentRowCount hresult(int*);" & _
	"CurrentColumnCount hresult(int*);" & _
	"CachedRowCount hresult(int*);" & _
	"CachedColumnCount hresult(int*);"

Global Const $sIID_IUIAutomationGridItemPattern = "{78F8EF57-66C3-4E09-BD7C-E79B2004894D}"
Global Const $dtag_IUIAutomationGridItemPattern = _
	"CurrentContainingGrid hresult(ptr*);" & _
	"CurrentRow hresult(int*);" & _
	"CurrentColumn hresult(int*);" & _
	"CurrentRowSpan hresult(int*);" & _
	"CurrentColumnSpan hresult(int*);" & _
	"CachedContainingGrid hresult(ptr*);" & _
	"CachedRow hresult(int*);" & _
	"CachedColumn hresult(int*);" & _
	"CachedRowSpan hresult(int*);" & _
	"CachedColumnSpan hresult(int*);"

Global Const $sIID_IUIAutomationInvokePattern = "{FB377FBE-8EA6-46D5-9C73-6499642D3059}"
Global Const $dtag_IUIAutomationInvokePattern = _
	"Invoke hresult();"

Global Const $sIID_IUIAutomationItemContainerPattern = "{C690FDB2-27A8-423C-812D-429773C9084E}"
Global Const $dtag_IUIAutomationItemContainerPattern = _
	"FindItemByProperty hresult(ptr;int;variant;ptr*);"

Global Const $sIID_IUIAutomationLegacyIAccessiblePattern = "{828055AD-355B-4435-86D5-3B51C14A9B1B}"
Global Const $dtag_IUIAutomationLegacyIAccessiblePattern = _
	"Select hresult(long);" & _
	"DoDefaultAction hresult();" & _
	"SetValue hresult(wstr);" & _
	"CurrentChildId hresult(int*);" & _
	"CurrentName hresult(bstr*);" & _
	"CurrentValue hresult(bstr*);" & _
	"CurrentDescription hresult(bstr*);" & _
	"CurrentRole hresult(uint*);" & _
	"CurrentState hresult(uint*);" & _
	"CurrentHelp hresult(bstr*);" & _
	"CurrentKeyboardShortcut hresult(bstr*);" & _
	"GetCurrentSelection hresult(ptr*);" & _
	"CurrentDefaultAction hresult(bstr*);" & _
	"CachedChildId hresult(int*);" & _
	"CachedName hresult(bstr*);" & _
	"CachedValue hresult(bstr*);" & _
	"CachedDescription hresult(bstr*);" & _
	"CachedRole hresult(uint*);" & _
	"CachedState hresult(uint*);" & _
	"CachedHelp hresult(bstr*);" & _
	"CachedKeyboardShortcut hresult(bstr*);" & _
	"GetCachedSelection hresult(ptr*);" & _
	"CachedDefaultAction hresult(bstr*);" & _
	"GetIAccessible hresult(idispatch*);"

; Supports LegacyIAccessiblePattern
Global Const $sIID_IAccessible = "{618736E0-3C3D-11CF-810C-00AA00389B71}"
Global Const $dtag_IAccessible = _
	"GetTypeInfoCount hresult(uint*);" & _ ; IDispatch
	"GetTypeInfo hresult(uint;int;ptr*);" & _
	"GetIDsOfNames hresult(struct*;wstr;uint;int;int);" & _
	"Invoke hresult(int;struct*;int;word;ptr*;ptr*;ptr*;uint*);" & _
	"get_accParent hresult(ptr*);" & _     ; IAccessible
	"get_accChildCount hresult(long*);" & _
	"get_accChild hresult(variant;idispatch*);" & _
	"get_accName hresult(variant;bstr*);" & _
	"get_accValue hresult(variant;bstr*);" & _
	"get_accDescription hresult(variant;bstr*);" & _
	"get_accRole hresult(variant;variant*);" & _
	"get_accState hresult(variant;variant*);" & _
	"get_accHelp hresult(variant;bstr*);" & _
	"get_accHelpTopic hresult(bstr*;variant;long*);" & _
	"get_accKeyboardShortcut hresult(variant;bstr*);" & _
	"get_accFocus hresult(struct*);" & _
	"get_accSelection hresult(variant*);" & _
	"get_accDefaultAction hresult(variant;bstr*);" & _
	"accSelect hresult(long;variant);" & _
	"accLocation hresult(long*;long*;long*;long*;variant);" & _
	"accNavigate hresult(long;variant;variant*);" & _
	"accHitTest hresult(long;long;variant*);" & _
	"accDoDefaultAction hresult(variant);" & _
	"put_accName hresult(variant;bstr);" & _
	"put_accValue hresult(variant;bstr);"

Global Const $sIID_IUIAutomationMultipleViewPattern = "{8D253C91-1DC5-4BB5-B18F-ADE16FA495E8}"
Global Const $dtag_IUIAutomationMultipleViewPattern = _
	"GetViewName hresult(int;bstr*);" & _
	"SetCurrentView hresult(int);" & _
	"CurrentCurrentView hresult(int*);" & _
	"GetCurrentSupportedViews hresult(ptr*);" & _
	"CachedCurrentView hresult(int*);" & _
	"GetCachedSupportedViews hresult(ptr*);"

Global Const $sIID_IUIAutomationObjectModelPattern = "{71C284B3-C14D-4D14-981E-19751B0D756D}" ; Windows 8
Global Const $dtag_IUIAutomationObjectModelPattern = _
	"GetUnderlyingObjectModel hresult(ptr*);"

Global Const $sIID_IUIAutomationRangeValuePattern = "{59213F4F-7346-49E5-B120-80555987A148}"
Global Const $dtag_IUIAutomationRangeValuePattern = _
	"SetValue hresult(double);" & _
	"CurrentValue hresult(double*);" & _
	"CurrentIsReadOnly hresult(long*);" & _
	"CurrentMaximum hresult(double*);" & _
	"CurrentMinimum hresult(double*);" & _
	"CurrentLargeChange hresult(double*);" & _
	"CurrentSmallChange hresult(double*);" & _
	"CachedValue hresult(double*);" & _
	"CachedIsReadOnly hresult(long*);" & _
	"CachedMaximum hresult(double*);" & _
	"CachedMinimum hresult(double*);" & _
	"CachedLargeChange hresult(double*);" & _
	"CachedSmallChange hresult(double*);"

Global Const $sIID_IUIAutomationScrollPattern = "{88F4D42A-E881-459D-A77C-73BBBB7E02DC}"
Global Const $dtag_IUIAutomationScrollPattern = _
	"Scroll hresult(long;long);" & _
	"SetScrollPercent hresult(double;double);" & _
	"CurrentHorizontalScrollPercent hresult(double*);" & _
	"CurrentVerticalScrollPercent hresult(double*);" & _
	"CurrentHorizontalViewSize hresult(double*);" & _
	"CurrentVerticalViewSize hresult(double*);" & _
	"CurrentHorizontallyScrollable hresult(long*);" & _
	"CurrentVerticallyScrollable hresult(long*);" & _
	"CachedHorizontalScrollPercent hresult(double*);" & _
	"CachedVerticalScrollPercent hresult(double*);" & _
	"CachedHorizontalViewSize hresult(double*);" & _
	"CachedVerticalViewSize hresult(double*);" & _
	"CachedHorizontallyScrollable hresult(long*);" & _
	"CachedVerticallyScrollable hresult(long*);"

Global Const $sIID_IUIAutomationScrollItemPattern = "{B488300F-D015-4F19-9C29-BB595E3645EF}"
Global Const $dtag_IUIAutomationScrollItemPattern = _
	"ScrollIntoView hresult();"

Global Const $sIID_IUIAutomationSelectionPattern = "{5ED5202E-B2AC-47A6-B638-4B0BF140D78E}"
Global Const $dtag_IUIAutomationSelectionPattern = _
	"GetCurrentSelection hresult(ptr*);" & _
	"CurrentCanSelectMultiple hresult(long*);" & _
	"CurrentIsSelectionRequired hresult(long*);" & _
	"GetCachedSelection hresult(ptr*);" & _
	"CachedCanSelectMultiple hresult(long*);" & _
	"CachedIsSelectionRequired hresult(long*);"

Global Const $sIID_IUIAutomationSelectionItemPattern = "{A8EFA66A-0FDA-421A-9194-38021F3578EA}"
Global Const $dtag_IUIAutomationSelectionItemPattern = _
	"Select hresult();" & _
	"AddToSelection hresult();" & _
	"RemoveFromSelection hresult();" & _
	"CurrentIsSelected hresult(long*);" & _
	"CurrentSelectionContainer hresult(ptr*);" & _
	"CachedIsSelected hresult(long*);" & _
	"CachedSelectionContainer hresult(ptr*);"

Global Const $sIID_IUIAutomationSelectionPattern2 = "{0532BFAE-C011-4E32-A343-6D642D798555}" ; Windows 10-1709
Global Const $dtag_IUIAutomationSelectionPattern2 = $dtag_IUIAutomationSelectionPattern & _
	"get_CurrentFirstSelectedItem hresult(ptr*);" & _
	"get_CurrentLastSelectedItem hresult(ptr*);" & _
	"get_CurrentCurrentSelectedItem hresult(ptr*);" & _
	"get_CurrentItemCount hresult(int*);" & _
	"get_CachedFirstSelectedItem hresult(ptr*);" & _
	"get_CachedLastSelectedItem hresult(ptr*);" & _
	"get_CachedCurrentSelectedItem hresult(ptr*);" & _
	"get_CachedItemCount hresult(int*);"

Global Const $sIID_IUIAutomationSpreadsheetPattern = "{7517A7C8-FAAE-4DE9-9F08-29B91E8595C1}" ; Windows 8
Global Const $dtag_IUIAutomationSpreadsheetPattern = _
	"GetItemByName hresult(bstr;ptr*);"

Global Const $sIID_IUIAutomationSpreadsheetItemPattern = "{7D4FB86C-8D34-40E1-8E83-62C15204E335}" ; Windows 8
Global Const $dtag_IUIAutomationSpreadsheetItemPattern = _
	"get_CurrentFormula hresult(bstr*);" & _
	"GetCurrentAnnotationObjects hresult(ptr*);" & _
	"GetCurrentAnnotationTypes hresult(ptr*);" & _
	"get_CachedFormula hresult(bstr*);" & _
	"GetCachedAnnotationObjects hresult(ptr*);" & _
	"GetCachedAnnotationTypes hresult(ptr*);"

Global Const $sIID_IUIAutomationStylesPattern = "{85B5F0A2-BD79-484A-AD2B-388C9838D5FB}" ; Windows 8
Global Const $dtag_IUIAutomationStylesPattern = _
	"get_CurrentStyleId hresult(int*);" & _
	"get_CurrentStyleName hresult(bstr*);" & _
	"get_CurrentFillColor hresult(int*);" & _
	"get_CurrentFillPatternStyle hresult(bstr*);" & _
	"get_CurrentShape hresult(bstr*);" & _
	"get_CurrentFillPatternColor hresult(int*);" & _
	"get_CurrentExtendedProperties hresult(bstr*);" & _
	"GetCurrentExtendedPropertiesAsArray hresult(struct*;int*);" & _
	"get_CachedStyleId hresult(int*);" & _
	"get_CachedStyleName hresult(bstr*);" & _
	"get_CachedFillColor hresult(int*);" & _
	"get_CachedFillPatternStyle hresult(bstr*);" & _
	"get_CachedShape hresult(bstr*);" & _
	"get_CachedFillPatternColor hresult(int*);" & _
	"get_CachedExtendedProperties hresult(bstr*);" & _
	"GetCachedExtendedPropertiesAsArray hresult(struct*;int*);"

Global Const $sIID_IUIAutomationSynchronizedInputPattern = "{2233BE0B-AFB7-448B-9FDA-3B378AA5EAE1}"
Global Const $dtag_IUIAutomationSynchronizedInputPattern = _
	"StartListening hresult(long);" & _
	"Cancel hresult();"

Global Const $sIID_IUIAutomationTablePattern = "{620E691C-EA96-4710-A850-754B24CE2417}"
Global Const $dtag_IUIAutomationTablePattern = _
	"GetCurrentRowHeaders hresult(ptr*);" & _
	"GetCurrentColumnHeaders hresult(ptr*);" & _
	"CurrentRowOrColumnMajor hresult(long*);" & _
	"GetCachedRowHeaders hresult(ptr*);" & _
	"GetCachedColumnHeaders hresult(ptr*);" & _
	"CachedRowOrColumnMajor hresult(long*);"

Global Const $sIID_IUIAutomationTableItemPattern = "{0B964EB3-EF2E-4464-9C79-61D61737A27E}"
Global Const $dtag_IUIAutomationTableItemPattern = _
	"GetCurrentRowHeaderItems hresult(ptr*);" & _
	"GetCurrentColumnHeaderItems hresult(ptr*);" & _
	"GetCachedRowHeaderItems hresult(ptr*);" & _
	"GetCachedColumnHeaderItems hresult(ptr*);"

Global Const $sIID_IUIAutomationTextChildPattern = "{6552B038-AE05-40C8-ABFD-AA08352AAB86}" ; Windows 8
Global Const $dtag_IUIAutomationTextChildPattern = _
	"get_TextContainer hresult(ptr*);" & _
	"get_TextRange hresult(ptr*);"

Global Const $sIID_IUIAutomationTextPattern = "{32EBA289-3583-42C9-9C59-3B6D9A1E9B6A}"
Global Const $dtag_IUIAutomationTextPattern = _
	"RangeFromPoint hresult(struct;ptr*);" & _
	"RangeFromChild hresult(ptr;ptr*);" & _
	"GetSelection hresult(ptr*);" & _
	"GetVisibleRanges hresult(ptr*);" & _
	"DocumentRange hresult(ptr*);" & _
	"SupportedTextSelection hresult(long*);"

Global Const $sIID_IUIAutomationTextPattern2 = "{506A921A-FCC9-409F-B23B-37EB74106872}" ; Windows 8
Global Const $dtag_IUIAutomationTextPattern2 = $dtag_IUIAutomationTextPattern & _
	"RangeFromAnnotation hresult(ptr;ptr*);" & _
	"GetCaretRange hresult(bool;ptr*);"

Global Const $sIID_IUIAutomationTextEditPattern = "{17E21576-996C-4870-99D9-BFF323380C06}" ; Windows 8.1
Global Const $dtag_IUIAutomationTextEditPattern = $dtag_IUIAutomationTextPattern & _
	"GetActiveComposition hresult(ptr*);" & _
	"GetConversionTarget hresult(ptr*);"

; Supports TextPattern
Global Const $sIID_IUIAutomationTextRange = "{A543CC6A-F4AE-494B-8239-C814481187A8}"
Global Const $dtag_IUIAutomationTextRange = _
	"Clone hresult(ptr*);" & _
	"Compare hresult(ptr;long*);" & _
	"CompareEndpoints hresult(long;ptr;long;int*);" & _
	"ExpandToEnclosingUnit hresult(long);" & _
	"FindAttribute hresult(int;variant;long;ptr*);" & _
	"FindText hresult(bstr;long;long;ptr*);" & _
	"GetAttributeValue hresult(int;variant*);" & _
	"GetBoundingRectangles hresult(ptr*);" & _
	"GetEnclosingElement hresult(ptr*);" & _
	"GetText hresult(int;bstr*);" & _
	"Move hresult(long;int;int*);" & _
	"MoveEndpointByUnit hresult(long;long;int;int*);" & _
	"MoveEndpointByRange hresult(long;ptr;long);" & _
	"Select hresult();" & _
	"AddToSelection hresult();" & _
	"RemoveFromSelection hresult();" & _
	"ScrollIntoView hresult(long);" & _
	"GetChildren hresult(ptr*);"

; Supports TextPattern
Global Const $sIID_IUIAutomationTextRange2 = "{BB9B40E0-5E04-46BD-9BE0-4B601B9AFAD4}" ; Windows 8.1
Global Const $dtag_IUIAutomationTextRange2 = $dtag_IUIAutomationTextRange & _
	"ShowContextMenu hresult();"

; Supports TextPattern
Global Const $sIID_IUIAutomationTextRange3 = "{6A315D69-5512-4C2E-85F0-53FCE6DD4BC2}" ; Windows 10-1703
Global Const $dtag_IUIAutomationTextRange3 = $dtag_IUIAutomationTextRange2 & _
	"GetEnclosingElementBuildCache hresult(ptr;ptr*);" & _
	"GetChildrenBuildCache hresult(ptr;ptr*);" & _
	"GetAttributeValues hresult(long;int;ptr*);"

; Supports TextPattern
Global Const $sIID_IUIAutomationTextRangeArray = "{CE4AE76A-E717-4C98-81EA-47371D028EB6}"
Global Const $dtag_IUIAutomationTextRangeArray = _
	"Length hresult(int*);" & _
	"GetElement hresult(int;ptr*);"

Global Const $sIID_IUIAutomationTogglePattern = "{94CF8058-9B8D-4AB9-8BFD-4CD0A33C8C70}"
Global Const $dtag_IUIAutomationTogglePattern = _
	"Toggle hresult();" & _
	"CurrentToggleState hresult(long*);" & _
	"CachedToggleState hresult(long*);"

Global Const $sIID_IUIAutomationTransformPattern = "{A9B55844-A55D-4EF0-926D-569C16FF89BB}"
Global Const $dtag_IUIAutomationTransformPattern = _
	"Move hresult(double;double);" & _
	"Resize hresult(double;double);" & _
	"Rotate hresult(double);" & _
	"CurrentCanMove hresult(long*);" & _
	"CurrentCanResize hresult(long*);" & _
	"CurrentCanRotate hresult(long*);" & _
	"CachedCanMove hresult(long*);" & _
	"CachedCanResize hresult(long*);" & _
	"CachedCanRotate hresult(long*);"

Global Const $sIID_IUIAutomationTransformPattern2 = "{6D74D017-6ECB-4381-B38B-3C17A48FF1C2}" ; Windows 8
Global Const $dtag_IUIAutomationTransformPattern2 = $dtag_IUIAutomationTransformPattern & _
	"Zoom hresult(double);" & _
	"ZoomByUnit hresult(long);" & _
	"get_CurrentCanZoom hresult(bool*);" & _
	"get_CachedCanZoom hresult(bool*);" & _
	"get_CurrentZoomLevel hresult(double*);" & _
	"get_CachedZoomLevel hresult(double*);" & _
	"get_CurrentZoomMinimum hresult(double*);" & _
	"get_CachedZoomMinimum hresult(double*);" & _
	"get_CurrentZoomMaximum hresult(double*);" & _
	"get_CachedZoomMaximum hresult(double*);"

Global Const $sIID_IUIAutomationValuePattern = "{A94CD8B1-0844-4CD6-9D2D-640537AB39E9}"
Global Const $dtag_IUIAutomationValuePattern = _
	"SetValue hresult(bstr);" & _
	"CurrentValue hresult(bstr*);" & _
	"CurrentIsReadOnly hresult(long*);" & _
	"CachedValue hresult(bstr*);" & _
	"CachedIsReadOnly hresult(long*);"

Global Const $sIID_IUIAutomationVirtualizedItemPattern = "{6BA3D7A6-04CF-4F11-8793-A8D1CDE9969F}"
Global Const $dtag_IUIAutomationVirtualizedItemPattern = _
	"Realize hresult();"

Global Const $sIID_IUIAutomationWindowPattern = "{0FAEF453-9208-43EF-BBB2-3B485177864F}"
Global Const $dtag_IUIAutomationWindowPattern = _
	"Close hresult();" & _
	"WaitForInputIdle hresult(int;long*);" & _
	"SetWindowVisualState hresult(long);" & _
	"CurrentCanMaximize hresult(long*);" & _
	"CurrentCanMinimize hresult(long*);" & _
	"CurrentIsModal hresult(long*);" & _
	"CurrentIsTopmost hresult(long*);" & _
	"CurrentWindowVisualState hresult(long*);" & _
	"CurrentWindowInteractionState hresult(long*);" & _
	"CachedCanMaximize hresult(long*);" & _
	"CachedCanMinimize hresult(long*);" & _
	"CachedIsModal hresult(long*);" & _
	"CachedIsTopmost hresult(long*);" & _
	"CachedWindowVisualState hresult(long*);" & _
	"CachedWindowInteractionState hresult(long*);"


; EventIds
Global Const $sIID_IUIAutomationEventHandler = "{146C3C17-F12E-4E22-8C27-F894B9B79C69}"
Global Const $dtag_IUIAutomationEventHandler = _
	"HandleAutomationEvent hresult(ptr;int);"

Global Const $sIID_IUIAutomationFocusChangedEventHandler = "{C270F6B5-5C69-4290-9745-7A7F97169468}"
Global Const $dtag_IUIAutomationFocusChangedEventHandler = _
	"HandleFocusChangedEvent hresult(ptr);"

; PropertyIds
Global Const $sIID_IUIAutomationPropertyChangedEventHandler = "{40CD37D4-C756-4B0C-8C6F-BDDFEEB13B50}"
Global Const $dtag_IUIAutomationPropertyChangedEventHandler = _
	"HandlePropertyChangedEvent hresult(ptr;int;variant);"

; StructureChangeType
Global Const $sIID_IUIAutomationStructureChangedEventHandler = "{E81D1B4E-11C5-42F8-9754-E7036C79F054}"
Global Const $dtag_IUIAutomationStructureChangedEventHandler = _
	"HandleStructureChangedEvent hresult(ptr;long;ptr);"

; TextEditChangeType
Global Const $sIID_IUIAutomationTextEditTextChangedEventHandler = "{92FAA680-E704-4156-931A-E32D5BB38F3F}" ; Windows 8.1
Global Const $dtag_IUIAutomationTextEditTextChangedEventHandler = _
	"HandleTextEditTextChangedEvent hresult(ptr;long;ptr);"

; PropertyIds, TextAttributeIds, AnnotationTypes, StyleIds
Global Const $sIID_IUIAutomationChangesEventHandler = "{58EDCA55-2C3E-4980-B1B9-56C17F27A2A0}" ; Windows 10-1703
Global Const $dtag_IUIAutomationChangesEventHandler = _
	"HandleChangesEvent hresult(ptr;ptr;int);"

; NotificationKind, NotificationProcessing
Global Const $sIID_IUIAutomationNotificationEventHandler = "{C7CB2637-E6C2-4D0C-85DE-4948C02175C7}" ; Windows 10-1709
Global Const $dtag_IUIAutomationNotificationEventHandler = _
	"HandleNotificationEvent hresult(ptr;long;long;bstr*;bstr*);"

Global Const $sIID_IUIAutomationActiveTextPositionChangedEventHandler = "{F97933B0-8DAE-4496-8997-5BA015FE0D82}" ; Windows 10-1809
Global Const $dtag_IUIAutomationActiveTextPositionChangedEventHandler = _
	"HandleActiveTextPositionChangedEvent hresult(ptr;ptr);"

Global Const $sIID_IUIAutomationEventHandlerGroup = "{C9EE12F2-C13B-4408-997C-639914377F4E}" ; Windows 10-1809
Global Const $dtag_IUIAutomationEventHandlerGroup = _
	"AddActiveTextPositionChangedEventHandler hresult(long;ptr;ptr);" & _
	"AddAutomationEventHandler hresult(long;long;ptr;ptr);" & _
	"AddChangesEventHandler hresult(long;ptr;int;ptr;ptr);" & _
	"AddNotificationEventHandler hresult(long;ptr;ptr);" & _
	"AddPropertyChangedEventHandler hresult(long;ptr;ptr;ptr);" & _
	"AddStructureChangedEventHandler hresult(long;ptr;ptr);" & _
	"AddTextEditTextChangedEventHandler hresult(long;long;ptr;ptr);"


Global Const $sIID_IUIAutomationCacheRequest = "{B32A92B5-BC25-4078-9C08-D7EE95C48E03}"
Global Const $dtag_IUIAutomationCacheRequest = _
	"AddProperty hresult(int);" & _
	"AddPattern hresult(int);" & _
	"Clone hresult(ptr*);" & _
	"get_TreeScope hresult(long*);" & _
	"put_TreeScope hresult(long);" & _
	"get_TreeFilter hresult(ptr*);" & _
	"put_TreeFilter hresult(ptr);" & _
	"get_AutomationElementMode hresult(long*);" & _
	"put_AutomationElementMode hresult(long);"

Global Const $sIID_IUIAutomationTreeWalker = "{4042C624-389C-4AFC-A630-9DF854A541FC}"
Global Const $dtag_IUIAutomationTreeWalker = _
	"GetParentElement hresult(ptr;ptr*);" & _
	"GetFirstChildElement hresult(ptr;ptr*);" & _
	"GetLastChildElement hresult(ptr;ptr*);" & _
	"GetNextSiblingElement hresult(ptr;ptr*);" & _
	"GetPreviousSiblingElement hresult(ptr;ptr*);" & _
	"NormalizeElement hresult(ptr;ptr*);" & _
	"GetParentElementBuildCache hresult(ptr;ptr;ptr*);" & _
	"GetFirstChildElementBuildCache hresult(ptr;ptr;ptr*);" & _
	"GetLastChildElementBuildCache hresult(ptr;ptr;ptr*);" & _
	"GetNextSiblingElementBuildCache hresult(ptr;ptr;ptr*);" & _
	"GetPreviousSiblingElementBuildCache hresult(ptr;ptr;ptr*);" & _
	"NormalizeElementBuildCache hresult(ptr;ptr;ptr*);" & _
	"Condition hresult(ptr*);"

Global Const $sIID_IRawElementProviderSimple = "{D6DD68D1-86FD-4332-8666-9ABEDEA2D24C}"
Global Const $dtag_IRawElementProviderSimple = _
	"ProviderOptions hresult(long*);" & _
	"GetPatternProvider hresult(int;ptr*);" & _
	"GetPropertyValue hresult(int;variant*);" & _
	"HostRawElementProvider hresult(ptr*);"

Global Const $sIID_IUIAutomationProxyFactory = "{85B94ECD-849D-42B6-B94D-D6DB23FDF5A4}"
Global Const $dtag_IUIAutomationProxyFactory = _
	"CreateProvider hresult(hwnd;long;long;ptr*);" & _
	"ProxyFactoryId hresult(bstr*);"

Global Const $sIID_IUIAutomationProxyFactoryEntry = "{D50E472E-B64B-490C-BCA1-D30696F9F289}"
Global Const $dtag_IUIAutomationProxyFactoryEntry = _
	"ProxyFactory hresult(ptr*);" & _
	"ClassName hresult(bstr*);" & _
	"ImageName hresult(bstr*);" & _
	"AllowSubstringMatch hresult(long*);" & _
	"CanCheckBaseClass hresult(long*);" & _
	"NeedsAdviseEvents hresult(long*);" & _
	"ClassName hresult(wstr);" & _
	"ImageName hresult(wstr);" & _
	"AllowSubstringMatch hresult(long);" & _
	"CanCheckBaseClass hresult(long);" & _
	"NeedsAdviseEvents hresult(long);" & _
	"SetWinEventsForAutomationEvent hresult(int;int;ptr);" & _
	"GetWinEventsForAutomationEvent hresult(int;int;ptr*);"

Global Const $sIID_IUIAutomationProxyFactoryMapping = "{09E31E18-872D-4873-93D1-1E541EC133FD}"
Global Const $dtag_IUIAutomationProxyFactoryMapping = _
	"Count hresult(uint*);" & _
	"GetTable hresult(ptr*);" & _
	"GetEntry hresult(uint;ptr*);" & _
	"SetTable hresult(ptr);" & _
	"InsertEntries hresult(uint;ptr);" & _
	"InsertEntry hresult(uint;ptr);" & _
	"RemoveEntry hresult(uint);" & _
	"ClearTable hresult();" & _
	"RestoreDefaultTable hresult();"
