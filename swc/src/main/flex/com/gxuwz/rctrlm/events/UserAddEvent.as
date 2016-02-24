/**
 * Created by Administrator on 2016/2/17.
 */
package com.gxuwz.rctrlm.events {
import flash.events.Event;

public class UserAddEvent extends Event{

    [Bindable] public var user:*;
    [Bindable] public var action:*;
    public static var USER_CONNECTION_WITH_SERVICE_FROM_SERVER:String="userConnectionWithService";
    public function UserAddEvent (type:String, bubbles : Boolean = true,
                                  cancelable : Boolean = false) {
        super (type,bubbles,cancelable);
    }

    override public function clone():Event{
        return new UserAddEvent(type,bubbles,cancelable);
    }
}
}
