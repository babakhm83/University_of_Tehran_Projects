# CA1 - Computer Fundamentals and Programming

This project consists of three parts, each focusing on different aspects of programming in C. The goal of this project is to solve real-world problems using concepts like conditionals, loops, and numerical methods.

## Problem Breakdown

### Part 1: Trampoline Jump Calculation
- **Objective**: Help Parisa reach the professor's office by jumping on a trampoline, considering the room’s floor number, the height of each floor, and the initial jump height.
- **Input**: 
  - A three-digit integer representing the room number.
  - A floating-point number representing the initial jump height.
- **Output**: 
  - The region where the trampoline should be placed.
  - The number of jumps required to reach the desired floor.

**Sample Input/Output**:
- Input: 311 0.6
- Output: 3 3

### Part 2: Calorie Calculation for Weight Management
- **Objective**: Help Sohail track his calorie intake over `n` days based on his food choices and determine whether he gains weight, loses weight, or maintains it.
- **Input**: 
  - An integer `n` representing the number of days.
  - `n` integers, each representing a type of food consumed.
- **Output**:
  - "chagh" if Sohail gains weight.
  - "laghar" if Sohail loses weight.
  - "bedoon taghir" if there is no change in weight.

**Sample Input/Output**:
- Input: 4 6 2 9 5
- Output: chagh

### Part 3: Root Finding for Cubic Equations (Bonus)
- **Objective**: Help Navid find the real roots of a cubic equation using numerical methods. The roots are found within a defined range based on the coefficients provided.
- **Input**: 
  - Three coefficients of the cubic equation.
  - A floating-point number specifying the allowed error for finding the roots.
- **Output**: 
  - Up to three real roots of the equation. If no roots are found, print "bedoon rishe".

**Sample Input/Output**:
- Input: 1 2 3 0.0009
- Output: bedoon rishe bedoon rishe

## Compilation and Execution

To compile and run the program, follow these steps:

1. **Compile the program**:
   ```bash
   gcc -o ca1 1.c 2.c 3.c -lm
   
2. **Run the program**:
   ```bash
    ./ca1
   
3. **Provide the required inputs** as specified in the problem description.

Credits
Instructor: Dr. Moradi, Dr. Hashemi
Course: Computer Fundamentals and Programming, Faculty of Electrical and Computer Engineering, University of Tehran
