local mvn = require("java-maven-test.mvn")
local ui = require("java-maven-test.ui")

local M = {}

-- Function that registers all the commands exposed to Neovim (MavenTest, MavenTestAtCursor, MavenTestAllInClass)
function M.register()
    vim.api.nvim_create_user_command("MavenTest", function()
        ui.select_test_to_execute()
    end)

    vim.api.nvim_create_user_command("MavenTestAtCursor", function()
        mvn.execute_test_at_cursor()
    end)

    vim.api.nvim_create_user_command("MavenTestAllInClass", function()
        mvn.execute_all_tests_in_class()
    end)
end

return M
