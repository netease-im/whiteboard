#include <QStandardPaths>
#include <QTextCodec>
#include <windows.h>
#include "whiteboard_helper.h"

WhiteboardHelper::WhiteboardHelper()
{

}

WhiteboardHelper::~WhiteboardHelper()
{

}

QString WhiteboardHelper::getDefaultDownloadPath()
{
    return QStandardPaths::writableLocation(QStandardPaths::DownloadLocation);
}

void WhiteboardHelper::openDir(QString path)
{
    path.replace("/", "\\");
    QTextCodec * codec = QTextCodec::codecForName("GB18030");
    QString cmd = QString(" /select,\"" + path + "\"");
    ShellExecuteA(NULL, "open", "explorer", codec->fromUnicode(cmd).constData(), NULL, SW_SHOWDEFAULT);
}

