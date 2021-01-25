package com.netease.whiteboardandroiddemo.main;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.Toast;

import com.netease.nimlib.sdk.NIMClient;
import com.netease.nimlib.sdk.RequestCallbackWrapper;
import com.netease.nimlib.sdk.ResponseCode;
import com.netease.nimlib.sdk.auth.AuthService;
import com.netease.nimlib.sdk.auth.LoginInfo;
import com.netease.nimlib.sdk.chatroom.ChatRoomService;
import com.netease.nimlib.sdk.chatroom.model.ChatRoomInfo;
import com.netease.nimlib.sdk.chatroom.model.EnterChatRoomData;
import com.netease.nimlib.sdk.chatroom.model.EnterChatRoomResultData;
import com.netease.whiteboardandroiddemo.Constant;
import com.netease.whiteboardandroiddemo.R;
import com.netease.whiteboardandroiddemo.utils.ContactHttpClient;
import com.netease.whiteboardandroiddemo.whiteboard.WhiteboardActivity;

public class MainActivity extends AppCompatActivity {
    private EditText roomIdEt;
    private Button joinBtn;
    private AuthService authService;
    private ChatRoomService chatRoomService;
    private ProgressBar loadingPb;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        initViews();
    }

    private void initViews() {
        authService = NIMClient.getService(AuthService.class);
        chatRoomService = NIMClient.getService(ChatRoomService.class);
        roomIdEt = findViewById(R.id.et_room_id);

        loadingPb = findViewById(R.id.pb_loading);
        loadingPb.setVisibility(View.INVISIBLE);

        joinBtn = findViewById(R.id.btn_join);
        joinBtn.setClickable(true);
        joinBtn.setOnClickListener(v -> {
            joinBtn.setClickable(false);
            loadingPb.setVisibility(View.VISIBLE);
            enterWhiteboard();
        });
    }

    private void enterWhiteboard() {
        final String roomId = getRoomIdFromEt();
        if (TextUtils.isEmpty(roomId)) {
            onJoinFailed("房间ID号码为空");
            return;
        }
        ContactHttpClient.getInstance().register(new ContactHttpClient.ContactHttpCallback<LoginInfo>() {
            @Override
            public void onSuccess(LoginInfo info) {
                loginIm(info, roomId);
            }

            @Override
            public void onFailed(int code, String errorMsg) {
                onJoinFailed(String.format("注册IM失败，code=%s, msg=%s", code, errorMsg));
            }
        });
    }

    private String getRoomIdFromEt() {
        Editable roomIdEditable = roomIdEt.getText();
        return roomIdEditable == null ? "" : roomIdEditable.toString();
    }

    private void loginIm(final LoginInfo loginInfo, final String roomId) {
        authService.login(loginInfo).setCallback(new RequestCallbackWrapper<LoginInfo>() {
            @Override
            public void onResult(int code, LoginInfo result, Throwable exception) {
                if (code != ResponseCode.RES_SUCCESS || result == null) {
                    onJoinFailed("登录IM失败，code=" + code);
                    return;
                }

                EnterChatRoomData enterData = new EnterChatRoomData(roomId);
                enterChatRoom(enterData, loginInfo.getAccount());
            }
        });
    }

    private void enterChatRoom(EnterChatRoomData enterData, String account) {
        chatRoomService.enterChatRoom(enterData).setCallback(new RequestCallbackWrapper<EnterChatRoomResultData>() {
            @Override
            public void onResult(int code, EnterChatRoomResultData result, Throwable exception) {
                if (code != ResponseCode.RES_SUCCESS || result == null) {
                    onJoinFailed("进入聊天室失败，code=" + code);
                    return;
                }
                ChatRoomInfo roomInfo = result.getRoomInfo();
                if (roomInfo == null) {
                    onJoinFailed("聊天室信息为空");
                    return;
                }
                String ownerAccount = roomInfo.getCreator();
                if (TextUtils.isEmpty(ownerAccount)) {
                    onJoinFailed("获取聊天室创建者失败");
                    return;
                }
                Intent intent = new Intent(MainActivity.this, WhiteboardActivity.class);
                intent.putExtra(Constant.EXTRA_ROOM_ID, enterData.getRoomId());
                intent.putExtra(Constant.EXTRA_ACCOUNT, account);
                intent.putExtra(Constant.EXTRA_OWNER_ACCOUNT, ownerAccount);
                loadingPb.setVisibility(View.INVISIBLE);
                joinBtn.setClickable(true);
                MainActivity.this.startActivity(intent);
            }
        });
    }

    private void onJoinFailed(String reason) {
        runOnUiThread(()->{
            Toast.makeText(MainActivity.this, "进入房间失败" + (TextUtils.isEmpty(reason) ? "" : ": " + reason), Toast.LENGTH_SHORT).show();
            loadingPb.setVisibility(View.INVISIBLE);
            joinBtn.setClickable(true);
        });
    }
}