/**
 * Created by Administrator on 2016/1/26.
 */
package com.gxuwz.rctrlm.events {
import flash.events.Event;

public class CommandEvent extends Event{

    public static var SEND_COMMAND_FROM_EXPERT:String = "commandFromExpertEvent";//尝试连接服务


    public var data:*;
    public var action:*;
    public function CommandEvent (type:String, bubbles : Boolean = true,
        cancelable : Boolean = false) {
    super (type,bubbles,cancelable);
    }

    override public function clone():Event{
        return new CommandEvent(type,bubbles,cancelable);
    }
}
}
