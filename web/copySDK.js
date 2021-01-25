/**
 * 将最新的sdk拷贝到当前sdk/sdk和webview/webview中
 */

const fs = require('fs-extra')
const path = require('path')

fs.emptyDirSync(path.resolve(__dirname, 'sdk', 'sdk'))
fs.emptyDirSync(path.resolve(__dirname, 'webview', 'webview'))


fs.copySync(
    path.resolve(__dirname, '..', '..', 'whiteboard-web-demo', 'sdk_output', 'sdk'),
    path.resolve(__dirname, 'sdk', 'sdk')
)

fs.copySync(
    path.resolve(__dirname, '..', '..', 'whiteboard-web-demo', 'sdk_output', 'webview'),
    path.resolve(__dirname, 'webview', 'webview')
)

console.log('请修改sdk/index.html中版本号')