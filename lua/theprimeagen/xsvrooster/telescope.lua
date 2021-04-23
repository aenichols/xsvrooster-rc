local utils = require('telescope.utils')

local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

actions.HALLO = function()
    print("HALLO")
end

actions.git_fetch_branch_tolocal = function(prompt_bufnr)
  local cwd = action_state.get_current_picker(prompt_bufnr).cwd
  local selection = action_state.get_selected_entry()
  actions.close(prompt_bufnr)
  local stdout, ret, stderr = utils.get_os_command_output({ 'git', 'fetch', '-f', 'origin' , selection.value .. ':' .. selection.value }, cwd)

  if ret == 0 then
    print("Fetched into local: ")
    print(selection.value)
  else
    print(string.format(
      'Error when fetching branch into local: %s. Git returned: "%s"',
      selection.value,
      table.concat(stderr, '  ')
    ))
  end
end

actions.git_merge = function(prompt_bufnr)
  local cwd = action_state.get_current_picker(prompt_bufnr).cwd
  local selection = action_state.get_selected_entry()

  local confirmation = vim.fn.input('Do you really wanna merge branch ' .. selection.value .. '? [Y/n] ')
  if confirmation ~= '' and string.lower(confirmation) ~= 'y' then return end

  actions.close(prompt_bufnr)
  local _, ret, stderr = utils.get_os_command_output({ 'git', 'merge', selection.value }, cwd)

  if ret == 0 then
    print("Merged into target: ")
    print(selection.value)
  else
    print(string.format(
      'Error when merging branch into target: %s. Git returned: "%s"',
      selection.value,
      table.concat(stderr, '  ')
    ))
  end
end

return actions

