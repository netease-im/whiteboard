#ifndef NEMLOGINMANAGER_H
#define NEMLOGINMANAGER_H

#include <QObject>
#include <QSettings>

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

    Q_INVOKABLE void    logoutRoom();
    Q_INVOKABLE void    setRoomInfo(const QString& name);
    Q_INVOKABLE QString getAccount() const;
    Q_INVOKABLE QString getAppKey() const;
    Q_INVOKABLE qint64  getUid() const;
    Q_INVOKABLE QString getAppSecret() const;
    Q_INVOKABLE QString getNonce() const;
    Q_INVOKABLE QString getCurTime() const;
    Q_INVOKABLE QString getCheckSum() const;
    Q_INVOKABLE void    setCheckSum();
    Q_INVOKABLE QString getDefaultRoom() const;
    Q_INVOKABLE void    setDefaultSettings(const QString& roomID) const;
    Q_INVOKABLE QString getWhiteboardUrl() const;
    Q_INVOKABLE QString getRoomid() const;

signals:
    void loginFinished();
    void enterRoomFinished();
    void exitRoom();

private:
    NEMLoginManager();
    ~NEMLoginManager();

private:
    QString    m_account;
    QString    m_roomName;
    QString    m_appKey = "caee83f25bef456b13b4e9f54c8da4c8";
    qint64     m_uid;
    /**
     * samplecode仅作为展示使用。实际开发时，请不要将appsecret放置在客户端代码中，以防泄漏。
     * 客户端中放置appsecret是为了在客户不需要设置应用服务器时，即能够跑通白板的sample code。
     */
    QString    m_appsecret = "c45c1fa7999e";
    QString    m_checksum;
    QString    m_nonce = "123456";;
    QString    m_curTime;
    /**
     * 下面的WEBVIEW_URL始终指向最新的SDK版本。
     * 为了保证您线上的应用不会由于版本升级失效，请到该地址：https://doc.yunxin.163.com/whiteboard/docs/DMzNDkxMDc?platform=web ，下载最新的webview静态资源，并通过您的静态服务器部署。
     */
    QString    m_staticUrl = "https://app.yunxin.163.com/webdemo/whiteboard/webview.html";
    QSettings* m_settings;

};

#endif  // NEMLOGINMANAGER_H
