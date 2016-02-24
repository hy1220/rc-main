/**
 * Created by xjzx on 2015/7/26.
 */
package com.gxuwz.rctrlm.events {
import flash.events.Event;
import flash.net.NetConnection;
import flash.net.NetStream;

public class ConServerBarEvent extends Event {

    public static var TRY_CONNECT_SERVER_EVENT:String = "tryConnectServerEvent";//尝试连接服务
    public static var TRY_LOGIN_SERVER_EVENT:String = "tryLoginServerEvent";//尝试连接服务
    public static var CHANGE_STATUS_TO_CALL_READY:String = "changeStatusToCallReadyEvent";//监听呼叫
    public static var TRY_DISCONNECT_SERVER_EVENT:String="tryDisconnectServerEvent";//尝试断开连接
    public static var TRY_CALLUSER_EVENT:String="tryCallUserEvent";//尝试呼叫远程用户
    public static var TRY_CANCEL_CALLUSER_EVENT:String="tryCancelCallUserEvent";//尝试取消远程连接
    public static var CHANGE_STATUS_TO_TRY_CONNECT:String="changeStatusToTryConnect";//将状态改变为尝试连接状态
    public static var PLAY_VIDEO_EVENT:String="playVideoEvent";// 派发到播放模块
    public static var SEND_MESSAGE_TO_REMOTE_USER:String="sendMessageToRemoteUser";//发送信息
    public static var SHOW_MESSAGE_EVENT:String="showMessageEvent";
    public static var TRY_DISCONNECT_REMOTE_USER_EVENT:String="tryDisconnectRemoterUserEvent";
    public var data : *;

    public var userName:String;
    public var remoteUser:String;
    public var action:String;
    public var connectURL:String;

    public var netConnection:NetConnection;
    public var netStream:NetStream;
    public function ConServerBarEvent(type:String, bubbles : Boolean = true,
        cancelable : Boolean = false) {
        super (type,bubbles,cancelable);
    }
 }
}
