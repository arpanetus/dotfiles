local M = {}

M.getPlaceholders = function () 
  return {
    ['${file}'] = function(_)
      return vim.fn.expand("%:p")
    end,
    ['${fileBasename}'] = function(_)
      return vim.fn.expand("%:t")
    end,
    ['${fileBasenameNoExtension}'] = function(_)
      return vim.fn.fnamemodify(vim.fn.expand("%:t"), ":r")
    end,
    ['${fileDirname}'] = function(_)
      return vim.fn.expand("%:p:h")
    end,
    ['${fileExtname}'] = function(_)
      return vim.fn.expand("%:e")
    end,
    ['${relativeFile}'] = function(_)
      return vim.fn.expand("%:.")
    end,
    ['${relativeFileDirname}'] = function(_)
      return vim.fn.fnamemodify(vim.fn.expand("%:.:h"), ":r")
    end,
    ['${workspaceFolder}'] = function(_)
      return vim.fn.getcwd()
    end,
    ['${workspaceFolderBasename}'] = function(_)
      return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    end,
    ['${env:([%w_]+)}'] = function(match)
      return os.getenv(match) or ''
    end,
  } 
end

local function all_trim(s)
   return s:match( "^%s*(.-)%s*$" )
end

M.parseEnvFileString = function(src)
  local tbl = {}
  local err
  for l in src:gmatch "([^\n]+)" do
      l = l.."\n" -- Add indicator for EOL
      l = l:gsub("#.-\n","")

      if l == "" or l:match "^%s+$" then
          goto continue
      end

      local k, is_v
      for s in l:gmatch "([^=]+)" do
          if not is_v and s:match "^.+$" then
              k = all_trim(s)
          elseif is_v and k:match "^.+$" then
              tbl[k] = all_trim(s)
          else
              err = "expected captured '^.+$' pattern, got "..s
              break
          end
          is_v = true
      end
      ::continue::
  end

  if err then
      return nil, err
  else 
    -- vim.notify(vim.inspect(tbl))
    return tbl 
  end
end


return M
