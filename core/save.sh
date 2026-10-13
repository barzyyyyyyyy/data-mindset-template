#!/bin/sh
# Saves the team's work and publishes it to their site, in one step: commit everything, bring in
# whatever is already on main, push to main. DO NOT EDIT.
# Run it as: sh core/save.sh "what changed, in a few words"
cd "$(dirname "$0")/.." || exit 1
msg=${1:-"Update the analysis"}
git add -A
git diff --cached --quiet || git commit -q -m "$msg" || { echo "Could not save."; exit 1; }
git fetch -q origin main 2>/dev/null && { git merge -q --no-edit FETCH_HEAD >/dev/null 2>&1 || { git merge --abort 2>/dev/null; echo "Could not combine with what is on main: resolve it, then run this again."; exit 1; }; }
# One push for both: main (the site) and the session's own branch, so the session never has to
# push its branch separately afterwards.
branch=$(git rev-parse --abbrev-ref HEAD)
if [ "$branch" = main ] || [ "$branch" = HEAD ]; then targets="HEAD:main"; else targets="HEAD:main HEAD:refs/heads/$branch"; fi
git push -q origin $targets && echo "SAVED: published. The dashboard shows new panels at once (refresh it)." || { echo "Could not publish. Try again."; exit 1; }
