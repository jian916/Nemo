// When an in-game setting that requires a restart to take effect is changed,
// the client tries to launch ro.gnjoy.com. This patch disables the behavior.
// Author: mrjnumber1
function DisableKROSiteLaunch()
{
    var urls = [
        "ro.gnjoy.com",
        "http://ro.gnjoy.com",
        "http://ro.gnjoy.com/",
        "http://ro.hangame.com/login/loginstep.asp?prevURL=/NHNCommon/NHN/Memberjoin.asp",
        "http://www.ragnarok.co.in/index.php",
        "https://iro.ragnarokonline.com/member/memberjoin1.asp?mNum=1",
        "http://t.kunlun.com/?act=voucher.main&cid=1000&pid=61",
        "http://www.hangame.com",
        "http://ragnarok.co.kr",
        "http://roz.gnjoy.com",
        "http://roz.gnjoy.com/"
    ]
    var patched = false;

    for (var i = 0; i < urls.length; i ++)
    {
        var offset = pe.stringRaw(urls[i]);
        if (offset !== -1)
        {
            pe.replaceByte(offset, 0);
            patched = true;
        }
    }

    if (patched === false)
        return "Failed in Step 1";
    return true;
}
