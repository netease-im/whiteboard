#ifndef NEMCHATROOMMANAGER_H
#define NEMCHATROOMMANAGER_H

#include <QObject>
#include <QSettings>

class NEMChatroomManager : public QObject {
    Q_OBJECT

public:
    static NEMChatroomManager& instance() {
        static NEMChatroomManager manager;

        return manager;
    }

public:
    bool init();

    Q_INVOKABLE void logoutChatroom();

    Q_INVOKABLE QString getRoomid() const;

    Q_INVOKABLE void setLoginChatroomInfo(const QString& name,
                                          const QString& wsUrl,
                                          const QString& uid,
                                          const QString& secret,
                                          const QString& staticUrlField2);
    Q_INVOKABLE QString getWhiteboardUrl() const;
    Q_INVOKABLE QString getWsUrl() const;
    Q_INVOKABLE QString getStaticUrl2() const;
    Q_INVOKABLE QString getNonce() const;
    Q_INVOKABLE QString getCurTime() const;
    Q_INVOKABLE QString getCheckSum() const;
    Q_INVOKABLE void    setCheckSum();
    Q_INVOKABLE QString getDefaultRoom() const;  
    Q_INVOKABLE QString getDefaultAppkey() const;
    Q_INVOKABLE QString getDefaultWsUrl() const;
    Q_INVOKABLE QString getDefaultUid() const;
    Q_INVOKABLE QString getDefaultAppsecret() const;
    Q_INVOKABLE QString getDefaultStaticUrl2() const;

    Q_INVOKABLE void    setDefaultSettings(const QString& roomID,
                                           const QString& appkey,
                                           const QString& wsUrl,
                                           const QString& uid,
                                           const QString& appsecret,
                                           const QString& staticUrl2) const;

signals:
    void enterRoomFinished();
    void exitRoom();

private:
    NEMChatroomManager();
    ~NEMChatroomManager();

private:
    QString    m_roomName;
    qint64     m_roomid;
    QString    m_wsUrl;
    QString    m_uid;
    QString    m_appsecret;
    QString    m_staticUrl2;
    QString    m_checksum;
    QString    m_nonce;
    QString    m_curTime;
    QSettings *m_settings;
};

#endif  // NEMCHATROOMMANAGER_H
