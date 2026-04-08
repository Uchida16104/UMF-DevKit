module UMFVerification

open FStar.Mul
open FStar.List.Tot

val fibonacci : n:nat -> Tot nat (decreases n)
let rec fibonacci n =
  if n = 0 then 0
  else if n = 1 then 1
  else fibonacci (n - 1) + fibonacci (n - 2)

val fibonacci_positive : n:nat -> Lemma (fibonacci n >= 0)
let fibonacci_positive n = ()

val fibonacci_base_0 : unit -> Lemma (fibonacci 0 = 0)
let fibonacci_base_0 () = ()

val fibonacci_base_1 : unit -> Lemma (fibonacci 1 = 1)
let fibonacci_base_1 () = ()

val factorial : n:nat -> Tot pos
let rec factorial n =
  if n = 0 then 1
  else n * factorial (n - 1)

val factorial_positive : n:nat -> Lemma (factorial n >= 1)
let rec factorial_positive n =
  if n = 0 then ()
  else factorial_positive (n - 1)

val power : base:nat -> exp:nat -> Tot nat
let rec power base exp =
  if exp = 0 then 1
  else base * power base (exp - 1)

val power_zero_exp : base:nat -> Lemma (power base 0 = 1)
let power_zero_exp base = ()

val power_one_exp : base:nat -> Lemma (power base 1 = base)
let power_one_exp base = ()

val sum_list : list nat -> Tot nat
let rec sum_list lst =
  match lst with
  | [] -> 0
  | hd :: tl -> hd + sum_list tl

val sum_list_empty : unit -> Lemma (sum_list [] = 0)
let sum_list_empty () = ()

val sum_list_single : n:nat -> Lemma (sum_list [n] = n)
let sum_list_single n = ()

val max_nat : a:nat -> b:nat -> Tot nat
let max_nat a b = if a >= b then a else b

val max_nat_comm : a:nat -> b:nat -> Lemma (max_nat a b = max_nat b a)
let max_nat_comm a b = ()

val max_nat_idempotent : a:nat -> Lemma (max_nat a a = a)
let max_nat_idempotent a = ()

val gcd : a:pos -> b:pos -> Tot pos (decreases (a + b))
let rec gcd a b =
  if a = b then a
  else if a > b then gcd (a - b) b
  else gcd a (b - a)

val gcd_comm : a:pos -> b:pos -> Lemma (gcd a b = gcd b a)
let rec gcd_comm a b =
  if a = b then ()
  else if a > b then gcd_comm (a - b) b
  else gcd_comm a (b - a)

val is_even : n:nat -> Tot bool
let is_even n = n % 2 = 0

val is_odd : n:nat -> Tot bool
let is_odd n = n % 2 = 1

val even_not_odd : n:nat -> Lemma (is_even n ==> not (is_odd n))
let even_not_odd n = ()

val sum_evens_even : a:nat -> b:nat ->
  Lemma (requires is_even a /\ is_even b)
        (ensures is_even (a + b))
let sum_evens_even a b = ()
