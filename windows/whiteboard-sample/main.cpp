#include <QFont>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QtWebEngine/QtWebEngine>

#include "login/nem_chatroom_manager.h"
#include "login/nem_login_manager.h"
#include "util/clipboard.h"
#include "util/nem_config_helper.h"

int main(int argc, char* argv[]) {
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QtWebEngine::initialize();

    //开启调试：可通过 http://127.0.0.1:9223 进行调试
    // qputenv("QTWEBENGINE_REMOTE_DEBUGGING", "9223");

    QGuiApplication app(argc, argv);
    QFont font;
    font.setFamily("Microsoft YaHei");
    app.setFont(font);

    if (!NEMLoginManager::instance().init()) {
        Q_ASSERT(false);
        return 0;
    }

    if (!NEMChatroomManager::instance().init()) {
        NEMLoginManager::instance().release();
        Q_ASSERT(false);
        return 0;
    }

    qmlRegisterType<Clipboard>("Clipboard", 1, 0, "Clipboard");

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("NEMLoginManager", &NEMLoginManager::instance());
    engine.rootContext()->setContextProperty("NEMChatroomManager", &NEMChatroomManager::instance());

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app,
                     [url](QObject* obj, const QUrl& objUrl) {
                         if (!obj && url == objUrl)
                             QCoreApplication::exit(-1);
                     },
                     Qt::QueuedConnection);
    engine.load(url);

    int result = app.exec();

    NEMLoginManager::instance().release();
    NEMChatroomManager::instance().release();

    return result;
}
