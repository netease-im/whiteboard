package com.netease.whiteboardandroiddemo.utils;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

public class MD5 {
    public static String getStringMD5(String value) {
        if (value == null || value.trim().length() < 1) {
            return null;
        }
        return getMD5(value.getBytes(StandardCharsets.UTF_8));
    }

    public static String getMD5(byte[] source) {
        try {
            MessageDigest md5 = MessageDigest.getInstance("MD5");
            return HexDump.toHex(md5.digest(source));
        } catch (Exception e) {
            throw new RuntimeException(e.getMessage(), e);
        }
    }
}
