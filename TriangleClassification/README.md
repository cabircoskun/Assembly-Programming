# 🧮 Right Triangle Hypotenuse Classification in Assembly

This project is an Assembly program that finds and classifies the hypotenuses of all possible right triangles with integer side lengths between 1 and 50. 
The program checks each hypotenuse to determine if it is **prime** and whether the **sum of the legs is odd**.

## 📐 Triangle Criteria

For each possible combination of side lengths `a` and `b` (where 1 ≤ a, b ≤ 50), the hypotenuse `c` is calculated using:
c² = a² + b²
The triangle is valid if:
- `c` is an integer,
- `c ≤ 50`.

## 🧪 Conditions for Classification

Two conditions must be checked:

1. `c` must be a **prime number**.
2. `a + b` must be an **odd number**.

### Classification Rules

- If **both conditions** are satisfied → add `c` to `primeOddSum` array.
- If **any condition fails** → add `c` to `nonPrimeOrEvenSum` array.

Both arrays are limited to **a maximum of 15 elements**.

## 💾 Data

```asm
primeOddSum         DB 15 DUP(?)
nonPrimeOrEvenSum   DB 15 DUP(?)