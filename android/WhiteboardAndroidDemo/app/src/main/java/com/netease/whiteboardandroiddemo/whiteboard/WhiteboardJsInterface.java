package com.netease.whiteboardandroiddemo.whiteboard;

import android.content.ContentResolver;
import android.content.Context;
import android.net.Uri;
import android.text.TextUtils;
import android.webkit.JavascriptInterface;
import android.webkit.MimeTypeMap;
import android.webkit.ValueCallback;
import android.webkit.WebView;

import androidx.annotation.Nullable;

import com.netease.whiteboardandroiddemo.Constant;
import com.netease.whiteboardandroiddemo.utils.NELogger;

import org.apache.commons.codec.binary.Hex;
import org.apache.commons.codec.digest.DigestUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.lang.ref.WeakReference;
import java.util.Random;
import java.util.UUID;

public class WhiteboardJsInterface {
    private static final String TAG = "WhiteboardJsInterface";
    private final WeakReference<WhiteboardContractView> contractReference;
    private ValueCallback<Uri[]> fileValueCallback;

    /** Instantiate the interface and set the context */
    public WhiteboardJsInterface(WhiteboardContractView contractView) {
        this.contractReference = new WeakReference<>(contractView);
    }

    /** Show a toast from the web page */
    @JavascriptInterface
    public void NativeFunction(String toast) {
        try {
            JSONObject obj = new JSONObject(toast);
            String action = obj.getString("action");
            JSONObject param = obj.getJSONObject("param");

            NELogger.i(TAG, String.format("called by js, toast=%s, obj=%s, param=%s", toast, obj, param));
            switch (action) {
                // Web页面已经准备好了
                case "webPageLoaded":
                    login();
                    break;
                case "webJoinWBSucceed":
                    enableDraw();
                    setBrushColor();
                    break;
                // 网络异常
                case "webJoinWBFailed":
                // 网络异常
                case "webCreateWBFailed":
                // 白板信令通道已断开
                case "webLeaveWB":
                // 网络异常
                case "webError":
                    onLogout();
                    break;
                case "webGetAuth":
                    sendAuthInfo();
                    break;
                // Js运行时报错
                case "webJsError":
                default:
                    break;
            }
        } catch (Throwable e) {
            e.printStackTrace();
            NELogger.e(TAG, "execute native function error");
        }
    }

    private void onLogout() {
        WhiteboardContractView contract = contractReference.get();
        if (contract == null) {
            return;
        }
        contract.finish();
    }

    private void login() throws JSONException {
        NELogger.i(TAG, "login");

        WhiteboardContractView contract = contractReference.get();
        if (contract == null) {
            return;
        }

        JSONObject jsParam = new JSONObject();
        JSONObject param = new JSONObject();
        JSONObject testParams = new JSONObject();

        jsParam.put("action", "jsJoinWB");
        jsParam.put("param", param);
        param.put("uid", Integer.parseInt(contract.getUid()));
        param.put("channelName", contract.getChannel());
        param.put("record", true);
        param.put("debug", true);
        param.put("platform", "android");
        param.put("appKey", contract.getAppKey());

        testParams.put("isDemo", true);
        param.put("testParams", testParams);

        runJs((jsParam.toString()));
    }

    public void logout() {
        NELogger.i(TAG, "logout");
        WhiteboardContractView contract = contractReference.get();
        if (contract == null) {
            return;
        }
        JSONObject jsParam = new JSONObject();
        JSONObject param = new JSONObject();
        try {
            jsParam.put("action", "jsLeaveWB");
            jsParam.put("param", param);
            runJs((jsParam.toString()));
        } catch (JSONException e) {
            NELogger.e(TAG, "failed to send logout to js");
        }
    }

    private void enableDraw() throws JSONException {
        JSONObject jsParam = new JSONObject();
        JSONObject param = new JSONObject();
        JSONArray paramArr = new JSONArray();

        jsParam.put("action", "jsDirectCall");

        param.put("target", "drawPlugin");
        param.put("action", "enableDraw");
        paramArr.put(true);
        param.put("params", paramArr);
        jsParam.put("param", param);
        runJs((jsParam.toString()));
    }

    /**
     * samplecode仅作为展示使用。实际开发时，请不要将appsecret放置在客户端代码中，以防泄漏。
     * 客户端中放置appsecret是为了在客户不需要设置应用服务器时，即能够跑通白板的sample code。
     *
     * sample code中获取auth的流程如下：
     * 1. webview通过webGetAuth请求auth
     * 2. 客户端生成auth
     * 3. 客户端通过jsSendAuth返回auth
     *
     * 开发者应该创建应用服务器，将该流程改为：
     * 1. webview通过webGetAuth请求auth
     * 2. 客户端向应用服务器请求auth
     * 3. 应用服务器生成auth
     * 4. 应用服务器向客户端返回auth
     * 5. 客户端通过jsSendAuth返回auth
     */
    private void sendAuthInfo() throws JSONException, UnsupportedEncodingException {
        WhiteboardContractView contract = contractReference.get();
        if (contract == null) {
            return;
        }

        JSONObject jsParam = new JSONObject();
        JSONObject param = new JSONObject();
        long timestamp = System.currentTimeMillis() / 1000;
        String nonce = "8788";
        //String sha1Hex = DigestUtils.sha1Hex(contract.getAppSecret() + nonce + Long.toString(timestamp));
        String sha1Hex = new String(Hex.encodeHex(DigestUtils.sha1(contract.getAppSecret() + nonce + Long.toString(timestamp))));
        jsParam.put("action", "jsSendAuth");
        jsParam.put("param", param);
        param.put("code", 200);
        param.put("nonce", nonce);
        param.put("curTime", timestamp);
        param.put("checksum", sha1Hex);
        runJs((jsParam.toString()));
    }

    private void setBrushColor() throws JSONException {
        int randomInt = new Random().nextInt(Constant.BUSH_COLOR_ARRAY.length - 2);
        String colorStr = Constant.BUSH_COLOR_ARRAY[randomInt + 2];
        NELogger.i(TAG, String.format("set bush color %s with %s", colorStr, randomInt));
        JSONObject jsParam = new JSONObject();
        JSONObject param = new JSONObject();
        JSONArray paramArr = new JSONArray();

        jsParam.put("action", "jsDirectCall");

        param.put("target", "drawPlugin");
        param.put("action", "setColor");
        paramArr.put(colorStr);
        param.put("params", paramArr);
        jsParam.put("param", param);
        runJs((jsParam.toString()));
    }

    private void runJs(final String param) {
        WhiteboardContractView contract = contractReference.get();
        if (contract == null) {
            return;
        }
        WebView whiteboardView = contract.getWhiteboardView();
        final String escapedParam = param.replaceAll("\"", "\\\\\"");
        whiteboardView.post(() -> {
            NELogger.i("native function call js", "javascript:WebJSBridge(\"" + escapedParam + "\")");
            whiteboardView.loadUrl("javascript:WebJSBridge(\"" + escapedParam + "\")");
        });
    }

    public synchronized void transferFile(Uri uri) {
        if (fileValueCallback == null) {
            return;
        }

        fileValueCallback.onReceiveValue(uri == null ? null : new Uri[]{uri});
    }

    public synchronized void setFileValueCallback(ValueCallback<Uri[]> callback) {
        fileValueCallback = callback;
    }


    @Nullable
    public File getFileFromUri(final Uri uri, final Context context) {
        if(uri == null) {
            return null;
        }
        //android10以上转换
        if (ContentResolver.SCHEME_FILE.equals(uri.getScheme())) {
            return new File(uri.getPath());
        }
        if (!ContentResolver.SCHEME_CONTENT.equals(uri.getScheme())) {
            return null;
        }
        //把文件复制到沙盒目录
        ContentResolver contentResolver = context.getContentResolver();
        String displayName = UUID.randomUUID().toString() + System.currentTimeMillis()
                +"."+ MimeTypeMap.getSingleton().getExtensionFromMimeType(contentResolver.getType(uri));

        try {
            InputStream is = contentResolver.openInputStream(uri);
            File file = new File(context.getExternalCacheDir().getAbsolutePath(), displayName);
            FileOutputStream fos = new FileOutputStream(file);

            int bufferSize = 1024;
            byte[] byteBuffer = new byte[bufferSize];
            int size;
            do {
                size = is.read(byteBuffer);
                if (size == 0) {
                    break;
                }
                fos.write(byteBuffer, 0, size);
            }
            while (size >= bufferSize);
            fos.close();
            is.close();
            return file;
        } catch (Throwable e) {
            e.printStackTrace();
            return null;
        }
    }
}
