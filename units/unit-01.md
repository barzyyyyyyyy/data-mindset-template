# Lesson 1 · The data you start with

**The question:** what exactly does the app record, and can you follow one visit through it?

## How it goes

1. **[Slides](slides/01-the-data-you-start-with/slides.html)**, in class.
2. **Your assistant leads the practice.** In the Claude app: **Code → + New**, check the chips say
   **Data-mindset** and your repository, and say ***"Let's practice lesson 1"***.
3. **[Lesson 1 · Questions](checker/?lesson=lesson-01)**, answered from [your dashboard](dashboard/#unit-01), then the memo.

## What you'll build

Build on [your dashboard's **lesson 1** board](dashboard/#unit-01):
- **Replay a visit**: paste a `session_id`, and see that visit as one timeline, oldest first: every click, choice and sign-in.

Along the way: [the database map](units/database-map.html), [a test visit](app/?test=1), and finding yourself in the raw data.

## The practice data

Your assistant tells you when. Then copy it here and run it in Supabase's SQL Editor.

[the practice data](data/copy.html?f=lesson-02)

<!-- For your assistant: the page stops here. Everything below is your brief for this lesson; the team doesn't see it on the page. -->

**The question this lesson asks:** what exactly does the app record, and can you follow one
visit through it?

Before any number, you need to know the raw rows by heart. Every number you build later is
made of them; if you misread them now, every later number inherits the mistake and nothing
will warn you.

## 0. The class slides

Start with [the slides for this lesson](slides/01-the-data-you-start-with/slides.html) (arrow keys to move). The
walkthrough below assumes you have been through them.

## 1. Load the practice data

Copy the practice data with the button below and run it in Supabase.
(The same data serves lessons 1 and 2.)

[the practice data](data/copy.html?f=lesson-02)

## 2. Read the map

Open [**The database on one page**](units/database-map.html). Then draw the
four tables and how they connect on paper, in your own words, and compare your drawing with the map.

## 3. Watch yourself being recorded

1. On [your dashboard](dashboard/#checks), press **Is capture working? → Run the check**. It must say "Capture works".
2. Open [your app as a test run](app/?test=1) and use it for a minute: open a photo,
   visit a profile, start signing up.
3. Find your visit in the dashboard's [raw `sessions` table](dashboard/#raw), then your taps in `clicks`.
   Does what you see match what you did?

## 4. Build: "Replay a visit"

> **Build it with your AI assistant.** In the Claude app (or [claude.ai/code](https://claude.ai/code)): **Code → + New**,
> check the chip above the message box says **Data-mindset**, and type: *"Let's practice lesson 1"*.
> It walks you through everything below, one step at a time.

Add a panel to [your dashboard's **lesson 1** board](dashboard/#unit-01): paste a `session_id`, and it shows that visit as one timeline,
oldest first: every click, choice and sign-in, with the time, the screen and what happened.

**Already decided:** one visit, chosen by its `session_id`; every click, choice and sign-in in it;
oldest first. **Yours to decide:** what each row of the timeline shows, and how you check the
replay is right.

This is your first view. First ask your assistant to build the example view, and see its panel appear on
[the dashboard's **Example** board](dashboard/#example): that is the whole pattern. Then build yours the same way:
- the timeline is a **view** in the `analysis` schema, with its SQL in `analysis/` and a
  one-sentence definition as its comment (your AI assistant knows the rules);
- the dashboard only displays it.

You will use this panel in every lesson after this one: it is how you check a number, by
following one participant from the raw rows to the dashboard.

**In scope:** the replay panel and its view. **Not yet:** any counting. That starts in lesson 2.

## 5. Check yourself

Open [**Lesson 1 · Questions**](checker/?lesson=lesson-01) and answer its questions. Use your replay panel for the
questions about one visit.

## 6. The memo (half a page)

Write it at the end of [Lesson 1 · Questions](checker/?lesson=lesson-01). Your draft is saved as you type.
