package com.netease.whiteboardandroiddemo.main;

import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.netease.whiteboardandroiddemo.Constant;
import com.netease.whiteboardandroiddemo.R;
import com.netease.whiteboardandroiddemo.whiteboard.WhiteboardActivity;

import java.util.Random;

public class MainActivity extends AppCompatActivity {
    private long userId = -1;
    private EditText roomIdEt;
    private Button joinBtn;
    private ProgressBar loadingPb;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        userId = new Random().nextInt(100000000);
        initViews();
    }

    private void initViews() {
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

        Intent intent = new Intent(MainActivity.this, WhiteboardActivity.class);
        intent.putExtra(Constant.KEY_APP_KEY, Constant.APP_KEY);
        intent.putExtra(Constant.KEY_UID, userId + "");
        intent.putExtra(Constant.KEY_ROOM_ID, roomId);
        intent.putExtra(Constant.KEY_WEBVIEW_URL, Constant.WEBVIEW_URL);

        loadingPb.setVisibility(View.INVISIBLE);
        joinBtn.setClickable(true);
        MainActivity.this.startActivity(intent);
    }

    private String getRoomIdFromEt() {
        Editable roomIdEditable = roomIdEt.getText();
        return roomIdEditable == null ? "" : roomIdEditable.toString();
    }

    private void onJoinFailed(String reason) {
        runOnUiThread(()->{
            Toast.makeText(MainActivity.this, "进入房间失败" + (TextUtils.isEmpty(reason) ? "" : ": " + reason), Toast.LENGTH_SHORT).show();
            loadingPb.setVisibility(View.INVISIBLE);
            joinBtn.setClickable(true);
        });
    }
}