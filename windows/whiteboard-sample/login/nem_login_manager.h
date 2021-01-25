#ifndef NEMLOGINMANAGER_H
#define NEMLOGINMANAGER_H

#include <QObject>
#include "nim_cpp_client.h"
#include "nim_cpp_tool.h"

#define app_key ""

using namespace nim;

class NEMLoginManager : public QObject {
    Q_OBJECT

public:
    static NEMLoginManager& instance() {
        static NEMLoginManager manager;

        return manager;
    }

public:
    bool init();
    void release();
    void login(const QString& user, const QString& password);

    Q_INVOKABLE void logout();
    Q_INVOKABLE QString getAccount() const;
    Q_INVOKABLE QString getPassword() const;
    Q_INVOKABLE QString getAppKey() const;

signals:
    void loginFinished();
    void loginFailed();

private:
    NEMLoginManager();
    ~NEMLoginManager();

private:
    QString m_account;
    QString m_password;
    QString m_appKey = app_key;
};

#endif  // NEMLOGINMANAGER_H
