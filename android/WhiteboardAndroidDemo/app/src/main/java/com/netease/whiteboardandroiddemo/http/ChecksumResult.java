package com.netease.whiteboardandroiddemo.http;

public class ChecksumResult {
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
        private String wbAppKey;
        private String wbNonce;
        private long wbCurtime;
        private String wbCheckSum;

        public String getWbAppKey() {
            return wbAppKey;
        }

        public void setWbAppKey(String wbAppKey) {
            this.wbAppKey = wbAppKey;
        }

        public String getWbNonce() {
            return wbNonce;
        }

        public void setWbNonce(String wbNonce) {
            this.wbNonce = wbNonce;
        }

        public long getWbCurtime() {
            return wbCurtime;
        }

        public void setWbCurtime(long wbCurtime) {
            this.wbCurtime = wbCurtime;
        }

        public String getWbCheckSum() {
            return wbCheckSum;
        }

        public void setWbCheckSum(String wbCheckSum) {
            this.wbCheckSum = wbCheckSum;
        }
    }
}
