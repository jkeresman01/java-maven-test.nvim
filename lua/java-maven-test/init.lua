local M = {}

local mvn = require("java-maven-test.mvn")
local util = require("java-maven-test.util")

local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local config = require("telescope.config")

function M.find()
    local tests = util.get_test_methods()

    local opts = {
        layout_config = {
            height = 30,
            width = 60,
        },
    }

    pickers
        .new(opts, {
            prompt_title = "Java Test",

            finder = finders.new_table({
                results = tests,

                entry_maker = function(test_name)
                    return {
                        value = test_name,
                        display = test_name,
                        ordinal = test_name,
                    }
                end,
            }),

            sorter = config.values.generic_sorter(opts),

            attach_mappings = function(prompt_bufnr)
                actions.select_default:replace(function()
                    actions.close(prompt_bufnr)
                    local selected_test_case = action_state.get_selected_entry()

                    if selected_test_case then
                        mvn.execute_selected_test(selected_test_case.value)
                    end
                end)
                return true
            end,
        })
        :find()
end

return M
