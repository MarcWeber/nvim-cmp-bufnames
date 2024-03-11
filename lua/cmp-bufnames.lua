local M = {}

function M:is_available()
  return true
end

function M:get_keyword_pattern (params)
  -- copied from fuzzy cmp filename matching, overkill ? It works
  local min_match_length = params.option.min_match_length or 3
  -- local min_match_length = 3
  -- params.option = vim.tbl_deep_extend('keep', params.option, defaults)
  if vim.api.nvim_get_mode().mode == 'c' then
    return string.format([=[.\{%d,}]=], min_match_length)
  else
    return string.format([=[\k\{%d,}]=], min_match_length)
  end
end

function M:complete(params, callback)

  local bufs = (params.option.bufs or vim.api.nvim_list_bufs)()

  -- if length changed a new file is there
  -- maybe this caching needs improvement
  if not M.bufs or not #bufs == #M.bufs then
    M.bufs = bufs
    M.bufnames = {}
    for i, h in ipairs(bufs) do
      M.bufnames[i] = vim.api.nvim_buf_get_name(h)
    end

    local completions = {}

    local add_function = params.option.add or function(M, completions, i,  name)
      local function add(name)
        table.insert(completions, { textEditText = name,  cmp = { kind_text = "cmp-bufnames " .. i}, label = name})
      end
      add(name)
      add(vim.fs.basename(name))
    end

    for i, name in ipairs(M.bufnames) do
      if not (name == "") then
        add_function(M, completions, i, name)
      end
    end
    M.completions = completions
  end

  callback(M.completions)
end
return M
