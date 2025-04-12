# 🧮 OBP Calculation and Sorting in Assembly

This project calculates Student Success Scores (OBP) based on their midterm and final exam grades using Assembly language.
 The scores are then sorted in descending order.

## 📌 Formula

OBP is calculated with the formula:
OBP = Round((Midterm × 0.4) + (Final × 0.6))

In Assembly, floating-point operations are avoided, so the formula is rewritten as: OBP = ((Midterm × 4 + Final × 6 + 5) / 10)