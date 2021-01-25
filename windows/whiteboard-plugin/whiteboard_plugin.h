#ifndef WHITEBOARDPLUGIN_PLUGIN_H
#define WHITEBOARDPLUGIN_PLUGIN_H

#include <QQmlExtensionPlugin>

class NEMWhiteboardPlugin : public QQmlExtensionPlugin {
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)

public:
    void registerTypes(const char* uri) override;
};

#endif  // WHITEBOARDPLUGIN_PLUGIN_H
