local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local config = require("telescope.config")

local mvn = require("java-maven-test.mvn")
local util = require("java-maven-test.util")

local M = {}

local function create_entry(test_name)
    return {
        value = test_name,
        display = test_name,
        ordinal = test_name,
    }
end

local function execute_selected_test(prompt_bufnr)
    actions.close(prompt_bufnr)
    local selected_test_case = action_state.get_selected_entry()

    if selected_test_case then
        mvn.execute_test(selected_test_case.value)
    end
end

local function get_layout_config()
    return {
        layout_config = {
            height = 30,
            width = 60,
        },
    }
end

local function get_picker_options(tests)
    return {
        prompt_title = "Java Test",

        finder = finders.new_table({
            results = tests,
            entry_maker = create_entry,
        }),

        sorter = config.values.generic_sorter({}),

        attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                execute_selected_test(prompt_bufnr)
            end)
            return true
        end,
    }
end

function M.show_java_test_method_picker()
    local tests = util.get_test_methods()
    local layout_conf = get_layout_config()
    local picker_opts = get_picker_options(tests)
    pickers.new(layout_conf, picker_opts):find()
end

return M
