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

    Q_INVOKABLE void setLoginChatroomInfo(const QString& name);
    Q_INVOKABLE QString getWhiteboardUrl() const;
    Q_INVOKABLE QString getDefaultRoom() const;  
    Q_INVOKABLE void    setDefaultSettings(const QString& roomID) const;

signals:
    void enterRoomFinished();
    void exitRoom();

private:
    NEMChatroomManager();
    ~NEMChatroomManager();

private:
    QString    m_roomName;
    qint64     m_roomid;
    QString    m_uid;
    QString    m_staticUrl2 = "https://app.yunxin.163.com/webdemo/whiteboard/webview.html";
    QSettings *m_settings;
};

#endif  // NEMCHATROOMMANAGER_H
