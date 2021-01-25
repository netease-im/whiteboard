package com.netease.whiteboardandroiddemo.whiteboard;

import android.app.Activity;
import android.webkit.WebView;

import com.netease.nimlib.sdk.chatroom.model.ChatRoomKickOutEvent;
import com.netease.nimlib.sdk.chatroom.model.ChatRoomMessage;

import java.util.List;

public interface WhiteboardContractView {
    /**
     * 获取通道，即房间号
     */
    String getChannel();

    /**
     * 获取当前账号
     */
    String getAccount();

    /**
     * 获取房间创建者
     */
    String getOwnerAccount();

    /**
     * 获取展示白板用的{@link WebView}
     */
    WebView getWhiteboardView();

    /**
     * 关闭页面
     * @see Activity#finish()
     */
    void finish();

    /**
     * 被踢后
     * @param event 被踢信息
     */
    void onKickOut(ChatRoomKickOutEvent event);

    /**
     * 收到消息后
     * @param messageList 收到的消息列表
     */
    void onReceiveMessage(List<ChatRoomMessage> messageList);
}
