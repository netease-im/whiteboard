package com.netease.whiteboardandroiddemo.http;

public class WsSecretResult {
    private int code;
    private Data data;
    private String requestId;
    private String costTime;

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public Data getData() {
        return data;
    }

    public void setData(Data data) {
        this.data = data;
    }

    public String getRequestId() {
        return requestId;
    }

    public void setRequestId(String requestId) {
        this.requestId = requestId;
    }

    public String getCostTime() {
        return costTime;
    }

    public void setCostTime(String costTime) {
        this.costTime = costTime;
    }

    public static class Data {
        private String wsSecret;

        public String getWsSecret() {
            return wsSecret;
        }

        public void setWsSecret(String wsSecret) {
            this.wsSecret = wsSecret;
        }
    }
}
