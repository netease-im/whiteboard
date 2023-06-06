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

import com.google.gson.Gson;
import com.netease.whiteboardandroiddemo.Constant;
import com.netease.whiteboardandroiddemo.http.AntiLeechInfoParams;
import com.netease.whiteboardandroiddemo.http.ChecksumResult;
import com.netease.whiteboardandroiddemo.http.WsSecretResult;
import com.netease.whiteboardandroiddemo.utils.NELogger;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.lang.ref.WeakReference;
import java.util.UUID;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

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
            String param = obj.getString("param");

            NELogger.i(TAG, String.format("called by js, toast=%s, obj=%s, param=%s", toast, obj, param));
            switch (action) {
                // Web页面已经准备好了
                case "webPageLoaded":
                    login();
                    break;
                case "webJoinWBSucceed":
                    enableDraw();
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
                case "webGetAntiLeechInfo":
                    sendAntiLeechInfo(param);
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
        JSONObject drawPluginParams = new JSONObject();

        jsParam.put("action", "jsJoinWB");
        jsParam.put("param", param);
        param.put("uid", Integer.parseInt(contract.getUid()));
        param.put("channelName", contract.getChannel());
        param.put("record", true);
        param.put("debug", true);
        param.put("platform", "android");
        param.put("appKey", contract.getAppKey());

        JSONObject appConfig = new JSONObject();
        appConfig.put("nosAntiLeech", true);
        appConfig.put("presetId", Constant.PRESET_ID);
        drawPluginParams.put("appConfig", appConfig);

        param.put("drawPluginParams", drawPluginParams);

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

        MediaType mediaType = MediaType.parse("application/json;charset=utf8");
        JSONObject body = new JSONObject();
        body.put("wbAppKey", contract.getAppKey());
        body.put("roomId", contract.getChannel());
        body.put("uid", contract.getUid());

        Request request = new Request.Builder()
                .url(Constant.CHECKSUM_URL)
                .post(RequestBody.create(mediaType, body.toString()))
                .build();

        OkHttpClient client = new OkHttpClient();
        client.newCall(request).enqueue(new Callback() {
            @Override
            public void onFailure(Call call, IOException e) {
                NELogger.e(TAG, "getCheckSum failed " + e);
            }

            @Override
            public void onResponse(Call call, Response response) throws IOException {
                String body = response.body().string();
                if (TextUtils.isEmpty(body) || response.code() != 200) {
                    NELogger.e(TAG, "getCheckSum failed: response not OK");
                    onGetCheckSumFailure(response.code());
                    return;
                }

                ChecksumResult result = new Gson().fromJson(body, ChecksumResult.class);
                if (result.getCode() != 200) {
                    NELogger.e(TAG, "getCheckSum failed: result code is " + result.getCode());
                    onGetCheckSumFailure(result.getCode());
                    return;
                }

                JSONObject jsParam = new JSONObject();
                JSONObject param = new JSONObject();
                try {
                    jsParam.put("action", "jsSendAuth");
                    jsParam.put("param", param);
                    param.put("code", result.getCode());
                    param.put("nonce", result.getData().getWbNonce());
                    param.put("curTime", result.getData().getWbCurtime());
                    param.put("checksum", result.getData().getWbCheckSum());
                    runJs((jsParam.toString()));
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        });
    }

    private void onGetCheckSumFailure(int code) {
        JSONObject jsParam = new JSONObject();
        JSONObject param = new JSONObject();
        try {
            jsParam.put("action", "jsSendAuth");
            jsParam.put("param", param);
            param.put("code", code);
            runJs((jsParam.toString()));
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    private void sendAntiLeechInfo(String args) throws JSONException, UnsupportedEncodingException {
        WhiteboardContractView contract = contractReference.get();
        if (contract == null) {
            return;
        }

        String curTime = System.currentTimeMillis() / 1000 + "";
        AntiLeechInfoParams antiLeechInfoParams = new Gson().fromJson(args, AntiLeechInfoParams.class);

        MediaType mediaType = MediaType.parse("application/json;charset=utf8");
        JSONObject body = new JSONObject();
        body.put("wbAppKey", contract.getAppKey());
        body.put("bucketName", antiLeechInfoParams.getProp().getBucket());
        body.put("objectKey", antiLeechInfoParams.getProp().getObject());
        body.put("wsTime", curTime);

        Request request = new Request.Builder()
                .url(Constant.WS_SECRET_URL)
                .post(RequestBody.create(mediaType, body.toString()))
                .build();

        OkHttpClient client = new OkHttpClient();
        client.newCall(request).enqueue(new Callback() {
            @Override
            public void onFailure(Call call, IOException e) {
                NELogger.e(TAG, "getWsSecret failed " + e);
            }

            @Override
            public void onResponse(Call call, Response response) throws IOException {
                String body = response.body().string();
                if (TextUtils.isEmpty(body) || response.code() != 200) {
                    NELogger.e(TAG, "getWsSecret failed response is not OK");
                    onGetWsSecretFailure(response.code(), body);
                    return;
                }

                WsSecretResult result = new Gson().fromJson(body, WsSecretResult.class);
                if (result.getCode() != 200) {
                    NELogger.e(TAG, "getWsSecret failed: result code is " + result.getCode());
                    onGetWsSecretFailure(result.getCode(), body);
                    return;
                }

                JSONObject jsParam = new JSONObject();
                JSONObject param = new JSONObject();

                try {
                    jsParam.put("action", "jsSendAntiLeechInfo");
                    jsParam.put("param", param);
                    param.put("code", result.getCode());
                    param.put("seqId", antiLeechInfoParams.getSeqId());

                    Uri uri = Uri.parse(antiLeechInfoParams.getUrl())
                            .buildUpon()
                            .appendQueryParameter("wsSecret", result.getData().getWsSecret())
                            .appendQueryParameter("wsTime", curTime)
                            .build();

                    param.put("url", uri.toString());
                    param.put("curTime", curTime);
                    runJs((jsParam.toString()));
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        });
    }

    private void onGetWsSecretFailure(int code, String msg) {
        JSONObject jsParam = new JSONObject();
        JSONObject param = new JSONObject();
        try {
            jsParam.put("action", "jsSendAntiLeechInfo");
            jsParam.put("param", param);
            param.put("code", code);
            param.put("message", msg);

            runJs((jsParam.toString()));
        } catch (JSONException e) {
            e.printStackTrace();
        }
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
