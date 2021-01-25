#include "nem_config_helper.h"

#include <QCoreApplication>
#include <QDebug>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>

NEMConfigHelper::NEMConfigHelper() {
    parseConfig();
}

NEMConfigHelper::~NEMConfigHelper() {}

QString NEMConfigHelper::getWebUrl() {
    return m_webUrl;
}

QString NEMConfigHelper::getAppkey() {
    return m_appKey;
}

QString NEMConfigHelper::getHttpUrl() {
    return m_httpUrl;
}

void NEMConfigHelper::parseConfig() {
    QString filePath = QCoreApplication::applicationDirPath() + "\\test.json";
    QFile loadFile(filePath);

    if (!loadFile.open(QIODevice::ReadOnly)) {
        qDebug() << "could't open projects json";
        return;
    }

    QByteArray allData = loadFile.readAll();
    loadFile.close();

    qInfo() << "allData: " << allData;

    QJsonParseError json_error;
    QJsonDocument jsonDoc(QJsonDocument::fromJson(allData, &json_error));

    if (json_error.error != QJsonParseError::NoError) {
        qDebug() << "json error!";
        return;
    }

    QJsonObject rootObj = jsonDoc.object();
    m_webUrl = rootObj["url"].toString();
    m_appKey = rootObj["appkey"].toString();
    m_httpUrl = rootObj["httpUrl"].toString();

    qInfo() << "m_webUrl: " << m_webUrl;
    qInfo() << "m_appKey: " << m_appKey;
    qInfo() << "m_httpUrl: " << m_httpUrl;
}
