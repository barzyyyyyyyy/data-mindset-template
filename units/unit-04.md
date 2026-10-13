# Lesson 4 · Tasks: success and time

**The question this lesson asks:** can people do what the app is for, and how long does it take?

## 0. The class slides

Start with [the slides for this lesson](slides/04-tasks/slides.html) (arrow keys to move). The
walkthrough below assumes you have been through them.

## 1. Your task

> **Build it with your AI assistant.** In the Claude app (or [claude.ai/code](https://claude.ai/code)): **Code → + New**,
> check the chip above the message box says **Data-mindset**, and type: *"Let's start lesson 4"*.
> It walks you through everything below, one step at a time.

A usability task is a goal you give a participant: *"Find a photo of a dog and open it."* Your team
chooses **one** task for the photo app. Two ways:

- **Pick a suggested one.** Your assistant shows you a short list.
- **Say your own, in words.** Your assistant works out what reaching it looks like in the data and
  shows you the **best route**: the fewest choices that get there, step by step. If that's your
  task, approve it. If not, say it again differently, say another, or pick a suggested one.

A task must end in something the app records: a screen reached, a photo opened, a search, a like.
"Find a photo you love" can't be checked; "like the photo of the three puppies" can. It can be about
one particular photo, or any; and it must take **at least 3 choices** ("open your profile" is too
simple to tell you anything about the app).

Once you approve it, your task is saved, and your practice data is **made from it**: simulated
participants sign in and try your task. Each try is a row in a new table, **`task_runs`**
(see [the database map](units/database-map.html)). The app knows your task, so a run **ends by
itself the moment the goal is reached** (`success`); otherwise the participant gives up, or leaves.

## 2. Load the practice data

Only after your task is saved: copy the practice data with the button below and run it in Supabase.

[the practice data](data/copy.html?f=lesson-04)

## 3. Build: your task's runs, who succeeded, and how long it took

Build these on [your dashboard's **lesson 4** board](dashboard/#unit-04), **each in its own panel**:

| Panel | What it shows |
| --- | --- |
| Your task's runs | How many runs, and how they ended: success, gave up, or never ended |
| Who succeeded | Participants who succeeded **directly**, **indirectly**, or **failed** |
| Time to success | How long a successful run took, in seconds |

**Already decided**, so the questions mean the same thing for everyone:
- **A participant is a browser**, and **a participant's result is their last run** of the task.
- **Direct** = succeeded with no more choices than the best route; **indirect** = succeeded with
  more; **failed** = never reached it.

**Yours to decide**, and they are the point of this lesson:
- **Your task, and what success means**: the goal you approve in step 1.
- **Which runs, and which participants, count at all.**
- **How to find a run's choices**, for direct and indirect: the run is in `task_runs`, the choices
  are in `selections`.

**In scope:** your task, its runs, success and time. **Not yet:** questionnaires (lesson 5),
heatmaps (lesson 6).

## 4. Check yourself

Open [**Lesson 4 · Questions**](checker/?lesson=lesson-04) and answer its questions **from your
dashboard**. Some ask about things your panels don't show. That's on purpose: say what your
dashboard is missing, and build it with your assistant under **On your own**.

## 5. The memo (half a page)

Write it at the end of [Lesson 4 · Questions](checker/?lesson=lesson-04), once every question is
right or given up.
