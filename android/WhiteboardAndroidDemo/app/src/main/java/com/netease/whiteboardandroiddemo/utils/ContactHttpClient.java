package com.netease.whiteboardandroiddemo.utils;

import android.util.Log;

import com.netease.nimlib.sdk.auth.LoginInfo;
import com.netease.whiteboardandroiddemo.Constant;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.util.UUID;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.FormBody;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import okhttp3.ResponseBody;

/**
 * 通讯录数据获取协议的实现
 * <p/>
 * Created by huangjun on 2015/3/6.
 */
public class ContactHttpClient {
    private static final String TAG = "ContactHttpClient";

    // code
    private static final int RESULT_CODE_SUCCESS = 200;
    private static final int RESULT_CODE_INVALID = 1000;

    // header
    private static final String HEADER_KEY_APP_KEY = "appkey";
    private static final String HEADER_CONTENT_TYPE = "Content-Type";
    private static final String HEADER_USER_AGENT = "User-Agent";

    // request
    private static final String REQUEST_USER_NAME = "username";
    private static final String REQUEST_NICK_NAME = "nickname";
    private static final String REQUEST_PASSWORD = "password";

    // result
    private static final String RESULT_KEY_RES = "res";
    private static final String RESULT_KEY_ERROR_MSG = "errmsg";


    public interface ContactHttpCallback<T> {
        void onSuccess(T t);

        void onFailed(int code, String errorMsg);
    }

    private static ContactHttpClient instance;

    public static synchronized ContactHttpClient getInstance() {
        if (instance == null) {
            instance = new ContactHttpClient();
        }

        return instance;
    }

    private ContactHttpClient() {
    }


    /**
     * 向应用服务器创建账号（注册账号）
     * 由应用服务器调用WEB SDK接口将新注册的用户数据同步到云信服务器
     */
    public void register(final ContactHttpCallback<LoginInfo> callback) {
        String url = Constant.API_SERVER;
        String uuid = UUID.randomUUID().toString().toLowerCase();
        String account = uuid.replace("-", "").substring(0, 20);
        String nick = account.substring(0, 10);

        OkHttpClient client = new OkHttpClient();
        Request.Builder builder = new Request.Builder();
        builder.addHeader(HEADER_CONTENT_TYPE, "application/x-www-form-urlencoded; charset=utf-8");
        builder.addHeader(HEADER_USER_AGENT, "nim_demo_android");
        builder.addHeader(HEADER_KEY_APP_KEY, Constant.APP_KEY);

        RequestBody body = new FormBody.Builder()
                .add(REQUEST_USER_NAME, account)
                .add(REQUEST_NICK_NAME, nick)
                .add(REQUEST_PASSWORD, Constant.TOKEN)
                .build();

        Request request = builder.url(url).post(body).build();
        client.newCall(request).enqueue(new Callback() {
            @Override
            public void onFailure(Call call, IOException e) {
                String errMsg = e != null ? e.getMessage() : "null";
                Log.e(TAG, "register failed : , errorMsg = " + errMsg);
                if (callback != null) {
                    callback.onFailed(RESULT_CODE_INVALID, errMsg);
                }
            }

            @Override
            public void onResponse(Call call, Response response) {
                if (response == null) {
                    if (callback != null) {
                        callback.onFailed(RESULT_CODE_INVALID, "empty response");
                    }
                    return;
                }
                int httpCode = response.code();
                if (httpCode != RESULT_CODE_SUCCESS) {
                    if (callback != null) {
                        callback.onFailed(httpCode, response.message());
                        return;
                    }
                }
                ResponseBody body = response.body();
                try {
                    JSONObject resObj = new JSONObject(body.string());
                    int resCode = resObj.optInt(RESULT_KEY_RES);
                    if (resCode == RESULT_CODE_SUCCESS) {
                        callback.onSuccess(new LoginInfo(account, Constant.TOKEN));
                    } else {
                        String error = resObj.optString(RESULT_KEY_ERROR_MSG);
                        callback.onFailed(resCode, error);
                    }
                    return;
                } catch (JSONException | IOException e) {
                    e.printStackTrace();
                }
                callback.onSuccess(new LoginInfo(account, Constant.TOKEN));
            }
        });
    }
}
