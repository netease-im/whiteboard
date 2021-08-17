package com.netease.whiteboardandroiddemo.whiteboard;

import android.app.Activity;
import android.webkit.WebView;

public interface WhiteboardContractView {
    /**
     * 获取AppKey
     */
    String getAppKey();

    /**
     * 获取AppSecret
     */
    String getAppSecret();

    /**
     * 获取通道，即房间号
     */
    String getChannel();

    /**
     * 获取UID
     */
    String getUid();

    /**
     * 获取展示白板用的{@link WebView}
     */
    WebView getWhiteboardView();

    /**
     * 关闭页面
     * @see Activity#finish()
     */
    void finish();
}
