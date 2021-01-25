package com.netease.whiteboardandroiddemo;

import android.app.Application;

import com.netease.nimlib.sdk.NIMClient;
import com.netease.nimlib.sdk.SDKOptions;

public class App extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        NIMClient.init(this, null, getSDKOptions());
    }

    private SDKOptions getSDKOptions() {
        SDKOptions options = new SDKOptions();
        options.appKey = Constant.APP_KEY;
        options.asyncInitSDK = false;
        return options;
    }
}
