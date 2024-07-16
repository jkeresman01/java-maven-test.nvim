local M = {}

local util = require('java-maven-test.util')
local mvn = require('java-maven-test.mvn')

local action_state = require('telescope.actions.state')
local actions = require('telescope.actions')
local finders = require('telescope.finders')
local pickers  = require('telescope.pickers')
local config   = require('telescope.config')

function M.find()
    local tests = util.get_test_methods()

    local opts = {
        layout_config = {
            height = 30,
            width  = 60
        },
    }

    pickers.new(opts, {
        prompt_title = 'Java Test',

        finder = finders.new_table {
            results = tests,

            entry_maker = function(test)
                return {
                    value   = test,
                    display = test,
                    ordinal = test
                }
            end
        },

        sorter = config.values.generic_sorter(opts),

        attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()

                if selection then
                    mvn.execute_selected_test(selection.value)
                end

            end)
        return true
        end,

    }):find()
end

return M


