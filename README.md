![image](https://github.com/ElPiloto/make_your_own_luck.nvim/assets/629190/88b72903-4a0e-45d7-89f5-4cadc1ebb6bd)


# Make Your Own Luck

Like [fortune.nvim](https://github.com/rubiin/fortune.nvim), but you can define your own list of fortunes!

This plugin will let you pick a random entry from a text file. You can use this
to display a randomized message in your startup screen using something like
[alpha-nvim](https://github.com/goolord/alpha-nvim)

The example above uses `make_your_own_luck.nvim` + `alpha-nvim` to display a
random a `Would You Rather` question every time I open neovim.


💸 Cache Rules The World Around Me

Uses caching to go fast. Reduces start-up overhead from 1.91 ms --> 0.11 ms.

**The first time you choose a random value**: the entire
text file is read into memory and a random element is returned. After the
element is returned, we write a _second_ random element to a cached location on
disk.

**The second time you choose a random value**: it returns the cached element
from the previous call. After returning that value, we replace the cached
element on disk with a new random element in the background using
`plenary.async`.

## Plugin Installation

Neovim installation using lazy.nvim

```
return {
  "ElPiloto/make_your_own_luck.nvim",
  lazy = false,
  dependencies = {"nvim-lua/plenary.nvim"}
}
```

## Setting up your custom fortunes directory

You specify a _base directory_. Inside of that base directory are the different
_lists_ you want to choose from as directories. Inside each list directory is a
text file called `short.txt` that contains a list of items to choose from -
each on its own line.

In the example below, the base directory is `/path/to/my_base_dir/`. There are
two lists: `100_words_that_rhyme_with_orange` and
`things_i_would_do_for_a_klondike_bar`.
```
/path/to/my_base_dir/
├── 100_words_that_rhyme_with_orange
│   └── short.txt
└── things_i_would_do_for_a_klondike_bar
    └── short.txt

```

## Usage

```
local myol = require("make_your_own_luck")
myol.BASE_DIR = "/path/to/my_base_dir/" 
fortune = myol.get_random_item("100_words_that_rhyme_with_orange")
```



# Roadmap

- [ ] Improve configuration:
  - [ ] Set base dir in plugin setup.
  - [ ] Define a list of expected lists.
- [ ] Allow mixing multiple fortunes.
- [ ] Make code more robust and degrade gracefully on error.
- [ ] Use xdg cache location for saving cache data.
- [ ] Implement check health?
- [ ] Unify terminology in code.
- [ ] Improve and document `wrap_in_box` function.
- [ ] Provide example for alpha-nvim?
