# 🧮 Mode Calculation of an Integer Array in Assembly

This Assembly project is an EXE-type program that calculates the **mode (most frequent value)** of an integer array with a maximum length of 10. 
The program receives user input, stores the integers in an array, and determines which value occurs most frequently.

## 📋 Program Overview

The program is structured into three main parts:

- **SAYILAR**: An integer array that stores up to 10 user-provided values.
- **GIRIS_DIZI (Macro)**: Collects user input and fills the array.
- **MOD (Procedure)**: Calculates and returns the mode (most frequent value) of the array.
- **Stack-based Parameter Transfer**: Parameters and return values between procedures are passed using the stack.

## ✅ Requirements & Features

- Accepts up to 10 integers as input.
- Works with arrays shorter than 10 by handling array termination properly.
- Uses stack operations to pass array length and addresses between main, macro, and subroutines.
- Outputs the mode value after processing.

## 📂 Memory Definitions

```asm
SAYILAR        DW 10 DUP(?)
ARRAY_LENGTH   DW ?
MODE_RESULT    DW ?