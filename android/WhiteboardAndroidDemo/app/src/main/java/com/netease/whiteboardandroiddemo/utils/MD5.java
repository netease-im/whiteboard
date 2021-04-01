package com.netease.whiteboardandroiddemo.utils;

import android.content.Context;
import android.net.Uri;
import android.os.ParcelFileDescriptor;
import android.util.Log;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

public class MD5 {
    private static final String TAG = "MD5";
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

    public static String getStreamMD5(String filePath) {
        String hash = null;
        byte[] buffer = new byte[4096];
        BufferedInputStream in=null;
        try
        {
            MessageDigest md5 = MessageDigest.getInstance("MD5");
            in = new BufferedInputStream(new FileInputStream(filePath));
            int numRead = 0;
            while ((numRead = in.read(buffer)) > 0) {
                md5.update(buffer, 0, numRead);
            }
            in.close();
            hash = HexDump.toHex(md5.digest());
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (in != null) {
                try {
                    in.close();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
        }
        return hash;
    }

    public static String getUriMD5(Context context, Uri uri) {
        ParcelFileDescriptor fd = null;
        String hash = null;
        byte[] buffer = new byte[4096];
        FileInputStream inputStream = null;
        try {
            MessageDigest md5 = MessageDigest.getInstance("MD5");
            fd = context.getContentResolver().openFileDescriptor(uri, "r");
            if (fd == null) {
                return "";
            }
            inputStream = new FileInputStream(fd.getFileDescriptor());
            int numRead = 0;
            while ((numRead = inputStream.read(buffer)) > 0) {
                md5.update(buffer, 0, numRead);
            }
            inputStream.close();
            hash = HexDump.toHex(md5.digest());
        } catch (Exception e) {
            Log.e(TAG, "getStreamMD5 is error", e);
        } finally {
            try {
                if (inputStream != null) {
                    inputStream.close();
                }
                if (fd != null) {
                    fd.close();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return hash;
    }
}
