# 🧮 2D Convolution Using C and Assembly

This project performs a **2D convolution operation** on a given matrix using a square kernel. 
The implementation uses **C language** in combination with **Assembly** for low-level memory manipulation and performance enhancement.

## 📌 Project Context

The task is to read matrices and kernels, flatten them into 1D arrays, and apply 2D convolution using pointer arithmetic in Assembly.
 The logic is driven from a C/C++ environment that integrates the Assembly routine.

## 📁 Given Files

- Two input matrices of different sizes
- Two square kernels of different sizes
- One base `C++` file (`main.cpp`) to integrate and test your Assembly code
- Input `.txt` files (used only for testing, not part of code logic)

## 🧾 Convolution Explanation

For a given `n x m` matrix and a `k x k` kernel:
- Both are passed as **1D arrays** in memory.
- To access element `(i, j)` in the matrix:  index = i * m + j
- The kernel is always square: `k x k`, and is accessed similarly.

### Convolution Formula (Valid Index Range)

For each valid position `(i, j)` in the matrix:
Output[i][j] = ∑ ∑ Matrix[i + u][j + v] × Kernel[u][v]
The convolution result is stored in a new output array (flattened as 1D).

## 🛠️ Assembly Responsibilities

- Access and manipulate array elements using linear indexing
- Handle boundary checks for convolution validity
- Loop over the matrix and apply the kernel appropriately
- Perform integer multiplications and accumulations
- Return the result back to C for display or validation

## 🔗 Integration (C + Assembly)

- C/C++ code initializes data and calls the Assembly routine.
- Parameters such as:
  - Pointers to matrix and kernel
  - Dimensions of matrix and kernel
  - Output array
- are passed via registers or the stack.
