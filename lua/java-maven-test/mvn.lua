local notify = require("java-maven-test.notify")

local util = require("java-maven-test.util")

local M = {}

-- Executes a Maven test command for a specific test method within a Java class.
--
-- @param test_name: The name of the test method which to execute
function M.execute_test(test_name)
    local class_name = util.get_java_class()

    local mvn_test_command = string.format("mvn test -Dtest=%s#%s", class_name, test_name)

    vim.fn.jobstart(mvn_test_command, {
        stdout_buffered = true,
        stderr_buffered = true,

        on_stdout = function(_, output, _)
            if output then
                notify.handle_test_output(output, test_name)
            end
        end,

        on_exit = function(_, exit_code, _)
            if exit_code == 0 then
                notify.test_completed_successfully()
            else
                notify.test_failed(exit_code)
            end
        end,
    })
end

-- Function to execute the test at the cursor (using Treesitter)
function M.execute_test_at_cursor()
    local test_name = util.get_test_name_at_cursor()
    if util.is_test_name_valid(test_name) then
        execute_test(test_name)
    else
        notify.invalid_test_name(test_name)
    end
end

-- Executes all test methods within the current Java class.
function M.execute_all_tests_in_class()
    local test_methods = util.get_test_methods()
    if #test_methods > 0 then
        execute_test("")
    else
        notify.no_tests_found()
    end
end

return M
