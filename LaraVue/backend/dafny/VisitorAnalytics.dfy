datatype VisitorEvent = VisitorEvent(route: string, referrer: string, dwellSeconds: nat, consent: bool)

function AnomalyScore(e: VisitorEvent): nat
{
  (if e.dwellSeconds <= 1 then 40 else 0) +
  (if e.route == "/pricing" then 10 else 0) +
  (if e.consent then 0 else 5)
}

function TotalDwell(events: seq<VisitorEvent>): nat
{
  if |events| == 0 then 0
  else events[0].dwellSeconds + TotalDwell(events[1..])
}

function RouteCount(route: string, events: seq<VisitorEvent>): nat
{
  if |events| == 0 then 0
  else (if events[0].route == route then 1 else 0) + RouteCount(route, events[1..])
}

lemma RouteCountNonNegative(route: string, events: seq<VisitorEvent>)
  ensures RouteCount(route, events) >= 0
{
}
