#ifndef NEMCONFIGHELPER_H
#define NEMCONFIGHELPER_H

#include <QObject>

class NEMConfigHelper : public QObject {
    Q_OBJECT
public:
    static NEMConfigHelper& instance() {
        static NEMConfigHelper helper;

        return helper;
    }

public:
    Q_INVOKABLE QString getWebUrl();
    Q_INVOKABLE QString getAppkey();
    Q_INVOKABLE QString getHttpUrl();

private:
    void parseConfig();

private:
    NEMConfigHelper();
    ~NEMConfigHelper();

private:
    QString m_webUrl;
    QString m_appKey;
    QString m_httpUrl;
};

#endif  // NEMCONFIGHELPER_H
