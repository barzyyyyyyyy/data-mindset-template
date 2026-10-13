// =====================================================================
// The course connection. DO NOT EDIT.
// Fetches your team's own practice data and questions, checks answers (each
// try reaches the lecturer), reports setup and memos, and asks which
// lesson this student is on (the lecturer sets it; units/CURRENT is the
// fallback when the course can't be reached).
// Needs supabase-js and core/course-config.js loaded first.
// =====================================================================
const Course = (() => {
  const db = window.supabase.createClient(COURSE_URL, COURSE_KEY, {
    auth: { persistSession: false, autoRefreshToken: false, storageKey: 'course' }
  });
  const root = (() => { const p = location.pathname; const i = p.search(/\/(units|checker|dashboard|data|slides)\//); return i >= 0 ? p.slice(0, i + 1) : p.replace(/[^/]*$/, ''); })();

  // Who this is: 'github-name/repository', from the site's address (or the SITE file when run locally).
  let who = null;
  async function student() {
    if (who) return who;
    // On the course's central copy of a page, the team comes with it (core/central.js).
    if (window.COURSE_TEAM) return (who = window.COURSE_TEAM.site);
    let site = location.hostname.endsWith('github.io') ? location.origin + root : '';
    if (!site) site = (await fetch(root + 'SITE', { cache: 'no-store' }).then(r => r.ok ? r.text() : '').catch(() => '')).trim();
    const m = site.match(/^https?:\/\/([^.]+)\.github\.io\/([^/]+)/);
    return (who = m ? `${m[1]}/${m[2]}` : null);
  }
  const call = (fn, args) => Promise.race([
    db.rpc(fn, args).then(({ data, error }) => { if (error) throw error; return data; }),
    new Promise((_, no) => setTimeout(() => no(new Error('the course did not answer')), 4000))]);

  // { lesson: 'unit-02', since: '…' }. Falls back to units/CURRENT.
  async function lesson() {
    try {
      const s = await student();
      if (s) { const r = await call('course_my_lesson', { p_student: s }); if (r && r.lesson) return r; }
    } catch {}
    const cur = (await fetch(root + 'units/CURRENT', { cache: 'no-store' }).then(r => r.ok ? r.text() : '').catch(() => '')).trim();
    return { lesson: cur, since: null };
  }
  // The course server: your team's own practice data, questions and answer checks.
  async function server(body) {
    const s = await student();
    if (!s) throw new Error('This page cannot tell which team it belongs to. Open it from your GitHub Pages site.');
    const res = await fetch(COURSE_FN, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ ...body, student: s }) });
    const j = await res.json().catch(() => ({}));
    if (!res.ok) throw new Error(j.error || 'The course server did not answer. Try again in a minute.');
    return j;
  }
  const data = (dataId) => server({ action: 'data', data: dataId }).then(j => j.sql);
  const questions = (lessonId) => server({ action: 'questions', lesson: lessonId });
  // { right } — and for a breakdown question, { right, cells: { row: true/false } }.
  const check = (lessonId, question, value) => server({ action: 'check', lesson: lessonId, question, value });
  // After 3 wrong tries: close the question for good (it scores 0) and get its right answer.
  const giveUp = (lessonId, question, text) => server({ action: 'giveup', lesson: lessonId, question, text }).then(j => j.answer);
  // Reports never block the student: if the course can't be reached, the page carries on.
  async function memo(lessonId, text, submittedAt) {
    const s = await student(); if (!s) return;
    call('course_save_memo', { p_student: s, p_lesson: lessonId, p_text: text, p_submitted: submittedAt }).catch(() => {});
  }
  return { student, lesson, data, questions, check, giveUp, memo };
})();
