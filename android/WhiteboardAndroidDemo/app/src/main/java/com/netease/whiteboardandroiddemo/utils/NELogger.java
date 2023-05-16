package com.netease.whiteboardandroiddemo.utils;

import com.elvishew.xlog.LogConfiguration;
import com.elvishew.xlog.LogLevel;
import com.elvishew.xlog.XLog;
import com.elvishew.xlog.XLog.Log;
import com.elvishew.xlog.flattener.PatternFlattener;
import com.elvishew.xlog.printer.Printer;
import com.elvishew.xlog.printer.file.FilePrinter;
import com.elvishew.xlog.printer.file.clean.FileLastModifiedCleanStrategy;

public class NELogger {
    private static long kMilliSecondsPerDay = 24 * 3600 * 1000;
    private static String webLogTag = "WhiteboardJsInterface";

    public static void init(String logPath, int maxDaysLogFileBackup) {
        LogConfiguration config = new LogConfiguration.Builder()
            .logLevel(LogLevel.ALL)
            .tag(webLogTag)
            .build();

        Printer filePrinter = new FilePrinter
            .Builder(logPath)
            .fileNameGenerator(new NEFileNameGenerator("ne_whiteboard_", ".log"))
            .cleanStrategy(new FileLastModifiedCleanStrategy(maxDaysLogFileBackup * kMilliSecondsPerDay))
            .flattener(new PatternFlattener("{d} {l}/{t}: {m}"))
            .build();

        XLog.init(config, filePrinter);
    }

    public static void v(String tag, String msg) {
        Log.i(tag, msg);
    }

    public static void d(String tag, String msg) {
        Log.i(tag, msg);
    }

    public static void i(String tag, String msg) {
        Log.i(tag, msg);
    }

    public static void w(String tag, String msg) {
        Log.i(tag, msg);
    }

    public static void e(String tag, String msg) {
        Log.i(tag, msg);
    }
}
