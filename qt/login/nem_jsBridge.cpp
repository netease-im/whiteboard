#include <QJsonDocument>
#include <QJsonObject>
#include "nem_jsBridge.h"

NEMJsBridge::NEMJsBridge(QObject* parent)
    : QObject(parent) {}

void NEMJsBridge::NativeFunction(QString toast) {
    QJsonParseError err;
    QJsonDocument doc = QJsonDocument::fromJson(toast.toUtf8(), &err);
    qInfo() << "toast: " << toast;

    if (err.error != QJsonParseError::NoError)
        return;

    QJsonObject obj = doc.object();
    QString action = obj["action"].toString();
    QJsonObject param = obj["param"].toObject();

    if (action == "webPageLoaded") {
        emit webPageLoadFinished();
    }else if (action == "webJoinWBSucceed") {
        emit webJoinWriteBoardSucceed();
    } else if (action == "webJoinWBFailed") {
        int errorCode = param["code"].toInt();
        QString errorMessage = param["msg"].toString();
        emit webJoinWriteBoardFailed(errorCode, errorMessage);
    } else if (action == "webCreateWBFailed") {
        int errorCode = param["code"].toInt();
        QString errorMessage = param["msg"].toString();
        emit webCreateWriteBoardFailed(errorCode, errorMessage);
    } else if (action == "webLeaveWB") {
        emit webLeaveWriteBoard();
    } else if (action == "webJsError") {
        QString errorMessage = param["msg"].toString();
        emit webJsError(errorMessage);
    } else if (action == "webError") {
        int errorCode = param["code"].toInt();
        QString errorMessage = param["msg"].toString();
        QString errorType = param["type"].toString();
        emit webError(errorCode, errorMessage, errorType);
    }else if (action == "webLog"){
        QString logType = param["type"].toString();
        QString logMessage = param["msg"].toString();
        emit webLog(logType, logMessage);
    }else if (action == "webGetAuth")
    {
        emit webGetAuth();
    }
}
