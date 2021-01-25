#include "whiteboard_plugin.h"
#include <qqml.h>
#include "nem_jsBridge.h"

void NEMWhiteboardPlugin::registerTypes(const char* uri) {
    qmlRegisterType<NEMJsBridge>(uri, 1, 0, "NEMJsBridge");
}
