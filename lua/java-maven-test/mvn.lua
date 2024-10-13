local notify = require("java-maven-test.notify")
local util = require("java-maven-test.util")

local M = {}

-- Executes specified test method using maven
--
-- @param test_name The name of the test method to execute
--
function M.execute_test(test_name)
    local class_name = util.get_java_class()
    local mvn_test_command = string.format("mvn test -Dtest=%s#%s", class_name, test_name)
    util.start_job()
end

-- Executes the test method at the current cursor position
--
function M.execute_test_at_cursor()
    local test_name = util.get_test_name_at_cursor()

    if util.is_test_name_valid(test_name) then
        execute_test(test_name)
    else
        notify.invalid_test_name(test_name)
    end
end

-- Executes specified test suite using maven
-- 
function M.execute_test_suite(test_suite)
    local mvn_test_command = string.format("mvn test -DsuiteXmlFile=%s", test_suite)
    util.start_job(mvn_test_command)
end

-- Executes all tests in the current Java class
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
