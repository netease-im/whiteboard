#include <QRandomGenerator>
#include <QTimer>
#include "nem_login_manager.h"

NEMLoginManager::NEMLoginManager() 
{
}

NEMLoginManager::~NEMLoginManager() {}

bool NEMLoginManager::init() {
    
    QTimer::singleShot(100, [=]{
        emit loginFinished();
    });
    
    return true;
}

void NEMLoginManager::setLoginInfo(const QString &appKey,
                                   const QString& uid,
                                   const QString& appsecret)
{
    m_appKey = appKey;
    m_uid = uid.toLongLong();
    m_appsecret = appsecret;
    m_account = "user ID: " + uid;
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
