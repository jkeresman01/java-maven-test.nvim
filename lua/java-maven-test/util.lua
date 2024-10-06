local ts_utils = require("nvim-treesitter.ts_utils")

local M = {}

-- Gets the current buffer number
--
-- @return The buffer number of the current buffer
local function get_current_buffer()
    return vim.api.nvim_get_current_buf()
end

-- Gets the Treesitter parser for the specified buffer and language
--
-- @param bufnr The buffer number
-- @param language The programming language (e.g., "java")
--
-- @return The Treesitter parser object for the specified buffer and language
local function get_parser(bufnr, language)
    return vim.treesitter.get_parser(bufnr, language)
end

-- Retrieves captured nodes matching the query and capture name
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

-- Retrieves all test methods annotated with @Test in the current Java file
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

-- Retrieves the class name from the current Java file
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

-- Retrieves the name of the test at the current cursor position
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
