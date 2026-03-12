const openFileBtn = document.getElementById('openFileBtn');
const playPauseBtn = document.getElementById('playPauseBtn');
const fontDownBtn = document.getElementById('fontDownBtn');
const fontUpBtn = document.getElementById('fontUpBtn');
const fontSizeLabel = document.getElementById('fontSizeLabel');
const pinBtn = document.getElementById('pinBtn');
const minBtn = document.getElementById('minBtn');
const fileName = document.getElementById('fileName');
const progressFill = document.getElementById('progressFill');
const status = document.getElementById('status');
const counter = document.getElementById('counter');
const reader = document.getElementById('reader');
const linePrev = document.getElementById('linePrev');
const lineActive = document.getElementById('lineActive');
const lineNext1 = document.getElementById('lineNext1');
const lineNext2 = document.getElementById('lineNext2');
const lineNext3 = document.getElementById('lineNext3');

let isPlaying = false;
let isPinned = true;
let fontSize = 26;
let lines = [];
let activeIndex = 0;

function parseLines(text) {
  return text
    .split('\n')
    .map((line) => line.trim())
    .filter(Boolean);
}

function updateFontSize() {
  const lineFontSize = Math.round(fontSize * 2.8);
  document.documentElement.style.setProperty('--line-font-size', `${lineFontSize}px`);
  document.querySelectorAll('.line').forEach((line) => {
    line.style.fontSize = `${lineFontSize}px`;
  });
  fontSizeLabel.textContent = `${fontSize}pt`;
}

function updateStatus() {
  status.classList.toggle('playing', isPlaying);
  status.innerHTML = `<span class="indicator"></span> ${isPlaying ? 'PLAYING' : 'PAUSED'}`;
}

function updateProgress() {
  if (lines.length === 0) {
    progressFill.style.width = '0%';
    counter.textContent = 'LINE 0 / 0';
    return;
  }

  const progress = ((activeIndex + 1) / lines.length) * 100;
  progressFill.style.width = `${Math.min(100, progress)}%`;
  counter.textContent = `LINE ${activeIndex + 1} / ${lines.length}`;
}

function renderLines() {
  if (lines.length === 0) {
    linePrev.textContent = '';
    lineActive.textContent = 'Load a .txt or .docx file to begin.';
    lineNext1.textContent = '';
    lineNext2.textContent = '';
    lineNext3.textContent = '';
    updateProgress();
    return;
  }

  linePrev.textContent = lines[activeIndex - 1] || '';
  lineActive.textContent = lines[activeIndex] || '';
  lineNext1.textContent = lines[activeIndex + 1] || '';
  lineNext2.textContent = lines[activeIndex + 2] || '';
  lineNext3.textContent = lines[activeIndex + 3] || '';

  updateProgress();
}

function advanceLine() {
  if (!isPlaying || lines.length === 0) {
    return;
  }

  if (activeIndex < lines.length - 1) {
    activeIndex += 1;
    renderLines();
  }
}

function togglePlayPause() {
  isPlaying = !isPlaying;
  playPauseBtn.textContent = isPlaying ? '❚❚' : '▶';
  updateStatus();
}

openFileBtn.addEventListener('click', async () => {
  const result = await window.echoly.openFile();

  if (!result || result.canceled) {
    return;
  }

  if (result.error) {
    status.innerHTML = `<span class="indicator"></span> ERROR: ${result.error.toUpperCase()}`;
    return;
  }

  const parsedLines = parseLines(result.text || '');
  lines = parsedLines.length > 0 ? parsedLines : ['The selected file is empty.'];
  activeIndex = 0;

  const nameParts = (result.filePath || '').split(/[/\\]/);
  fileName.textContent = nameParts[nameParts.length - 1] || 'Untitled';

  renderLines();
  reader.focus();
});

playPauseBtn.addEventListener('click', () => {
  togglePlayPause();
});

fontDownBtn.addEventListener('click', () => {
  fontSize = Math.max(18, fontSize - 2);
  updateFontSize();
});

fontUpBtn.addEventListener('click', () => {
  fontSize = Math.min(44, fontSize + 2);
  updateFontSize();
});

pinBtn.addEventListener('click', () => {
  isPinned = !isPinned;
  pinBtn.textContent = isPinned ? 'PIN' : 'UNPIN';
  window.echoly.togglePin(isPinned);
});

minBtn.addEventListener('click', () => {
  window.echoly.minimizeWindow();
});

document.addEventListener('keydown', (event) => {
  if (event.key === 'Enter') {
    event.preventDefault();
    advanceLine();
  }

  if (event.key === ' ') {
    event.preventDefault();
    togglePlayPause();
  }
});

updateFontSize();
updateStatus();
renderLines();
