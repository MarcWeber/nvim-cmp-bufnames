complete buffer names with caching

Example usage:

```lua
local sources = {}

-- register sources you want
require('cmp').register_source('bufnames', require('cmp-bufnames'))
cmp.setup({
  sources = {
        name = "bufnames",
        -- optional
        option = {
            bufs = vim.api.nvim_list_bufs, -- you could return current buffer only
            min_match_length = 3, -- default
            add = function(M, completions, i,  name)
                -- you can ignore non active buffers here etc
                local function add(i, name)
                    completions.insert(completions, { textEditText = name,  cmp = { kind_text = "cmp-bufnames " .. i}, label = name})
                end
                -- basename without extension: add(vim.fs.basename(name):match '[^.]*') or see vim's fnamemodify({fname},
                add(dict.name)
                add(vim.fs.basename(name))
            end
        }
    }
})
```
