# tmux-cheatsheet

## Installation

### Ubuntu

Install tmux:

```bash
sudo apt install tmux -y
```

Install tmux plugin manager:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Create the tmux configuration:

```bash
mkdir -p ~/.config/tmux
touch ~/.config/tmux/tmux.conf
```

The content of `tmux.conf`:

```
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'

run '~/.tmux/plugins/tpm/tpm'
```

Then you can source it with:

```bash
tmuxh source ~/.config/tmux/tmux.conf
```

## Cheatsheets

The prefix key is `cmd + b`

To create a new window, prefix key + `c`

To navigate to between windows we can use the prefix key and the number of the window, or prefix key + `n` or `p`

To split your current window into a horizontal pane, press the prefix key + `%` and to split the pane vertically, the prefix key + `"`

The switch between panes you can use the prefix key + the direction arrows

The prefix and `q` will show you a number of the pane which you can switch to by pressing the number

To zoom into a pane, you can use the prefix key and `z`

To close, prefix key + `q`

## Resources

- [Dreams of Code - TMUX](https://www.youtube.com/watch?v=DzNmUNvnB04)
