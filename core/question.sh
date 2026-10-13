#!/bin/sh
# Reads one question's wording from the course server, so the assistant knows what the team means
# by "question 6". Wording only: the server never sends answers. DO NOT EDIT.
# Run it as: sh core/question.sh <lesson> <number>     e.g. sh core/question.sh lesson-03 6
cd "$(dirname "$0")/.." || exit 1
[ -n "$2" ] || { echo 'usage: sh core/question.sh <lesson> <number>   e.g. sh core/question.sh lesson-03 6'; exit 1; }
FN=$(sed -n 's/^const COURSE_URL = .\(.*\).;$/\1/p' core/course-config.js)/functions/v1/course
# The team is owner/repo, the last two parts of the repository's address.
team=$(git remote get-url origin | sed 's#\.git$##; s#/*$##' | awk -F'[/:]' '{print $(NF-1) "/" $NF}')
curl -s -X POST "$FN" -H "Content-Type: application/json" \
  -d "{\"action\":\"questions\",\"lesson\":\"$1\",\"student\":\"$team\"}" |
python3 -c 'import json, sys
n = int(sys.argv[1])
try: d = json.load(sys.stdin)
except Exception: print("The course server did not answer. Try again in a minute."); sys.exit(1)
qs = d.get("questions") or []
if not qs: print(d.get("error") or "No questions for this lesson."); sys.exit(1)
if not 1 <= n <= len(qs): print(f"This lesson has {len(qs)} questions (1 to {len(qs)})."); sys.exit(1)
q = qs[n - 1]; text = q["text"]
print(f"Question {n} of {len(qs)}: {text}")
if q.get("rows"): print("Answer: a table, one box per row: " + " | ".join(q["rows"]))' "$2"
