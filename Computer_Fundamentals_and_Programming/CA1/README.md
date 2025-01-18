# Computer Fundamentals and Programming - CA1

This repository contains solutions for the Computer Fundamentals and Programming course (CA1) that demonstrate basic programming concepts and algorithms in C.

## Directory Structure

The project has the following directory structure:

    └── CA1/
        ├── 1.c
        ├── 2.c
        └── 3.c

## Description of Files

### `1.c`
This program calculates the number of jumps required to reach a specific height based on the given input. The height is computed based on a floor value derived from the user input, and the program simulates jumping with a trampoline to reach the desired height.

#### Key Features:
- Calculates which part of the trampoline the user should place.
- Determines the number of jumps required to reach a specific height.

### `2.c`
This program computes the total kilocalories consumed based on a list of food items. It compares the total caloric intake to the daily caloric expenditure (100 kcal per item) and determines if the user is overweight, underweight, or at a stable weight.

#### Key Features:
- Defines the caloric content of various foods.
- Takes input for the number of food items and calculates the total caloric intake.
- Outputs "chagh" (overweight), "laghar" (underweight), or "bedoon taghir" (no change) based on the comparison.

### `3.c`
This program calculates the roots of a cubic function by simulating different values for `x` and identifying sign changes in the function's output. It uses both numerical approximation and analytical methods to find the roots.

#### Key Features:
- Finds roots of cubic equations by testing different values for `x`.
- Uses an approximation method to find roots and refine them.
- If a root corresponds to a point where the derivative is zero, it computes the root precisely using a quadratic formula.

## Compilation and Execution

To compile and run any of the files, use a C compiler such as GCC:

1. Compile a file:

    ```bash
    gcc 1.c -o 1
    gcc 2.c -o 2
    gcc 3.c -o 3
    ```

2. Run the compiled program:

    ```bash
    ./1
    ./2
    ./3
    ```

## Dependencies

- No external libraries or dependencies are required, apart from the standard C library.
