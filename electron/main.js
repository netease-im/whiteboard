if (process.env.NODE_ENV !== 'production') {
  try {
    require('electron-reloader')(module);
  } catch {}
}

// main.js

// Modules to control application life and create native browser window
const { app, BrowserWindow } = require('electron')

function createWindow () {
  // Create the browser window.
  const mainWindow = new BrowserWindow({
    width: 1920,
    height: 1080
  })
  mainWindow.maximize()
  // and load the index.html of the app.
  mainWindow.loadFile('./dist/assets/index.html')

  // Open the DevTools.
  // mainWindow.webContents.openDevTools()
}

app.commandLine.appendSwitch('ignore-certificate-errors', 'true');

// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
// 部分 API 在 ready 事件触发后才能使用。
app.whenReady().then(() => {
  createWindow()

  app.on('activate', function () {
    // On macOS it's common to re-create a window in the app when the
    // dock icon is clicked and there are no other windows open.
    if (BrowserWindow.getAllWindows().length === 0) createWindow()
  })
})

// Quit when all windows are closed, except on macOS. There, it's common
// for applications and their menu bar to stay active until the user quits
// explicitly with Cmd + Q.
app.on('window-all-closed', function () {
  if (process.platform !== 'darwin') app.quit()
})