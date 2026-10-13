// =====================================================================
// Central course pages. DO NOT EDIT.
// Every course page on a team's site loads this file from the COURSE's site (not the team's own
// copy), first thing. It sends the visit to the course's own, always up-to-date copy of the same
// page, carrying the team's address as ?site=owner/repo. There the page reads the team's own files
// (supabase-config.js, dashboard/boards.js) from the team's site (see core/team.js), and links keep
// carrying ?site. The app stays on the team's site: participants never leave it.
//
// Kill switch: make this file empty (or set ENABLED = false) and every team's site shows its own
// local copy of each page again, at once.
// =====================================================================
(function () {
  var ENABLED = true;
  // While testing: only these teams use the central pages (empty = every team).
  var ONLY = [];
  var HOST = 'asafbarzilay-web.github.io', BASE = '/data-mindset-template/';
  if (!ENABLED) return;
  var onCentral = location.hostname === HOST && location.pathname.indexOf(BASE) === 0;

  if (!onCentral) {
    // A team's own site (owner.github.io/repo/...): go to the course's copy of this page.
    if (!/\.github\.io$/.test(location.hostname)) return;          // a local copy (localhost): stay
    var parts = location.pathname.split('/');                      // ['', repo, ...rest]
    var owner = location.hostname.split('.')[0], repo = parts[1];
    if (!repo) return;
    if (ONLY.length && ONLY.indexOf((owner + '/' + repo).toLowerCase()) < 0) return;
    var q = new URLSearchParams(location.search);
    q.set('site', owner + '/' + repo);
    location.replace('https://' + HOST + BASE + parts.slice(2).join('/') + '?' + q.toString() + location.hash);
    return;
  }

  // On the course's copy: which team is this for? This tab remembers it (until the tab is closed), so
  // a page opened here without ?site still shows the same team.
  var site = new URLSearchParams(location.search).get('site'), KEY = 'course-site';
  var valid = function (x) { return !!x && /^[\w.-]+\/[\w.-]+$/.test(x); };
  if (!valid(site)) {
    var kept = null;
    try { kept = sessionStorage.getItem(KEY); } catch (e) {}
    if (valid(kept)) {
      var back = new URLSearchParams(location.search); back.set('site', kept);
      location.replace(location.pathname + '?' + back.toString() + location.hash);
    }
    return;                                                        // the course's own original
  }
  try { sessionStorage.setItem(KEY, site); } catch (e) {}
  var teamBase = 'https://' + site.split('/')[0].toLowerCase() + '.github.io/' + site.split('/')[1] + '/';
  window.COURSE_TEAM = { site: site, base: teamBase };

  // Links: course pages keep ?site; the app always opens on the team's own site.
  function fix(a) {
    if (!a || !a.getAttribute('href')) return;
    var u;
    try { u = new URL(a.getAttribute('href'), location.href); } catch (e) { return; }
    if (u.hostname !== HOST || u.pathname.indexOf(BASE) !== 0) return;
    var rest = u.pathname.slice(BASE.length);
    if (rest.indexOf('app/') === 0) { a.href = teamBase + rest + u.search + u.hash; return; }
    if (!u.searchParams.get('site')) { u.searchParams.set('site', site); a.href = u.toString(); }
  }
  ['mousedown', 'click', 'auxclick', 'focusin', 'touchstart'].forEach(function (ev) {
    document.addEventListener(ev, function (e) { fix(e.target && e.target.closest && e.target.closest('a[href]')); }, true);
  });
})();
