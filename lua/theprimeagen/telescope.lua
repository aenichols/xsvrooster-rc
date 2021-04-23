local actions = require('telescope.actions')

local action_state = require('telescope.actions.state')
local finders = require('telescope.finders')
local make_entry = require('telescope.make_entry')
local pickers = require('telescope.pickers')
local previewers = require('telescope.previewers')
local utils = require('telescope.utils')
local entry_display = require('telescope.pickers.entry_display')

local conf = require('telescope.config').values


require('telescope').setup {
    defaults = {
        file_sorter = require('telescope.sorters').get_fzy_sorter,
        prompt_prefix = ' >',
        color_devicons = true,
        keep_last_buf = true,

        file_previewer   = require('telescope.previewers').vim_buffer_cat.new,
        grep_previewer   = require('telescope.previewers').vim_buffer_vimgrep.new,
        qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,

        mappings = {
            i = {
                ["<C-q>"] = actions.send_to_qflist,
            },
        }
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        }
    }
}

require('telescope').load_extension('fzy_native')

local M = {}
-- M.search_dotfiles = function()
--     require("telescope.builtin").find_files({
--         prompt_title = "< VimRC >",
--         cwd = "$HOME/dotfiles/awesome-streamerrc/ThePrimeagen/",
--     })
-- end

            -- map(mode, key, lua function to call)
            --
            -- good place to look: telescope.actions (init.lua)
            -- lua function to call:  (gets bufnr, not necessarily needed)
            --   require('telescope.actions.state').get_selected_entry(bufnr)
            --   Actions just take the bufnr and give out information
            --   require('telescope.actions').close(bufnr)
            --
            --   check out telescope.actions for _all the available_ supported
            --   actions.
            --
            --   :h telescope.setup ->
            --   :h telescope.builtin ->
            --   :h telescope.layout ->
            --   :h telescope.actions
            --
-- function set_background(content)
--     vim.fn.system(
--         "dconf write /org/mate/desktop/background/picture-filename \"'" .. content .. "'\"")
-- end

-- local function select_background(prompt_bufnr, map)
--     local function set_the_background(close)
--         local content =
--         require('telescope.actions.state').get_selected_entry(prompt_bufnr)
--         set_background(content.cwd .. "/" .. content.value)
--         if close then
--             require('telescope.actions').close(prompt_bufnr)
--         end
--     end

--     map('i', '<C-p>', function()
--         set_the_background()
--     end)

--     map('i', '<CR>', function()
--         set_the_background(true)
--     end)
-- end

-- local function image_selector(prompt, cwd)
--     return function()
--         require("telescope.builtin").find_files({
--             prompt_title = prompt,
--             cwd = cwd,

--             attach_mappings = function(prompt_bufnr, map)
--                 select_background(prompt_bufnr, map)

--                 -- Please continue mapping (attaching additional key maps):
--                 -- Ctrl+n/p to move up and down the list.
--                 return true
--             end
--         })
--     end
-- end:

-- M.anime_selector = image_selector("< Anime Bobs > ", "~/dotfiles/backgrounds")
-- M.chat_selector = image_selector("< Chat Sucks > ", "~/dotfiles/chat")

M.git_branches = function()
    require("telescope.builtin").git_branches({
        attach_mappings = function(_, map)
            map('i', '<c-d>', actions.git_delete_branch)
            map('n', '<c-d>', actions.git_delete_branch)
            return true
        end
    })
end

--ROOSTER
local rooster = require("theprimeagen.xsvrooster.telescope")

M.git_local_branches = function()

  local opts = {}

  local format = '%(HEAD)'
              .. '%(refname)'
              .. '%(authorname)'
              .. '%(upstream:lstrip=2)'
              .. '%(committerdate:format-local:%Y/%m/%d%H:%M:%S)'
  local output = utils.get_os_command_output({ 'git', 'for-each-ref', 'refs/heads', '--perl', '--format', format }, opts.cwd)

  local results = {}
  local widths = {
    name = 0,
    authorname = 0,
    upstream = 0,
    committerdate = 0,
  }
  local unescape_single_quote = function(v)
      return string.gsub(v, "\\([\\'])", "%1")
  end
  local parse_line = function(line)
    local fields = vim.split(string.sub(line, 2, -2), "''", true)
    local entry = {
      head = fields[1],
      refname = unescape_single_quote(fields[2]),
      authorname = unescape_single_quote(fields[3]),
      upstream = unescape_single_quote(fields[4]),
      committerdate = fields[5],
    }
    local prefix
    if vim.startswith(entry.refname, 'refs/remotes/') then
      prefix = 'refs/remotes/'
    elseif vim.startswith(entry.refname, 'refs/heads/') then
      prefix = 'refs/heads/'
    else
      return
    end
    local index = 1
    if entry.head ~= '*' then
      index = #results + 1
    end

    entry.name = string.sub(entry.refname, string.len(prefix)+1)
    for key, value in pairs(widths) do
      widths[key] = math.max(value, utils.strdisplaywidth(entry[key] or ''))
    end
    if string.len(entry.upstream) > 0 then
      widths.upstream_indicator = 2
    end
    table.insert(results, index, entry)
  end
  for _, line in ipairs(output) do
    parse_line(line)
  end
  if #results == 0 then
    return
  end

  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = 1 },
      { width = widths.name },
      { width = widths.authorname },
      { width = widths.upstream_indicator },
      { width = widths.upstream },
      { width = widths.committerdate },
    }
  }

  local make_display = function(entry)
    return displayer {
      {entry.head},
      {entry.name, 'TelescopeResultsIdentifier'},
      {entry.authorname},
      {string.len(entry.upstream) > 0 and '=>' or ''},
      {entry.upstream, 'TelescopeResultsIdentifier'},
      {entry.committerdate}
    }
  end

  pickers.new(opts, {
    prompt_title = 'Git Local Branches',
    finder = finders.new_table {
      results = results,
      entry_maker = function(entry)
        entry.value = entry.name
        entry.ordinal = entry.name
        entry.display = make_display
        return entry
      end
    },
    previewer = previewers.git_branch_log.new(opts),
    sorter = conf.file_sorter(opts),
    attach_mappings = function(_, map)
      actions.select_default:replace(actions.git_checkout)
      map('i', '<c-t>', actions.git_track_branch)
      map('n', '<c-t>', actions.git_track_branch)

      map('i', '<c-r>', actions.git_rebase_branch)
      map('n', '<c-r>', actions.git_rebase_branch)

      map('i', '<c-d>', actions.git_delete_branch)
      map('n', '<c-d>', actions.git_delete_branch)

      map('i', '<c-f>', rooster.git_fetch_branch_tolocal)
      map('n', '<c-f>', rooster.git_fetch_branch_tolocal)

      map('i', '<c-e>', rooster.git_merge)
      map('n', '<c-e>', rooster.git_merge)

      map('i', '<c-u>', false)
      map('n', '<c-u>', false)
      return true
    end
  }):find()
end

return M

