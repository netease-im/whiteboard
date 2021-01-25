#ifndef NEMHTTPAPI_H
#define NEMHTTPAPI_H

#include "nem_http_manager.h"

class NEMHttpApi {
public:
    static NEMRequest* createChatroom(const QString& creator, const QString& roomid, const QString& ext, const QString& appKey);

    static NEMRequest* closeChatroom(const QString& roomid, const QString& uid, const QString& appKey);

    static NEMRequest* registerAccount(const QString& userName, const QString& nickName, const QString& password, const QString& appKey);
};

#endif  // NEMHTTPAPI_H
