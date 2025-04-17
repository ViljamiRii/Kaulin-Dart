## Kaulin Dart Exercises

### Exercise 1: Sum of Two Numbers

Write a function `summa(a, b)` that returns the sum of two integers.

#### Input
Two integers `a` and `b`.

#### Output
Return the integer result of `a + b`.

#### Example
```
summa(3, 5) → 8
```

#### Solution
```kaulin
funktio summa(a, b) {
  paluu a + b;
}
```

---

### Exercise 2: Is the Number Even?

Write a function `onko_parillinen(x)` that returns `tosi` if `x` is even, otherwise `epätosi`.

#### Example
```
onko_parillinen(4) → tosi
onko_parillinen(7) → epätosi
```

#### Solution
```kaulin
funktio onko_parillinen(x) {
  paluu x % 2 == 0;
}
```

---

### Exercise 3: Maximum of Three Numbers

Write a function `maksimi(a, b, c)` that returns the greatest of the three numbers.

#### Example
```
maksimi(2, 5, 3) → 5
```

#### Solution
```kaulin
funktio maksimi(a, b, c) {
  muuttuja max = a;
  jos (b > max) max = b;
  jos (c > max) max = c;
  paluu max;
}
```

---

### Exercise 4: Factorial

Write a function `kertoma(n)` that returns the factorial of a non-negative integer `n`.

#### Example
```
kertoma(5) → 120
```

#### Solution
```kaulin
funktio kertoma(n) {
  muuttuja tulos = 1;
  toista (muuttuja i = 1; i <= n; i = i + 1) {
    tulos = tulos * i;
  }
  paluu tulos;
}
```

---

### Exercise 5: Count to N

Write a function `laske(n)` that prints numbers from 1 to `n`, one per line.

#### Example
```
laske(5)
→
1
2
3
4
5
```

#### Solution
```kaulin
funktio laske(n) {
  toista (muuttuja i = 1; i <= n; i = i + 1) {
    tulosta(i);
  }
}
```
