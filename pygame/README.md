# PyGame

Awesome tutorial from [Clear Code](https://www.youtube.com/watch?v=AY9MnQ4x3zk)

## Basic Window

```python
import pygame
from sys import exit

pygame.init()
screen = pygame.display.set_mode((800,400))
pygame.display.set_caption('My Game')
clock = pygame.time.Clock()

while True:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            exit()
    # draw all our elements
    # update everything
    pygame.display.update()
    clock.tick(60)
```

## Mouse in Event Loop

```python
import pygame
from sys import exit

pygame.init()
screen = pygame.display.set_mode((800,400))
pygame.display.set_caption('My Game')
clock = pygame.time.Clock()

while True:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            exit()
        if event.type == pygame.MOUSEMOTION:
            print(event.pos) 
        if event.type == pygame.MOUSEBUTTONDOWN:
            print('mouse was clicked')
        if event.type == pygame.MOUSEBUTTONUP:
            print('mouse button was released')
            
    pygame.display.update()
    clock.tick(60)
```

## Keyboard in Event Loop

```python
import pygame
from sys import exit

pygame.init()
screen = pygame.display.set_mode((800,400))
pygame.display.set_caption('My Game')
clock = pygame.time.Clock()

while True:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            exit()
        if event.type == pygame.KEYDOWN:
            print('key pressed') 
        if event.type == pygame.KEYUP:
            print('key was released')
            
    pygame.display.update()
    clock.tick(60)
```
