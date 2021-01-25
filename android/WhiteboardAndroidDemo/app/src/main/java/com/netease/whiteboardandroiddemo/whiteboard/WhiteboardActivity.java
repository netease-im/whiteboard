package com.netease.whiteboardandroiddemo.whiteboard;

import androidx.appcompat.app.AppCompatActivity;

import android.app.AlertDialog;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.View;
import android.view.WindowManager;
import android.webkit.JsResult;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.widget.TextView;
import android.widget.Toast;

import com.netease.nimlib.sdk.NIMClient;
import com.netease.nimlib.sdk.chatroom.ChatRoomService;
import com.netease.nimlib.sdk.chatroom.model.ChatRoomKickOutEvent;
import com.netease.nimlib.sdk.chatroom.model.ChatRoomMessage;
import com.netease.whiteboardandroiddemo.Constant;
import com.netease.whiteboardandroiddemo.R;

import java.util.List;

public class WhiteboardActivity extends AppCompatActivity implements WhiteboardContractView {
    private WebView whiteboardWv;
    private String roomId;
    private String account;
    private String ownerAccount;

    private TextView copiedToastTv;
    private Handler mainHandler;
    private WhiteboardJsInterface jsInterface;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
        setContentView(R.layout.activity_whiteboard);
        jsInterface = new WhiteboardJsInterface(this);
        mainHandler = new Handler(Looper.getMainLooper());
        parseIntent();
        initViews();
        jsInterface.registerObservers(true);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        jsInterface.registerObservers(false);
        jsInterface.logout();
        NIMClient.getService(ChatRoomService.class).exitChatRoom(roomId);
    }

    private void parseIntent() {
        Intent intent = getIntent();
        roomId = intent.getStringExtra(Constant.EXTRA_ROOM_ID);
        account = intent.getStringExtra(Constant.EXTRA_ACCOUNT);
        ownerAccount = intent.getStringExtra(Constant.EXTRA_OWNER_ACCOUNT);
    }

    private void initViews() {
        copiedToastTv = findViewById(R.id.tv_copied_toast);

        ((TextView) findViewById(R.id.tv_room_id)).setText(String.format(getString(R.string.room_id_is_has_s), roomId));
        ((TextView) findViewById(R.id.tv_account)).setText(account);
        findViewById(R.id.ib_copy_room_id).setOnClickListener(v -> copyRoomId());
        findViewById(R.id.tv_exit_room).setOnClickListener(v -> WhiteboardActivity.this.finish());

        // 白板内容
        whiteboardWv = findViewById(R.id.wv_whiteboard);
        WebSettings settings = whiteboardWv.getSettings();
        if (settings != null) {
            settings.setJavaScriptEnabled(true);
        }

        whiteboardWv.setWebChromeClient(new WebChromeClient() {
            @Override
            public boolean onJsAlert(WebView view, String url, String message, final JsResult result) {
                AlertDialog.Builder builder = new AlertDialog.Builder(WhiteboardActivity.this);
                builder.setTitle("Alert");
                builder.setMessage(message);
                builder.setPositiveButton(android.R.string.ok, (dialog, which) -> result.confirm());
                builder.setCancelable(false);
                builder.create().show();
                return true;
            }
        });

        whiteboardWv.addJavascriptInterface(jsInterface, "jsBridge");
        whiteboardWv.loadUrl(Constant.LOAD_URL);
    }

    private void copyRoomId() {
        ClipboardManager cm = (ClipboardManager) getSystemService(Context.CLIPBOARD_SERVICE);
        if (cm == null) {
            Toast.makeText(this, "复制失败", Toast.LENGTH_SHORT).show();
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
    public String getChannel() {
        return roomId;
    }

    @Override
    public String getOwnerAccount() {
        return ownerAccount;
    }

    @Override
    public String getAccount() {
        return account;
    }

    @Override
    public WebView getWhiteboardView() {
        return whiteboardWv;
    }

    @Override
    public void finish() {
        super.finish();
    }

    @Override
    public void onKickOut(ChatRoomKickOutEvent event) {
        AlertDialog kickOutDialog = new AlertDialog.Builder(this)
                .setMessage(R.string.hint_room_invalid)
                .setPositiveButton(R.string.ok_with_blank, (dialog, which) -> {
                        finish();
                })
                .setCancelable(false)
                .create();
        kickOutDialog.show();
    }

    @Override
    public void onReceiveMessage(List<ChatRoomMessage> messageList) {
    }
}