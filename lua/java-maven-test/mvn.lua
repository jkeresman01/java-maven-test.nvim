--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: mvn.lua
-- Author: Josip Keresman

local notify = require("java-maven-test.notify")
local util = require("java-maven-test.util")

local M = {}

function M.execute_test(test_name)
    local class_name = util.get_java_class()
    local mvn_test_command = string.format("mvn test -Dtest=%s#%s", class_name, test_name)
    util.start_job(test_name)
end

function M.execute_test_at_cursor()
    local test_name = util.get_test_name_at_cursor()

    if util.is_test_name_valid(test_name) then
        execute_test(test_name)
    else
        notify.invalid_test_name(test_name)
    end
end

function M.execute_test_suite(test_suite)
    local mvn_test_command = string.format("mvn test -DsuiteXmlFile=%s", test_suite)
    util.start_job(mvn_test_command)
end

function M.execute_all_tests_in_class()
    local test_methods = util.get_test_methods()

    if #test_methods > 0 then
        execute_test("")
    else
        notify.no_tests_found()
    end
end

return M
