#!/bin/sh
# Lesson 4: the team's task, through the course server. DO NOT EDIT.
#   sh core/task.sh menu                          the suggested tasks, each with its best route
#   sh core/task.sh photos                        the photos a task can name, by screen, with what they show
#   sh core/task.sh route '<marks>'               the best route for a goal (nothing is saved)
#   sh core/task.sh save "<the task in words>" '<marks>'   save the team's task (only after they approved it)
#   sh core/task.sh show                          the team's saved task
# <marks> is the success criteria: a JSON list of the choices, in order, that make the task a success,
# each { "value": ..., "step": ... } as in selections ("step" optional; a value ending in * means "starts
# with"; alternatives joined by |). Example: '[{"value":"search:dog*","step":"search"},{"value":"open:*","step":"search_results"}]'
cd "$(dirname "$0")/.." || exit 1
FN=$(sed -n 's/^const COURSE_URL = .\(.*\).;$/\1/p' core/course-config.js)/functions/v1/course
team=$(git remote get-url origin | sed 's#\.git$##; s#/*$##' | awk -F'[/:]' '{print $(NF-1) "/" $NF}')
op=$1
case "$op" in menu|show|photos) ;; route) [ -n "$2" ] || op=;; save) [ -n "$3" ] || op=;; *) op=;; esac
[ -n "$op" ] || { sed -n '3,10p' "$0" | sed 's/^# //'; exit 1; }
[ "$op" = show ] && op=get
python3 - "$FN" "$team" "$op" "$2" "$3" <<'PY'
import json, sys, urllib.request
fn, team, op, a, b = sys.argv[1:6]
body = {'action': 'task', 'lesson': 'lesson-04', 'student': team, 'op': op}
try:
    if op == 'route': body['marks'] = json.loads(a)
    if op == 'save': body['words'], body['marks'] = a, json.loads(b)
except ValueError:
    print('The marks are not valid JSON. Example: \'[{"value":"open:*","step":"discover"}]\''); sys.exit(1)
req = urllib.request.Request(fn, json.dumps(body).encode(), {'Content-Type': 'application/json'})
try: j = json.load(urllib.request.urlopen(req, timeout=20))
except urllib.error.HTTPError as e:
    try: print('NOT DONE: ' + json.load(e).get('error', str(e)))
    except Exception: print('NOT DONE: the course server answered ' + str(e.code))
    sys.exit(1)
except Exception: print('The course server did not answer. Try again in a minute.'); sys.exit(1)

def show(t):
    if not t.get('reachable'):
        print('UNREACHABLE: no route in the app makes these choices. Nobody could complete this task.'); return
    if t.get('tooShort'):
        print('TOO SIMPLE: the best route is ' + str(t['length']) + ' choice(s): ' + ' -> '.join(t['steps']) + '. A task needs at least 3.'); return
    print('Best route (' + str(t['length']) + ' choices): ' + ' -> '.join(t['steps']))
    print('Success means: ' + ', then '.join(t['success']) + '.')

if op == 'photos':
    for screen, ps in j['photos'].items():
        print(screen + ':')
        for pid, what in ps.items(): print(f'  {pid}  {what}')
elif op == 'menu':
    for i, t in enumerate(j['tasks'], 1):
        print(f'{i}. {t["words"]}'); print('   marks: ' + json.dumps(t['marks'])); show(t); print()
elif op == 'get':
    if j.get('none'): print('NO TASK YET: this team has not saved a task.')
    else:
        print('Task: ' + j['words']); print('marks: ' + json.dumps(j['marks'])); show(j)
        print('LOCKED (questions started): it can no longer change.' if j.get('locked') else 'Not locked: it can still change, until a question is checked.')
elif op == 'route': show(j)
else: print('SAVED: "' + j['words'] + '"'); show(j); print('Next: the team loads this lesson\'s practice data (made from this task).')
PY
