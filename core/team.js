// =====================================================================
// The team's own files. DO NOT EDIT.
// <script src="core/team.js" data-file="supabase-config.js"></script> loads that file from the
// team's site: from the team's own address when the page is the course's central copy (see
// core/central.js), or from this same site otherwise. Always a fresh copy: the site lets browsers
// keep a file for 10 minutes, which would hide a panel the assistant just published.
// =====================================================================
(function () {
  var me = document.currentScript, file = me.getAttribute('data-file');
  var team = window.COURSE_TEAM;
  var src = team ? team.base + file : new URL('../' + file, me.src).href;
  src += (src.indexOf('?') < 0 ? '?' : '&') + 'v=' + Date.now();
  // The board straight from the team's repository (GitHub's API has it the moment the assistant
  // saves; the site takes about a minute to rebuild). The API allows 60 reads an hour per network:
  // past that, or for any other file, the site's copy as before.
  var repo = team && team.site;
  if (!repo) { var m = location.hostname.match(/^([^.]+)\.github\.io$/), seg = location.pathname.split('/')[1];
    if (m && seg) repo = m[1] + '/' + seg; }
  if (repo && file === 'dashboard/boards.js') {
    try {
      var x = new XMLHttpRequest();
      x.open('GET', 'https://api.github.com/repos/' + repo + '/contents/' + file + '?ref=main&t=' + Date.now(), false);
      x.setRequestHeader('Accept', 'application/vnd.github.raw');
      x.send();
      if (x.status === 200 && x.responseText) {
        document.write('<script>' + x.responseText.replace(/<\/script/gi, '<\\/script') + '\n<\/script>');
        return;
      }
    } catch (e) {}
  }
  document.write('<script src="' + src.replace(/"/g, '') + '"><\/script>');
})();
