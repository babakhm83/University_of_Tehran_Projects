from cube import Cube
from constants import *
from utility import *

import random
import random
import numpy as np
import matplotlib.pyplot as plt


class Snake:
    body = []
    turns = {}

    def __init__(self, color, pos, file_name=None):
        # pos is given as coordinates on the grid ex (1,5)
        self.color = color
        self.head = Cube(pos, color=color)
        self.body.append(self.head)
        self.dirnx = 0
        self.dirny = 1
        self.states_shape = (3, 4, 4, 3, 3, 4, 4, 4)
        try:
            self.q_table = np.load(file_name)
        except:
            # TODO: Initialize Q-table
            self.q_table = np.zeros(self.states_shape)
        # self.q_table = np.zeros(self.states_shape)  # TODO: Initialize Q-table

        self.lr = 0.001  # TODO: Learning rate
        self.min_lr = 0.0001
        self.lr_decay = 0.995
        self.discount_factor = 0.85  # TODO: Discount factor
        self.epsilon = 0.0001  # TODO: Epsilon
        self.min_epsilon = 0.0001
        self.epsilon_decay = 0.995
        self.food_eaten_history = []
        self.last_match_food_eaten = 0
        self.reward_history = []
        self.last_match_reward = 0
        self.length_history = []
        self.length_of_last_match = 0
        self.reasons_for_end = {'out_of_board': 0, 'hit_itself': 0, 'hit_other_body': 0,
                                'hit_head_and_was_longer': 0, 'hit_head_and_was_shorter': 0, 'hit_head_and_was_equal': 0}
        self.pos_history = []
        self.state = np.zeros(len(self.states_shape)-1, dtype=int).tolist()

    def get_optimal_policy(self, state):
        # TODO: Get optimal policy
        return np.argmax(self.q_table[*state])

    def make_action(self, state):
        chance = random.random()
        if chance < self.epsilon:
            action = random.randint(0, 3)
        else:
            action = self.get_optimal_policy(state)
        return action

    def update_q_table(self, state, action, next_state, reward):
        # TODO: Update Q-table
        self.q_table[*state][action] = self.q_table[*state][action]+self.lr * \
            (reward+self.discount_factor *
             np.max(self.q_table[*next_state])-self.q_table[*state][action])

    def move(self, snack, other_snake):
        # TODO: Create state
        action = self.make_action(self.state)

        if action == 0:  # Left
            self.dirnx = -1
            self.dirny = 0
            self.turns[self.head.pos[:]] = [self.dirnx, self.dirny]
        elif action == 1:  # Right
            self.dirnx = 1
            self.dirny = 0
            self.turns[self.head.pos[:]] = [self.dirnx, self.dirny]
        elif action == 2:  # Up
            self.dirny = -1
            self.dirnx = 0
            self.turns[self.head.pos[:]] = [self.dirnx, self.dirny]
        elif action == 3:  # Down
            self.dirny = 1
            self.dirnx = 0
            self.turns[self.head.pos[:]] = [self.dirnx, self.dirny]

        for i, c in enumerate(self.body):
            p = c.pos[:]
            if p in self.turns:
                turn = self.turns[p]
                c.move(turn[0], turn[1])
                if i == len(self.body) - 1:
                    self.turns.pop(p)
            else:
                c.move(c.dirnx, c.dirny)

        # TODO: Create new state after moving and other needed values and return them
        new_state = np.zeros_like(self.state)
        new_state[0] = 1 if len(self.body) > len(other_snake.body) else \
            (2 if len(self.body) == len(other_snake.body) else 0)
        if snack.pos[0] > self.head.pos[0]:
            new_state[1] = 2
        if snack.pos[1] > self.head.pos[1]:
            new_state[1] += 1
        if other_snake.head.pos[0] > self.head.pos[0]:
            new_state[2] = 2
        if other_snake.head.pos[1] > self.head.pos[1]:
            new_state[2] += 1
        new_state[3] = 2 if self.head.pos[0] == 1 else (
            1 if self.head.pos[0] == ROWS-2 else 0)
        new_state[4] = 2 if self.head.pos[1] == 1 else (
            1 if self.head.pos[1] == ROWS-2 else 0)
        new_state[5:] = self.find_nearest(self.head.pos, other_snake)
        old_state = self.state
        self.state = new_state
        self.pos_history.append(self.head.pos[:])
        return old_state, new_state, action

    def find_nearest(self, self_pos, other):
        r = 0
        l = 0
        u = 0
        d = 0
        for body in self.body[1:]:
            if body.pos[1] == self_pos[1]:
                if body.pos[0] == self_pos[0]+1:
                    r = 1
                if body.pos[0] == self_pos[0]-1:
                    l = 1
            if body.pos[0] == self_pos[0]:
                if body.pos[1] == self_pos[1]+1:
                    u = 1
                if body.pos[1] == self_pos[1]-1:
                    d = 1
        for body in other.body[1:]:
            if body.pos[1] == self_pos[1]:
                if body.pos[0] == self_pos[0]+1:
                    r = 1
                if body.pos[0] == self_pos[0]-1:
                    l = 1
            if body.pos[0] == self_pos[0]:
                if body.pos[1] == self_pos[1]+1:
                    u = 1
                if body.pos[1] == self_pos[1]-1:
                    d = 1
        return r + 2*l, u + 2*d

    def check_out_of_board(self):
        headPos = self.head.pos
        if headPos[0] >= ROWS - 1 or headPos[0] < 1 or headPos[1] >= ROWS - 1 or headPos[1] < 1:
            self.reset((random.randint(3, 18), random.randint(3, 18)))
            return True
        return False

    def calc_reward(self, snack, other_snake):
        reward = 0
        win_self, win_other = False, False

        if self.check_out_of_board():
            # TODO: Punish the snake for getting out of the board
            reward -= 50
            self.reasons_for_end['out_of_board'] += 1
            win_other = True

        if self.head.pos == snack.pos:
            self.addCube()
            snack = Cube(randomSnack(ROWS, self), color=(0, 255, 0))
            # TODO: Reward the snake for eating
            reward += 1
            self.last_match_food_eaten += 1

        if self.head.pos in list(map(lambda z: z.pos, self.body[1:])):
            # TODO: Punish the snake for hitting itself
            reward -= 3
            self.reasons_for_end['hit_itself'] += 1
            win_other = True

        if self.head.pos in list(map(lambda z: z.pos, other_snake.body)):

            if self.head.pos != other_snake.head.pos:
                # TODO: Punish the snake for hitting the other snake
                reward -= 2
                self.reasons_for_end['hit_other_body'] += 1
                win_other = True
            else:
                if len(self.body) > len(other_snake.body):
                    # TODO: Reward the snake for hitting the head of the other snake and being longer
                    reward += 50
                    self.reasons_for_end['hit_head_and_was_longer'] += 1
                    win_self = True
                elif len(self.body) == len(other_snake.body):
                    # TODO: No winner
                    self.reasons_for_end['hit_head_and_was_equal'] += 1
                    reward -= 1
                    reset(self, other_snake, True, True)
                else:
                    # TODO: Punish the snake for hitting the head of the other snake and being shorter
                    reward -= 2
                    self.reasons_for_end['hit_head_and_was_shorter'] += 1
                    win_other = True
                    
        for i in range(len(self.pos_history)-1):
            if self.head.pos == self.pos_history[-i-2]:
                reward -= 1/(i+1)
        self.last_match_reward += reward
        self.length_of_last_match += 1
        reset(self, other_snake, win_self, win_other)
        return snack, reward, win_self, win_other

    def save_history(self):
        self.reward_history.append(
            self.last_match_reward)
        self.food_eaten_history.append(
            self.last_match_food_eaten)
        self.length_history.append(
            self.length_of_last_match)
        self.last_match_reward = 0
        self.last_match_food_eaten = 0
        self.length_of_last_match = 0
        if self.epsilon > self.min_epsilon:
            self.epsilon *= self.epsilon_decay
        if self.lr > self.min_lr:
            self.lr *= self.lr_decay
        self.pos_history = []

    def get_history(self):
        return np.array(self.reward_history), np.array(self.food_eaten_history), np.array(self.length_history)

    def report(self):
        print('Number of times out of board:',
              self.reasons_for_end['out_of_board'])
        print('Number of times hit my self:',
              self.reasons_for_end['hit_itself'])
        print('Number of times the other snake:',
              self.reasons_for_end['hit_other_body'])
        print('Number of times hit other snake head but I was longer:',
              self.reasons_for_end['hit_head_and_was_longer'])
        print('Number of times hit other snake head but I was shorter:',
              self.reasons_for_end['hit_head_and_was_shorter'])
        print('Number of times hit other snake head but I was equal:',
              self.reasons_for_end['hit_head_and_was_equal'])

    def reset(self, pos):
        self.head = Cube(pos, color=self.color)
        self.body = []
        self.body.append(self.head)
        self.turns = {}
        self.dirnx = 0
        self.dirny = 1

    def addCube(self):
        tail = self.body[-1]
        dx, dy = tail.dirnx, tail.dirny

        if dx == 1 and dy == 0:
            self.body.append(
                Cube((tail.pos[0] - 1, tail.pos[1]), color=self.color))
        elif dx == -1 and dy == 0:
            self.body.append(
                Cube((tail.pos[0] + 1, tail.pos[1]), color=self.color))
        elif dx == 0 and dy == 1:
            self.body.append(
                Cube((tail.pos[0], tail.pos[1] - 1), color=self.color))
        elif dx == 0 and dy == -1:
            self.body.append(
                Cube((tail.pos[0], tail.pos[1] + 1), color=self.color))

        self.body[-1].dirnx = dx
        self.body[-1].dirny = dy

    def draw(self, surface):
        for i, c in enumerate(self.body):
            if i == 0:
                c.draw(surface, True)
            else:
                c.draw(surface)

    def save_q_table(self, file_name):
        np.save(file_name, self.q_table)

