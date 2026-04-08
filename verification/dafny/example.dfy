module UMFVerification {

  function Fibonacci(n: nat): nat
    decreases n
  {
    if n == 0 then 0
    else if n == 1 then 1
    else Fibonacci(n - 1) + Fibonacci(n - 2)
  }

  lemma FibonacciPositive(n: nat)
    ensures Fibonacci(n) >= 0
  {}

  lemma FibonacciMonotone(n: nat)
    requires n >= 1
    ensures Fibonacci(n) >= Fibonacci(n - 1)
    decreases n
  {
    if n == 1 {
    } else {
      FibonacciMonotone(n - 1);
    }
  }

  method ComputeFibonacci(n: nat) returns (result: nat)
    ensures result == Fibonacci(n)
  {
    if n == 0 {
      result := 0;
    } else {
      var a: nat := 0;
      var b: nat := 1;
      var i: nat := 1;
      while i < n
        invariant 1 <= i <= n
        invariant a == Fibonacci(i - 1)
        invariant b == Fibonacci(i)
        decreases n - i
      {
        var tmp := a + b;
        a := b;
        b := tmp;
        i := i + 1;
      }
      result := b;
    }
  }

  method BinarySearch(arr: array<int>, target: int) returns (index: int)
    requires arr != null
    requires forall i, j :: 0 <= i < j < arr.Length ==> arr[i] <= arr[j]
    ensures index == -1 || (0 <= index < arr.Length && arr[index] == target)
    ensures index == -1 ==> forall k :: 0 <= k < arr.Length ==> arr[k] != target
  {
    var lo: int := 0;
    var hi: int := arr.Length - 1;
    index := -1;

    while lo <= hi
      invariant 0 <= lo
      invariant hi < arr.Length
      invariant forall k :: 0 <= k < lo ==> arr[k] != target
      invariant forall k :: hi < k < arr.Length ==> arr[k] != target
      decreases hi - lo + 1
    {
      var mid := lo + (hi - lo) / 2;
      if arr[mid] == target {
        index := mid;
        return;
      } else if arr[mid] < target {
        lo := mid + 1;
      } else {
        hi := mid - 1;
      }
    }
  }

  method InsertionSort(arr: array<int>)
    requires arr != null
    modifies arr
    ensures forall i, j :: 0 <= i < j < arr.Length ==> arr[i] <= arr[j]
    ensures arr.Length == old(arr.Length)
  {
    var i := 1;
    while i < arr.Length
      invariant 1 <= i <= arr.Length
      invariant forall p, q :: 0 <= p < q < i ==> arr[p] <= arr[q]
      decreases arr.Length - i
    {
      var key := arr[i];
      var j := i - 1;
      while j >= 0 && arr[j] > key
        invariant -1 <= j < i
        invariant forall p, q :: 0 <= p < q < i && q != j + 1 ==> arr[p] <= arr[q]
        decreases j + 1
      {
        arr[j + 1] := arr[j];
        j := j - 1;
      }
      arr[j + 1] := key;
      i := i + 1;
    }
  }

  method Main() {
    var fib10 := ComputeFibonacci(10);
    print "Fibonacci(10) = ", fib10, "\n";

    var arr := new int[5];
    arr[0] := 1; arr[1] := 3; arr[2] := 5; arr[3] := 7; arr[4] := 9;
    var idx := BinarySearch(arr, 5);
    print "BinarySearch([1,3,5,7,9], 5) = index ", idx, "\n";
  }
}
