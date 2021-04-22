#include "nem_http_api.h"
#include "nem_http_manager.h"

NEMRequest* NEMHttpApi::createChatroom(const QString& creator, const QString& name, const QString& ext, const QString& appKey) {
    QMap<QString, QString> payloadParamMap;
    payloadParamMap["creator"] = creator;
    payloadParamMap["name"] = name;
    payloadParamMap["ext"] = ext;

    QMap<QString, QString> headerParamMap;
    headerParamMap["appKey"] = appKey;

    return NEMHttpManager::instance().post("https://app.netease.im/api/chatroom/create", headerParamMap, payloadParamMap, 10000);
}

NEMRequest* NEMHttpApi::closeChatroom(const QString& roomid, const QString& uid, const QString& appKey) {
    QMap<QString, QString> payloadParamMap;
    payloadParamMap["roomid"] = roomid;
    payloadParamMap["uid"] = uid;

    QMap<QString, QString> headerParamMap;
    headerParamMap["appKey"] = appKey;

    return NEMHttpManager::instance().post("https://app.netease.im/api/chatroom/close", headerParamMap, payloadParamMap, 10000);
}

NEMRequest* NEMHttpApi::registerAccount(const QString& userName, const QString& nickName, const QString& password, const QString& appKey) {
    QMap<QString, QString> payloadParamMap;
    payloadParamMap["username"] = userName;
    payloadParamMap["nickname"] = nickName;
    payloadParamMap["password"] = password;

    QMap<QString, QString> headerParamMap;
    headerParamMap["charset"] = "utf-8";
    headerParamMap["appkey"] = appKey;
    headerParamMap["User-Agent"] = "nim_demo_pc";

    return NEMHttpManager::instance().post("https://app.netease.im/api/createDemoUser", headerParamMap, payloadParamMap, false, 10000);
}
