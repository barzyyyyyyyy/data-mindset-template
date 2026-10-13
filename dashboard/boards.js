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
  'unit-01': [],
  'unit-02': [],
  'unit-03': [],
  'unit-04': [],
  'unit-08': []
};

