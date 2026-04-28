module VisitorAnalytics

open FStar.Mul

type event = {
  route: string;
  referrer: string;
  dwell_seconds: nat;
  consent: bool
}

let anomaly_score (e:event) : nat =
  (if e.dwell_seconds <= 1 then 40 else 0) +
  (if e.route = "/pricing" then 10 else 0) +
  (if e.consent then 0 else 5)

let total_dwell (xs:list event) : Tot nat =
  FStar.List.Tot.fold_left (fun acc e -> acc + e.dwell_seconds) 0 xs

let rec route_count (r:string) (xs:list event) : Tot nat =
  match xs with
  | [] -> 0
  | x::tl -> (if x.route = r then 1 else 0) + route_count r tl

let lemma_route_count_nonnegative (r:string) (xs:list event) : Lemma (route_count r xs >= 0)
  = ()
