package com.gxuwz.rctrlm.utils.fluorinefx.aperture
{
import mx.rpc.mxml.IMXMLSupport;

[Event(name="result", type="mx.rpc.events.ResultEvent")]
[Event(name="fault", type="mx.rpc.events.FaultEvent")]
[Bindable]
public class method implements IMXMLSupport
{
    private var _name:String = "";
    private var _showBusyCursor:Boolean = false;
    private var _arguments:Array;

    public function method()
    {
        _arguments = [];
    }

    /**
     *  Defines the method name that you want to call on the service class.
     *
     *  @default empty string
     */
    public function get name():String
    {
        return _name;
    }

    /**
     *  @private
     */
    public function set name( value:String ):void
    {
        _name = value;
    }

    public function get concurrency():String
    {
        return null;
    }

    public function set concurrency(value:String):void
    {
    }

    public function get showBusyCursor():Boolean
    {
        return _showBusyCursor;
    }

    public function set showBusyCursor(value:Boolean):void
    {
        _showBusyCursor = value;
    }

    public function get arguments():Array
    {
        return _arguments.slice(0);
    }

    public function set arguments( value:Array ):void
    {
        _arguments = value.slice(0);
    }
}
}