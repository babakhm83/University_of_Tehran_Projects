from snake import *
from dummysnake import *
from utility import *
from cube import *

import pygame
import numpy as np
from tkinter import messagebox
from snake import Snake
from dummysnake import DummySnake
from tqdm import tqdm

def main():
    pygame.init()
    win = pygame.display.set_mode((WIDTH, HEIGHT))

    snake_1 = Snake((255, 0, 0), (15, 15), SNAKE_1_Q_TABLE)
    snake_2 = DummySnake((255, 255, 0), (5, 5), SNAKE_1_Q_TABLE)
    snake_1.addCube()
    snake_2.addCube()

    snack = Cube(randomSnack(ROWS, snake_1), color=(0, 255, 0))

    clock = pygame.time.Clock()
    win_self=0
    win_other=0
    num_iterations = 100000
    with tqdm(total=num_iterations) as pbar:
        while True:
            reward_1 = 0
            reward_2 = 0

            pygame.time.delay(25)
            clock.tick(100)
            redrawWindow(snake_1, snake_2, snack, win)
            
            for event in pygame.event.get():
                if event.type == pygame.QUIT or win_self >= num_iterations or win_other >= num_iterations:
                    if messagebox.askokcancel("Quit", "Do you want to save the Q-tables?"):
                        save(snake_1, snake_2)
                    print('\n')
                    snake_1.report(win_self, win_other)
                    pygame.quit()
                    exit()
                    
                if event.type == pygame.KEYDOWN and event.key == pygame.K_ESCAPE:
                    np.save(SNAKE_1_Q_TABLE, snake_1.q_table)
                    np.save(SNAKE_2_Q_TABLE, snake_2.q_table)
                    pygame.time.delay(1000)

            state_1, new_state_1, action_1 = snake_1.move(snack, snake_2)
            # state_2, new_state_2, action_2 = snake_2.move(snack, snake_1)
            if not snake_2.human_move():
                win_self+=num_iterations

            snack, reward_1, win_1, win_2 = snake_1.calc_reward(snack, snake_2)
            progress = int(win_1)
            win_self += int(win_1)
            win_other += int(win_2)
            snack, reward_2, win_2, win_1 = snake_2.calc_reward(snack, snake_1)
            progress += int(win_1)
            win_self += int(win_1)
            win_other += int(win_2)

            # snake_1.update_q_table(state_1, action_1, new_state_1, reward_1)
            # snake_2.update_q_table(state_2, action_2, new_state_2, reward_2)
            pbar.update(progress)

if __name__ == "__main__":
    main()
