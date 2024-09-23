local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local config = require("telescope.config")

local mvn = require("java-maven-test.mvn")
local util = require("java-maven-test.util")

local M = {}

-- Helper function to create test entries for the picker.
--
-- @param test_name: The name of the test to create an entry for.
--
-- @return: A table containing the value, display, and ordinal properties for the test entry.
local function create_entry(test_name)
    return {
        value = test_name,
        display = test_name,
        ordinal = test_name,
    }
end

-- Helper function to execute the selected test case.
--
-- This function retrieves the selected test entry from the prompt buffer and
-- calls the Maven module to execute the test.
--
-- @param prompt_bufnr: The buffer number for the current prompt.
local function execute_selected_test(prompt_bufnr)
    actions.close(prompt_bufnr)
    local selected_test_case = action_state.get_selected_entry()

    if selected_test_case then
        mvn.execute_selected_test(selected_test_case.value)
    end
end

-- Helper function to configure the layout for the picker.
--
-- @return: A table containing the height and width configuration for the layout.
local function get_layout_config()
    return {
        layout_config = {
            height = 30,
            width = 60,
        },
    }
end

-- Helper function to create picker options.
--
-- This function generates the configuration needed for the Telescope picker, including
-- finder, sorter, and mappings for handling user input.
--
-- @param tests: A list of test method names to display in the picker.
--
-- @return: A table containing the configuration for the picker.
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

-- Main function to find and display test cases.
-- This function retrieves test methods, configures the picker options, and launches the picker.
function M.find()
    local tests = util.get_test_methods()
    local opts = get_layout_config()
    pickers.new(opts, get_picker_options(tests)):find()
end

return M

