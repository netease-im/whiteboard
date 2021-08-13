QT += qml quick webengine webchannel network svg

CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS \
           CPPWRAPPER_DLL \
           GLOG_NO_ABBREVIATED_SEVERITIES

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        login/nem_chatroom_manager.cpp \
        login/nem_login_manager.cpp \
        login/nem_jsBridge.cpp \
        login/sha1.cpp \
        main.cpp \
        util/clipboard.cpp \
        util/nem_glog.cpp\
		util/whiteboard_helper.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH = $$PWD/../bin

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

#DESTDIR = $$PWD/../bin

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    login/nem_chatroom_manager.h \
    login/nem_login_manager.h \
    login/nem_jsBridge.h \
    login/sha1.h \
    util/clipboard.h \
    util/nem_glog.h \
	util/whiteboard_helper.h\

win32 {
    QMAKE_CXXFLAGS += -wd4100 /utf-8

    RC_ICONS = "nim.ico"
}


win32:CONFIG(release, debug|release): LIBS += -L$$PWD/glog/lib/ -lglog
else:win32:CONFIG(debug, debug|release): LIBS += -L$$PWD/glog/lib/ -lglogd

INCLUDEPATH += $$PWD/glog/include
DEPENDPATH += $$PWD/glog/include
