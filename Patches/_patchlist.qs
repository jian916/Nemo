//===============================================================================================================//
// Register all your Patches and Patch groups in this file. Always register group before using its id in a patch //
//===============================================================================================================//

GlobalInit();

//###################################################################################################
//#                                                                                                 #
//# FORMAT for registering group : registerGroup(group id, group Name, mutualexclude [true/false]); #
//#                                                                                                 #
//# If you wish that only 1 patch can be active at a time (default) put mutualexclude as true       #
//#                                                                                                 #
//###################################################################################################

registerGroup( 0, "通用", false);

registerGroup( 1, "聊天限制", true);

registerGroup( 2, "修正視角角度", true);

registerGroup( 3, "擴增視角距離", true);

registerGroup( 4, "使用圖示", true);

registerGroup( 5, "GRF管理", true);

registerGroup( 6, "共用染色", true)

registerGroup( 7, "共用染色", true);

registerGroup( 8, "登入背景", true);

registerGroup( 9, "封包混淆", false);

registerGroup(10, "登入模式", true);

registerGroup(11, "點數商城", true);

registerGroup(12, "隱藏按鈕", false);

registerGroup(14, "授權介面", true);

registerGroup(15, "復活相關", true);

registerGroup(16, "移動延遲", true);

registerGroup(17, "起源版", false);

registerGroup(18, "自訂技能", false);

registerGroup(19, "髮型", true);

registerGroup(20, "路徑", false);

globalVarTest = 123;

//#########################################################################################################################################################
//#                                                                                                                                                       #
//# FORMAT for registering patch : registerPatch(patch id, functionName, patch Name, category, group id, author, description, recommended [true/false] ); #
//#                                                                                                                                                       #
//#  functionName is the function called when a patch is enabled. All your logic goes inside it.                                                          #
//#  You can define your function in any .qs file in the patches folder.                                                                                  #
//#  Remember the functionName needs to be in quotes (single or double) here but no quotes should be used while defining it.                              #
//#                                                                                                                                                       #
//#########################################################################################################################################################

//==========================================================================================================================//
// Note:                                                                                                                    //
// Currently some of the ids are not used in between (probably some patches were removed/disabled due to errors/deprecated) //
// It would be safer to not use those IDs for your own Patches to avoid any future conflict.                                //
//==========================================================================================================================//

//0 Unused - to be filled
registerPatch(  1, "UseTildeForMatk", "使用~號顯示Matk範圍", "介面", 0, "Neo", "素質欄的Matk區間顯示~號，而不是+號，Matk 是區間傷害", true);

registerPatch(  2, "AllowChatFlood", "發話洗頻判斷次數", "介面", 1, "Shinryo", "設定發話洗頻的限制，預設是只能發3次一樣內容", false);

registerPatch(  3, "RemoveChatLimit", "發話洗頻限制關閉", "介面", 1, "Neo", "取消發話洗頻的限制(設定次數限制的選項會取消)", false);

registerPatch(  4, "CustomAuraLimits", "自訂光圈顯示條件", "介面", 0, "Neo", "可以修改光圈顯示的條件(範例檔在Input\auraSpec.txt)", false);

registerPatch(  5, "EnableProxySupport", "啟用代理伺服器", "修復", 0, "Ai4rei/AN", "是否支援代理伺服器", false);

registerPatch(  6, "ForceSendClientHash", "發送登入器校驗碼", "封包", 0, "GreenBox, Neo", "是否發送登入器的 MD5 校驗碼，需要模擬器支援，可以防止登入器被修改，或是拿來限制登入器(在login_athena.conf設定)", false);

//registerPatch(  7, "ChangeGravityErrorHandler", "Change Gravity Error Handler", "修復", 0, " ", "It changes the Gravity Error Handler Mesage for a Custom One Pre-Defined by Diff Team", false);

registerPatch(  8, "CustomWindowTitle", "修改登入器標題[英文]", "介面", 0, "Shinryo", "修改登入器的標題(不支援中文，中文要用16進制自行修改)，預設為 'Ragnarok'", false);

registerPatch(  9, "Disable1rag1Params", "不用參數直接啟動遊戲", "修復", 0, "Shinryo", "不用 1rag1 參數就可以直接啟動遊戲，若沒用參數啟動遊戲會顯示空白的 Error", true);

registerPatch( 10, "Disable4LetterCharnameLimit", "取消角色名最少4個字限制", "修復", 0, "Shinryo", "取消角色名稱最少4個字的限制 (伺服端還是有限制)", false);

registerPatch( 11, "Disable4LetterUsernameLimit", "取消帳號最少4個字限制", "修復", 0, "Shinryo", "取消帳號最少4個字的限制 (伺服端還是有限制)", false);

registerPatch( 12, "Disable4LetterPasswordLimit", "取消密碼最少4個字限制", "修復", 0, "Shinryo", "取消密碼最少4個字的限制 (伺服端還是有限制)", false);

registerPatch( 13, "DisableFilenameCheck", "移除登入器名稱檢查", "修復", 0, "Shinryo", "移除登入器名稱檢查機制，解決檔名只要不是Ragexe.exe就無法啟動遊戲的問題", true);

registerPatch( 14, "DisableHallucinationWavyScreen", "Disable Hallucination Wavy Screen", "修復", 0, "Shinryo", "Disables the Hallucination effect (screen becomes wavy and lags the client), used by baphomet, horongs, and such", true);

registerPatch( 15, "DisableHShield", "移除駭客保護程式", "修復", 0, "Ai4rei/AN, Neo", "移除駭客保護機制，要 Diff 就一定要關閉 (它會吃 aossdk.dll 及 v3hunt.dll)", true);

registerPatch( 16, "DisableSwearFilter", "關閉發言過濾", "介面", 0, "Shinryo", "關閉發言過濾機制，忽略 manner.txt 內的關鍵字", false);

registerPatch( 17, "EnableOfficialCustomFonts", "使用官方的聊天泡泡字型", "介面", 0, "Shinryo", "對應角色 @font 編號，使用官方的自訂聊天泡泡字型(相關字型在 System\\Font 目錄下，但內建的不支援中文顯示，只吃eot字型檔，可用ttf轉檔)", false);

registerPatch( 18, "SkipServiceSelect", "跳過伺服器選擇介面", "介面", 0, "Shinryo", "跳過伺服器選擇的介面，預設會選第一個伺服器", false);

registerPatch( 19, "EnableTitleBarMenu", "遊戲標題顯示功能列", "介面", 0, "Shinryo", "讓遊戲的右上角顯示功能列(縮小&關閉)", true);

registerPatch( 20, "ExtendChatBox", "擴增聊天輸入限制", "介面", 0, "Shinryo", "擴增聊天視窗輸入的字數限制(最少70、最多234)", false);

registerPatch( 21, "ExtendChatRoomBox", "擴增聊天室輸入限制", "介面", 0, "Shinryo", "擴增聊天室輸入的字數限制(最少70、最多234)", false);

registerPatch( 22, "ExtendPMBox", "擴增密頻輸入限制", "介面", 0, "Shinryo", "擴增密頻(1:1)的字數限制(最少70、最多221)", false);

registerPatch( 23, "EnableWhoCommand", "開啟 /who 指令", "介面", 0, "Neo", "開啟 /who 指令，查詢線上人數，對所有(langtype)都開啟 (需要伺服端支援)", true);

registerPatch( 24, "FixCameraAnglesRecomm", "修正視角角度(建議)", "介面", 2, "Shinryo", "修正視角的角度，建議的角度 60 度", true);

registerPatch( 25, "FixCameraAnglesLess", "修正視角角度(最小)", "介面", 2, "Shinryo", "修正視角的角度，限制最小角度 30 度", false);

registerPatch( 26, "FixCameraAnglesFull", "修正視角角度(無限制)", "介面", 2, "Shinryo", "修正視角的角度，無限制角度 (shift+右鍵按著移動)", false);

registerPatch( 27, "HKLMtoHKCU", "登錄表儲存位置(HKLM改HKCU)", "修復", 0, "Shinryo", "有關登錄表儲存設定的位置，啟動遊戲反覆彈 Setup 請勾選測試", false);

registerPatch( 28, "IncreaseViewID", "擴增頭飾編號", "資料", 0, "Shinryo", "擴增頭飾的編號(預設2000，最大32000)", true);

registerPatch( 29, "DisableGameGuard", "移除 Game Guard 遊戲保護器", "修復", 0, "Neo", "移除 Game Guard 遊戲保護器，沒移除無法啟動遊戲", true);

registerPatch( 30, "IncreaseZoomOut50Per", "視野限制增加 50%", "介面", 3, "Shinryo", "增加 50% 視野遠近限制 (滾輪拉遠近)", false);

registerPatch( 31, "IncreaseZoomOut75Per", "視野限制增加 75%", "介面", 3, "Shinryo", "增加 75% 視野遠近限制 (滾輪拉遠近)", false);

registerPatch( 32, "IncreaseZoomOutMax", "視野限制取消", "介面", 3, "Shinryo", "取消視野遠近限制 (滾輪拉遠近)", true);

registerPatch( 33, "KoreaServiceTypeXMLFix", "啟用韓版預設的 ClientInfo 設定", "修復", 0, "Shinryo", "當讀取自訂的 ClientInfo 失敗時，使用韓版預設的 ClientInfo ，只有在 ServiceType 為 Korean 時才會顯示選項", true);

registerPatch( 34, "EnableShowName", "預設啟用/showname功能", "修復", 0, "Neo", "此功能會把名字跟公會稱號對換，簡化並加粗顯示，隱藏組隊名跟公會名 (預設啟用/showname功能)", false);

registerPatch( 35, "ReadDataFolderFirst", "優先讀取data資料夾", "資料", 0, "Shinryo", "優先讀取data資料夾的檔案", true);

registerPatch( 36, "ReadMsgstringtabledottxt", "使用msgstringtable.txt介面訊息", "資料", 0, "Shinryo", "使用msgstringtable.txt的所有介面訊息，沒勾選預設是韓文亂碼", true);

registerPatch( 37, "ReadQuestid2displaydottxt", "使用questid2display.txt任務訊息", "資料", 0, "Shinryo", "使用questid2display.txt的被動任務訊息", true);

registerPatch( 38, "RemoveGravityAds", "移除Gravity的廣告", "介面", 0, "Shinryo", "移除登入介面顯示的 Gravity 廣告", true);

registerPatch( 39, "RemoveGravityLogo", "移除Gravity的Logo", "介面", 0, "Shinryo", "移除登入介面顯示的 Gravity Logo", true);

registerPatch( 40, "RestoreLoginWindow", "恢復舊版登入界面", "修復", 10, "Shinryo, Neo", "恢復舊版的登入界面，沒勾選就沒登入界面喔", true);

registerPatch( 41, "DisableNagleAlgorithm", "關閉Nagle網卡緩衝", "封包", 0, "Shinryo", "取消 Nagle 演算法，Nagle 簡單講是緩衝演算法(資料到達一定的量才會一並傳輸)，使用此演算法可以減少網路傳輸量，但會增加延遲，以目前網路頻寬來講沒有差這一點，所以會勾選關閉", true);

registerPatch( 42, "SkipResurrectionButton", "隱藏原地復活選項", "介面", 15, "Shinryo", "角色死亡時，不顯示原地復活選項", false);

registerPatch( 43, "DeleteCharWithEmail", "使用信箱當刪除角色的密碼", "修復", 0, "Neo", "刪除角色時，使用信箱來當密碼，而不再輸入生日，強制所有(langtype)都使用", false);

registerPatch( 44, "TranslateClient", "翻譯登入器寫死的韓文", "介面", 0, "Ai4rei/AN, Neo", "修復一些寫死再登入器內無法翻譯的韓文，會用TranslateClient.txt表替換", true);

registerPatch( 45, "UseCustomAuraSprites", "使用自製的滿等光圈", "資料", 0, "Shinryo", "使用自製的滿等光圈", false);

registerPatch( 46, "UseNormalGuildBrackets", "改變工會名稱外框", "介面", 0, "Shinryo", "修改角色ID旁顯示的工會名稱外框，預設()，勾選使用[]", true);

registerPatch( 47, "UseRagnarokIcon", "使用RO預設Icon圖示", "介面", 4, "Shinryo, Neo", "使用RO預設的Icon圖示", true);

registerPatch( 48, "UsePlainTextDescriptions", "文字檔使用原編碼讀取", "資料", 0, "Shinryo", "文字檔使用原編碼讀取，而不是編碼過的", true);

registerPatch( 49, "EnableMultipleGRFs", "讀取多個 GRF [INI]", "自訂", 5, "Shinryo", "啟用後讀取多個GRF，勾選時可輸入自訂的名稱(預設 data.ini)，最多只能讀取10個 GRF", true);

registerPatch( 50, "SkipLicenseScreen", "跳過授權條款介面", "介面", 14, "Shinryo, MS", "跳過不顯示授權條款，直接到伺服器選擇畫面", false);

registerPatch( 51, "ShowLicenseScreen", "啟動遊戲時顯示授權條款", "介面", 14, "Neo", "強制登入時顯示授權條款，強制所有(langtype)都顯示", false);

registerPatch( 52, "UseCustomFont", "自訂遊戲介面字型", "介面", 0, "Ai4rei/AN", "使用自訂的遊戲介面字型，從系統字型中挑選 (字型名稱不支援中文，若要中文請自行 HEX)", false);

registerPatch( 53, "UseAsciiOnAllLangTypes", "使用 Ascii 編碼顯示文字", "介面", 0, "Ai4rei/AN", "使用 Ascii 編碼顯示文字", true);

registerPatch( 54, "ChatColorGM", "修改GM訊息文字顏色", "顏色", 0, "Ai4rei/AN, Shakto", "改變 GM 聊天視窗文字的顏色，預設值為 FFFF00 (黃色)", false);

registerPatch( 55, "ChatColorPlayerOther", "修改一般訊息文字顏色", "顏色", 0, "Ai4rei/AN, Shakto", "改變 一般對話 聊天視窗文字的顏色，預設值為 FFFFFF (白色)", false);

//Disabled since GM Chat Color also patches the Main color - to be removed
//registerPatch( 56, "ChatColorMain", "Chat Color - Main", "顏色", 0, "Ai4rei/AN, Shakto", "Changes the Main Chat color and sets it to the specified value", false);

registerPatch( 57, "ChatColorGuild", "修改公會訊息文字顏色", "顏色", 0, "Ai4rei/AN, Shakto", "改變 公會 聊天視窗文字的顏色，預設值為 B4FFB4 (亮綠色)", false);

registerPatch( 58, "ChatColorPartyOther", "修改組隊其他人訊息文字顏色", "顏色", 0, "Ai4rei/AN, Shakto", "改變 組隊其他人 聊天視窗文字的顏色，預設值為 FFC8C8 (粉紅色)", false);

registerPatch( 59, "ChatColorPartySelf", "修改組隊自己發言文字顏色", "顏色", 0, "Ai4rei/AN, Shakto", "改變 組隊自己發言 的顏色，預設值為 FFC800 (橘色)", false);

registerPatch( 60, "ChatColorPlayerSelf", "修改自己發言文字顏色", "顏色", 0, "Ai4rei/AN, Shakto", "改變 自己發言 的聊天視窗文字顏色，預設值為 00FF00 (綠色)", false);

registerPatch( 61, "DisablePacketEncryption", "關閉封包混淆", "封包", 0, "Ai4rei/AN", "取消封包混淆，此功能並不是加密，而是讓每個封包有一個隨機流水號，只要跟伺服端沒有對應就無法連線", false);

registerPatch( 62, "DisableLoginEncryption", "關閉登入封包加密", "封包", 0, "Neo", "關閉登入封包加密，封包 0x2b0", true);

registerPatch( 63, "UseOfficialClothPalette", "使用官方外觀染色檔", "介面", 0, "Neo", "使用官方預設的外觀染色檔", true);

registerPatch( 64, "FixChatAt", "修復 @ 符號 Bug", "修復", 0, "Shinryo", "修復聊天視窗不能輸入 @ 的限制", true);

registerPatch( 65, "ChangeItemInfo", "修改iteminfo*.lub路徑", "自訂", 20, "Neo", "勾選後可以輸入自訂的成就 iteminfo*.lub 檔案，如果有官方的更新，可以防止原本的 lub 被覆蓋", true);

registerPatch( 66, "LoadItemInfoPerServer", "用伺服器名稱自動選擇iteminfo", "資料", 0, "Neo", "讓 iteminfo 的 main function 引入伺服器名稱，自動判斷需要的內容，有分流且需要不同iteminfo才會用到", false);

registerPatch( 67, "DisableQuakeEffect", "取消技能震動效果", "介面", 0, "Ai4rei/AN", "取消技能震動效果、地裂、爆氣等等", false);

registerPatch( 68, "Enable64kHairstyle", "解除髮型數量限制", "介面", 19, "Ai4rei/AN", "解除髮型數量限制，支援64k種髮型，官方僅 27 種", true);

registerPatch( 69, "ExtendNpcBox", "擴增input的字數限制", "介面", 0, "Ai4rei/AN", "擴增腳本 input 的字數限制(最少2052、最多4096)", false);

registerPatch( 70, "CustomExpBarLimits", "自訂經驗條顯示條件", "介面", 0, "Neo", "可以修改經驗條顯示的條件 (範例檔在Input\\expBarSpec.txt)", false);

registerPatch( 71, "IgnoreResourceErrors", "忽略補丁檔案錯誤", "修復", 0, "Shinryo", "忽略所有資源缺檔錯誤(可幫助除錯，DeBug時不用勾)", false);

registerPatch( 72, "IgnoreMissingPaletteError", "忽略染色檔案錯誤", "修復", 0, "Shinryo", "忽略染色檔案缺檔的錯誤(可幫助除錯，DeBug時不用勾)", false);

registerPatch( 73, "RemoveHourlyAnnounce", "關閉健康提示", "介面", 0, "Ai4rei/AN", "關閉健康提示，就是每個小時的問候語", true);

registerPatch( 74, "IncreaseScreenshotQuality", "修改照相截圖的品質", "介面", 0, "Ai4rei/AN", "修改照相截圖 jpeg 的品質 (最小0%，最大100%)", false);

registerPatch( 75, "EnableFlagEmotes", "啟用旗子表情", "介面", 0, "Neo", "是否啟用旗子表情，需要自行設定旗子的列表", false);

registerPatch( 76, "EnforceOfficialLoginBackground", "使用官方登入背景", "介面", 0, "Shinryo", "強制使用官方的登入背景圖", false);

registerPatch( 77, "EnableCustom3DBones", "載入自製的3D模型", "自訂", 0, "Ai4rei/AN", "是否載入自製的3D模型", false);

registerPatch( 78, "MoveCashShopIcon", "移動商城圖示位置", "介面",  11, "Neo", "移動商城圖示顯示的位置", false);

registerPatch( 79, "SharedBodyPalettesV2", "服裝共用染色檔", "介面", 6, "Ai4rei/AN, Neo", "所有職業服裝共用單一染色檔，格式為(body_%d.pal)", false);

registerPatch( 80, "SharedBodyPalettesV1", "服裝共用染色檔(分男女)", "介面", 6, "Ai4rei/AN, Neo", "所有職業服裝共用單一染色檔(分男女)，格式為(body_%s_%d.pal)", false);

registerPatch( 81, "RenameLicenseTxt", "修改授權條款路徑", "資料", 0, "Neo", "修改授權條款 licence.txt 的檔案名稱", false);

registerPatch( 82, "SharedHeadPalettesV1", "髮色共用染色檔(分男女)", "介面", 7, "Ai4rei/AN, Neo", "髮色在相同髮型共用單一染色檔(分男女)，格式為(head_%s_%d.pal)", false);

registerPatch( 83, "SharedHeadPalettesV2", "髮色共用染色檔", "介面", 7, "Ai4rei/AN, Neo", "髮色在相同髮型共用單一染色檔，格式為(head_%d.pal)", false);

registerPatch( 84, "RemoveSerialDisplay", "移除右下角序號顯示", "介面", 0, "Shinryo", "移除遊戲介面右下角的序號顯示", true);

registerPatch( 85, "ShowCancelToServiceSelect","選擇伺服器時可上一步", "介面", 0, "Neo", "登入帳號時，可以點上一步重新選擇伺服器", false);

registerPatch( 86, "OnlyFirstLoginBackground", "只顯示第一種背景圖片", "介面", 8, "Shinryo", "只顯示第一種背景圖片", false);

registerPatch( 87, "OnlySecondLoginBackground", "只顯示第二種背景圖片", "介面", 8, "Shinryo", "只顯示第二種背景圖片", false);

registerPatch( 88, "AllowSpaceInGuildName", "允許公會名稱內有空白", "介面", 0, "Shakto", "允許創公會時，公會名中使用空白 (/guild \"測 試\")", false);

registerPatch( 90, "EnableDNSSupport", "IP支援域名(DNS)解析", "資料", 0, "Shinryo", "是否支援域名解析，啟用後 clientinfo.xml 即可使用網址類型的IP 例如: roip.no-ip.net", true);

registerPatch( 91, "DCToLoginWindow", "斷線後自動返回登入介面", "介面", 0, "Neo", "斷線後是否返回登入介面，預設是直接關閉遊戲", false);

registerPatch( 92, "PacketFirstKeyEncryption", "設定封包混淆第一組key", "封包", 9, "Shakto, Neo", "封包混淆的第一組key (有使用的話，需跟模擬器對應)", false);

registerPatch( 93, "PacketSecondKeyEncryption", "設定封包混淆第二組key", "封包", 9, "Shakto, Neo", "封包混淆的第二組key (有使用的話，需跟模擬器對應)", false);

registerPatch( 94, "PacketThirdKeyEncryption", "設定封包混淆第三組key", "封包", 9, "Shakto, Neo", "封包混淆的第三組key (有使用的話，需跟模擬器對應)", false);

registerPatch( 95, "UseSSOLoginPacket", "使用SSO登入封包", "封包", 10, "Ai4rei/AN", "使用SSO方式登入，可以使用參數的方式登入 (登入Restore Login Window不能勾選)", false);

registerPatch( 96, "RemoveGMSprite", "取消GM外觀", "介面", 0, "Neo", "取消GM外觀，使用預設的職業模組", false);

registerPatch( 97, "CancelToLoginWindow", "選角時取消返回登入介面", "修復", 0, "Neo", "在選擇角色時，可以點取消返回登入介面，而不是結束遊戲", true);

registerPatch( 98, "DisableDCScream", "不讀取驚聲尖叫的檔案", "介面", 0, "Neo", "不讀取驚聲尖叫的檔案 dc_scream.txt", false);

registerPatch( 99, "DisableBAFrostJoke", "不讀取冷笑話的檔案", "介面", 0, "Neo", "不讀取冷笑話的檔案 ba_frostjoke.txt", false);

registerPatch(100, "DisableMultipleWindows", "禁止登入器雙開", "介面", 0, "Shinryo, Ai4rei/AN", "禁止登入器雙開 (這無法有效杜絕雙開)", false);

registerPatch(101, "SkipCheaterFriendCheck", "關閉朋友名稱相似提示", "介面", 0, "Ai4rei/AN", "在密語時關閉相似朋友名字的提醒", false);

registerPatch(102, "SkipCheaterGuildCheck", "關閉公會玩家名稱相似提示", "介面", 0, "Ai4rei/AN", "在密語時關閉相似工會玩家名字的提醒", false);

registerPatch(103, "DisableAutofollow", "關閉自動跟隨功能", "自訂", 0, "Functor, Neo", "關閉自動跟隨的功能 [Shift+右鍵]", false);

registerPatch(104, "IncreaseHairLimits", "擴增髮型跟染色檔編號", "介面", 0, "Neo", "擴增髮型跟染色檔編號", true);

// registerPatch(105, "HideNavButton", "隱藏[導航]按鈕", "介面", 12, "Neo", "隱藏導航的按鈕", false);

// registerPatch(106, "HideBgButton", "隱藏[戰場]按鈕", "介面", 12, "Neo", "隱藏戰場的按鈕", false);

// registerPatch(107, "HideBankButton", "隱藏[銀行]按鈕", "介面", 12, "Neo", "隱藏銀行的按鈕", false);

// registerPatch(108, "HideBooking", "隱藏[招募]按鈕", "介面", 12, "Neo", "隱藏組隊招募的按鈕", false);

// registerPatch(109, "HideRodex", "隱藏[信箱]按鈕", "介面", 12, "Neo", "隱藏信箱(RODEX)的按鈕", false);

// registerPatch(110, "HideAchieve", "隱藏[成就]按鈕", "介面", 12, "Neo", "隱藏成就的按鈕", false);

// registerPatch(111, "HideRecButton", "隱藏[錄影]按鈕", "介面", 12, "Neo", "隱藏錄影的按鈕", false);

// registerPatch(112, "HideMapButton", "隱藏[地圖]按鈕", "介面", 12, "Neo", "隱藏地圖的按鈕", false);

// registerPatch(113, "HideQuest", "隱藏[任務]按鈕", "介面", 12, "Neo", "隱藏任務的按鈕", false);

registerPatch(114, "ChangeVendingLimit", "修改收購商店金額限制 [測試]", "資料", 0, "Neo", "修改收購商店最多100萬的限制", false);

registerPatch(115, "EnableEffectForAllMaps", "開啟所有地圖的特效 [測試]", "資料", 0, "Neo", "在所有地圖開啟地圖特效 (EffectTool)", false);

//registerPatch(151, "UseArialOnAllLangTypes", "Use Arial on All LangTypes", "介面", 0, "Ai4rei/AN, Shakto", "Makes Arial the default font on all LangTypes (it's enable ascii by default)", true);

//FixTetraVortex patch is removed since the black screen animation issue is fixed Server Side

//======================================//
// Special Patches by Neo and Curiosity //
//======================================//

registerPatch(200, "EnableMultipleGRFsV2", "讀取多個 GRF [內嵌隱藏]", "自訂", 5, "Neo", "勾選時載入預先設定好的(data.ini)，內嵌在登入器裡", false);

registerPatch(201, "EnableCustomHomunculus", "載入自製的生命體", "自訂", 0, "Neo", "是否載入自製的生命體", false);

registerPatch(202, "EnableCustomJobs", "載入自製的職業外觀", "自訂", 0, "Neo", "是否載入自製的職業外觀", false);

registerPatch(203, "EnableCustomShields", "載入自製的盾牌外觀", "自訂", 0, "Neo", "是否載入自製的盾牌外觀", false);

registerPatch(204, "IncreaseAtkDisplay", "擴增傷害顯示位數", "自訂", 0, "Neo", "擴增傷害顯示的位數，預設是6位數99萬9999，啟用後變10位", true);

registerPatch(205, "EnableMonsterTables", "讀取魔物對話檔案", "自訂", 0, "Ind, Neo", "讀取魔物對話檔案，MonsterTalkTable.xml、PetTalkTable.xml 和 MonsterSkillInfo.xml", false);

registerPatch(206, "LoadCustomQuestLua", "載入自製的任務 lub 檔", "自訂", 0, "Neo", "載入自製的任務 lub 檔，在補丁 lua files\quest 裡面", false);

registerPatch(207, "ResizeFont", "修改字型大小", "介面", 0, "Yommy, Neo", "修改字型大小，預設是10，中文改大會變很醜", false);

registerPatch(208, "RestoreCashShop", "恢復右上方[商城]圖示", "特殊", 0, "Neo", "恢復右上方商城的按鈕圖示，RE 版本沒有商城才要勾選", false);

registerPatch(209, "EnableMailBox", "恢復信箱功能", "介面", 0, "Neo", "啟用信箱功能(舊版信箱，非 RODEX)，對所有(langtype)都支援", false);

registerPatch(210, "UseCustomIcon", "使用自製的圖示", "介面", 4, "Neo", "使用自製的圖示 8bpp (256 色) 32x32 圖片", false);

registerPatch(211, "UseCustomDLL", "載入自製的 DLL", "自訂", 0, "Neo", "掛載自製的 DLL，例如 啟動動畫 (範例檔在Input\dlls.txt)", false);

registerPatch(212, "RestoreRoulette", "恢復右上方[轉盤]圖示", "特殊", 0, "Neo", "恢復右上方轉盤按鈕圖示，新版預設已關閉", false);

registerPatch(213, "DisableHelpMsg", "關閉登入遊戲的教學提示", "介面", 0, "Neo", "關閉登入遊戲時，顯示的教學提示", true);

registerPatch(214, "RestoreModelCulling", "恢復透視模組", "特殊", 0, "Curiosity", "啟用透視模組(Culling)，當玩家在房子後面會將房子透明化處理(有些地圖有BUG)", false);

registerPatch(215, "IncreaseMapQuality", "地圖支援32位元紋理", "自訂", 0, "Curiosity", "讓地圖支援32位元顏色紋理", false);

registerPatch(216, "HideCashShop", "隱藏右上方[商城]圖示", "介面", 12, "Neo", "隱藏右上方商城按鈕圖示", false);

registerPatch(217, "HideRoulette", "隱藏右上方[轉盤]圖示", "介面", 12, "Neo", "隱藏右上方轉盤按鈕圖示", false);

registerPatch(218, "ShowExpNumbers", "顯示經驗值", "介面", 0, "Neo", "在左上角角色狀態欄經驗條旁顯示經驗值", false);

registerPatch(219, "ShowResurrectionButton", "顯示原地復活按鈕", "介面", 15, "Neo", "角色死亡時強制顯示原地復活按鈕(不管mapflag都會顯示)", false);

registerPatch(220, "DisableMapInterface", "關閉世界地圖", "介面", 0, "Neo", "關閉世界地圖功能", false);

registerPatch(221, "RemoveJobsFromBooking", "組隊招募不顯示職業名稱", "介面", 0, "Neo", "組隊招募不顯示職業名稱", false);

registerPatch(222, "ShowReplayButton", "顯示錄影播放按鈕", "介面", 0, "Neo", "選擇伺服器時，顯示錄影播放的按鈕", false);

registerPatch(223, "MoveItemCountUpwards", "美化左上角狀態欄[測試]", "介面", 0, "Neo", "美化左上角的狀態欄", false);

//registerPatch(224, "IncreaseNpcIDs", "擴充 NPC 編號上限[測試]", "自訂", 0, "Neo", "Increase the Loaded NPC IDs to include 10K+ range IDs. Limits are configurable", false);

registerPatch(225, "ShowRegisterButton", "顯示註冊按鈕", "介面", 0, "Neo", "在登入輸入帳號介面顯示註冊按鈕", false);

registerPatch(226, "DisableWalkToDelay", "關閉移動延遲[不建議]", "自訂", 16, "MegaByte", "關閉移動延遲，讓玩家可以無延遲移動，啟用後會造成伺服器負擔", false);

registerPatch(227, "SetWalkToDelay", "修改移動延遲", "自訂", 16, "MegaByte", "修改移動延遲，延遲越低移動反應越快，設定過短會造成伺服器負擔", false);

registerPatch(228, "DisableDoram", "關閉喵族的腳色介面[測試]", "介面", 0, "Ai4Rei, Secret", "關閉喵族的創立腳色介面 (建議伺服端也要限制)", false);

registerPatch(229, "EnableEmblemForBG", "顯示公會圖示在戰場地圖", "介面", 0, "Neo", "在戰場地圖時，玩家頭上顯示公會圖示", false);

registerPatch(230, "AlwaysReadKrExtSettings", "永遠讀取韓版lub的檔案名稱不受語言影響", "修復", 0, "Secret", "永遠讀取韓版 lub 的檔案名稱，而不會受登入器 clientinfo 設定的 ServiceType 而改變路徑", false);

registerPatch(231, "RemoveHardcodedAddress", "移除寫死在登入器的IP跟Port", "修復", 17, "4144", "移除寫死在登入器的IP跟Port", false);

registerPatch(232, "RestoreOldLoginPacket", "恢復舊版的登入封包", "特殊", 17, "4144", "恢復舊版的登入封包 0x64", false);

// registerPatch(233, "HideSNSButton", "隱藏[TWITTER]按鈕", "介面", 12, "Secret", "隱藏 TWITTER 的按鈕", false);

registerPatch(234, "IgnoreLuaErrors", "忽略 Lua 錯誤", "修復", 0, "4144", "忽略所有 Lua/Lub 錯誤(可幫助除錯，DeBug時不用勾)", false);

registerPatch(235, "EnableGuildWhenInClan", "啟用在氏族中也可加入公會", "自訂", 0, "Functor, Secret", "在成為氏族成員時，移除單一公會的限制，可同時有兩個工會", false);

registerPatch(236, "EnablePlayerSkills", "啟用自訂玩家技能[測試]", "自訂", 18, "Neo", "啟用自訂玩家技能 (使用 Lua 檔案)", false);

registerPatch(237, "EnableHomunSkills", "啟用自訂生命體技能[測試]", "自訂", 18, "Neo", "啟用自訂生命體技能 (使用 Lua 檔案)", false);

registerPatch(238, "EnableMerceSkills", "啟用自訂傭兵技能[測試]", "自訂", 18, "Neo", "啟用自訂傭兵技能 (使用 Lua 檔案)", false);

registerPatch(239, "IgnoreAccountArgument", "禁止 /account: 參數", "修復", 0, "Secret", "禁止 /account: 參數", false);

registerPatch(240, "LoadCustomClientInfo", "修改 clientinfo.xml 路徑", "自訂", 0, "Secret", "修改自訂的 clientinfo.xml 路徑", false);

registerPatch(241, "AlwaysLoadClientPlugins", "自動載入插件[測試]", "修復", 0, "Secret", "自動載入 DLL 插件", false);

registerPatch(242, "DisableKROSiteLaunch", "關閉韓版網頁登入的功能", "修復", 0, "mrjnumber1", "關閉韓版(ro.gnjoy.com)網頁登入的功能，若未關閉將無法使用傳統方式登入", false);

registerPatch(243, "ChangeQuickSwitchDelay", "修改一鍵換裝的延遲時間", "修復", 0, "mrjnumber1", "修改一鍵換裝的延遲時間", false);

registerPatch(244, "DisableCDGuard", "移除 Cheat Defender 遊戲保護器", "修復", 0, "4144", "移除 Cheat Defender 遊戲保護器，沒移除無法啟動遊戲", true);

registerPatch(245, "FixedCharJobCreate", "修改建立角色時的角色編號錯誤", "自訂", 0, "4144", "修改建立角色時的角色編號錯誤", false);

// registerPatch(246, "IncreaseHairSprites", "Increase hair style limit in game", "自訂", 19, "4144", "Allow use more hair styles than default limit", false);

registerPatch(247, "ChangeNewCharNameHeight", "修改新的創角介面名字欄位的高度", "自訂", 0, "4144", "修改新的創角介面名字欄位的高度", false);

registerPatch(248, "RemoveWrongCharFromCashShop", "移除點數商城中隨機出現的字元", "自訂", 0, "4144", "移除點數商城中隨機出現的字元", false);

registerPatch(249, "ChangeMinimalResolutionLimit", "修改遊戲最小解析度限制", "自訂", 0, "4144", "修改遊戲最小解析度限制 (預設值為 1024x768", false);

registerPatch(250, "AllowLeavelPartyLeader", "允許隊長在沒有隊員的地圖離開組隊", "自訂", 0, "4144", "允許隊長在沒有隊員的地圖離開組隊，此為新版登入器的限制", false);

registerPatch(251, "AllowCloseCutinByEsc", "可使用 Esc 關閉 cutin 圖片", "自訂", 0, "4144", "可使用 Esc 關閉 cutin 的 NPC 圖片", false);

registerPatch(252, "FixAchievementCounters", "修復成就系統計數問題", "自訂", 0, "4144", "修復 2017 登入器成就系統計數錯誤的問題", false);

registerPatch(253, "SkipHiddenMenuButtons", "修復功能列的隱形按鈕", "Custom", 12, "4144", "當啟用隱藏左上方功能列的按鈕時，修復隱形的按鈕", false);

registerPatch(268, "RestoreChatFocus", "恢復聊天視窗左鍵選取文字功能", "Custom", 0, "4144", "恢復聊天輸入視窗左鍵選取的功能", false);

registerPatch(280, "ChangeGuildExpLimit", "修改公會經驗抽成上限", "Custom", 0, "4144", "修改公會經驗抽成的百分比限制 (預設50%)", false);

registerPatch(283, "ChangeFadeOutDelay", "修改瞬移的延遲時間", "Custom", 0, "4144", "修改在同張地圖瞬移的延遲時間", false);

registerPatch(284, "CopyCDGuard", "移除 CDClient.dll 檔案檢查系統", "Fix", 0, "4144", "移除 Cheat Defender 遊戲保護器後，保留的 DLL 用空白的 CDClient.dll 檔案覆蓋到目標資料夾", false);

registerPatch(285, "FixActDelay", "修復 Act 有過多影格的延遲", "Fix", 0, "Functor, 4144", "修復 Act 有過多影格的延遲", false);

registerPatch(286, "HideZeroDateInGuildMembers", "隱藏公會成員 (1969-01-01) 最後上線時間", "Fix", 0, "4144", "隱藏公會成員預設無意義的 (1969-01-01) 最後上線時間", false);


registerPatch(300, "FixItemDescBug", "修復物品說明亂碼 Bug", "介面", 0, "Jchcc", "修復物品右鍵內容 '[' 造成的亂碼", false);

registerPatch(301, "SetMaxItemCount", "修改角色道具上限顯示", "介面", 0, "Jchcc", "修改角色道具容量最大上限顯示的數值 (只是登入器顯示，跟伺服端無關)", false);

registerPatch(302, "SetAutoFollowDelay", "設定自動跟隨延遲", "自訂", 0, "Jchcc", "讓自動跟隨更緊密，減少過圖跟丟的情況", false);

registerPatch(303, "DefaultBrowserInCashshop", "使用預設瀏覽器開啟商城內連結", "介面", 0, "Jchcc", "使用系統預設的瀏覽器開啟新版商城(2018)內的連結，不使用 IE", false);

registerPatch(304, "UseDefaultBrowser", "使用預設瀏覽器開啟NPC的<URL>連結", "介面", 0, "Jchcc", "使用系統預設的瀏覽器開啟 NPC 的 <URL> 連結，不再使用RO內建的瀏覽器", false);

registerPatch(305, "ShortcutAllItem", "允許所有物品放快捷列", "修復", 0, "Jchcc", "讓所有物品都能放到快捷列，方便做數量追蹤", false);

registerPatch(306, "CustomWindowTitleHex", "修改登入器標題[HEX]", "介面", 0, "Jian", "修改登入器的標題(支援中文，請輸入16進制)，預設為 '52 61 67 6E 61 72 6F 6B' (Ragnarok)", false);

registerPatch(307, "ChangeHealthBarSize", "修改角色下方生命條的大小", "介面", 0, "Jchcc", "修改角色下方藍綠色的HP/SP顯示大小", false);

registerPatch(308, "ChangeMvpHealthBarSize", "修改MVP下方生命條的大小", "介面", 0, "Jchcc", "修改MVP下方生命條顯示大小", false);

registerPatch(309, "MvpItemIdenfifyName", "MVP物品用已鑑定名稱顯示", "Fix", 0, "Jchcc", "MVP物品訊息用已鑑定名稱顯示.", false);

registerPatch(310, "SetButtonBooking",	"隱藏[招募]按鈕", "介面", 12, "Jchcc", "隱藏左上角功能欄隊伍招募按鈕", false);

registerPatch(311, "SetButtonBg",		"隱藏[戰場]按鈕", "介面", 12, "Jchcc", "隱藏左上角功能欄戰場按鈕", false);

registerPatch(312, "SetButtonQuest",	"隱藏[任務]按鈕", "介面", 12, "Jchcc", "隱藏左上角功能欄任務按鈕", false);

registerPatch(313, "SetButtonMap",		"隱藏[地圖]按鈕", "介面", 12, "Jchcc", "隱藏左上角功能欄地圖按鈕", false);

registerPatch(314, "SetButtonNav",		"隱藏[導航]按鈕", "介面", 12, "Jchcc", "隱藏左上角功能欄導航按鈕", false);

registerPatch(315, "SetButtonBank",		"隱藏[銀行]按鈕", "介面", 12, "Jchcc", "隱藏左上角功能欄銀行按鈕", false);

registerPatch(316, "SetButtonRec",		"隱藏[錄影]按鈕", "介面", 12, "Jchcc", "隱藏左上角功能欄錄影按鈕", false);

registerPatch(317, "SetButtonMail",		"隱藏[信箱]按鈕", "介面", 12, "Jchcc", "隱藏左上角功能欄信箱按鈕", false);

registerPatch(318, "SetButtonAchieve",	"隱藏[成就]按鈕", "介面", 12, "Jchcc", "隱藏左上角功能欄成就按鈕", false);

registerPatch(319, "SetButtonTip",		"隱藏[提示]按鈕", "介面", 12, "Jchcc", "隱藏左上角功能欄提示按鈕", false);

registerPatch(320, "SetButtonAttend",	"隱藏[簽到]按鈕", "介面", 12, "Jchcc", "隱藏左上角功能欄簽到按鈕", false);

registerPatch(321, "SetButtonSNS",		"隱藏[TWITTER]按鈕", "介面", 12, "Jchcc", "隱藏左上角功能欄TWITTER按鈕", false);

registerPatch(322, "SetButtonCashShop",	"隱藏[商城]按鈕", "介面", 12, "Jchcc", "隱藏左上角功能欄商城按鈕", false);

registerPatch(323, "fixHomunculusAI", "修復生命體AI", "Fix", 0, "Jchcc", "修復20170920之後的登入器生命體AI無法自動攻擊的問題", false);


registerPatch(350, "ChangeAchievementListPath", "修改AchievementList*.lub路徑", "自訂", 20, "Jian", "勾選後可以輸入自訂的成就 AchievementList*.lub 檔案，如果有官方的更新，可以防止原本的 lub 被覆蓋", false);

registerPatch(351, "ChangeMonsterSizeEffectPath", "修改MonsterSizeEffect*.lub路徑", "自訂", 20, "Jian", "勾選後可以輸入自訂的魔物設定 MonsterSizeEffect*.lub 檔案，如果有官方的更新，可以防止原本的 lub 被覆蓋", false);

registerPatch(353, "ChangeTowninfoPath", "修改Towninfo*.lub路徑", "自訂", 20, "Jian", "勾選後可以輸入自訂的圖標 Towninfo*.lub 檔案，如果有官方的更新，可以防止原本的 lub 被覆蓋", false);

registerPatch(354, "ChangePetEvolutionClnPath", "修改PetEvolutionCln*.lub路徑", "自訂", 20, "Jian", "勾選後可以輸入自訂的生命體 PetEvolutionCln*.lub 檔案，如果有官方的更新，可以防止原本的 lub 被覆蓋", false);

registerPatch(355, "ChangeTipboxPath", "修改Tipbox*.lub路徑", "自訂", 20, "Jian", "勾選後可以輸入自訂的教學 Tipbox*.lub 檔案，如果有官方的更新，可以防止原本的 lub 被覆蓋", false);

registerPatch(356, "ChangeCheckAttendancePath", "修改CheckAttendance*.lub路徑", "自訂", 20, "Jian", "勾選後可以輸入自訂的簽到 CheckAttendance*.lub 檔案，如果有官方的更新，可以防止原本的 lub 被覆蓋", false);

registerPatch(357, "ChangeOngoingQuestInfoListPath", "修改OngoingQuestInfoList*路徑", "自訂", 20, "Jian", "勾選後可以輸入自訂的任務 OngoingQuestInfoList* 檔案，如果有官方的更新，可以防止原本的 lub 被覆蓋", false);

registerPatch(358, "ChangeRecommendedQuestInfoListPath", "修改RecommendedQuestInfoList*路徑", "自訂", 20, "Jian", "勾選後可以輸入自訂的任務 RecommendedQuestInfoList* 檔案，如果有官方的更新，可以防止原本的 lub 被覆蓋", false);

registerPatch(359, "ChangePrivateAirplanePath", "修改PrivateAirplane*.lub路徑", "自訂", 20, "Jian", "勾選後可以輸入自訂的飛空艇 PrivateAirplane*.lub 檔案，如果有官方的更新，可以防止原本的 lub 被覆蓋", false);

registerPatch(360, "ChangeDefaultBGM", "修改預設 BGM 路徑", "自訂", 20, "Jian", "修改預設 BGM 路徑，改變登入帳號或未設定地圖的背景聲音，官方預設為 bgm\\01.mp3", false);

registerPatch(287, "ChangeDisplayCharDelDelay", "Change character display deletion time from actual date to relative date", "Custom", 0, "Functor", "Change character display deletion time from actual date to relative date", false);

registerPatch(288, "MoveShieldToTop", "Draw shield on top of other player sprites", "Custom", 0, "4144", "Move shield sprite closed to camera for draw on top of other player sprites", false);


GlobalPostInit();
