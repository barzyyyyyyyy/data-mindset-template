#!/bin/sh
# Brings in the course's latest updates: new lessons, slides, the lesson that is open, fixes.
# DO NOT EDIT. Run it as: sh core/update.sh
# Your own files (dashboard/boards.js, analysis/, SITE, supabase-config.js) are never touched
# by the course, so the update merges cleanly.
cd "$(dirname "$0")/.." || exit 1
COURSE=${COURSE:-https://github.com/asafbarzilay-web/data-mindset-template.git}
before=$(git rev-parse HEAD)
# First whatever is already on the team's own main (another session's work, the lecturer's fixes).
git fetch -q origin main 2>/dev/null && { git merge -q --no-edit FETCH_HEAD >/dev/null 2>&1 || git merge --abort 2>/dev/null; }
git fetch -q "$COURSE" main 2>/dev/null || { echo "Could not reach the course. Try again later."; exit 1; }
# A copy that was not forked from the course gets its updates from the lecturer instead.
rules() { git diff --quiet "$before" HEAD -- CLAUDE.md 2>/dev/null || echo "RULES CHANGED: re-read CLAUDE.md now, before anything else, and follow the new version from here on."; }
git merge-base HEAD FETCH_HEAD >/dev/null 2>&1 || {
  [ "$(git rev-parse HEAD)" = "$before" ] && echo "Already up to date." || { echo "Updated:"; git log --oneline "$before..HEAD" | head -10; }
  rules; echo "Current lesson: $(cat units/CURRENT)"; exit 0; }
git merge --no-edit FETCH_HEAD >/dev/null 2>&1 || { git merge --abort 2>/dev/null; echo "Could not bring in the course update. Ask your lecturer."; exit 1; }
if [ "$(git rev-parse HEAD)" = "$before" ]; then echo "Already up to date."; else
  echo "Course updated:"; git log --oneline "$before..HEAD" | head -10
  git push -q origin HEAD:main && echo "Published to your site."; fi
rules
echo "Current lesson: $(cat units/CURRENT)"
