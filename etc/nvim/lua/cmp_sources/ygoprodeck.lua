-- lua/cmp_ygoprodeck/init.lua
--
-- An nvim-cmp source that completes Yu-Gi-Oh! card names using the
-- ygoprodeck public API: https://db.ygoprodeck.com/api/v7/cardinfo.php
--
-- The API returns the entire card database in one response (several MB),
-- so this source fetches it once, caches it in memory for CACHE_TTL
-- seconds, and then filters/matches locally on every keystroke (cmp
-- already does fuzzy filtering on the `label` field, so we just need to
-- hand it the full item list).

local API_URL = 'https://db.ygoprodeck.com/api/v7/cardinfo.php'
local CACHE_TTL = 60 * 60 * 6 -- 6 hours, in seconds

local source = {}

function source.new()
  local self = setmetatable({}, { __index = source })
  self.cache_items = nil -- built completion items, cached
  self.cache_time = 0
  self.fetching = false
  self.pending = {} -- callbacks waiting on an in-flight fetch
  return self
end

function source.get_debug_name()
  return 'ygoprodeck'
end

-- Only trigger fetching after a couple characters so we don't hammer
-- the API needlessly; cmp will still call complete() on every keystroke,
-- we just no-op until then.
function source:is_available()
  return true
end

function source.get_trigger_characters()
  return {}
end

function source.get_keyword_pattern()
  return [[\k\+]]
end

local function build_items(cards)
  local cmp_ok, cmp = pcall(require, 'cmp')
  local kind = cmp_ok and cmp.lsp.CompletionItemKind.Text or 1

  local items = {}
  for _, card in ipairs(cards) do
    if card.name then
      table.insert(items, {
        label = card.id,
        kind = kind,
        detail = table.concat({
          card.type ,
          card.race ,
        }, '|' ),
        documentation = {
          kind = 'markdown',
          value = string.format(
            '# %s\n\n%s\n\n| Type | Attribute | ATK | DEF |\n|---|---|---|---|\n| %s | %s | %s | %s |',
            card.name,
            card.desc or '_no description_',
            card.type or '-',
            card.attribute or '-',
            card.atk ~= nil and tostring(card.atk) or '-',
            card.def ~= nil and tostring(card.def) or '-'
          ),
        },
      })
    end
  end
  return items
end

-- Fetches the card list via curl (async), returns raw decoded `data` array
-- (or nil + error string) through `callback`. Callback is invoked on the
-- main loop.
local function fetch_cards(callback)
  if vim.system then
    -- Neovim >= 0.10
    vim.system({ 'curl', '-s', '-f', API_URL }, { text = true }, function(obj)
      vim.schedule(function()
        if obj.code ~= 0 or not obj.stdout or obj.stdout == '' then
          callback(nil, 'curl failed (code ' .. tostring(obj.code) .. '): ' .. (obj.stderr or ''))
          return
        end
        local ok, decoded = pcall(vim.json.decode, obj.stdout)
        if not ok or type(decoded) ~= 'table' or not decoded.data then
          callback(nil, 'failed to decode API response as JSON')
          return
        end
        callback(decoded.data, nil)
      end)
    end)
  else
    -- Fallback for older Neovim versions
    local stdout_chunks = {}
    vim.fn.jobstart({ 'curl', '-s', '-f', API_URL }, {
      stdout_buffered = true,
      on_stdout = function(_, data)
        stdout_chunks = data
      end,
      on_exit = function(_, code)
        vim.schedule(function()
          if code ~= 0 then
            callback(nil, 'curl exited with code ' .. code)
            return
          end
          local raw = table.concat(stdout_chunks, '\n')
          local ok, decoded = pcall(vim.json.decode, raw)
          if not ok or type(decoded) ~= 'table' or not decoded.data then
            callback(nil, 'failed to decode API response as JSON')
            return
          end
          callback(decoded.data, nil)
        end)
      end,
    })
  end
end

function source:complete(_, callback)
  local now = os.time()

  -- Fresh cache available: respond immediately.
  if self.cache_items and (now - self.cache_time) < CACHE_TTL then
    callback({ items = self.cache_items, isIncomplete = false })
    return
  end

  -- A fetch is already in flight: queue this callback for when it lands.
  if self.fetching then
    table.insert(self.pending, callback)
    return
  end

  -- Serve stale cache immediately (if any) while we refresh in the background,
  -- so typing never blocks on the network.
  if self.cache_items then
    callback({ items = self.cache_items, isIncomplete = false })
  end

  self.fetching = true
  fetch_cards(function(data, err)
    self.fetching = false

    if err or not data then
      vim.notify('[cmp-ygoprodeck] ' .. (err or 'unknown fetch error'), vim.log.levels.WARN)
      if not self.cache_items then
        callback({ items = {}, isIncomplete = false })
      end
      for _, cb in ipairs(self.pending) do
        cb({ items = self.cache_items or {}, isIncomplete = false })
      end
      self.pending = {}
      return
    end

    self.cache_items = build_items(data)
    self.cache_time = os.time()

    callback({ items = self.cache_items, isIncomplete = false })
    for _, cb in ipairs(self.pending) do
      cb({ items = self.cache_items, isIncomplete = false })
    end
    self.pending = {}
  end)
end

require('cmp').register_source('ygoprodeck', source)

