#include <QFileInfo>
#include <QHttpPart>
#include <QJsonDocument>
#include <QJsonObject>
#include <QUrlQuery>

#include "nem_http_manager.h"

NEMHttpManager::NEMHttpManager() {
    networkAccessManager = new QNetworkAccessManager();
}

NEMHttpManager::~NEMHttpManager() {
    delete networkAccessManager;
}

NEMRequest* NEMHttpManager::get(const QString& urlString, const QMap<QString, QString>& params, int timeout) {
    QUrl url(urlString);

    if (!params.isEmpty()) {
        QUrlQuery query;

        for (auto it = params.begin(); it != params.end(); it++) {
            query.addQueryItem(it.key(), it.value());
        }

        url.setQuery(query);
    }

    QNetworkRequest request(url);

    //支持301, 302重定向
    request.setAttribute(QNetworkRequest::FollowRedirectsAttribute, true);

    if (networkAccessManager->networkAccessible() == QNetworkAccessManager::NotAccessible) {
        qInfo() << "networkaccess change !";

        networkAccessManager->setNetworkAccessible(QNetworkAccessManager::Accessible);
    }

    QNetworkReply* reply = networkAccessManager->get(request);

    if (!reply) {
        qCritical("reply is null");

        return nullptr;
    }

    return new NEMRequest(reply, urlString, timeout);
}

NEMRequest* NEMHttpManager::post(const QString& urlString,
                                 const QMap<QString, QString>& headerParams,
                                 const QMap<QString, QString>& payloadParams,
                                 bool useUtf8,
                                 int timeout) {
    QUrl url(urlString);

    QNetworkRequest request(url);

    QSslConfiguration config;
    QSslConfiguration conf = request.sslConfiguration();
    conf.setPeerVerifyMode(QSslSocket::VerifyNone);
    conf.setProtocol(QSsl::TlsV1SslV3);
    request.setSslConfiguration(conf);

    if (useUtf8) {
        request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json;charset=utf-8");
    } else {
        request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    }

    for (auto it = headerParams.begin(); it != headerParams.end(); it++) {
        request.setRawHeader(it.key().toUtf8().data(), it.value().toUtf8().data());
    }

    QString postData;

    if (useUtf8) {
        QJsonObject obj;
        for (auto it = payloadParams.begin(); it != payloadParams.end(); it++) {
            obj.insert(it.key(), it.value());
        }
        postData = QJsonDocument(obj).toJson(QJsonDocument::Compact);
    } else {
        QUrlQuery query;

        for (auto it = payloadParams.begin(); it != payloadParams.end(); it++) {
            query.addQueryItem(it.key(), it.value());
        }

        postData = query.toString(QUrl::FullyEncoded);
    }

    qInfo() << "postData: " << postData;

    QNetworkReply* reply = networkAccessManager->post(request, postData.toUtf8());

    if (networkAccessManager->networkAccessible() == QNetworkAccessManager::NotAccessible) {
        qInfo() << "networkaccess change !";

        networkAccessManager->setNetworkAccessible(QNetworkAccessManager::Accessible);
    }

    if (!reply) {
        return nullptr;
    }

    return new NEMRequest(reply, urlString, timeout);
}
