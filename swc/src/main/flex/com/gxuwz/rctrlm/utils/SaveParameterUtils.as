/**
 * Created by xjzx on 2015/7/26.
 */
package com.gxuwz.rctrlm.utils{
import flash.net.SharedObject;

public class SaveParameterUtils {
    /**
     * 本地用户将一些公共的数据保存到该变量来
     */
    private static var localSO:SharedObject=SharedObject.getLocal("remoteControlMicroscopeSettings");

    public static function GetCOMIndexUtils():String {
        if (localSO.data.hasOwnProperty("COMIndex"))
        {
            return localSO.data.comIndex;
        }
        return null;
    }
    public static function saveUserNameUtils(userName:String):void {
        localSO.data.user = userName;
        try
        {
            localSO.flush();
        }
        catch (e:Error)
        {
            trace("Cannot write shared object\n");
        }

    }
}
}
