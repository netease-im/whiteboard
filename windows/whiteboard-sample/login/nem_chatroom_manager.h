#ifndef NEMCHATROOMMANAGER_H
#define NEMCHATROOMMANAGER_H

#include <QObject>

class NEMChatroomManager : public QObject {
    Q_OBJECT

public:
    static NEMChatroomManager& instance() {
        static NEMChatroomManager manager;

        return manager;
    }

public:
    bool init();
    void release();

    Q_INVOKABLE void createChatroom(const QString& creator, const QString& name);
    Q_INVOKABLE void closeChatroom();

    Q_INVOKABLE void loginChatroom(const QString& strRoomid);
    Q_INVOKABLE void logoutChatroom();

    Q_INVOKABLE QString getCreator() const;
    Q_INVOKABLE QString getRoomid() const;

signals:
    void enterRoomFinished();
    void kickByMultiSpot();
    void kickByManager();
    void exitRoom();
    void chatRoomFinished();
    void joinRoomFailed(QString errMsg);
    void createRoomFailed(QString errMsg);

private:
    NEMChatroomManager();
    ~NEMChatroomManager();

private:
    QString m_creator;
    QString m_roomName;
    qint64 m_roomid;
};

#endif  // NEMCHATROOMMANAGER_H
