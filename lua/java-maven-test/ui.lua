local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local config = require("telescope.config")

local mvn = require("java-maven-test.mvn")
local util = require("java-maven-test.util")

local M = {}

-- Creates an entry table for a test method
--
-- @param test_name The name of the test method
--
-- @return A table containing the test name as `value`, `display`, and `ordinal` for Telescope's entry
local function create_entry(test_name)
    return {
        value = test_name,
        display = test_name,
        ordinal = test_name,
    }
end

-- Executes the selected test method from the picker
--
-- @param prompt_bufnr The buffer number of the prompt picker
--
-- @return nil
local function execute_selected_test(prompt_bufnr)
    actions.close(prompt_bufnr)
    local selected_test_case = action_state.get_selected_entry()

    if selected_test_case then
        mvn.execute_test(selected_test_case.value)
    end
end

-- Returns the layout configuration for the picker
--
-- @return A table containing the layout configuration for the picker
local function get_layout_config()
    return {
        layout_config = {
            height = 30,
            width = 60,
        },
    }
end

-- Returns the picker options for selecting a test method
--
-- @param tests A list of available test methods to display in the picker
--
-- @return A table containing the configuration options for the picker
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

-- Displays the Telescope picker for selecting and executing a Java test method
--
-- @return nil
function M.show_java_test_method_picker()
    local tests = util.get_test_methods()
    local layout_conf = get_layout_config()
    local picker_opts = get_picker_options(tests)
    pickers.new(layout_conf, picker_opts):find()
end

return M
