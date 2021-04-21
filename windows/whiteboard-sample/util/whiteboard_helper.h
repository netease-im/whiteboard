#ifndef WHITEBOARDHELPER_H
#define WHITEBOARDHELPER_H

#include <QObject>

class WhiteboardHelper : public QObject
{
    Q_OBJECT
public:
    static WhiteboardHelper& instance() {
        static WhiteboardHelper helper;

        return helper;
    }

    Q_INVOKABLE QString getDefaultDownloadPath();

    Q_INVOKABLE void openDir(QString path);

private:
    WhiteboardHelper();
};

#endif // WHITEBOARDHELPER_H
