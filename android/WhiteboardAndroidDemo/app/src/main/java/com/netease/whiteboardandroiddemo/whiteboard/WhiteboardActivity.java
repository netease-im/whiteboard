package com.netease.whiteboardandroiddemo.whiteboard;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.net.http.SslError;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;
import android.text.TextUtils;
import android.util.Base64;
import android.util.Log;
import android.view.View;
import android.view.WindowManager;
import android.webkit.JsResult;
import android.webkit.SslErrorHandler;
import android.webkit.ValueCallback;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.netease.whiteboardandroiddemo.Constant;
import com.netease.whiteboardandroiddemo.R;
import com.netease.whiteboardandroiddemo.utils.HexDump;
import com.netease.whiteboardandroiddemo.utils.NELogger;

import java.io.File;
import java.io.FileOutputStream;
import java.util.UUID;

public class WhiteboardActivity extends AppCompatActivity implements WhiteboardContractView {
    private static final String TAG = "WhiteboardActivity";
    private WebView whiteboardWv;
    private String appKey;
    private String appSecret;
    private String roomId;
    private String uid;
    private String webViewUrl;

    private TextView copiedToastTv;
    private Handler mainHandler;
    private Handler bgHandler;
    private WhiteboardJsInterface jsInterface;

    private static final int REQUEST_CODE_FILE_BROWSER = 1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
        setContentView(R.layout.activity_whiteboard);
        jsInterface = new WhiteboardJsInterface(this);
        mainHandler = new Handler(Looper.getMainLooper());
        HandlerThread thread = new HandlerThread("bg");
        thread.start();
        bgHandler = new Handler(thread.getLooper());
        parseIntent();
        initViews();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        bgHandler.getLooper().quit();
    }

    private void parseIntent() {
        Intent intent = getIntent();
        appKey = intent.getStringExtra(Constant.KEY_APP_KEY);
        appSecret = intent.getStringExtra(Constant.KEY_APP_SECRET);
        uid = intent.getStringExtra(Constant.KEY_UID);
        roomId = intent.getStringExtra(Constant.KEY_ROOM_ID);
        webViewUrl = intent.getStringExtra(Constant.KEY_WEBVIEW_URL);

        if (TextUtils.isEmpty(webViewUrl)) {
            NELogger.e(TAG, "webViewUrl is null");
        }
    }

    private void initViews() {
        copiedToastTv = findViewById(R.id.tv_copied_toast);
        whiteboardWv = findViewById(R.id.wv_whiteboard);
        // Android 5.0 WebView渲染硬件加速存在兼容性问题
        if (Build.VERSION.SDK_INT <= Build.VERSION_CODES.LOLLIPOP) {
            whiteboardWv.setLayerType(View.LAYER_TYPE_SOFTWARE, null);
        }

        ((TextView) findViewById(R.id.tv_room_id)).setText(String.format(getString(R.string.room_id_is_has_s), roomId));
        findViewById(R.id.ib_copy_room_id).setOnClickListener(v -> copyRoomId());
        findViewById(R.id.tv_exit_room).setOnClickListener(v -> {
            jsInterface.logout();
            WhiteboardActivity.this.finish();
        });

        // 白板内容
        WebSettings settings = whiteboardWv.getSettings();
        if (settings != null) {
            settings.setJavaScriptEnabled(true);
        }

        whiteboardWv.setWebChromeClient(new WebChromeClient() {
            @Override
            public boolean onJsAlert(WebView view, String url, String message, final JsResult result) {
                Log.i(TAG, "onJsAlert");
                AlertDialog.Builder builder = new AlertDialog.Builder(WhiteboardActivity.this);
                builder.setTitle("Alert");
                builder.setMessage(message);
                builder.setPositiveButton(android.R.string.ok, (dialog, which) -> result.confirm());
                builder.setCancelable(false);
                builder.create().show();
                return true;
            }

            @Override
            public boolean onShowFileChooser(WebView webView, ValueCallback<Uri[]> filePathCallback, FileChooserParams fileChooserParams) {
                Log.i(TAG, "onShowFileChooser");
                try {
                    jsInterface.setFileValueCallback(filePathCallback);
                    Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
                    intent.setType("*/*");
                    intent.addCategory(Intent.CATEGORY_OPENABLE);
                    startActivityForResult(intent, REQUEST_CODE_FILE_BROWSER);
                    return true;
                } catch (Throwable e) {
                    return false;
                }
            }
        });

        whiteboardWv.setWebViewClient(new WebViewClient() {
            @Override
            public void onReceivedSslError(WebView view, SslErrorHandler handler, SslError error) {
                handler.proceed();
            }
        });

        whiteboardWv.setDownloadListener((url, userAgent, contentDisposition, mimeType, contentLength) -> {
            String key = "base64,";
            int keyIndex = url.indexOf(key);
            String dataBase64Str = keyIndex < 0 ? url : url.substring(keyIndex + key.length());
            if (TextUtils.isEmpty(dataBase64Str)) {
                Log.e(TAG, "empty file");
                return;
            }
            byte[] dataOriginBytes = Base64.decode(dataBase64Str, Base64.DEFAULT);
            bgHandler.post(() -> Log.i(TAG, "dataOriginBytes=" + (dataOriginBytes == null ? "null" : HexDump.toHex(dataOriginBytes))));
            File local = new File(getExternalFilesDir(Environment.DIRECTORY_DOWNLOADS), UUID.randomUUID().toString());
            try {
                if (!local.exists() && !local.createNewFile()) {
                    Log.i(TAG, "path error, exist: " + local.exists());
                    return;
                }
                FileOutputStream outputStream = new FileOutputStream(local, false);
                outputStream.write(dataOriginBytes);
                outputStream.close();
                Toast.makeText(this, "已下载到 " + local.getAbsolutePath(), Toast.LENGTH_LONG).show();
                Log.i(TAG, "download complete, path is " + local.getAbsolutePath());
            } catch (Throwable e) {
                Toast.makeText(this, "下载异常 " + local.getAbsolutePath(), Toast.LENGTH_SHORT).show();
                e.printStackTrace();
            }
        });

        whiteboardWv.addJavascriptInterface(jsInterface, "jsBridge");
        whiteboardWv.loadUrl(webViewUrl);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case REQUEST_CODE_FILE_BROWSER:
                onGetChosenFile(resultCode, data);
                break;
            default:
                break;
        }

    }

    private void onGetChosenFile(int resultCode, Intent data) {
        if (resultCode != Activity.RESULT_OK || data == null) {
            jsInterface.transferFile(null);
            return;
        }
        Uri uri = data.getData();
        jsInterface.transferFile(uri);
    }

    private void copyRoomId() {
        ClipboardManager cm = (ClipboardManager) getSystemService(Context.CLIPBOARD_SERVICE);
        if (cm == null) {
            Toast.makeText(getApplicationContext(), "复制失败", Toast.LENGTH_SHORT).show();
            return;
        }

        // 执行复制房间号
        ClipData mClipData = ClipData.newPlainText("roomId", roomId);
        cm.setPrimaryClip(mClipData);

        // 展示复制成功的提示
        copiedToastTv.setVisibility(View.VISIBLE);
        mainHandler.postDelayed(() -> copiedToastTv.setVisibility(View.GONE), 1000);
    }

    @Override
    public String getAppKey() {
        return appKey;
    }

    @Override
    public String getAppSecret() {
        return appSecret;
    }

    @Override
    public String getChannel() {
        return roomId;
    }

    @Override
    public String getUid() {
        return uid;
    }

    @Override
    public WebView getWhiteboardView() {
        return whiteboardWv;
    }

    @Override
    public void finish() {
        super.finish();
    }
}
