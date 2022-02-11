# PyGame

Awesome tutorial from [Clear Code](https://www.youtube.com/watch?v=AY9MnQ4x3zk)

## Basic Window

```python
import pygame
from sys import exit

pygame.init()
screen = pygame.display.set_mode((800,400))
pygame.display.set_caption('My Game')

while True:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            exit()
    # draw all our elements
    # update everything
    pygame.display.update()
```
