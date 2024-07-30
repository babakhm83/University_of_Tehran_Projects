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
import seaborn as sns
sns.set_theme()

def main():
    pygame.init()
    win = pygame.display.set_mode((WIDTH, HEIGHT))

    snake_1 = Snake((255, 0, 0), (15, 15), SNAKE_1_Q_TABLE)
    snake_2 = DummySnake((255, 255, 0), (5, 5), SNAKE_2_Q_TABLE)
    snake_1.addCube()
    snake_2.addCube()

    snack = Cube(randomSnack(ROWS, snake_1), color=(0, 255, 0))

    clock = pygame.time.Clock()
    win_self=0
    win_other=0
    num_iterations = 1000
    win_self_list=[]
    win_other_list=[]
    with tqdm(total=num_iterations) as pbar_self:
        with tqdm(total=num_iterations) as pbar_other:
            while True:
                reward_1 = 0
                reward_2 = 0

                # pygame.time.delay(25)
                # clock.tick(100)
                # redrawWindow(snake_1, snake_2, snack, win)
                
                for event in pygame.event.get():
                    if event.type == pygame.QUIT or win_self >= num_iterations or win_other >= num_iterations:
                        if messagebox.askokcancel("Quit", "Do you want to save the Q-tables?"):
                            save(snake_1, snake_2)
                        print('\n')
                        def plot_report(average_size):
                            plt.title('Win history')
                            plt.plot(win_self_list, label='snake')
                            plt.plot(win_other_list, label='dummy snake')
                            plt.legend(loc="upper left")
                            plt.show()
                            snake1_reward_history, snake1_food_eaten_history, snake1_match_length_history = snake_1.get_history()
                            snake2_reward_history, snake2_food_eaten_history, snake2_match_length_history =snake_2.get_history()
                            def get_average(average_size,array):
                                array = [array[i:i+average_size] for i in range(0, len(array), average_size)]
                                return [np.mean(row) for row in array]
                            max_food_eaten_snake1 = max(snake1_food_eaten_history)
                            max_food_eaten_snake2 = max(snake2_food_eaten_history)
                            food_eaten_history = np.zeros(
                                (max_food_eaten_snake1+1, max_food_eaten_snake2+1))
                            for i, j in zip(snake1_food_eaten_history,
                                            snake2_food_eaten_history):
                                food_eaten_history[i][j]+=1
                            snake1_reward_history = get_average(average_size,snake1_reward_history)
                            snake1_food_eaten_history = get_average(average_size,snake1_food_eaten_history)
                            snake1_match_length_history = get_average(average_size,snake1_match_length_history)
                            snake2_reward_history = get_average(average_size,snake2_reward_history)
                            snake2_food_eaten_history = get_average(average_size,snake2_food_eaten_history)
                            plt.title('Reward history of snake')
                            plt.plot(snake1_reward_history)
                            plt.show()
                            plt.title('Reward history of dummy snake')
                            plt.plot(snake2_reward_history)
                            plt.show()
                            plt.title('Number of foods eaten history')
                            ax=sns.heatmap(food_eaten_history)
                            ax.invert_yaxis()
                            plt.xlabel('dummy snake')
                            plt.ylabel('snake')
                            plt.show()
                            plt.title('Number of foods eaten history')
                            plt.plot(snake1_food_eaten_history, label='snake')
                            plt.plot(snake2_food_eaten_history, label='dummy snake')
                            plt.legend(loc="upper left")
                            plt.show()
                            plt.title('Length of games history')
                            plt.plot(snake1_match_length_history)
                            plt.show()
                            print(f'\nSnake won {win_self} times vs Dummy Snake won {win_other} times')
                            snake_1.report()
                            snake_2.report()
                        # plot_report(100)
                        pygame.quit()
                        exit()
                        
                    if event.type == pygame.KEYDOWN and event.key == pygame.K_ESCAPE:
                        np.save(SNAKE_1_Q_TABLE, snake_1.q_table)
                        np.save(SNAKE_2_Q_TABLE, snake_2.q_table)
                        pygame.time.delay(1000)

                state_1, new_state_1, action_1 = snake_1.move(snack, snake_2)
                state_2, new_state_2, action_2 = snake_2.move(snack, snake_1)

                snack, reward_1, win_1, win_2 = snake_1.calc_reward(snack, snake_2)
                progress_self = int(win_1)
                progress_other = int(win_2)
                win_self += int(win_1)
                win_other += int(win_2)
                snack, reward_2, win_2, win_1 = snake_2.calc_reward(snack, snake_1)
                progress_self += int(win_1)
                progress_other += int(win_2)
                win_self += int(win_1)
                win_other += int(win_2)
                win_self_list.append(win_self)
                win_other_list.append(win_other)
                # snake_1.update_q_table(state_1, action_1, new_state_1, reward_1)
                # snake_2.update_q_table(state_2, action_2, new_state_2, reward_2)
                pbar_self.update(progress_self)
                pbar_other.update(progress_other)

if __name__ == "__main__":
    main()
