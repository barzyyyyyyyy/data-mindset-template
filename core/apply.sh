#!/bin/sh
# Builds the team's analysis in their database: sends each file in analysis/ to it. DO NOT EDIT.
# Run it as: sh core/apply.sh                 (every file in analysis/)
#        or: sh core/apply.sh analysis/x.sql  (just those)
# Needs SUPABASE_SECRET_KEY in the Claude cloud environment (setup step 7). Never prints the key.
# Then it saves and publishes everything (core/save.sh), built or not, so no work is ever lost.
cd "$(dirname "$0")/.." || exit 1
URL=$(sed -n "s/^const SUPABASE_URL = '\(.*\)';/\1/p" supabase-config.js)
case "$URL" in *YOUR-*|"") echo "NOT CONNECTED: supabase-config.js still has the placeholders (setup step 8)."; exit 1;; esac
[ -n "$SUPABASE_SECRET_KEY" ] || { echo "NO KEY: this environment has no SUPABASE_SECRET_KEY. Add it to the cloud environment (setup step 7), then start a new session."; exit 1; }

files="$*"; [ -n "$files" ] || files=$(ls analysis/*.sql 2>/dev/null)
[ -n "$files" ] || { echo "Nothing to build: analysis/ has no .sql files."; exit 0; }

# The rules every file must follow, checked before anything reaches the database: one view in
# `analysis`, named after its file, with its definition attached, and nothing else (no tables, no
# copies of data, no changes to rows). A file that breaks them is not built.
lint() {   # $1 = file; prints what is wrong, or nothing
  python3 - "$1" <<'PYLINT'
import re, sys
f = sys.argv[1]; name = re.sub(r'\.sql$', '', f.split('/')[-1])
sql = open(f).read()
code = re.sub(r"'(?:[^']|'')*'", "''", sql)              # strings out: definitions may say anything
code = re.sub(r'--[^\n]*', '', code).lower()
problems = []
if not re.search(r'create\s+or\s+replace\s+view\s+analysis\.' + re.escape(name.lower()) + r'\b', code):
    problems.append(f'it must create the view analysis.{name} (named after the file)')
if not re.search(r'comment\s+on\s+view\s+analysis\.' + re.escape(name.lower()) + r'\s+is\s+\'', code):
    problems.append(f'it must attach the definition: comment on view analysis.{name} is \'We count …\'')
others = re.findall(r'create\s+or\s+replace\s+view\s+analysis\.(\w+)', code)
if any(o != name.lower() for o in others): problems.append('one view per file: it creates another view too')
for word in ('create table', 'materialized', 'insert ', 'update ', 'delete ', 'truncate', 'alter ', 'grant ', 'revoke ', 'create function', 'create schema'):
    if word in code: problems.append(f'only a view and its comment belong here (found "{word.strip()}")')
print('; '.join(problems))
PYLINT
}

send() {   # $1 = file; prints the HTTP status, then the answer
  python3 -c 'import json,sys;print(json.dumps({"p_sql":open(sys.argv[1]).read()}))' "$1" |
    curl -s -w '\n%{http_code}' -X POST "$URL/rest/v1/rpc/analysis_apply" \
      -H "apikey: $SUPABASE_SECRET_KEY" -H "Authorization: Bearer $SUPABASE_SECRET_KEY" \
      -H "Content-Type: application/json" --data-binary @-
}
# A view built on another view needs that one first: keep passing over what failed while it helps.
bad=0
for f in $files; do
  why=$(lint "$f")
  [ -n "$why" ] && { echo "NOT BUILT $f: $why"; bad=1; }
done
save() { sh core/save.sh "Build $(echo $files | sed 's#analysis/##g; s#\.sql##g')"; }
[ $bad = 1 ] && { echo "Fix these files first; nothing was built."; save; exit 1; }
left="$files"
while [ -n "$left" ]; do
  failed=""
  for f in $left; do
    code=$(send "$f" | tail -1)
    case "$code" in 200) echo "OK   $f";;
      401|403) echo "FAIL the secret key was refused: check SUPABASE_SECRET_KEY in the cloud environment (setup step 7)."; exit 1;;
      404) echo "FAIL your database has no analysis_apply: run the setup again (setup step 5)."; exit 1;;
      *) failed="$failed $f";; esac
  done
  [ "$failed" = "$left" ] && break
  left=$failed
done
[ -z "$left" ] && { echo "ALL BUILT"; save; exit 0; }
for f in $left; do
  echo "FAIL $f: $(send "$f" | sed '$d' | python3 -c 'import json,sys
try: print(json.load(sys.stdin).get("message", "unknown error"))
except Exception: print("unknown error")')"
done
save
exit 1
