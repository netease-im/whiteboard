#ifndef NEM_GLOG_H
#define NEM_GLOG_H

#include <QObject>
#include "glog/logging.h"

class NEMGlog: public QObject
{
    Q_OBJECT

public:
    NEMGlog(char* argv[]);
    ~NEMGlog();

    Q_INVOKABLE void setlogInfo(const QString& logMessage);

private:
    void configureGoogleLog();
};

#endif // NEM_GLOG_H
