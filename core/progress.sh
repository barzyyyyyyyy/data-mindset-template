#!/bin/sh
# Prints where the team stands: the lesson, its checker answers and memo (table coursework),
# what is built (views in analysis/, panels per board) and the last steps saved.
# DO NOT EDIT. Run it as: sh core/progress.sh
cd "$(dirname "$0")/.." || exit 1
URL=$(sed -n "s/^const SUPABASE_URL = '\(.*\)';/\1/p" supabase-config.js)
KEY=$(sed -n "s/^const SUPABASE_PUBLISHABLE_KEY = '\(.*\)';/\1/p" supabase-config.js)
. ./core/course.sh
# Can this session build in the database? Checked first, so no work starts in a session that can't finish it.
if [ -z "$SUPABASE_SECRET_KEY" ]; then
  echo "Building: NO KEY. This session has no SUPABASE_SECRET_KEY: it is not running in the Data-mindset environment (or the key is missing there)."
else
  code=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$URL/rest/v1/rpc/analysis_apply" -H "apikey: $SUPABASE_SECRET_KEY" \
    -H "Authorization: Bearer $SUPABASE_SECRET_KEY" -H "Content-Type: application/json" -d '{"p_sql":"select 1"}')
  case "$code" in 200) echo "Building: ready";;
    401|403) echo "Building: KEY REFUSED. The secret key in the Data-mindset environment is wrong (setup step 7).";;
    *) echo "Building: NOT READY (the database answered $code; run the setup again, step 5).";; esac
fi
L=$(course_lesson 2>/dev/null)
case "$L" in *lesson*) echo "Current lesson (set by the lecturer): $L";; *) echo "Current lesson: $(cat units/CURRENT) (the course could not be reached)";; esac
# Which lesson's practice data is in the database (the data marks itself when it is loaded).
loaded=$(curl -s "$URL/rest/v1/coursework?select=answer,updated_at&lesson=eq.practice-data&question=eq.loaded" -H "apikey: $KEY" | python3 -c "
import json, sys
try:
    r = json.load(sys.stdin)
    print(r[0]['answer'] + ' (loaded ' + r[0]['updated_at'][:16].replace('T', ' ') + ' UTC)' if r else 'unknown (none loaded since this check was added)')
except Exception:
    print('unknown')")
echo "Practice data in the database: $loaded"
# Each lesson's questions as the course has them now (old answers to removed questions don't count).
curl -s "$URL/rest/v1/coursework?select=lesson,question,is_right,submitted_at,answer&lesson=neq.practice-data" -H "apikey: $KEY" |
STUDENT_ID="$STUDENT_ID" FN="$COURSE_URL/functions/v1/course" python3 -c '
import json, os, sys, urllib.request
try: rows = json.load(sys.stdin)
except Exception: print("Questions: could not reach the database."); sys.exit(0)
if not isinstance(rows, list) or not rows: print("Questions: nothing answered yet."); sys.exit(0)
for lesson in sorted({r["lesson"] for r in rows}):
    mine = {r["question"]: r for r in rows if r["lesson"] == lesson}
    try:
        req = urllib.request.Request(os.environ["FN"], json.dumps({"action": "questions", "lesson": lesson, "student": os.environ["STUDENT_ID"]}).encode(), {"Content-Type": "application/json"})
        qs = json.load(urllib.request.urlopen(req, timeout=10))["questions"]
    except Exception:
        print(f"{lesson}: could not reach the course server."); continue
    open_ = [str(i + 1) for i, q in enumerate(qs) if not (mine.get(q["id"], {}).get("is_right") or q["id"] + ":gaveup" in mine)]
    memo = mine.get("memo")
    memo_state = "submitted" if memo and memo.get("submitted_at") else "draft, not submitted" if memo and (memo.get("answer") or "").strip() else "not started"
    done, still = len(qs) - len(open_), ", ".join(open_)
    print(f"{lesson} questions: {done} of {len(qs)} right or given up." + (f" Still open (numbers as on the page): {still}. Not memo time yet." if open_ else " All done.") + f" Memo: {memo_state}.")
'
echo

# What is built so far, from the repository: carry on from here, don't start the lesson over.
echo "Views built (analysis/), with their definitions:"
python3 - <<'EOF'
import glob, re
files = sorted(glob.glob('analysis/*.sql'))
if not files: print('  none yet')
for f in files:
    m = re.search(r"comment on view\s+\S+\s+is\s+'((?:[^']|'')*)'", open(f).read(), re.I | re.S)
    print(f"  {f[9:-4]}: " + (m.group(1).replace("''", "'").replace('\n', ' ') if m else '(no definition)'))
print('Panels on the dashboard (dashboard/boards.js):')
src = open('dashboard/boards.js').read()
for key, body in re.findall(r"^  '?([\w-]+)'?: \[(.*?)^  \]", src, re.M | re.S):
    titles = re.findall(r"title: '((?:[^'\\]|\\.)*)'", body)
    labels = re.findall(r"label: '((?:[^'\\]|\\.)*)'", body)
    print(f"  {key}: " + (', '.join(titles) or 'none') + (f" (numbers: {', '.join(labels)})" if labels else ''))
EOF
echo "The team's last steps (changes to analysis/ and the panels):"
git log --format='  %ad  %s' --date=format:'%b %d %H:%M' -8 --no-merges -- analysis dashboard/boards.js
