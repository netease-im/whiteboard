#ifndef NEMJSBRIDGE_H
#define NEMJSBRIDGE_H

#include <QObject>

class NEMJsBridge : public QObject {
    Q_OBJECT

public:
    explicit NEMJsBridge(QObject* parent = 0);

    Q_INVOKABLE void NativeFunction(QString toast);

signals:
    void webPageLoadFinished();

    void webLoginIMSucceed();
    void webLoginIMFailed(int errorCode, const QString& errorMessage);

    void webJoinWriteBoardSucceed();
    void webJoinWriteBoardFailed(int errorCode, const QString& errorMessage);

    void webCreateWriteBoardSucceed();
    void webCreateWriteBoardFailed(int errorCode, const QString& errorMessage);

    void webLeaveWriteBoard();

    void webError(int errorCode, const QString& errorMessage, const QString& errorType);
    void webJsError(const QString& errorMessage);

    void webLog(const QString& logType, const QString& logMessage);
    void webGetAuth();
};

#endif  // NEMJSBRIDGE_H
