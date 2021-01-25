QT += qml quick webengine webchannel network svg

CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS \
           CPPWRAPPER_DLL

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        http/nem_http_api.cpp \
        http/nem_http_manager.cpp \
        http/nem_request.cpp \
        login/nem_chatroom_manager.cpp \
        login/nem_login_manager.cpp \
        main.cpp \
        util/clipboard.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH = $$PWD/../bin

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

DESTDIR = $$PWD/../bin

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    http/nem_http_api.h \
    http/nem_http_manager.h \
    http/nem_request.h \
    login/nem_chatroom_manager.h \
    login/nem_login_manager.h \
    util/clipboard.h

win32 {
    INCLUDEPATH += \
            $$PWD/nim_sdk/api

    CONFIG(debug, debug|release) {
        LIBS += -L$$PWD/nim_sdk/lib -lnim_sdk_cpp_wrapper_dll_d -lnim_chatroom_sdk_cpp_wrapper_dll_d
    } else {
        LIBS += -L$$PWD/nim_sdk/lib -lnim_sdk_cpp_wrapper_dll -lnim_chatroom_sdk_cpp_wrapper_dll
    }

    QMAKE_CXXFLAGS += -wd4100 /utf-8

    RC_ICONS = "nim.ico"
}
