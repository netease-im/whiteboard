cd %~dp0

chcp 65001
mkdir bin
mkdir bin\NEMWhiteboard

xcopy whiteboard-sample\nim_sdk\bin bin /s
copy whiteboard-plugin\NEMWhiteboard.qml bin\NEMWhiteboard
copy whiteboard-plugin\qmldir bin\NEMWhiteboard
