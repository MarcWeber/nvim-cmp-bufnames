local M = {}
function M:is_available()
  return true
end

function M:get_keyword_pattern (params)
  -- return [[\k\+]]
  -- return [[/]]
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
  local bufs = vim.api.nvim_list_bufs()

  -- if length changed a new file is there
  -- maybe this caching needs improvement
  if not M.bufs or not #bufs == #M.bufs then
    M.bufs = bufs
    M.bufnames = {}
    for i, h in ipairs(bufs) do
      M.bufnames[i] = vim.api.nvim_buf_get_name(h)
    end
  end

  local completions = {}
  local function add(i, name)
    table.insert(completions, { textEditText = name,  cmp = { kind_text ="cmp-bufnames " .. i}, label = name})
  end

  for i, name in ipairs(M.bufnames) do
    add(i, vim.fs.basename(name) )
    add(i, name)
  end

  callback(completions)
end
return M
