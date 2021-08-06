# **table** object reference

**table** object allow access pre searched addresses or constants for selected client.

## Functions

### table.get

``table.get(varId)``

Returns variable value as is or as virtual address.

### table.getValidated

``table.getValidated(varId)``

If variable not exists throw error.

Returns variable value as is or as virtual address.

### table.getHex1

``table.getHex1(varId)``

Returns variable value as hex strings with 1 bytes.

### table.getHex4

``table.getHex4(varId)``

Returns variable value as hex strings with 4 bytes.

### table.getRaw

``table.getRaw(varId)``

Returns variable value as raw address.

### table.getRawValidated

``table_getRawValidated(varId)``

If variable not exists throw error.

Returns variable value as raw address.


### table.getSessionAbsHex4

``table.getSessionAbsHex4(varId)``

Return variable value as is plus g_session variable value.

## Variable constants

## table.g_session

Virtual address of g_session.

## table.g_serviceType

Virtual address of g_serviceType.

## table.g_windowMgr

Virtual address of g_windowMgr.

## table.UIWindowMgr_MakeWindow

Virtual address of UIWindowMgr::MakeWindow.

## table.UIWindowMgr_DeleteWindow

Virtual address of UIWindowMgr::DeleteWindow.

## table.g_modeMgr

Virtual address of g_modeMgr.

## table.g_fileMgr

Virtual address of g_fileMgr.

## table.g_hMainWnd

Virtual address of g_hMainWnd.

## table.msgStringTable

Virtual address of msgStringTable.

## table.CSession_m_accountId

m_accountId offset inside CSession class.

## table.ITEM_INFO_location

Offset of location field in ITEM_INFO struct.

## table.ITEM_INFO_view_sprite

Offset of view_sprite field in ITEM_INFO struct.

## table.cashShopPreviewPatch1

Virtual address of first place of cash shop preview patch.

## table.cashShopPreviewPatch2

Virtual address of second place of cash shop preview patch.

## table.cashShopPreviewPatch3

Virtual address of third place of cash shop preview patch.

## table.cashShopPreviewFlag

Cash shop preview patch flag.

## table.bgCheck1

Battle ground address 1

## table.bgCheck2

Battle ground address 2

## table.CSession_IsBattleFieldMode

Virtual address of CSession::IsBattleFieldMode

## table.CSession_GetTalkType_ret

Virtual address near ret in CSession::GetTalkType

# table.m_lastLockOnPcGid

Virtual address of CGameMode::m_lastLockOnPcGid

## table.CGameMode_ProcessAutoFollow

Virtual address of CGameMode::ProcessAutoFollow

## table.CGameMode_OnUpdate

Virtual address of CGameMode::OnUpdate

## table.g_client_version

Virtual address of g_client_version

## table.packetVersion

Client packet version
