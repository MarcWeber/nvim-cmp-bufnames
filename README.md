Example usage:

```lua
local sources = {}

-- register sources you want

require('cmp').register_source('bufnames', require('cmp-bufnames'))
cmp.setup({
  ...
  sources = {"bufnames"}
})
```
