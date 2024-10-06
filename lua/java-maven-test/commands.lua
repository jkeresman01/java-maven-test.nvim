local mvn = require("java-maven-test.mvn")
local ui = require("java-maven-test.ui")

local M = {}

-- Registers custom user commands for executing Maven tests
--
-- This function creates three custom commands in Neovim:
-- - `MavenTest`: Opens the test method picker for selecting and running a Java test.
-- - `MavenTestAtCursor`: Runs the test method at the current cursor position.
-- - `MavenTestAllInClass`: Executes all tests in the current Java class.
--
-- @return nil
function M.register()
    vim.api.nvim_create_user_command("MavenTest", function()
        ui.show_java_test_method_picker()
    end, {
        desc = "Run Java test method picker",
    })

    vim.api.nvim_create_user_command("MavenTestAtCursor", function()
        mvn.execute_test_at_cursor()
    end, {
        desc = "Execute test at cursor position",
    })

    vim.api.nvim_create_user_command("MavenTestAllInClass", function()
        mvn.execute_all_tests_in_class()
    end, {
        desc = "Run all tests in the current Java class",
    })
end

return M
