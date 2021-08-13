#ifndef NEMLOGINMANAGER_H
#define NEMLOGINMANAGER_H

#include <QObject>

class NEMLoginManager : public QObject {
    Q_OBJECT

public:
    static NEMLoginManager& instance() {
        static NEMLoginManager manager;

        return manager;
    }

public:
    bool init();
    
    Q_INVOKABLE QString getAccount() const;
    Q_INVOKABLE QString getAppKey() const;
    Q_INVOKABLE qint64 getUid() const;
    Q_INVOKABLE QString getAppSecret() const;
    Q_INVOKABLE void setLoginInfo(const QString& appKey,
                                  const QString& uid,
                                  const QString& appsecret);

signals:
    void loginFinished();

private:
    NEMLoginManager();
    ~NEMLoginManager();

private:
    QString m_account;
    QString m_password;
    QString m_appKey;
    qint64 m_uid;
    QString m_appsecret;
};

#endif  // NEMLOGINMANAGER_H
