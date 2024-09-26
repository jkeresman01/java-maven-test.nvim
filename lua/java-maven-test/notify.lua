local M = {}

-- Function to notify when no test is selected
function M.no_test_selected()
    vim.notify("No test selected.", vim.log.levels.WARN)
end

-- Function to notify when no tests are found in the class
function M.no_tests_found()
    vim.notify("No tests found in the current class.", vim.log.levels.WARN)
end

-- Function to handle invalid test names
function M.invalid_test_name(test_name)
    vim.notify("Invalid test name: " .. test_name, vim.log.levels.ERROR)
end

-- Function to handle test output (stdout)
function M.handle_test_output(output, test_name)
    for _, line in pairs(output) do
        if string.find(line, "BUILD SUCCESS") then
            vim.notify("Test " .. test_name .. " passed successfully!", vim.log.levels.INFO)
        elseif string.find(line, "BUILD FAILURE") then
            vim.notify("Test " .. test_name .. " failed!", vim.log.levels.ERROR)
        end
    end
end

-- Function to notify when a test completes successfully
function M.test_completed_successfully()
    vim.notify("Maven test completed successfully", vim.log.levels.INFO)
end

-- Function to notify when a test fails
function M.test_failed(exit_code)
    vim.notify(
        "Maven test finished with errors (exit code: " .. exit_code .. ")",
        vim.log.levels.ERROR
    )
end

return M
