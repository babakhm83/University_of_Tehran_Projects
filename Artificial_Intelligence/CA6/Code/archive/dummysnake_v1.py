from cube import Cube
from constants import *
from utility import *

import random
import random
import numpy as np


class DummySnake:
    body = []
    turns = {}

    def __init__(self, color, pos, file_name=None):
        # pos is given as coordinates on the grid ex (1,5)
        self.color = color
        self.head = Cube(pos, color=color)
        self.body.append(self.head)
        self.dirnx = 0
        self.dirny = 1
        self.n_states = 2
        try:
            self.q_table = np.load(file_name)
        except:
            self.q_table = np.zeros((4, 4, 4))  # TODO: Initialize Q-table
        self.q_table = np.zeros((4, 4, 4))  # TODO: Initialize Q-table

        self.lr = 0.3  # TODO: Learning rate
        self.discount_factor = 0.5  # TODO: Discount factor
        self.epsilon = 0.5  # TODO: Epsilon
        self.reward_history = []
        self.last_match_reward = 0
        self.length_of_last_match = 0
        self.state = [0, 0]

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

    def human_move(self):
        event_type = None
        while not event_type:
            keys = pygame.key.get_pressed()
            if keys[pygame.K_ESCAPE]:
                return False
            if keys[pygame.K_LEFT] or keys[pygame.K_RIGHT] or keys[pygame.K_UP] or keys[pygame.K_DOWN]:
                break
            else:
                pygame.event.wait()
        if keys[pygame.K_LEFT]:  # Left
            self.dirnx = -1
            self.dirny = 0
            self.turns[self.head.pos[:]] = [self.dirnx, self.dirny]
        elif keys[pygame.K_RIGHT]:  # Right
            self.dirnx = 1
            self.dirny = 0
            self.turns[self.head.pos[:]] = [self.dirnx, self.dirny]
        elif keys[pygame.K_UP]:  # Up
            self.dirny = -1
            self.dirnx = 0
            self.turns[self.head.pos[:]] = [self.dirnx, self.dirny]
        elif keys[pygame.K_DOWN]:  # Down
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
        return True

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
        new_state = [0, 0]
        if snack.pos[0] > self.head.pos[0]:
            new_state[0] = 2
        if snack.pos[1] > self.head.pos[1]:
            new_state[0] += 1
        if other_snake.head.pos[0] > self.head.pos[0]:
            new_state[1] = 2
        if other_snake.head.pos[1] > self.head.pos[1]:
            new_state[1] += 1
        old_state = self.state
        self.state = new_state
        return old_state, new_state, action

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
            reward -= 20
            win_other = True
            reset(self, other_snake)

        if self.head.pos == snack.pos:
            self.addCube()
            snack = Cube(randomSnack(ROWS, self), color=(0, 255, 0))
            # TODO: Reward the snake for eating
            reward += 15

        if self.head.pos in list(map(lambda z: z.pos, self.body[1:])):
            # TODO: Punish the snake for hitting itself
            reward -= 15
            win_other = True
            reset(self, other_snake)

        if self.head.pos in list(map(lambda z: z.pos, other_snake.body)):

            if self.head.pos != other_snake.head.pos:
                # TODO: Punish the snake for hitting the other snake
                reward -= 10
                win_other = True
            else:
                if len(self.body) > len(other_snake.body):
                    # TODO: Reward the snake for hitting the head of the other snake and being longer
                    reward += 20
                    win_self = True
                elif len(self.body) == len(other_snake.body):
                    # TODO: No winner
                    pass
                else:
                    # TODO: Punish the snake for hitting the head of the other snake and being shorter
                    reward -= 15
                    win_other = True

            reset(self, other_snake)
        self.last_match_reward += reward
        self.length_of_last_match += 1
        return snack, reward, win_self, win_other

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
