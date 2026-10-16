// ===================================================================
// YOUR PANELS. This file is yours; the dashboard page itself is the course's.
// One list per lesson; a panel is { title, view, render(el) }, plus own: true for a panel the
// team added on its own (beyond the exercise): it shows under "On your own" on the lesson board.
// render(el) fills the card's body, reading ONE view in `analysis`:
//   db.schema('analysis').from('<view>').select('*')
// The page shows numbers; the view does the counting.
// ===================================================================
const BOARDS = {
  example: [
    { title: 'Taps per screen', view: 'example_taps_per_screen', render: async (el) => {
        const { data, error } = await db.schema('analysis').from('example_taps_per_screen')
          .select('*').order('taps', { ascending: false });
        if (error) { el.innerHTML = '<p class="muted">Ask your assistant to build <code>analysis/example_taps_per_screen.sql</code> to see this example.</p>'; return; }
        el.innerHTML = `<div class="scroll"><table><thead><tr><th>app</th><th>screen</th><th>taps</th></tr></thead><tbody>${
          data.map(r => `<tr><td>${esc(r.app)}</td><td>${esc(r.screen)}</td><td class="num">${r.taps}</td></tr>`).join('')}</tbody></table></div>`;
      } }
  ],
  'unit-01': [
    { title: 'Replay a visit', view: 'visit_events', render: async (el) => {
        el.innerHTML = `<p class="muted">Every click, choice and sign-in of one visit, oldest first. Any visit (tests and practice data included).</p>
          <p><input id="replay-id" placeholder="paste a session_id" style="width:100%;max-width:360px">
          <button id="replay-go">Replay</button></p><div id="replay-out"></div>`;
        const out = el.querySelector('#replay-out');
        const go = async () => {
          const id = el.querySelector('#replay-id').value.trim();
          if (!id) { out.innerHTML = ''; return; }
          const { data, error } = await db.schema('analysis').from('visit_events')
            .select('*').eq('session_id', id)
            .order('at', { ascending: true }).order('kind_order', { ascending: true });
          if (error) { out.innerHTML = `<p class="muted">${esc(error.message)}</p>`; return; }
          if (!data.length) { out.innerHTML = '<p class="muted">No clicks, choices or sign-ins for this session_id.</p>'; return; }
          out.innerHTML = `<div class="scroll"><table><thead><tr><th>when</th><th>screen</th><th>what happened</th><th>who</th><th>browser</th></tr></thead><tbody>${
            data.map(r => `<tr><td>${esc(new Date(r.at).toLocaleString())}</td><td>${esc(r.screen ?? '')}</td><td>${esc(r.what_happened)}</td><td>${esc(r.who ?? '')}</td><td>${esc(r.browser ?? '')}</td></tr>`).join('')}</tbody></table></div>`;
        };
        el.querySelector('#replay-go').addEventListener('click', go);
        el.querySelector('#replay-id').addEventListener('keydown', (e) => { if (e.key === 'Enter') go(); });
      } }
  ],
  'unit-02': [],
  'unit-03': [],
  'unit-04': [],
  'unit-08': []
};

