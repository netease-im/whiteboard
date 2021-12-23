package com.netease.whiteboardandroiddemo;

import android.app.Application;

import com.netease.whiteboardandroiddemo.utils.NELogger;

import java.io.File;

public class App extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        String webLogPath = getExternalFilesDir(null).getAbsolutePath() + File.separator + "weblog";
        NELogger.init(webLogPath, 7);
    }
}
