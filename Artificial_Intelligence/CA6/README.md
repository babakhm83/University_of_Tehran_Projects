# RL-Based Snake Game (Q-Learning)

A two-agent competitive Snake game where both snakes learn to play via tabular Q-learning, developed as the final assignment for an Artificial Intelligence course. A more heavily-tuned agent ("Snake") is trained and evaluated against a second, less-refined Q-learning agent ("Dummy Snake") on the same board.

**Institution:** University of Tehran, School of Electrical and Computer Engineering
**Course:** Artificial Intelligence
**Author:** Babak Hosseini Mohtasham
**Assignment specification:** [`AI-CA6-Description.pdf`](./AI-CA6-Description.pdf)

---

## Overview

Both snakes share the same core mechanics — move on a grid, eat food to grow, avoid walls/self-collision/the other snake — but are controlled by independently trained tabular Q-learning agents rather than hand-coded rules. Each agent's state representation, reward shaping, and learning hyperparameters were iterated on across several versions; the final versions (below) were trained head-to-head for roughly 1,000 games and evaluated on win rate and failure-mode breakdown.

**Objectives:**

1. Design a discretized state representation for a Snake agent (relative position of food, walls, and the opposing snake) suitable for tabular Q-learning.
2. Implement the Q-learning update rule (Bellman equation with a learning rate and discount factor) and an epsilon-greedy exploration policy with decay.
3. Train two independently parameterized agents against each other in a shared `pygame` environment, tracking reward, win count, and game length over training.
4. Evaluate the trained agents' relative performance, including a breakdown of *how* each snake tends to lose (running into a wall, into itself, or into the opponent).

## Methodology

| Component | Description |
|---|---|
| **Environment** | A `pygame`-based Snake board (20×20 grid) with two snakes and one food item, where the snake nearest the food route generally has the advantage |
| **State representation** | Discretized features including relative snake length, direction to food, proximity to walls, and direction to the opposing snake's head |
| **Learning algorithm** | Tabular Q-learning: `Q(s,a) ← Q(s,a) + lr · (reward + γ · max_a' Q(s',a') − Q(s,a))`, with epsilon-greedy action selection and both learning-rate and epsilon decay schedules |
| **Training** | Both agents trained simultaneously against each other for ~1,000 episodes (win-count-limited), with Q-tables saved periodically and on exit |
| **Evaluation** | Win/loss counts tracked over training, plus a breakdown of terminal-state causes (wall collision, self-collision, losing/winning/tying a head-to-head collision with the opponent) |

## Repository Structure

| Path | Description |
|---|---|
| [`Code/`](./Code) | The final implementation: `snake.py`, `dummysnake.py`, `main.py`, `cube.py`, `utility.py`, `constants.py` |
| [`Report/`](./Report) | Saved Q-tables (`.npy`) and training/evaluation plots (win history, reward history, food-eaten heatmap, game-length history) |
| [`AI-CA6-Description.pdf`](./AI-CA6-Description.pdf) | Original assignment specification (also covers an unrelated MDP/Value Iteration question from the same assignment) |

> **Note on the original layout:** this folder originally contained two implementation attempts under working-draft filenames (`copy_2.py`, `long_copy_2.py`, `long_copy_3.py`, etc.). `Code_clean/` contains the final, most-developed version (previously `long_copy_2.py` / `long_copy_3.py`) under descriptive names; the earlier iteration is preserved under `Code_clean/archive/`.

## Key Results

**The trained Snake agent won roughly twice as often as its opponent.** Over the full training run, "Snake" won 100,095 times versus "Dummy Snake"'s 51,045 wins — a consistent ~2:1 win-rate advantage that held steadily across training, visible in the win-history plot (`Report/Win_history1.png`).

**Failure-mode breakdown reveals where each agent struggled:**

| Outcome | Snake | Dummy Snake |
|---|---|---|
| Ran out of bounds | 5,100 | 13,802 |
| Collided with itself | 29,089 | 20,529 |
| Lost head-to-head collision | 16,154 | 22,382 |
| Won head-to-head collision (was longer) | 43,249 | 89 |
| Lost head-to-head collision (was shorter) | 630 | 133 |
| Tied head-to-head collision (equal length) | 1,239 | 69 |

The Snake agent rarely ran out of bounds (5,100 vs. 13,802 for Dummy Snake) and won the overwhelming majority of head-to-head collisions by having grown longer (43,249 times), suggesting its richer state representation (which included wall proximity, absent from the simpler agent) helped it both avoid the board edges and out-compete its opponent for food over time.

**Reward history confirms learning actually occurred**, rising from strongly negative average rewards in early episodes to a stable positive plateau (`Report/reward_snake1.png`), consistent with the Q-table converging toward a useful policy rather than the win-rate gap being a coincidence of random play.

## Reproducing the Results

1. Install dependencies: `pip install pygame numpy matplotlib seaborn tqdm`.
2. Run `python Code_clean/main.py` from within the `Code_clean/` directory (relative imports assume the supporting files are alongside `main.py`).
3. The game runs until either agent reaches 1,000 wins, at which point it prompts to save both Q-tables and offers to plot training history (win history, reward history, food-eaten heatmap, and game-length history).
4. Pretrained Q-tables from the original run are available in [`Report/`](./Report) (`qtble_long_copy_2.npy` for Snake, and the corresponding file for Dummy Snake) if you'd prefer to load a trained policy rather than train from scratch.

## Notes on Scope

- "Dummy Snake" is not a hand-coded baseline — it is a second, independently trained Q-learning agent with a simpler state representation and different hyperparameters, used as a point of comparison for the more developed agent rather than as a non-learning control.
- The assignment PDF covers a broader problem set (including an unrelated Markov Decision Process / Value Iteration question); this folder and README cover only the Snake reinforcement-learning portion.
- Training hyperparameters (learning rate, discount factor, epsilon and its decay schedule) were tuned iteratively across the versions preserved in `Code_clean/archive/`; the version in `Code_clean/` reflects the final, best-performing configuration.
