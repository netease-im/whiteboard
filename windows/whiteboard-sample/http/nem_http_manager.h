#ifndef NEMHTTPMANAGER_H
#define NEMHTTPMANAGER_H

#include <QMap>
#include <QNetworkAccessManager>

#include "nem_request.h"

class NEMHttpManager {
public:
    static NEMHttpManager& instance() {
        static NEMHttpManager manager;

        return manager;
    }

    NEMRequest* get(const QString& urlString, const QMap<QString, QString>& params, int timeout = 0);

    NEMRequest* post(const QString& urlString,
                     const QMap<QString, QString>& headerParams,
                     const QMap<QString, QString>& payloadParams,
                     bool useUtf8 = true,
                     int timeout = 0);

private:
    NEMHttpManager();
    ~NEMHttpManager();

private:
    QNetworkAccessManager* networkAccessManager;
};

#endif  // NEMHTTPMANAGER_H
