#include "nem_chatroom_manager.h"
#include <QJsonDocument>
#include <QJsonObject>
#include "chatroom/nim_chatroom_cpp.h"
#include "http/nem_http_api.h"
#include "nem_login_manager.h"
#include "nim_cpp_plugin_in.h"

using namespace nim_chatroom;

bool NEMChatroomManager::init() {
    if (!nim_chatroom::ChatRoom::Init("")) {
        return false;
    }

    qInfo() << "NEMChatroomManager::init success";

    nim_chatroom::ChatRoom::RegReceiveMsgCb([](int64_t room_id, const ChatRoomMessage& result) {

    });

    nim_chatroom::ChatRoom::RegReceiveMsgsCb([](int64_t room_id, const std::list<ChatRoomMessage>& result) {

    });

    nim_chatroom::ChatRoom::RegSendMsgAckCb([](int64_t room_id, int error_code, const ChatRoomMessage& result) {

    });

    nim_chatroom::ChatRoom::RegEnterCb(
        [this](int64_t room_id, const NIMChatRoomEnterStep step, int error_code, const ChatRoomInfo& info, const ChatRoomMemberInfo& my_info) {
            qInfo() << "RegEnterCb";
            qInfo() << "room_id" << room_id;
            qInfo() << "info.creator_id_" << QString::fromStdString(info.creator_id_);

            if (step != kNIMChatRoomEnterStepRoomAuthOver)
                return;

            m_creator = QString::fromStdString(info.creator_id_);

            emit enterRoomFinished();
        });

    nim_chatroom::ChatRoom::RegExitCb([this](int64_t room_id, int error_code, NIMChatRoomExitReason exit_reason) {
        qInfo() << "RegExitCb";
        qInfo() << "exit_reason" << exit_reason;

        if (exit_reason == kNIMChatRoomExitReasonKickByMultiSpot) {
            emit kickByMultiSpot();
            qInfo() << "kNIMChatRoomExitReasonKickByMultiSpot";
        } else if (exit_reason == kNIMChatRoomExitReasonRoomInvalid) {
            qInfo() << "kNIMChatRoomExitReasonRoomInvalid";
            emit chatRoomFinished();
        } else if (exit_reason == kNIMChatRoomExitReasonKickByManager) {
            qInfo() << "kNIMChatRoomExitReasonKickByManager";
            emit kickByManager();
        } else {
            emit exitRoom();
        }
    });

    nim_chatroom::ChatRoom::RegNotificationCb([](int64_t room_id, const ChatRoomNotification& notification) {
        qInfo() << "RegNotificationCb";
        qInfo() << notification.id_;
    });

    nim_chatroom::ChatRoom::RegLinkConditionCb([](int64_t room_id, const NIMChatRoomLinkCondition condition) {

    });

    return true;
}

void NEMChatroomManager::release() {
    qInfo() << "NEMChatroomManager::release";
    // nim_chatroom::ChatRoom::Cleanup();
}

void NEMChatroomManager::createChatroom(const QString& creator, const QString& name) {
    QJsonObject extObj;
    extObj["showType"] = 1;
    extObj["fullScreenType"] = 0;
    extObj["shareID"] = "";
    QString ext = QJsonDocument(extObj).toJson(QJsonDocument::Compact);

    m_creator = creator;
    m_roomName = name;

    NEMRequest* request = NEMHttpApi::createChatroom(creator, name, ext, app_key);
    connect(request, &NEMRequest::onSuccess, [=](const QString& response) {
        qInfo() << "createRoomSuccess";
        QJsonDocument doc = QJsonDocument::fromJson(response.toUtf8());
        QJsonObject data = doc.object();
        loginChatroom(QString::number(data["msg"].toVariant().toLongLong()));
    });

    connect(request, &NEMRequest::onFail, [this](int errType, int errCode, const QString& err) {
        qInfo() << "createRoomFailed";
        m_creator.clear();
        emit createRoomFailed(err);
    });
}

void NEMChatroomManager::closeChatroom() {
    NEMRequest* request = NEMHttpApi::closeChatroom(QString::number(m_roomid), m_creator, app_key);
    connect(request, &NEMRequest::onSuccess, [](const QString& response) { qInfo() << "close room success"; });
}

void NEMChatroomManager::loginChatroom(const QString& strRoomid) {
    m_roomid = strRoomid.toLongLong();

    qInfo() << "loginChatroom m_roomid：" << m_roomid;

    nim::PluginIn::ChatRoomRequestEnterAsync(m_roomid, [this](int error_code, const std::string& result) {
        qInfo() << "ChatRoomRequestEnterAsync" << QString::fromStdString(result) << "error_code: " << error_code;
        if (error_code != nim::kNIMResSuccess) {
            QString strErr = "加入房间失败";
            if (error_code == 404) {
                strErr += ", 房间号不存在";
            }

            emit joinRoomFailed(strErr);
            return;
        }

        if (!result.empty()) {
            ChatRoom::Enter(m_roomid, result);
        }
    });
}

void NEMChatroomManager::logoutChatroom() {
    ChatRoom::Exit(m_roomid);
}

QString NEMChatroomManager::getCreator() const {
    return m_creator;
}

QString NEMChatroomManager::getRoomid() const {
    return QString::number(m_roomid);
}

NEMChatroomManager::NEMChatroomManager() {}

NEMChatroomManager::~NEMChatroomManager() {}
