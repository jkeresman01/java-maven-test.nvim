local M = {}

-- Helper function to get the current buffer number.
--
-- @return (number) - The current buffer number.
local function get_current_buffer()
    return vim.api.nvim_get_current_buf()
end

-- Helper function to get a Tree-sitter parser for the given buffer and language.
--
-- @param bufnr (number) - The buffer number.
-- @param lang (string) - The language for the Tree-sitter parser.
--
-- @return (userdata) - The Tree-sitter parser.
local function get_parser(bufnr, lang)
    return vim.treesitter.get_parser(bufnr, lang)
end

-- Helper function to execute a Tree-sitter query and return captured nodes.
--
-- @param bufnr (number) - The buffer number.
-- @param tree (userdata) - The parsed syntax tree.
-- @param query_str (string) - The Tree-sitter query string.
-- @param capture_name (string) - The name of the capture to return.
--
-- @return (table) - A list of captured nodes' text.
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

-- Retrieves all test methods from the current Java file.
-- Parses the buffer using Tree-sitter and extracts methods annotated with @Test.
--
-- @return (table) - A list of test method names.
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

-- Retrieves the class name from the current Java class.
-- Parses the buffer using Tree-sitter and extracts the name of the class.
--
-- @return (string) - The name of the Java class.
function M.get_java_class()
    local bufnr = get_current_buffer()
    local parser = get_parser(bufnr, "java")
    local tree = parser:parse()[1]

    local class_name_query = [[
        (class_declaration
          name: (identifier) @class_name
        )
    ]]

    local class_names = get_captured_nodes(bufnr, tree, class_name_query, "class_name")
    return class_names[1]
end

return M

