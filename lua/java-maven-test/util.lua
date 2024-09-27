local ts_utils = require("nvim-treesitter.ts_utils")

local M = {}

local function get_current_buffer()
    return vim.api.nvim_get_current_buf()
end

local function get_parser(bufnr, language)
    return vim.treesitter.get_parser(bufnr, language)
end

local function get_captured_nodes(bufnr, tree, query_str, capture_name)
    local query = vim.treesitter.query.parse("java", query_str)
    local captured_texts = {}

    for id, node in query:iter_captures(tree:root(), bufnr, 0, -1) do
        if query.captures[id] == capture_name then
            local text = vim.treesitter.get_node_text(node, bufnr)
            table.insert(captured_texts, text)
        end
    end

    return captured_texts
end

function M.get_test_methods()
    local bufnr = get_current_buffer()
    local parser = get_parser(bufnr, "java")
    local tree = parser:parse()[1]

    local test_methods_query = [[
        (method_declaration
          (modifiers
            (marker_annotation
              (identifier) @annotation (#eq? @annotation "Test")))
          (identifier) @test_name)
    ]]

    return get_captured_nodes(bufnr, tree, test_methods_query, "test_name")
end

function M.get_java_class()
    local bufnr = get_current_buffer()
    local parser = get_parser(bufnr, "java")
    local tree = parser:parse()[1]

    local class_name_query = [[
        (class_declaration
          name: (identifier) @class_name
        )
    ]]

    return get_captured_nodes(bufnr, tree, class_name_query, "class_name")[1]
end

function M.get_test_name_at_cursor()
    local bufnr = get_current_buffer()
    local node = ts_utils.get_node_at_cursor()
    return vim.treesitter.get_node_text(node, bufnr)
end

function M.is_test_name_valid(test_name)
    return string.match(test_name, "%l*test%u*") or string.match(test_name, "%u*Test%l*")
end

function M.is_test_result_success(line)
    return string.find(line, "BUILD SUCCESS")
end

function M.is_test_result_failure(line)
    return string.find(line, "BUILD FAILURE")
end

return M
