const { app, BrowserWindow, ipcMain, dialog, screen } = require('electron');
const fs = require('node:fs/promises');
const path = require('node:path');
const mammoth = require('mammoth');

let mainWindow;

function getWindowBounds() {
  const primaryDisplay = screen.getPrimaryDisplay();
  const { width, height } = primaryDisplay.workAreaSize;
  const windowWidth = Math.min(1460, Math.floor(width * 0.9));
  const windowHeight = Math.min(900, Math.floor(height * 0.9));
  const x = Math.floor((width - windowWidth) / 2);
  const y = Math.floor((height - windowHeight) / 2);

  return { x, y, width: windowWidth, height: windowHeight };
}

function createWindow() {
  mainWindow = new BrowserWindow({
    ...getWindowBounds(),
    backgroundColor: '#d9d9d9',
    title: 'Echoly',
    trafficLightPosition: { x: 20, y: 20 },
    titleBarStyle: process.platform === 'darwin' ? 'hiddenInset' : 'default',
    alwaysOnTop: true,
    resizable: true,
    movable: true,
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      contextIsolation: true,
      nodeIntegration: false
    }
  });

  mainWindow.setAlwaysOnTop(true, 'screen-saver');
  mainWindow.setContentProtection(true);
  mainWindow.loadFile(path.join(__dirname, 'index.html'));
}

app.whenReady().then(() => {
  createWindow();

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) {
      createWindow();
    }
  });
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

ipcMain.handle('file:open', async () => {
  const { canceled, filePaths } = await dialog.showOpenDialog({
    title: 'Open speech file',
    properties: ['openFile'],
    filters: [
      { name: 'Supported files', extensions: ['txt', 'docx'] },
      { name: 'Text files', extensions: ['txt'] },
      { name: 'Word files', extensions: ['docx'] }
    ]
  });

  if (canceled || filePaths.length === 0) {
    return { canceled: true };
  }

  const selectedPath = filePaths[0];
  const extension = path.extname(selectedPath).toLowerCase();

  try {
    let content = '';

    if (extension === '.txt') {
      content = await fs.readFile(selectedPath, 'utf8');
    } else if (extension === '.docx') {
      const result = await mammoth.extractRawText({ path: selectedPath });
      content = result.value;
    } else {
      return { canceled: false, error: 'Unsupported file format. Please choose .txt or .docx.' };
    }

    return {
      canceled: false,
      filePath: selectedPath,
      text: content.replace(/\r\n/g, '\n').trim()
    };
  } catch (error) {
    return { canceled: false, error: error.message };
  }
});

ipcMain.on('window:minimize', () => {
  if (mainWindow) {
    mainWindow.minimize();
  }
});

ipcMain.on('window:toggle-pin', (_event, isPinned) => {
  if (mainWindow) {
    mainWindow.setAlwaysOnTop(Boolean(isPinned), 'screen-saver');
  }
});
