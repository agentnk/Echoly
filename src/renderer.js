const openFileBtn = document.getElementById('openFileBtn');
const playPauseBtn = document.getElementById('playPauseBtn');
const pinBtn = document.getElementById('pinBtn');
const minBtn = document.getElementById('minBtn');
const speedInput = document.getElementById('speedInput');
const fontInput = document.getElementById('fontInput');
const scriptText = document.getElementById('scriptText');
const promptArea = document.getElementById('promptArea');
const statusText = document.getElementById('status');

let isPlaying = false;
let isPinned = true;
let animationFrameId = null;
let offsetY = 0;
let lastFrame = null;

function updateStatus(message) {
  statusText.textContent = message;
}

function resetPromptPosition() {
  offsetY = 0;
  scriptText.style.transform = 'translateY(0px)';
  lastFrame = null;
}

function stopScrolling() {
  if (animationFrameId) {
    cancelAnimationFrame(animationFrameId);
    animationFrameId = null;
  }
  isPlaying = false;
  playPauseBtn.textContent = 'Play';
}

function tick(timestamp) {
  if (!lastFrame) {
    lastFrame = timestamp;
  }

  const deltaSeconds = (timestamp - lastFrame) / 1000;
  lastFrame = timestamp;

  const pixelsPerSecond = Number(speedInput.value);
  offsetY -= pixelsPerSecond * deltaSeconds;

  const contentHeight = scriptText.scrollHeight;
  const visibleHeight = promptArea.clientHeight;

  if (Math.abs(offsetY) > contentHeight - visibleHeight + 28) {
    stopScrolling();
    updateStatus('Reached end of script. Press Play to restart.');
    return;
  }

  scriptText.style.transform = `translateY(${offsetY}px)`;
  animationFrameId = requestAnimationFrame(tick);
}

function startScrolling() {
  const text = scriptText.textContent?.trim();
  if (!text || text === 'Load a .txt or .docx speech file to begin.') {
    updateStatus('Open a script first.');
    return;
  }

  if (Math.abs(offsetY) > scriptText.scrollHeight - promptArea.clientHeight) {
    resetPromptPosition();
  }

  isPlaying = true;
  playPauseBtn.textContent = 'Pause';
  updateStatus(`Scrolling at ${speedInput.value} px/s`);
  animationFrameId = requestAnimationFrame(tick);
}

openFileBtn.addEventListener('click', async () => {
  const result = await window.echoly.openFile();

  if (!result || result.canceled) {
    updateStatus('File selection canceled.');
    return;
  }

  if (result.error) {
    updateStatus(result.error);
    return;
  }

  stopScrolling();
  scriptText.textContent = result.text || 'The file was empty.';
  resetPromptPosition();
  updateStatus(`Loaded ${result.filePath}`);
});

playPauseBtn.addEventListener('click', () => {
  if (isPlaying) {
    stopScrolling();
    updateStatus('Paused');
  } else {
    startScrolling();
  }
});

speedInput.addEventListener('input', () => {
  if (isPlaying) {
    updateStatus(`Scrolling at ${speedInput.value} px/s`);
  }
});

fontInput.addEventListener('input', () => {
  scriptText.style.fontSize = `${fontInput.value}px`;
});

pinBtn.addEventListener('click', () => {
  isPinned = !isPinned;
  pinBtn.textContent = isPinned ? 'Pinned' : 'Unpinned';
  pinBtn.setAttribute('aria-pressed', String(isPinned));
  window.echoly.togglePin(isPinned);
  updateStatus(isPinned ? 'Window pinned on top.' : 'Window unpinned.');
});

minBtn.addEventListener('click', () => {
  window.echoly.minimizeWindow();
});
