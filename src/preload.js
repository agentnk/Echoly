const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('echoly', {
  openFile: () => ipcRenderer.invoke('file:open'),
  minimizeWindow: () => ipcRenderer.send('window:minimize'),
  togglePin: (isPinned) => ipcRenderer.send('window:toggle-pin', isPinned)
});
