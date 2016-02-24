/**
 * Created by user on 2015/8/23.
 */
package com.gxuwz.rctrlm.events {
import flash.events.Event;

public class PictureHandlerEvent extends  Event{
    public function PictureHandlerEvent(type:String, bubbles : Boolean = true,
                                        cancelable : Boolean = false){
        super (type,bubbles,cancelable);
    }

    override public function clone():Event{
        return new PictureHandlerEvent(type,bubbles,cancelable);
    }
}
}
