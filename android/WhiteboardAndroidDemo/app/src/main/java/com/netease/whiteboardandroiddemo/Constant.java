package com.netease.whiteboardandroiddemo;

public class Constant {
    public static final String APP_KEY = "YOUR_APPKEY";
    /**
     * samplecode仅作为展示使用。实际开发时，请不要将appsecret放置在客户端代码中，以防泄漏。
     * 客户端中放置appsecret是为了在客户不需要设置应用服务器时，即能够跑通白板的sample code。
     */
    public static final String APP_SECRET = "YOUR_APPSECRET";
    /**
     * 下面的WEBVIEW_URL始终指向最新的SDK版本。
     * 为了保证您线上的应用不会由于版本升级失效，请到该地址：https://doc.yunxin.163.com/whiteboard/docs/DMzNDkxMDc?platform=web ，下载最新的webview静态资源，并通过您的静态服务器部署。
     */
    public static final String WEBVIEW_URL = "https://app.yunxin.163.com/webdemo/whiteboard/webview.html";

    public static final String KEY_APP_KEY = "app_key";
    public static final String KEY_APP_SECRET = "app_secret";
    public static final String KEY_UID = "uid";
    public static final String KEY_ROOM_ID = "room_id";
    public static final String KEY_WEBVIEW_URL = "webview_url";

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
