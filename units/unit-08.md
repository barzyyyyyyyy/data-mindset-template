# Lesson 8 · Segmentation

**The question:** do some groups of visitors do better than others, and is the difference real?

## How it goes

1. **[Slides](slides/08-segmentation/slides.html)**, in class.
2. **Your assistant leads the practice.** In the Claude app: **Code → + New**, check the chips say
   **Data-mindset** and your repository, and say ***"Let's practice lesson 8"***.
3. **[Lesson 8 · Questions](checker/?lesson=lesson-08)**, answered from [your dashboard](dashboard/#unit-08), then the memo.

## What you'll build

Build on [your dashboard's **lesson 8** board](dashboard/#unit-08):
- **Activation**, overall: visits, how many got into the app, the rate.
- **A segment control** (device, source, new or returning) that every number follows, with sizes and warnings.

## The practice data

Your assistant tells you when. Then copy it here and run it in Supabase's SQL Editor.

[the practice data](data/copy.html?f=lesson-08)

<!-- For your assistant: the page stops here. Everything below is your brief for this lesson; the team doesn't see it on the page. -->

**The question this lesson asks:** do some groups of visitors do better than others, and is
the difference real?

## 0. The class slides

Start with [the slides for this lesson](slides/08-segmentation/slides.html) (arrow keys to move). The
walkthrough below assumes you have been through them.

## 1. Load the practice data

Copy the practice data with the button below and run it in Supabase.

[the practice data](data/copy.html?f=lesson-08)

This replaces the previous practice data. Your own test runs and real visits stay.

## 2. Build: segments, everywhere

> **Build it with your AI assistant.** In the Claude app (or [claude.ai/code](https://claude.ai/code)): **Code → + New**,
> check the chip above the message box says **Data-mindset**, and type: *"Let's practice lesson 8"*.
> It walks you through everything below, one step at a time.

The metric for this lesson is **activation**: a visit in which the person got into the app.
In the data, that is a visit with a choice (a row in `selections`) whose value is `discover`:
they logged in or signed up and reached the home screen.

Add to [your dashboard's **lesson 8** board](dashboard/#unit-08):

1. **Activation, overall:** how many visits, how many activated, the rate.
2. **A segment control** that splits visits by:
   - **device** (`platform`)
   - **source** (where the visit came from: `source`)
   - **new vs returning** (has this browser visited before?)
3. **Every number on the page follows the segment.** Nothing stays "all visits" by accident.
4. **Size next to every rate.** And a visible warning on any segment too small to trust.
   You decide what "too small" is, before you look at the results.

Before you build the control, look at what values `platform` and `source` actually take.

**In scope:** activation, the three segment types, combining two of them, sizes and warnings.
**Not yet:** funnels by step, time on screen, heatmaps.

## 3. Check yourself

Open [**Lesson 8 · Questions**](checker/?lesson=lesson-08) and answer **from your dashboard**. If a
question needs something your board doesn't show, you lead: decide what's missing, define it, and ask
your assistant to build it under **On your own**. One of the questions
compares mobile and desktop twice, in two different ways. If the two answers seem to
disagree, don't fix it: explain it in the memo.

## 4. The memo (half a page)

Write it at the end of [Lesson 8 · Questions](checker/?lesson=lesson-08). Your draft is saved as you type.
