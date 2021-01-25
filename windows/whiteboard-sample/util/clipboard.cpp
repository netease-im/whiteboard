#include "clipboard.h"

Clipboard::Clipboard(QObject *parent)
    : QObject(parent)
{
    clipboard = QGuiApplication::clipboard();
}

void Clipboard::setText(QString text)
{
    clipboard->setText(text, QClipboard::Clipboard);
}

QString Clipboard::getText()
{
    return clipboard->text(QClipboard::Clipboard);
}
