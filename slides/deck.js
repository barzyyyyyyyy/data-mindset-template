// Shows one slide at a time, scaled to the window. → / space / click: next,
// ← : back, Home / End: first / last. The slide number is kept in the URL
// (#5), so a reload stays on the same slide.
(function () {
  const slides = [...document.querySelectorAll('.slide')];
  const bar = document.createElement('div'); bar.className = 'bar'; document.body.appendChild(bar);
  const count = document.createElement('div'); count.className = 'count'; document.body.appendChild(count);
  let i = Math.min(slides.length - 1, Math.max(0, (parseInt(location.hash.slice(1), 10) || 1) - 1));

  function fit() {
    const s = Math.min(innerWidth / 1280, innerHeight / 720);
    slides.forEach(el => { el.style.transform = `scale(${s})`; });
  }
  function show(n) {
    i = Math.max(0, Math.min(slides.length - 1, n));
    slides.forEach((el, k) => el.classList.toggle('on', k === i));
    bar.style.width = `${((i + 1) / slides.length) * 100}%`;
    count.textContent = `${i + 1} / ${slides.length}`;
    history.replaceState(null, '', `#${i + 1}`);
  }
  addEventListener('keydown', e => {
    if (['ArrowRight', 'PageDown', ' '].includes(e.key)) { e.preventDefault(); show(i + 1); }
    if (['ArrowLeft', 'PageUp'].includes(e.key)) { e.preventDefault(); show(i - 1); }
    if (e.key === 'Home') show(0);
    if (e.key === 'End') show(slides.length - 1);
  });
  addEventListener('click', e => { if (!e.target.closest('a, button')) show(e.clientX < innerWidth / 3 ? i - 1 : i + 1); });
    // Opening the assistant (data-copy) also copies what to say to it.
  document.querySelectorAll('[data-copy]').forEach(b => b.addEventListener('click', () => {
    navigator.clipboard.writeText(b.dataset.copy).catch(() => {});
  }));
  // Links to the team's own pages (data-site="dashboard/"). Slides sit in <site>/slides/<lesson>/.
  const site = location.pathname.includes('/slides/') ? '../../' : '../../template/';
  document.querySelectorAll('a[data-site]').forEach(a => { a.href = site + a.dataset.site; });
  addEventListener('resize', fit);
  fit(); show(i);
})();
