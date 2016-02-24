package com.gxuwz.rctrlm.utils.fluorinefx.aperture
{

import flash.desktop.Clipboard;
import flash.desktop.ClipboardTransferMode;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.events.StatusEvent;
import flash.net.LocalConnection;
import flash.utils.Proxy;
import flash.utils.flash_proxy;

import mx.core.IMXMLObject;
import mx.managers.CursorManager;
import mx.rpc.AsyncToken;
import mx.rpc.Fault;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.mxml.IMXMLSupport;
import mx.utils.ObjectUtil;

use namespace flash_proxy;

[Event(name="result", type="mx.rpc.events.ResultEvent")]
[Event(name="fault", type="mx.rpc.events.FaultEvent")]

dynamic public class LocalObject extends Proxy implements IMXMLObject, IMXMLSupport,IEventDispatcher
{
    private var _dispatcher:EventDispatcher;
    private var _showBusyCursor:Boolean = false;
    private static var _listener:LocalConnection;
    private var _emitter:LocalConnection;
    private var _document:Object;
    private var _id:String;
    private static var _methodsLookup:Object = new Object();
    private static var _methodResultLookup:Object = new Object();
    private static var _methodResponderLookup:Object = new Object();
    private static var _methods:Array = [];

    public function LocalObject()
    {
        _dispatcher = new EventDispatcher(this);
        _methods = [];
        _methodsLookup = new Object();
        _methodResultLookup = new Object();
        _methodResponderLookup = new Object();
    }
    public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
        _dispatcher.addEventListener(type, listener, useCapture, priority);
    }

    public function dispatchEvent(evt:Event):Boolean{
        return _dispatcher.dispatchEvent(evt);
    }

    public function hasEventListener(type:String):Boolean{
        return _dispatcher.hasEventListener(type);
    }

    public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
        _dispatcher.removeEventListener(type, listener, useCapture);
    }

    public function willTrigger(type:String):Boolean {
        return _dispatcher.willTrigger(type);
    }

    public function initialized(document:Object, id:String):void
    {
        _document = document;
        _id = id;
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

    public function get methods():Array
    {
        return _methods;
    }

    public function set methods( value:Array ):void
    {
        _methods = value;
    }

    /**
     *  @private
     */
    private var _source:String = "";

    /**
     *  Source
     *  @default empty string
     */
    public function get source():String
    {
        return _source;
    }

    /**
     *  @private
     */
    public function set source( value:String ):void
    {
        _source = value;
    }

    private function get emitter():LocalConnection
    {
        if( _emitter == null )
        {
            _methodResultLookup["onApEvent"] = onApEvent;
            _emitter = new LocalConnection();
            _emitter.addEventListener(StatusEvent.STATUS, statusHandler);
            if( _listener == null )
            {
                _listener = new LocalConnection();
                _listener.allowDomain("*");
                _listener.client = this;
                _listener.addEventListener(StatusEvent.STATUS, statusHandler);
                try
                {
                    _listener.connect("apHandler");
                }
                catch (error:ArgumentError)
                {
                    var faultEvent:FaultEvent = new FaultEvent( FaultEvent.FAULT,
                            false,
                            false,
                            new Fault( StatusEvent.STATUS, "Connection error", "The connection name is already being used by another swf." ) );
                    dispatchEvent( faultEvent );
                }
            }
        }
        return _listener;
    }

    private function statusHandler(event:StatusEvent):void
    {
        if( event.level == "error" ) {
            var faultEvent:FaultEvent = new FaultEvent( FaultEvent.FAULT,
                    false,
                    false,
                    new Fault( StatusEvent.STATUS, event.code, event.code ) );
            dispatchEvent( faultEvent );
            // remove Busy Cursor
            if( _showBusyCursor )
                CursorManager.removeBusyCursor();
        }
    }

    override flash_proxy function callProperty(methodName:*, ...args ):*
    {
        var respond:LocalResponder = new LocalResponder( methodName, setQueryResult, setQueryFault );

        var parameters:Array = args;

        var rm:Object = new Object();
        rm.source = source;
        rm.operation = methodName.toString();
        rm.args = args;
        emitter.send("apTarget", "apHandle", rm);

        // Set Busy Cursor
        if( _showBusyCursor )
            CursorManager.setBusyCursor();

        // Save a reference to the current responder
        _methodResponderLookup[ methodName ] = respond;
        return respond.getAsyncToken();
    }

    override flash_proxy function getProperty( name:* ):* {
        if( _methodResultLookup[ name ] != null )
            return _methodResultLookup[ name ];
    }

    override flash_proxy function setProperty(name:*, value:*):void {
        _methodResultLookup[ name ] = value;
    }

    override flash_proxy function getDescendants( name:* ):* {
    }

    private function onApEvent(obj:Object):void
    {
        if( _document != null )
            _document.callLater(_onApEvent, [obj]);
        else
            _onApEvent(obj);
    }

    private function _onApEvent(obj:Object):void
    {
        var methodName:String = obj.operation;
        if( obj.status == null )
        {
            var reflectionObject : Object = ObjectUtil.getClassInfo(obj);
            // Pull out the the properties defined on the class into an array
            var propsArray : Array = reflectionObject.properties;
            for(var i:Number = 0; i < propsArray.length; i ++ )
            {
                if( propsArray[i].localName == "result" )
                {
                    setQueryResult(methodName, obj.result);
                    return;
                }
                if( propsArray[i].localName == "oledata" )
                {
                    var tmp:Object = Clipboard.generalClipboard.getData(obj.oledata as String, ClipboardTransferMode.CLONE_ONLY);
                    Clipboard.generalClipboard.clearData(obj.oledata as String);
                    setQueryResult(methodName, tmp);
                    return;
                }
            }
            //if( obj.result != null )
            //	setQueryResult(methodName, obj.result);
        }
        else
        {
            setQueryFault(methodName, obj.status);
        }
    }

    /**
     * 	@private
     */
    private function setQueryResult( methodName:String, result:Object ):void
    {
        var respond:LocalResponder = _methodResponderLookup[ methodName ];
        var asyncToken:AsyncToken = respond.getAsyncToken();
        var resultEvent:ResultEvent = new ResultEvent( ResultEvent.RESULT,
                false,
                true,
                result,
                respond.getAsyncToken());
        if( asyncToken.hasResponder() )
        {
            for( var i:int = 0; i < asyncToken.responders.length; i++ )
                asyncToken.responders[ i ].result( resultEvent );
        }
        dispatchEventHandler( resultEvent, methodName );
        // remove Busy Cursor
        if( _showBusyCursor )
            CursorManager.removeBusyCursor();
    }

    private function setQueryFault( methodName:String, fault:Object ):void
    {
        var respond:LocalResponder = _methodResponderLookup[ methodName ];
        var asyncToken:AsyncToken = respond.getAsyncToken();
        var faultEvent:FaultEvent = new FaultEvent( FaultEvent.FAULT,
                false,
                false,
                new Fault( fault.faultCode, fault.faultString, fault.faultDetail ),
                respond.getAsyncToken());
        if( asyncToken.hasResponder() )
        {
            for( var i:int = 0; i < asyncToken.responders.length; i++ )
                asyncToken.responders[ i ].fault( faultEvent );
        }
        dispatchEventHandler( faultEvent, methodName );
        // remove Busy Cursor
        if( _showBusyCursor )
            CursorManager.removeBusyCursor();
    }

    private function dispatchEventHandler( event:Event, methodName:String ):void
    {
        // Main class event call
        dispatchEvent( event );

        // Method Lookup and Dispatch Event for specific Method
        var methodReference:method;
        for each( var curMethod:method in methods ) {
            if( curMethod.name == methodName ) {
                methodReference = curMethod;
                break;
            }
        }
        if( methodReference ) {
            methodReference.dispatchEvent( event );
        }
    }

}
}