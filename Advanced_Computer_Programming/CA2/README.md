# Computer Fundamentals and Programming - CA3

This repository contains solutions for the Computer Fundamentals and Programming course (CA3). It demonstrates the use of arrays, sorting algorithms, and string manipulation in C.

## Directory Structure

The project follows this directory structure:

- **Q0.cpp**: Implements a program that converts each input string to uppercase.
- **Q1.cpp**: Solves a problem where you need to process a sequence of numbers and output a series of integers based on certain conditions.
- **Q2.cpp**: Implements a recursive solution to a problem involving manipulation of a sequence of integers.
- **Q3.cpp**: Solves a board-based problem (like a game) by manipulating a 7x7 board and outputting a sequence of moves to achieve the goal.

## Problem Descriptions

Each C++ file corresponds to a specific problem in the assignment. Below is a high-level description of each problem:

### Q0: Convert to Uppercase

This program reads strings from input and converts each string to uppercase. The main logic is implemented in the `to_upper` function which recursively converts each character of the string to uppercase.

### Q1: Sequence Processing

In this problem, a sequence of integers is given as input. The task is to process this sequence by checking conditions and recursively making decisions about how to continue processing the numbers. The `print_vector` function implements this recursive approach.

### Q2: Recursive Simulation

This program simulates a recursive process to calculate a number based on an initial sequence of integers. The `simon` function implements the recursive logic to manipulate the sequence, adjusting numbers based on specific rules.

### Q3: Game Board Problem (Reversi-like)

The final problem involves a board with `N` and `O` characters placed in a 7x7 grid. The task is to move the `N` pieces according to specific rules (up, down, left, right) to reach a target state. The `solve` function finds the sequence of moves required to achieve the target and prints the moves, or outputs "Loser" if the goal cannot be achieved.

### How to Compile and Run
To compile the programs, you can use g++ (or any C++ compiler):

```bash
g++ -o Q0 Q0.cpp
./Q0
g++ -o Q1 Q1.cpp
./Q1
g++ -o Q2 Q2.cpp
./Q2
g++ -o Q3 Q3.cpp
./Q3

Each program expects input from standard input (e.g., keyboard or input redirection). The output will be printed to the console.
