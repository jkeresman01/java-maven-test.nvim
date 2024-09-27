local util = require("java-maven-test.util")

local M = {}

function M.no_test_selected()
    vim.notify("No test selected.", vim.log.levels.WARN)
end

function M.no_tests_found()
    vim.notify("No tests found in the current class.", vim.log.levels.WARN)
end

function M.invalid_test_name(test_name)
    vim.notify("Invalid test name: " .. test_name, vim.log.levels.ERROR)
end

function M.handle_test_output(output, test_name)
    for _, line in pairs(output) do
        if util.is_test_result_success(line) then
            vim.notify("Test " .. test_name .. " passed successfully!", vim.log.levels.INFO)
        end

        if util.is_test_result_failure(line) then
            vim.notify("Test " .. test_name .. " failed!", vim.log.levels.ERROR)
        end
    end
end

return M
