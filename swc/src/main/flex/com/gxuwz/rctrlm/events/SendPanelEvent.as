/**
 * Created by user on 2015/8/24.
 */
package com.gxuwz.rctrlm.events {
import com.gxuwz.rctrlm.utils.fluorinefx.aperture.LocalObject;

import flash.events.Event;

public class SendPanelEvent extends Event{

    public var _msg:String;
    public var _remoteUser:String;

    public function SendPanelEvent( type:String, bubbles : Boolean = true,
                                    cancelable : Boolean = false) {
        super (type,bubbles,cancelable);
    }
    override public function clone():Event{
        return new SendPanelEvent(type,bubbles,cancelable);
    }
}
}
