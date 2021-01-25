TEMPLATE = lib
TARGET = whiteboard-plugin
QT += qml quick
CONFIG += plugin c++11 qmltypes

TARGET = $$qtLibraryTarget($$TARGET)
uri = NEMWhiteboard

QML_IMPORT_NAME = NEMWhiteboard
QML_IMPORT_MAJOR_VERSION = 1

DESTDIR = $$PWD/../bin/$$QML_IMPORT_NAME

SOURCES += \
        nem_jsBridge.cpp \
        whiteboard_plugin.cpp

HEADERS += \
        nem_jsBridge.h \
        whiteboard_plugin.h

pluginfiles.target += $$PWD/../bin/$$QML_IMPORT_NAME
pluginfiles.path = $$PWD/../bin/$$QML_IMPORT_NAME
pluginfiles.files += \
    $$PWD/../whiteboard-plugin/qmldir \
    $$PWD/../whiteboard-plugin/NEMWhiteboard.qml

INSTALLS += pluginfiles

DISTFILES += \
    NEMWhiteboard.qml
