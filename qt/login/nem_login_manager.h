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
    void login(const QString& user);
    
    Q_INVOKABLE QString getAccount() const;
    Q_INVOKABLE QString getAppKey() const;
    Q_INVOKABLE qint64 getUid() const;
    Q_INVOKABLE QString getAppSecret() const;
    Q_INVOKABLE QString getNonce() const;
    Q_INVOKABLE QString getCurTime() const;
    Q_INVOKABLE QString getCheckSum() const;
    Q_INVOKABLE void    setCheckSum();

signals:
    void loginFinished();

private:
    NEMLoginManager();
    ~NEMLoginManager();

private:
    QString m_account;
    QString m_appKey;
    qint64  m_uid;
    QString m_appsecret;
    QString m_checksum;
    QString m_nonce = "123456";;
    QString m_curTime;
};

#endif  // NEMLOGINMANAGER_H
