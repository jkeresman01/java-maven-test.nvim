local util = require("java-maven-test.util")

local M = {}

-- Displays a warning when no test is selected
--
function M.no_test_selected()
    vim.notify("No test selected.", vim.log.levels.WARN)
end

-- Displays a warning when no tests are found in the current class
--
-- @return nil
function M.no_tests_found()
    vim.notify("No tests found in the current class.", vim.log.levels.WARN)
end

-- Displays an error notification for an invalid test name
--
-- @param test_name The name of the invalid test
--
function M.invalid_test_name(test_name)
    vim.notify("Invalid test name: " .. test_name, vim.log.levels.ERROR)
end

-- Handles the test output and displays appropriate notifications based on the test result
--
-- @param output A table containing the output lines of the test execution
-- @param test_name The name of the test that was executed
--
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
