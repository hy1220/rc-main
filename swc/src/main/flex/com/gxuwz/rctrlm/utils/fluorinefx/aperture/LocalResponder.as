package com.gxuwz.rctrlm.utils.fluorinefx.aperture
{
import mx.rpc.AsyncToken;

public dynamic class LocalResponder //extends Responder
{
    /**
     * 	@private
     */
    private var _asyncToken:AsyncToken;

    /**
     * 	@private
     */
    private var _resultFunction:Function;

    /**
     * 	@private
     */
    private var _faultFunction:Function;

    public function LocalResponder(methodName:String, result:Function, fault:Function=null)
    {
        _resultFunction = result;
        _faultFunction = fault;
        _asyncToken = new AsyncToken( null );
    }

    /**
     * 	Returns the reference to the AsyncToken for this Responder.
     */
    public function getAsyncToken():AsyncToken {
        return _asyncToken;
    }

    public function get result():Function
    {
        return _resultFunction;
    }

    public function get fault():Function
    {
        return _faultFunction;
    }
}
}