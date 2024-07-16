local util = require("java-maven-test.util")
local ts_utils = require('nvim-treesitter.ts_utils')

local M = {}

local function execute_test(test_name)
    local class_name = util.get_java_class()
    local mvn_test_command = string.format('mvn test -Dtest=%s#%s', class_name, test_name)

    vim.cmd('vsplit term://bash')
    vim.fn.termopen(mvn_test_command)
end

function M.execute_test_at_cursor()
    local bufnr = vim.api.nvim_get_current_buf()
    local node = ts_utils.get_node_at_cursor()

    local test_name = vim.treesitter.get_node_text(node, bufnr)

    if util.is_slected_test_valid(test_name) then
        execute_test(test_name)
    end
end

function M.execute_selected_test(test_name)
    execute_test(test_name)
end

function M.execute_all_tests_in_class()
    execute_test("")
end

return M
