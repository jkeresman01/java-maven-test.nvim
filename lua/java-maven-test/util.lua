local ts_utils = require("nvim-treesitter.ts_utils")

local M = {}

-- Gets the current buffer number
--
-- @return The current buffer number
local function get_current_buffer()
    return vim.api.nvim_get_current_buf()
end

-- Gets the Treesitter parser for the specified buffer and language
--
-- @param bufnr The buffer number
-- @param language The programming language
--
-- @return The Treesitter parser object for the specified buffer and language
local function get_parser(bufnr, language)
    return vim.treesitter.get_parser(bufnr, language)
end

-- Gets captured nodes matching the query and capture name
--
-- @param query_str The Treesitter query string to match specific nodes
-- @param capture_name The name of the capture group to look for in the query
--
-- @return A list of captured node texts matching the capture group
local function get_captured_nodes(query_str, capture_name)
    local query = vim.treesitter.query.parse("java", query_str)
    local bufnr = get_current_buffer()
    local parser = get_parser(bufnr, "java")
    local tree = parser:parse()[1]

    local captured_texts = {}

    for id, node in query:iter_captures(tree:root(), bufnr, 0, -1) do
        if query.captures[id] == capture_name then
            local text = vim.treesitter.get_node_text(node, bufnr)
            table.insert(captured_texts, text)
        end
    end

    return captured_texts
end

-- Gets all test methods annotated with @Test in the current Java file
--
-- @return A list of test method names found in the current Java file
function M.get_test_methods()
    local test_methods_query = [[
        (method_declaration
          (modifiers
            (marker_annotation
              (identifier) @annotation (#eq? @annotation "Test")))
          (identifier) @test_name)
    ]]

    return get_captured_nodes(test_methods_query, "test_name")
end

-- Gets the class name from the current Java file
--
-- @return The class name found in the current Java file
function M.get_java_class()
    local class_name_query = [[
        (class_declaration
          name: (identifier) @class_name
        )
    ]]

    return get_captured_nodes(class_name_query, "class_name")[1]
end

-- Starts a background job to execute the given Maven command and processes the output
--
-- @param mvn_command The Maven command to be executed
--
-- @return nil
function M.start_job(mvn_command)
    vim.fn.jobstart(mvn_command, {
        stdout_buffered = true,

        on_stdout = function(_, output, _)
            if output then
                notify.handle_test_output(output, test_name)
            end
        end,
    })
end

-- Gets the test suites located under /src/test/resources or src/test directory
--
function M.get_test_suites()
    local find_test_suites_command =
        "find src/test/resources/ src/test/ -name \"*.xml\" | awk -F '/' '{print $NF}'"
    local handle = io.popen(find_test_suites_command)

    if not handle then
        vim.notify("No can do for finding test suites")
        return {}
    end

    local test_suites_results = handle:read("*a")
    handle:close()

    local test_suites = {}
    for test_suite in string.gmatch(test_suites_results, "[^\n]+") do
        table.insert(test_suites, test_suite)
    end

    return test_suites
end

-- Getss the name of the test at the current cursor position
--
-- @return The name of the test method at the cursor position
function M.get_test_name_at_cursor()
    local bufnr = get_current_buffer()
    local node = ts_utils.get_node_at_cursor()
    return vim.treesitter.get_node_text(node, bufnr)
end

-- Validates if a given test name follows standard naming conventions
--
-- @param test_name The name of the test to validate
--
-- @return `true` if the test name is valid, otherwise `false`
function M.is_test_name_valid(test_name)
    return string.match(test_name, "%l*test%u*") or string.match(test_name, "%u*Test%l*")
end

-- Checks if a test result indicates success
--
-- @param line The output line from the test execution
--
-- @return `true` if the line contains a success result, otherwise `false`
function M.is_test_result_success(line)
    return string.find(line, "BUILD SUCCESS")
end

-- Checks if a test result indicates failure
--
-- @param line The output line from the test execution
--
-- @return `true` if the line contains a failure result, otherwise `false`
function M.is_test_result_failure(line)
    return string.find(line, "BUILD FAILURE")
end

return M
