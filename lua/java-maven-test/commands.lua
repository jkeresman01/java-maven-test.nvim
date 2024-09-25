local mvn = require("java-maven-test.mvn")
local ui = require("java-maven-test.ui")

local M = {}


-- Function that registers all the commands exposed to Neovim
function M.register()
    vim.api.nvim_create_user_command("MavenTest", function()
        ui.select_test_to_execute()
    end, {
        desc = "Run Java test picker",
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
