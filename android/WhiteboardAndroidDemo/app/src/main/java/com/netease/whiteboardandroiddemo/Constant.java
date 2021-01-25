package com.netease.whiteboardandroiddemo;

public class Constant {
    /** 这里替换成你自己的AppKey */
    public static final String APP_KEY = "Your App Key";
    public static final String TOKEN = "e10adc3949ba59abbe56e057f20f883e";
    /** 这里替换成你自己的白板地址 */
    public static final String LOAD_URL = "Your Load Url of Whiteboard";
    /** 这里替换成你自己的应用服务器地址，用于注册IM*/
    public static final String API_SERVER = "Your Api Server";

    public static final String EXTRA_ROOM_ID = "extra_room_id";
    public static final String EXTRA_ACCOUNT = "extra_account";
    public static final String EXTRA_OWNER_ACCOUNT = "extra_owner_account";

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
