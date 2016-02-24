/**
 * Created by xjzx on 2015/7/26.
 */
package com.gxuwz.rctrlm.presenter {
import com.gxuwz.rctrlm.events.ConServerBarEvent;
import com.gxuwz.rctrlm.events.EventDispatcherFactory;
import com.gxuwz.rctrlm.model.Services;
import com.gxuwz.rctrlm.utils.SaveParameterUtils;

import com.gxuwz.rctrlm.views.conServerBar.ConServerBar;
import flash.events.NetStatusEvent;
import flash.net.NetConnection;
import flash.net.NetStream;

import spark.components.Alert;


public class ConServerBarPresenter {
    private var _view:ConServerBar;
    [Bindable]
    private var _netConnection:NetConnection;
    [Bindable]
    private var _netStream:NetStream;
    [Bindable]
    private var _remoteUser:String;

    public function ConServerBarPresenter(view:ConServerBar = null) {
        this._view = view;
        //各种请求状态的监听
        //监听
        EventDispatcherFactory.getEventDispatcher()
                .addEventListener(ConServerBarEvent.TRY_CONNECT_SERVER_EVENT,
                onConServEventHandler,false,0,true);
        EventDispatcherFactory.getEventDispatcher()
                .addEventListener(ConServerBarEvent.TRY_DISCONNECT_SERVER_EVENT,
                tryDisconnectHandler,false,0,true);
    }
    /**
     * 1.将输入的用户名存储到共享数据localSO中；
     * 2.创建一个 NetConnection 对象，并为将来连接到这个对象的对象创建一个Object对象及其方法。调用 connect() 方法以建立连接。
     * @param event
     *
     */
    protected function onConServEventHandler(event:ConServerBarEvent):void
    {
        trace("点击连接按钮事件处理中\n");
        //将新的userNameInput.text数据保存到共享变量localSO中
        SaveParameterUtils.saveUserNameUtils(event.data);
        trace(event.userName+"应该为用户名");
        trace(event.connectURL+"应该为连接地址");
        _netConnection=new NetConnection();
        _netConnection.client=new Services();
        _netConnection.addEventListener(NetStatusEvent.NET_STATUS, netConnectionStatusHandler);
        try{
            _netConnection.connect(event.connectURL,event.userName);
        }catch(e:Error) {
            trace("连接服务失败");
        }
    }

    private function netConnectionStatusHandler(e:NetStatusEvent):void{

        trace(e.info.code+"   Net Status");
        var netStatus:String=e.info.code as String;
        switch (netStatus){
            case "NetConnection.Connect.Success":
                //派发时间。同时把netConnection派发
                _netStream=new NetStream(_netConnection);
                var event:ConServerBarEvent =new ConServerBarEvent(ConServerBarEvent.CHANGE_STATUS_TO_CALL_READY);//尝试连连服务
                event.netConnection=_netConnection;
              //  event.netStream=_netStream;
                EventDispatcherFactory.getEventDispatcher().dispatchEvent(event);
                break;
            case "NetConnection.Connect.Closed":
                //派发事件
            case "NetConnection.Connect.Failed":
                //派发事件
                var evt:ConServerBarEvent =new ConServerBarEvent(ConServerBarEvent.CHANGE_STATUS_TO_TRY_CONNECT);//派发尝试监听
                evt.data=_netConnection;
                EventDispatcherFactory.getEventDispatcher().dispatchEvent(evt);
                break;
        }
    }
    private function tryDisconnectHandler(evt:ConServerBarEvent):void{

        try{
            _netConnection.close();
            _netConnection=null;
        }catch (e:Error){
            trace("关闭连接失败");
        }
    }

    public function commandTH(commandStr:String):void{
        Alert.show(commandStr+   " commandStr from expert  in ConServerBar");
        trace(commandStr+   " commandStr from expert  in ConServerBar");
    }
}
}
