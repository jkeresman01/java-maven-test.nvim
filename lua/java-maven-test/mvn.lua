local notify = require("java-maven-test.notify")
local util = require("java-maven-test.util")

local M = {}

-- Executes a specific test method using Maven
--
-- @param test_name The name of the test method to execute
--
-- @return nil
function M.execute_test(test_name)
    local class_name = util.get_java_class()
    local mvn_test_command = string.format("mvn test -Dtest=%s#%s", class_name, test_name)

    vim.fn.jobstart(mvn_test_command, {
        stdout_buffered = true,

        on_stdout = function(_, output, _)
            if output then
                notify.handle_test_output(output, test_name)
            end
        end,
    })
end

-- Executes the test method at the current cursor position
--
-- This function retrieves the test name under the cursor and validates it.
-- If the test name is valid, it will execute the test, otherwise, it will
-- display an error notification.
--
-- @return nil
function M.execute_test_at_cursor()
    local test_name = util.get_test_name_at_cursor()

    if util.is_test_name_valid(test_name) then
        execute_test(test_name)
    else
        notify.invalid_test_name(test_name)
    end
end

-- Executes all tests in the current Java class
--
-- If there are any test methods in the current Java class, it will run all
-- the tests by passing an empty string for the test method. If no tests are found,
-- it will notify the user.
--
-- @return nil
function M.execute_all_tests_in_class()
    local test_methods = util.get_test_methods()

    if #test_methods > 0 then
        execute_test("")
    else
        notify.no_tests_found()
    end
end

return M
