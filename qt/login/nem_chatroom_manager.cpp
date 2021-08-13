#include <QDateTime>
#include "nem_chatroom_manager.h"
#include "sha1.h"

bool NEMChatroomManager::init() {
    m_settings = new QSettings("login.ini", QSettings::IniFormat);
    m_nonce = "123456";
    return true;
}

void NEMChatroomManager::logoutChatroom() {
    emit exitRoom();
}

QString NEMChatroomManager::getRoomid() const {
    return QString::number(m_roomid);
}

void NEMChatroomManager::setLoginChatroomInfo(const QString& name,
                                              const QString& wsUrl,
                                              const QString& uid,
                                              const QString& appsecret,
                                              const QString& staticUrl2)
{
    m_roomName = name;
    m_roomid = name.toLongLong();
    m_wsUrl = wsUrl;
    m_uid = uid;
    m_appsecret = appsecret;
    m_staticUrl2 = staticUrl2;

    emit enterRoomFinished();
}

QString NEMChatroomManager::getWhiteboardUrl() const
{
    if(0 != m_staticUrl2.length()){
        return m_staticUrl2;
    }
    else {
        return m_wsUrl;
    }
}

QString NEMChatroomManager::getWsUrl() const
{
    return m_wsUrl;
}

QString NEMChatroomManager::getStaticUrl2() const
{
    return m_staticUrl2;
}

QString NEMChatroomManager::getNonce() const
{
    return m_nonce;
}

QString NEMChatroomManager::getCurTime() const
{
    return m_curTime;
}

QString NEMChatroomManager::getCheckSum() const
{
    return m_checksum;
}

void NEMChatroomManager::setCheckSum()
{
    QDateTime time = QDateTime::currentDateTime();   //获取当前时间
    int timeT = time.toTime_t();   //将当前时间转为时间戳
    m_curTime = QString::number(timeT);
    QString qstr = m_appsecret + m_nonce + m_curTime;
    std::string str = qstr.toStdString();
    char buffer[41];
    memset(buffer, 0, 41 * sizeof (char));
    SHA1 sha1;
    sha1.SHA_GO(str.c_str(), buffer);
    m_checksum = QString(buffer);
}

QString NEMChatroomManager::getDefaultRoom() const
{
    return m_settings->value("roomID").toString();
}

QString NEMChatroomManager::getDefaultAppkey() const
{
    return m_settings->value("appkey").toString();
}

QString NEMChatroomManager::getDefaultWsUrl() const
{
    return m_settings->value("wsUrl").toString();
}

QString NEMChatroomManager::getDefaultUid() const
{
    return m_settings->value("G2.uid").toString();
}

QString NEMChatroomManager::getDefaultAppsecret() const
{
    return m_settings->value("G2.appsecret").toString();
}
QString NEMChatroomManager::getDefaultStaticUrl2() const
{
    return m_settings->value("G2.staticUrl").toString();
}

void NEMChatroomManager::setDefaultSettings(const QString &roomID,
                                            const QString &appkey,
                                            const QString &wsUrl,
                                            const QString& uid,
                                            const QString& appsecret,
                                            const QString& staticUrl2) const
{
    m_settings->setValue("roomID", roomID);
    m_settings->setValue("appkey", appkey);
    m_settings->setValue("wsUrl", wsUrl);
    m_settings->setValue("G2.uid", uid);
    m_settings->setValue("G2.appsecret", appsecret);
    m_settings->setValue("G2.staticUrl", staticUrl2);
}


NEMChatroomManager::NEMChatroomManager() {}

NEMChatroomManager::~NEMChatroomManager() {}
