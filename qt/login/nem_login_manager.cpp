#include <QRandomGenerator>
#include <QTimer>
#include <QDateTime>
#include "sha1.h"
#include "nem_login_manager.h"

NEMLoginManager::NEMLoginManager()
{
}

NEMLoginManager::~NEMLoginManager() {}

bool NEMLoginManager::init() {
    
    m_settings = new QSettings("login.ini", QSettings::IniFormat);

    //随机生成用户名
    auto randomNumber = QRandomGenerator::global()->bounded(100000000, 9999999999);
    m_uid = randomNumber;
    QString userName = "user ID: " + QString::number(randomNumber);
    QTimer::singleShot(100, [=]{
        login(userName);
    });
    
    return true;
}

void NEMLoginManager::login(const QString& user) {
    m_account = user;
    emit loginFinished();
}


 void NEMLoginManager::logoutRoom()
{
     emit exitRoom();
}

void NEMLoginManager::setRoomInfo(const QString& name)
{
    m_roomName = name;

    emit enterRoomFinished();
}

QString NEMLoginManager::getAccount() const {
    return m_account;
}

QString NEMLoginManager::getAppKey() const {
    return m_appKey;
}

qint64 NEMLoginManager::getUid() const{
    return m_uid;
}

QString NEMLoginManager::getAppSecret() const{
    return m_appsecret;
}

QString NEMLoginManager::getNonce() const
{
    return m_nonce;
}

QString NEMLoginManager::getCurTime() const
{
    return m_curTime;
}

QString NEMLoginManager::getCheckSum() const
{
    return m_checksum;
}

void NEMLoginManager::setCheckSum()
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

QString NEMLoginManager::getDefaultRoom() const
{
    return m_settings->value("roomID").toString();
}

void NEMLoginManager::setDefaultSettings(const QString& roomID) const
{
    m_settings->setValue("roomID", roomID);
}

QString NEMLoginManager::getWhiteboardUrl() const
{
    return m_staticUrl;
}

QString NEMLoginManager::getRoomid() const
{
    return m_roomName;
}
