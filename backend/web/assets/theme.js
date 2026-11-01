// Only the display preference is persisted; credentials stay in page memory.
(() => {
  let theme;
  try { theme = localStorage.getItem('novyx-theme'); } catch {}
  if (!['light','dark'].includes(theme)) theme = 'dark';
  document.documentElement.dataset.theme = theme;
})();
