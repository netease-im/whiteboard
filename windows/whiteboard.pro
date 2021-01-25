TEMPLATE = subdirs

SUBDIRS += \
    whiteboard-plugin \
    whiteboard-sample

whiteboard-sample.depends = whiteboard-plugin
