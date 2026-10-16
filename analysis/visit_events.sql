create or replace view analysis.visit_events as
  with events as (
    select session_id, created_at as at, 1 as kind_order, 'click: ' || hit as what_happened
    from public.clicks
    union all
    select session_id, created_at, 2, 'choice: ' || value
    from public.selections
    union all
    select session_id, created_at, 0, 'sign-in'
    from public.identities
  )
  select e.session_id,
         e.at,
         e.kind_order,
         e.what_happened,
         (select i.account from public.identities i
           where i.session_id = e.session_id and i.created_at <= e.at
           order by i.created_at desc limit 1) as who,
         s.browser
  from events e
  join public.sessions s using (session_id);

comment on view analysis.visit_events is
  'We list every click, choice and sign-in of one visit, oldest first, from every visit, excluding nothing; each line shows when it happened, what happened (a click by where it landed, a choice by its value), who did it (the account signed in, from the sign-in onward) and the kind of browser.';
