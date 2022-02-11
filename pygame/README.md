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
