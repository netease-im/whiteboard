package com.netease.whiteboardandroiddemo;

public class Constant {
    public static final String APP_KEY = "YOUR_APPKEY";
    /**
     * samplecode仅作为展示使用。实际开发时，请不要将appsecret放置在客户端代码中，以防泄漏。
     * 客户端中放置appsecret是为了在客户不需要设置应用服务器时，即能够跑通白板的sample code。
     */
    public static final String WEBVIEW_URL = "https://app.yunxin.163.com/webdemo/whiteboard/webview.html";
    public static final String CHECKSUM_URL = "https://yiyong.netease.im/wb/getCheckSum";
    public static final String WS_SECRET_URL = "https://yiyong.netease.im/getWsSecret";

    public static final String KEY_APP_KEY = "app_key";
    public static final String KEY_UID = "uid";
    public static final String KEY_ROOM_ID = "room_id";
    public static final String KEY_WEBVIEW_URL = "webview_url";

    /**
     * 音视频转码模板ID
     */
    public static final int PRESET_ID; //请填写转码模板ID

    /** 白板刷的颜色，进入时随机选一个，第一个和第二个不能选 */
    public static final String[] BUSH_COLOR_ARRAY = new String[]{
            "rgb(0,0,0)",//黑
            "rgb(255,255,255)",//白
            "rgb(224,32,32)",
            "rgb(250,100,0)",
            "rgb(247,181,0)",
            "rgb(109,212,0)",
            "rgb(68,215,182)",
            "rgb(50,197,255)",
            "rgb(0,145,255)",
            "rgb(98,54,255)",
            "rgb(182,32,224)",
            "rgb(109,114,120)"
    };
}
