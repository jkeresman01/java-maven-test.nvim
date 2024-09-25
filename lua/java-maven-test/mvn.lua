local util = require("java-maven-test.util")
local ts_utils = require("nvim-treesitter.ts_utils")

local M = {}


-- Executes a Maven test command for a specific test method within a Java class.
--
-- @param test_name: The name of the test method which to execute
local function execute_test(test_name)
    local class_name = util.get_java_class()

    vim.cmd("vsplit term://bash")

    local mvn_test_command = string.format("mvn test -Dtest=%s#%s", class_name, test_name)
    vim.fn.termopen(mvn_test_command)
end


-- Executes the test method at the current cursor position in the buffer.
function M.execute_test_at_cursor()
    local bufnr = vim.api.nvim_get_current_buf()
    local node = ts_utils.get_node_at_cursor()

    local test_name = vim.treesitter.get_node_text(node, bufnr)

    if util.is_test_name_valid(test_name) then
        execute_test(test_name)
    end
end


-- Executes all test methods within the current Java class.
function M.execute_all_tests_in_class()
    local test_methods = util.get_test_methods()
    if not next(test_methods) == nil then
        execute_test("")
    end
end


return M
