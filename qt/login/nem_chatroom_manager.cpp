#include "nem_chatroom_manager.h"

bool NEMChatroomManager::init() {
    m_settings = new QSettings("login.ini", QSettings::IniFormat);
    return true;
}

void NEMChatroomManager::logoutChatroom() {
    emit exitRoom();
}

QString NEMChatroomManager::getRoomid() const {
    return QString::number(m_roomid);
}

void NEMChatroomManager::setLoginChatroomInfo(const QString& name)
{
    m_roomName = name;
    m_roomid = name.toLongLong();

    emit enterRoomFinished();
}

QString NEMChatroomManager::getWhiteboardUrl() const
{
    return m_staticUrl2;
}

QString NEMChatroomManager::getDefaultRoom() const
{
    return m_settings->value("roomID").toString();
}

void NEMChatroomManager::setDefaultSettings(const QString &roomID) const
{
    m_settings->setValue("roomID", roomID);
}
NEMChatroomManager::NEMChatroomManager() {}

NEMChatroomManager::~NEMChatroomManager() {}
