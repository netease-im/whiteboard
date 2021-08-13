#include <QFont>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QtWebEngine/QtWebEngine>
#include "login/nem_chatroom_manager.h"
#include "login/nem_login_manager.h"
#include "util/clipboard.h"
#include "util/whiteboard_helper.h"
#include "login/nem_jsBridge.h"
#include "util/nem_glog.h"


int main(int argc, char* argv[]) {

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QtWebEngine::initialize();

    QGuiApplication app(argc, argv);
    QFont font;
    font.setFamily("Microsoft YaHei");
    app.setFont(font);

    if (!NEMLoginManager::instance().init()) {
        Q_ASSERT(false);
        return 0;
    }

    if (!NEMChatroomManager::instance().init()) {
        Q_ASSERT(false);
        return 0;
    }

    qmlRegisterType<Clipboard>("Clipboard", 1, 0, "Clipboard");
    qmlRegisterType<NEMJsBridge>("NEMJsBridge", 1, 0, "NEMJsBridge");


    NEMGlog nemGlog(argv);

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("NEMLoginManager", &NEMLoginManager::instance());
    engine.rootContext()->setContextProperty("NEMChatroomManager", &NEMChatroomManager::instance());
    engine.rootContext()->setContextProperty("WhiteboardHelper", &WhiteboardHelper::instance());
    engine.rootContext()->setContextProperty("NEMGlog", &nemGlog);


    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app,
                     [url](QObject* obj, const QUrl& objUrl) {
                         if (!obj && url == objUrl)
                             QCoreApplication::exit(-1);
                     },
                     Qt::QueuedConnection);
    engine.load(url);

    int result = app.exec();

    return result;
}
