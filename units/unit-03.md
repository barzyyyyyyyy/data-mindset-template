# Lesson 3 · Funnels and drop-off

**The question:** where do people give up on registration?

## How it goes

1. **[Slides](slides/03-funnels/slides.html)**, in class.
2. **Your assistant leads the practice.** In the Claude app: **Code → + New**, check the chips say
   **Data-mindset** and your repository, and say ***"Let's practice lesson 3"***.
3. **[Lesson 3 · Questions](checker/?lesson=lesson-03)**, answered from [your dashboard](dashboard/#unit-03), then the memo.

## What you'll build

Build on [your dashboard's **lesson 3** board](dashboard/#unit-03):
- **The start screen**: Log in, Register, or left without choosing.
- **The registration funnel**: each step, its % of the step before and of the first step.

## The practice data

Your assistant tells you when. Then copy it here and run it in Supabase's SQL Editor.

[the practice data](data/copy.html?f=lesson-03)

<!-- For your assistant: the page stops here. Everything below is your brief for this lesson; the team doesn't see it on the page. -->

**The question this lesson asks:** where do people give up on registration?

## 0. The class slides

Start with [the slides for this lesson](slides/03-funnels/slides.html) (arrow keys to move). The
walkthrough below assumes you have been through them.

## 1. Load the practice data

Copy the practice data with the button below and run it in Supabase. It replaces the previous
practice data; your own test runs and real visits stay.

[the practice data](data/copy.html?f=lesson-03)

## 2. Build: the start screen, and the registration funnel

> **Build it with your AI assistant.** In the Claude app (or [claude.ai/code](https://claude.ai/code)): **Code → + New**,
> check the chip above the message box says **Data-mindset**, and type: *"Let's practice lesson 3"*.
> It walks you through everything below, one step at a time.

Every visit opens on the **start screen** (`start`), and goes one of three ways: **Log in**, for
people who already have an account; **Register**, the registration funnel; or neither. Registering
takes two screens: **email and password** (`register_email`), then **username** (`register_username`),
whose **Sign up** button leads into the app (`discover`).

Build these on [your dashboard's **lesson 3** board](dashboard/#unit-03), **each in its own panel**:

| Panel | What it shows |
| --- | --- |
| The start screen | Visits, and how many chose Log in, chose Register, or left without choosing |
| The registration funnel | One row per step, from where you decide it starts to getting into the app: how many reached it, its **% of the step before**, and its **% of the first step** |

**Yours to decide**, and they are the point of this lesson. Your assistant asks, and helps you find
them, but doesn't decide for you:
- **Where your funnel starts.** Every visit to the start screen, or something narrower?
- **What counts as reaching a step.** Which record in the data shows that a visit got there?
- **Visits or clicks.** What exactly does each step count?
- **Which visits count at all.**

Your assistant asks what each number should count, asks about anything you left open, and writes
the sentence from what you said.

**In scope:** the start screen, the registration funnel, and anything you need to check them.
**Not yet:** time on each screen, heatmaps. Those come in later lessons. (A question may ask you to split a number, by device for example: build that On your own. Segments get their full lesson in lesson 8.)

## 3. Check yourself

Open [**Lesson 3 · Questions**](checker/?lesson=lesson-03) and answer its questions **from your
dashboard**. The first two are your two panels: use **Copy table** on the panel, then paste.

Some questions ask about things your panels don't show. That's on purpose. **Now you lead:**
decide what your dashboard is missing, say what it should count, and ask your assistant to build
it. It goes on your board under **On your own**. Answer from the dashboard, never from a one-off
count.

## 4. The memo (half a page)

Write it at the end of [Lesson 3 · Questions](checker/?lesson=lesson-03). Your draft is saved as you type.
